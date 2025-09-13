public with sharing class FtbTwitchControllerInitializer {

    @AuraEnabled
    public static string connectApp(){
        FtbTwitchInvokeFacade client = new FtbTwitchInvokeFacade('FtbTwitchAuthApp');
        return client.operate();
    }

}