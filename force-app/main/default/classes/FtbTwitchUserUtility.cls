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

    public string getTwitchUsername(){
        String sessionId = this.getTwitchSessionId();

        TwitchUser__c twitchUser = getTwitchUserByTwitchId(sessionId);

        return twitchUser.DisplayName__c;
    }

    public string getTwitchUserId(){
        String sessionId = this.getTwitchSessionId();

        TwitchUser__c twitchUser = getTwitchUserByTwitchId(sessionId);

        return twitchUser.TwitchId__c;
    }

    public TwitchUser__c getTwitchUserBySessionId(){
        String sessionId = this.getTwitchSessionId();

        return getTwitchUserByTwitchId(sessionId);
    
    }

    public TwitchUser__c getTwitchUserByTwitchId(String twitchId){

        List<TwitchUser__c> twitchUsers = FtbTwitchDbOps.getSobject([SELECT Id, 
            Name, 
            DisplayName__c, 
            TwitchId__c, 
            LogoUrl__c, 
            Description__c, 
            AccessToken__c, 
            RefreshToken__c, 
            OfflineLogoUrl__c, 
            ViewCount__c, 
            UserType__c, 
            BroadcasterType__c 
            FROM TwitchUser__c  
            WHERE TwitchId__c = :twitchId]);
        
        if(twitchUsers.isEmpty()){
            throw new FtbTwitchException('No user found for twitch id: ' + twitchId, 
            String.valueOf(FtbTwitchEnums.FtbTwitchErrors.GENERIC_ERROR));
        }

        return twitchUsers[0];
    }

}