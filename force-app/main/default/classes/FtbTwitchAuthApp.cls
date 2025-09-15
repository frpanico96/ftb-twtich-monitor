public with sharing class FtbTwitchAuthApp implements FtbITwitchInvokeStrategy{

    private String appId;

    public HttpRequest setAdditionalHeaders(HttpRequest req){
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        return req;
    }

    public Boolean doExecuteCallout(String keyParam){
        List<TwitchApp__c> appCredentials = FtbTwitchUtility.getTwitchApp();

        return String.isBlank(appCredentials[0]?.AccessToken__c);
    }

    public HttpRequest setParamsOrBody(HttpRequest req, String params){

        // App auth is formatted in x-www-form-urlencoded
        List<TwitchApp__c> appCredentials = FtbTwitchUtility.getTwitchApp();

        this.appId = appCredentials[0].Id;

        req.setBody(generateBody(appCredentials[0].ClientId__c, appCredentials[0].ClientSecret__c));

        return req;
    }

    public FtbTwitchMonitorDto.FacadeResponse handleResponse(HttpResponse res){

        FtbTwitchMonitorDto.FacadeResponse response = new FtbTwitchMonitorDto.FacadeResponse(); 

        if(res.getStatusCode() != 200){
            throw new FtbTwitchException('Error: ' + res.getStatusCode() + ' ' + res.getStatus(), String.valueOf(FtbTwitchEnums.FtbTwitchErrors.AUTH_ERROR));
        }

        FtbTwitchMonitorDto.TwitchAuthAppResponse authResponse = (FtbTwitchMonitorDto.TwitchAuthAppResponse)JSON.deserialize(res.getBody(), FtbTwitchMonitorDto.TwitchAuthAppResponse.class);

        response.operationOutcome = String.valueOf(FtbTwitchEnums.FtbTwitchOutcome.SUCCESS);
        response.sobjToUpsert.add(new TwitchApp__c(Id = this.appId, AccessToken__c = authResponse.access_token));
        
        return response;
    }

    private string generateBody(String clientId, String clientSecret){
        return 'client_id=' + clientId + '&client_secret=' + clientSecret + '&grant_type=client_credentials';
    }

}