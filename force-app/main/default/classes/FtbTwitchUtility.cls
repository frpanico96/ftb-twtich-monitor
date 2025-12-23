public with sharing class FtbTwitchUtility extends FtbTwitchBaseClass{

    public FtbTwitchUtility(){
        super();
    }

    public static List<TwitchApp__c> getTwitchApp(String appName){
        throw new FtbTwitchException('Unimplemented method', String.valueOf(FtbTwitchEnums.FtbTwitchErrors.UNIMPLEMENTED_ERROR));
    }

    // This signature of the method get the default app
    public static List<TwitchApp__c> getTwitchApp(){

        List<TwitchApp__c> res = SOQL.of(TwitchApp__c.SObjectType)
        .with(TwitchApp__c.AccessToken__c, TwitchApp__c.ClientId__c, TwitchApp__c.ClientSecret__c, TwitchApp__c.TokenExpiration__c)
        .whereAre(SOQL.FilterGroup
            .add(SOQL.Filter.with(TwitchApp__c.Active__c).isTrue())
            .add(SOQL.Filter.with(TwitchApp__c.Default__c).isTrue()))
        .mockId('FtbTwitchUtility.getTwitchApp')
        .toList();

        if(res.isEmpty()){
            throw new FtbTwitchException('No active app credentials found', String.valueOf(FtbTwitchEnums.FtbTwitchErrors.AUTH_ERROR));
        }

        return res;
    }



}