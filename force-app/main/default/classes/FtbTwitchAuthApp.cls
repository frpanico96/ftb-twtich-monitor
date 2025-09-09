public with sharing class FtbTwitchAuthApp implements FtbITwitchInvokeStrategy{

    private String appId;

    public HttpRequest setAdditionalHeaders(HttpRequest req){
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        return req;
    }

    public HttpRequest setParamsOrBody(HttpRequest req){

        // App auth is formatted in x-www-form-urlencoded
        List<TwitchApp__c> appCredentials = [SELECT ClientId__c, ClientSecret__c FROM TwitchApp__c WHERE Active__c = true AND Default__c = true];

        if(appCredentials.isEmpty()){
            throw new FtbTwitchException('No active app credentials found');
        }

        this.appId = appCredentials[0].Id;

        String body = 'client_id=' + appCredentials[0].ClientId__c + '&client_secret=' + appCredentials[0].ClientSecret__c + '&grant_type=client_credentials';

        req.setBody(body);

        return req;
    }

    public FtbTwitchMonitorDto.FacadeResponse handleResponse(HttpResponse res){

        FtbTwitchMonitorDto.FacadeResponse response = new FtbTwitchMonitorDto.FacadeResponse(); 

        if(res.getStatusCode() != 200){
            throw new FtbTwitchException('Error: ' + res.getStatusCode() + ' ' + res.getStatus());
        }

        FtbTwitchMonitorDto.TwitchAuthAppResponse authResponse = (FtbTwitchMonitorDto.TwitchAuthAppResponse)JSON.deserialize(res.getBody(), FtbTwitchMonitorDto.TwitchAuthAppResponse.class);

        response.operationOutcome = authResponse.access_token;
        response.sobjToUpsert.add(new TwitchApp__c(Id = this.appId, AccessToken__c = authResponse.access_token));
        
        return response;
    }

}