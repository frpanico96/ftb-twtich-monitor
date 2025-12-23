public with sharing class FtbTwitchUserUtility extends FtbTwitchBaseClass{

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


    public TwitchUser__c createTwitchUser(FtbTwitchMonitorDto.TwitchUserResponseData userResData){
        return new TwitchUser__c(
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
    }


    public TwitchUser__c getTwitchUserBySessionId(){
        String sessionId = this.getTwitchSessionId();

        return getTwitchUserByTwitchId(sessionId);
    
    }

    public TwitchUser__c getTwitchUserByTwitchId(String twitchId){

        List<TwitchUser__c> twitchUsers = 
            SOQL.of(TwitchUser__c.SObjectType)
            .with(new List<SobjectField>{TwitchUser__c.Id, 
                  TwitchUser__c.Name, 
                  TwitchUser__c.DisplayName__c, 
                  TwitchUser__c.TwitchId__c, 
                  TwitchUser__c.LogoUrl__c, 
                  TwitchUser__c.Description__c, 
                  TwitchUser__c.AccessToken__c, 
                  TwitchUser__c.RefreshToken__c, 
                  TwitchUser__c.OfflineLogoUrl__c, 
                  TwitchUser__c.ViewCount__c, 
                  TwitchUser__c.UserType__c, 
                  TwitchUser__c.BroadcasterType__c})
            .whereAre(SOQL.Filter.with(TwitchUser__c.TwitchId__c).equal(twitchId))
            .mockId('FtbTwitchUserUtility.getTwitchUserByTwitchId')
            .toList();
        
        if(twitchUsers.isEmpty()){
            throw new FtbTwitchException('No user found for twitch id: ' + twitchId, 
            String.valueOf(FtbTwitchEnums.FtbTwitchErrors.GENERIC_ERROR));
        }

        return twitchUsers[0];
    }

}