public with sharing class FtbTwitchGetUser implements FtbITwitchInvokeStrategy {

    private Map<String, String> broadcasterTypeMap = new Map<String, String>{
            'partner' => 'Partner',
            'affiliate' => 'Affiliate',
            '' => ''
        };

    private Map<String, String> userType = new Map<String, String>{
        'admin' => 'Admin',
        'global_mod' => 'Global Mod',
        'staff' => 'Staff'
    };

    public Boolean doExecuteCallout(String keyParam){
        List<TwitchUser__c> existingUsers =(List<TwitchUser__c>)FtbTwitchDbOps.getSobject([SELECT Id FROM TwitchUser__c WHERE Name = :keyParam]);
        return existingUsers.isEmpty();
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

        FtbTwitchMonitorDto.FacadeResponse result = new FtbTwitchMonitorDto.FacadeResponse();

        if(res.getStatusCode() != 200){
            throw new FtbTwitchException('Error: ' + JSON.serialize(res.getBody()));
        }

        FtbTwitchMonitorDto.TwitchGetUserResponse userRes = (FtbTwitchMonitorDto.TwitchGetUserResponse) JSON.deserialize(res.getBody(), FtbTwitchMonitorDto.TwitchGetUserResponse.class);

        if(userRes.data.isEmpty()){
            throw new FtbTwitchException('Empty response from get Twitch User');
        }

        FtbTwitchMonitorDto.TwitchUserResponseData userResData = userRes.data[0];

        TwitchUser__c twitchUser = new TwitchUser__c(
            Name=userResData.login,
            TwitchId__c=userResData.id,
            DisplayName__c=userResData.display_name,
            LogoUrl__c=userResData.profile_image_url,
            OfflineLogoUrl__c=userResData.offline_image_url,
            Description__c=userResData.description,
            ViewCount__c=userResData.view_count,
            BroadcasterType__c=this.broadcasterTypeMap.get(userResData.broadcaster_type),
            UserType__c=this.userType.get(userResData.type)
        );

        result.sobjToUpsert.add(twitchUser);
        result.operationOutcome = String.valueOf(FtbTwitchEnums.FtbTwitchOutcome.SUCCESS);
        return result;

    }

}