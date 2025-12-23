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
private class FtbTwitchScopePickerControllerTest {

    @isTest
    static void getTwitchScopeForBoxListTest() {
    
        SOQL.mock('FtbTwitchScopePickerService.getAllScopes').thenReturn(new List<TwitchScope__c>{
            new TwitchScope__c(Name='Scope 1', Description__c='Description 1', Suggested__c=true, ScopeApiName__c='scope1', Active__c=true),
            new TwitchScope__c(Name='Scope 2', Description__c='Description 2', Suggested__c=false, ScopeApiName__c='scope2', Active__c=true),
            new TwitchScope__c(Name='Scope 3', Description__c='Description 3', Suggested__c=true, ScopeApiName__c='scope3', Active__c=true)
        });

        Test.startTest();
            FtbTwitchMonitorDto.TwitchScopePickerDto result = FtbTwitchScopePickerController.getTwitchScopeForBoxList();
        Test.stopTest();

        Assert.isNotNull(result, 'Result should not be null');
    }
}