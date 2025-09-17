public with sharing class FtbTwitchServiceInitializer {


    public static string generateTwitchLoginUrl(String additionalScopes){
        try{
            String defaultScope = 'channel:manage:polls channel:read:polls channel:manage:raids';
            if(String.isNotBlank(additionalScopes)){
                defaultScope += ' ' + additionalScopes;
            }
            String baseUrl = Url.getOrgDomainUrl().toExternalForm();
            String apexPage = baseUrl + '/apex/ftbTwitchInitializerFinalizePage';
            String responseType = 'code';
            List<TwitchApp__c> appCredentials = FtbTwitchUtility.getTwitchApp();
            String clientId = appCredentials[0].ClientId__c;
            String baseEndpoint = 'https://id.twitch.tv/oauth2/authorize';
            String fullUrl = baseEndpoint + '?client_id=' + clientId + '&redirect_uri=' + apexPage + '&response_type=' + responseType + '&scope=' + EncodingUtil.urlEncode(defaultScope, 'UTF-8');
            return fullUrl;
        } catch(Exception e){
            FtbTwitchTelemetryService.logException(e.getMessage(), e.getTypeName(), new TwitchLog__c());
        }
        return '';
    }


}