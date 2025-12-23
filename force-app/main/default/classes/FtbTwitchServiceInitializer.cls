public with sharing class FtbTwitchServiceInitializer extends FtbTwitchBaseClass{


    public static String generateTwitchLoginUrl(String additionalScopes){
        try{
            String defaultScope = 'channel:manage:polls channel:read:polls channel:manage:raids';
            if(String.isNotBlank(additionalScopes)){
                defaultScope += ' ' + additionalScopes;
            }
            String responseType = FtbTwitchConstants.TWITCH_LOGIN_CODE;
            List<TwitchApp__c> appCredentials = FtbTwitchUtility.getTwitchApp();
            String clientId = appCredentials[0].ClientId__c;
            String baseEndpoint = FtbTwitchConstants.TWITCH_LOGIN_BASE_URL;
            String fullUrl = baseEndpoint + '?client_id=' + clientId + '&redirect_uri=' + FtbTwitchConstants.REDIRECT_URI + '&response_type=' + responseType + '&scope=' + EncodingUtil.urlEncode(defaultScope, 'UTF-8');
            return fullUrl;
        } catch(Exception e){
            FtbTwitchTelemetryService.logException(e.getMessage(), e.getTypeName(), new TwitchLog__c());
        }
        return '';
    }


}