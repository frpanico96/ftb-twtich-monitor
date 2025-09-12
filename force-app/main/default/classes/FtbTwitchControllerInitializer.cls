public with sharing class FtbTwitchControllerInitializer {

    @AuraEnabled
    public static string connectApp(){
        try {
            FtbTwitchInvokeFacade client = new FtbTwitchInvokeFacade('FtbTwitchAuthApp');
            return client.operate();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}