public with sharing class FtbTwitchUtility extends FtbTwitchBaseClass{

    public FtbTwitchUtility(){
        super();
    }

    public static List<TwitchApp__c> getTwitchApp(String appName){
        throw new FtbTwitchException('Unimplemented method', String.valueOf(FtbTwitchEnums.FtbTwitchErrors.UNIMPLEMENTED_ERROR));
    }

    // This signature of the method get the default app
    public static List<TwitchApp__c> getTwitchApp(){

        List<TwitchApp__c> res = (List<TwitchApp__c>)FtbTwitchDbOps.getSobject([SELECT ClientId__c, ClientSecret__c FROM TwitchApp__c WHERE Active__c = true AND Default__c = true]);

        if(res.isEmpty()){
            throw new FtbTwitchException('No active app credentials found', String.valueOf(FtbTwitchEnums.FtbTwitchErrors.AUTH_ERROR));
        }

        return res;
    }



}