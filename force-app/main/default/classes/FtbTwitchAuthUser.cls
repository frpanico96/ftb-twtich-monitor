public with sharing class FtbTwitchAuthUser implements FtbITwitchInvokeStrategy{

    FtbTwitchUserUtility userUtilityClass = new FtbTwitchUserUtility();
    TwitchUser__c twitchUser;

    public FtbTwitchAuthUser(){
        this.twitchUser = userUtilityClass.getTwitchUserBySessionId();
    }

    public FtbTwitchMonitorDto.StrategyDoExecuteCalloutDto doExecuteCallout(String keyParam){
        FtbTwitchMonitorDto.StrategyDoExecuteCalloutDto result = new FtbTwitchMonitorDto.StrategyDoExecuteCalloutDto(String.isBlank(this.twitchUser.AccessToken__c));
        result.outcome = this.twitchUser.Id;
        return result;
    }

    public HttpRequest setAdditionalHeaders(HttpRequest req){
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        return req;
    }

    public HttpRequest setParamsOrBody(HttpRequest req, String params){
        List<TwitchApp__c> appCredentials = FtbTwitchUtility.getTwitchApp();
        req.setBody(generateBody(appCredentials[0].ClientId__c, appCredentials[0].ClientSecret__c, params));
        return req;
    }

    public FtbTwitchMonitorDto.FacadeResponse handleResponse(HttpResponse res){

        FtbTwitchMonitorDto.FacadeResponse response = new FtbTwitchMonitorDto.FacadeResponse(); 

        if(res.getStatusCode() != 200){
            throw new FtbTwitchException('Unable to Token User: ' + res.getStatusCode() + ' ' + res.getStatus(), String.valueOf(FtbTwitchEnums.FtbTwitchErrors.AUTH_ERROR));
        }

        FtbTwitchMonitorDto.TwitchAuthUserResponse authResponse = (FtbTwitchMonitorDto.TwitchAuthUserResponse)JSON.deserialize(res.getBody(), FtbTwitchMonitorDto.TwitchAuthUserResponse.class);

        TwitchUser__c twitchUser = new TwitchUser__c(
            Id = this.twitchUser.Id, 
            AccessToken__c = authResponse.access_token, 
            RefreshToken__c = authResponse.refresh_token);
        
        response.sobjToUpsert.add(twitchUser);
        response.operationOutcome = this.twitchUser.Id;
        
        return response;
    }

    private String generateBody(String clientId, String clientSecret, String code){
        return 'client_secret=' + clientSecret + '&client_id=' + clientId + '&code=' + code + '&grant_type=authorization_code&redirect_uri=' + FtbTwitchConstants.REDIRECT_URI;
    }

}