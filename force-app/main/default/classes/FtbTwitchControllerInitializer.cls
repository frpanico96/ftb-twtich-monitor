public with sharing class FtbTwitchControllerInitializer {

    @AuraEnabled
    public static string connectApp(){
        FtbTwitchInvokeFacade client = new FtbTwitchInvokeFacade('FtbTwitchAuthApp');
        return client.operate('');
    }

    @AuraEnabled
    public static string getTwitchUser(String user){
        FtbTwitchInvokeFacade client = new FtbTwitchInvokeFacade('FtbTwitchGetUser');
        return client.operate(user);
    }

    @AuraEnabled
    public static string getTwitchLoginUrl(String additionalScopes){
        return FtbTwitchServiceInitializer.generateTwitchLoginUrl(additionalScopes);
    }

    @AuraEnabled
    public static string connectUser(String code){
        FtbTwitchInvokeFacade client = new FtbTwitchInvokeFacade('FtbTwitchAuthUser');
        return client.operate(code);
    }

}