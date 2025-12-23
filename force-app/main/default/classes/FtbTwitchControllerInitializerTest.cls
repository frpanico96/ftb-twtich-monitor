/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class FtbTwitchControllerInitializerTest {

    @TestSetup
    static void setup(){
        
        insert new TwitchApp__c(
            Name='Sample App', 
            ClientId__c = 'Test Client Id',
            ClientSecret__c = 'Test Client Secret',
            Active__c = true,
            Default__c = true
            );
    }
    
    @isTest
    static void connectAppOkTest(){
    
        FtbTwitchMonitorDto.TwitchAuthAppResponse mockedResponse = new FtbTwitchMonitorDto.TwitchAuthAppResponse();
        mockedResponse.access_token = 'Sample Access Token';
        mockedResponse.expires_in = 200;
        mockedResponse.token_type = 'mocked_token';

        new HttpMock()
            .whenPostOn('/oauth2/token').body(JSON.serialize(mockedResponse)).statusCodeOk()
            .mock();
        
        Test.startTest();
            String outcome = FtbTwitchControllerInitializer.connectApp();
        Test.stopTest();

        List<TwitchApp__c> appToTest = [SELECT Id, AccessToken__c FROM TwitchApp__c];

        Assert.isNotNull(appToTest[0].AccessToken__c,'no access token provided');
        Assert.areEqual(outcome, String.valueOf(FtbTwitchEnums.FtbTwitchOutcome.SUCCESS), 'Operation did not succeed');
    }

    @isTest
    static void connectAppNoAppFoundTest(){

        SOQL.mock('FtbTwitchUtility.getTwitchApp').thenReturn(new List<TwitchApp__c>());
        
        Test.startTest();
            String outcome = FtbTwitchControllerInitializer.connectApp();
        Test.stopTest();

        Assert.areEqual(outcome, String.valueOf(FtbTwitchEnums.FtbTwitchOutcome.ERROR), 'Operation did not fail as expected');

    }

    @isTest
    static void connectAppTokenFailTest(){

        new HttpMock()
            .whenPostOn('/oauth2/token').body('').statusCodeNotFound()
            .mock();
        
        Test.startTest();
            String outcome = FtbTwitchControllerInitializer.connectApp();
        Test.stopTest();

        Assert.areEqual(outcome, String.valueOf(FtbTwitchEnums.FtbTwitchOutcome.ERROR), 'Operation did not fail as expected');

    }
    
    @isTest
    static void getTwitchUserOkTest(){

        FtbTwitchMonitorDto.TwitchGetUserResponse mockedResponse = new FtbTwitchMonitorDto.TwitchGetUserResponse();
        FtbTwitchMonitorDto.TwitchUserResponseData mockedResponseData = new FtbTwitchMonitorDto.TwitchUserResponseData();
        mockedResponseData.id = '12345';
        mockedResponseData.login = 'sample_login';
        mockedResponseData.display_name = 'Sample Display Name';
        mockedResponseData.type = '';
        mockedResponseData.broadcaster_type = '';
        mockedResponseData.description = 'Sample description';
        mockedResponseData.profile_image_url = 'http://sample.url/image.png';
        mockedResponseData.offline_image_url = 'http://sample.url/offline.png';
        mockedResponseData.view_count = 100;
        mockedResponseData.created_at = '2020-01-01T00:00:00Z';

        
        mockedResponse.data = new List<FtbTwitchMonitorDto.TwitchUserResponseData>{mockedResponseData};

        SOQL.mock('FtbTwitchGetUser.doExecuteCallout').thenReturn(new List<TwitchUser__c>());

        new HttpMock()
            .whenGetOn('Callout:TwitchApiMonitor/helix/users').body(mockedResponse).statusCodeOk()
            .mock();

        Test.startTest();
            String outcome = FtbTwitchControllerInitializer.getTwitchUser('sample_login');
        Test.stopTest();

        Assert.areEqual(outcome, String.valueOf(FtbTwitchEnums.FtbTwitchOutcome.SUCCESS), 'Operation did not succeed'); 
        Assert.areEqual(1, [SELECT COUNT() FROM TwitchUser__c WHERE Name = 'sample_login'], 'Twitch User was not created'); 
        Assert.areEqual(1, [SELECT COUNT() FROM TwitchSession__c], 'Twitch Session was not created');

    }

    @isTest
    static void getTwitchUserEmptyBodyTest(){

        FtbTwitchMonitorDto.TwitchGetUserResponse mockedResponse = new FtbTwitchMonitorDto.TwitchGetUserResponse();
        mockedResponse.data = new List<FtbTwitchMonitorDto.TwitchUserResponseData>();

        SOQL.mock('FtbTwitchGetUser.doExecuteCallout').thenReturn(new List<TwitchUser__c>());

        new HttpMock()
            .whenGetOn('Callout:TwitchApiMonitor/helix/users').body(mockedResponse).statusCodeOk()
            .mock();

        Test.startTest();
            String outcome = FtbTwitchControllerInitializer.getTwitchUser('sample_login');
        Test.stopTest();

        Assert.areNotEqual(outcome, String.valueOf(FtbTwitchEnums.FtbTwitchOutcome.SUCCESS), 'Operation did not succeed'); 
        Assert.areEqual(0, [SELECT COUNT() FROM TwitchUser__c WHERE Name = 'sample_login'], 'Twitch User was not created'); 
        Assert.areEqual(0, [SELECT COUNT() FROM TwitchSession__c], 'Twitch Session was not created');

    }

    @isTest
    static void getTwitchUserCalloutKoTest(){

        FtbTwitchMonitorDto.TwitchGetUserResponse mockedResponse = new FtbTwitchMonitorDto.TwitchGetUserResponse();
        mockedResponse.data = new List<FtbTwitchMonitorDto.TwitchUserResponseData>();

        SOQL.mock('FtbTwitchGetUser.doExecuteCallout').thenReturn(new List<TwitchUser__c>());

        new HttpMock()
            .whenGetOn('Callout:TwitchApiMonitor/helix/users').body(mockedResponse).statusCodeInternalServerError()
            .mock();

        Test.startTest();
            String outcome = FtbTwitchControllerInitializer.getTwitchUser('sample_login');
        Test.stopTest();

        Assert.areNotEqual(outcome, String.valueOf(FtbTwitchEnums.FtbTwitchOutcome.SUCCESS), 'Operation did not succeed'); 
        Assert.areEqual(0, [SELECT COUNT() FROM TwitchUser__c WHERE Name = 'sample_login'], 'Twitch User was not created'); 
        Assert.areEqual(0, [SELECT COUNT() FROM TwitchSession__c], 'Twitch Session was not created');

    }


    @isTest
    static void getTwitchLoginUrlOkTest(){

        String additionalScopes = 'user:read:email';
        String defaultScope = 'channel:manage:polls channel:read:polls channel:manage:raids';

        List<TwitchApp__c> appCredentials = FtbTwitchUtility.getTwitchApp();

        String expectedUrl = FtbTwitchConstants.TWITCH_LOGIN_BASE_URL 
        + '?client_id=' + appCredentials[0].ClientId__c + '&redirect_uri=' 
        + FtbTwitchConstants.REDIRECT_URI
        + '&response_type=code&scope=' 
        + EncodingUtil.urlEncode(defaultScope + ' ' + additionalScopes, 'UTF-8');


        Test.startTest();
            String loginUrl = FtbTwitchControllerInitializer.getTwitchLoginUrl(additionalScopes);
        Test.stopTest();

        Assert.isNotNull(loginUrl, 'Login URL is null');
        Assert.isTrue(loginUrl.contains(EncodingUtil.urlEncode(additionalScopes, 'UTF-8')), 'Additional scopes not included in URL');
        Assert.areEqual(expectedUrl, loginUrl, 'Login URL does not match expected URL');
    }

    @isTest
    static void getTwitchLoginUrlKoTest(){

        SOQL.mock('FtbTwitchUtility.getTwitchApp').throwException('Test exception');

        Test.startTest();
            String loginUrl = FtbTwitchControllerInitializer.getTwitchLoginUrl('user:read:email');
        Test.stopTest();

        Assert.isTrue(String.isBlank(loginUrl), 'Login URL should be blank on exception');
    }

    @isTest
    static void connectUserOkTest(){

        insert new TwitchUser__c(
            Name='sample_user',
            TwitchId__c='12345'
        );

        insert new TwitchSession__c(
            Name='sample_user_session',
            SessionId__c = '12345'
        );

        FtbTwitchMonitorDto.TwitchAuthUserResponse mockedResponse = new FtbTwitchMonitorDto.TwitchAuthUserResponse();
        mockedResponse.access_token = 'Sample User Access Token';
        mockedResponse.refresh_token = 'Sample User Refresh Token';
        mockedResponse.expires_in = 300;
        mockedResponse.scope = new List<String>{'user:read:email'};
        mockedResponse.token_type = 'mocked_user_token';

        new HttpMock()
            .whenPostOn('/oauth2/token').body(mockedResponse).statusCodeOk()
            .mock();
        
        Test.startTest();
            String outcome = FtbTwitchControllerInitializer.connectUser('sample_code');
        Test.stopTest();

        
        List<TwitchUser__c> userToTest = [SELECT Id, AccessToken__c FROM TwitchUser__c WHERE Name = 'sample_user'];
        
        Assert.areEqual(outcome, userToTest[0].Id, 'Operation did not succeed');
        Assert.isNotNull(userToTest[0].AccessToken__c,'no access token provided');
    }

    @isTest
    static void connectUserKoTest(){

        SOQL.mock('FtbTwitchUserUtility.getTwitchSessionId').thenReturn(new List<TwitchSession__c>{
            new TwitchSession__c(SessionId__c='12345')
        });

        SOQL.mock('FtbTwitchUserUtility.getTwitchUserByTwitchId').thenReturn(new List<TwitchUser__c>{
            new TwitchUser__c(Name='sample_user')
        });

        new HttpMock()
            .whenPostOn('/oauth2/token').body('').statusCodeNotFound()
            .mock();
        
        Test.startTest();
            String outcome = FtbTwitchControllerInitializer.connectUser('sample_code');
        Test.stopTest();    

        Assert.areNotEqual(outcome, String.valueOf(FtbTwitchEnums.FtbTwitchOutcome.SUCCESS), 'Operation did not succeed'); 
    }
}