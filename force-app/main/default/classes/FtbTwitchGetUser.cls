public with sharing class FtbTwitchGetUser extends FtbTwitchBaseClass implements FtbITwitchInvokeStrategy{



    public FtbTwitchMonitorDto.StrategyDoExecuteCalloutDto doExecuteCallout(String keyParam){

        List<TwitchUser__c> existingUsers = SOQL.of(TwitchUser__c.SObjectType)
            .with(TwitchUser__c.Id)
            .whereAre(SOQL.Filter.with(TwitchUser__c.Name).equal((keyParam)))
            .mockId('FtbTwitchGetUser.doExecuteCallout')
            .toList();
        
        return new FtbTwitchMonitorDto.StrategyDoExecuteCalloutDto(existingUsers.isEmpty());
    }

    public HttpRequest setAdditionalHeaders(HttpRequest req){
        List<TwitchApp__c> appCredentials = FtbTwitchUtility.getTwitchApp();

        req.setHeader('Authorization', 'Bearer ' + appCredentials[0].AccessToken__c);
        req.setHeader('Client-Id', appCredentials[0].ClientId__c);
        return req;
    }

    public HttpRequest setParamsOrBody(HttpRequest req, String params){
        String endpointWithParams = req.getEndpoint() + '?login=' + params;
        req.setEndpoint(endpointWithParams);
        return req;
    }

    public FtbTwitchMonitorDto.FacadeResponse handleResponse(HttpResponse res){

        FtbTwitchUserUtility userUtilityClass = new FtbTwitchUserUtility();
        FtbTwitchMonitorDto.FacadeResponse result = new FtbTwitchMonitorDto.FacadeResponse();

        if(res.getStatusCode() != 200){
            throw new FtbTwitchException('Error: ' + JSON.serialize(res.getBody()));
        }

        FtbTwitchMonitorDto.TwitchGetUserResponse userRes = (FtbTwitchMonitorDto.TwitchGetUserResponse) JSON.deserialize(res.getBody(), FtbTwitchMonitorDto.TwitchGetUserResponse.class);

        if(userRes.data.isEmpty()){
            throw new FtbTwitchException('Empty response from get Twitch User');
        }

        FtbTwitchMonitorDto.TwitchUserResponseData userResData = userRes.data[0];

        TwitchUser__c twitchUser = userUtilityClass.createTwitchUser(userResData);

        TwitchSession__c twitchSession = this.createTwitchSession(userResData.id);

        result.sobjToUpsert.add(twitchUser);
        result.sobjToUpsert.add(twitchSession);
        result.operationOutcome = String.valueOf(FtbTwitchEnums.FtbTwitchOutcome.SUCCESS);
        return result;

    }

}