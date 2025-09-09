public with sharing class FtbTwitchTelemetryService {

    public static TwitchLog__c logTrace(String message, String action, TwitchLog__c log){
        log.Message__c = message;
        log.Action__c = action;

        return log;
    }

    public static TwitchLog__c logException(String message, String action, TwitchLog__c log){

        log.IsError__c = true;
        log.Message__c = message;
        log.Action__c = action;

        return log;

    }

    public static TwitchLog__c logCalloutRequest(String httpMethod, String endpoint, String body, String action, TwitchLog__c log){


        log.HttpMethod__c = httpMethod;
        log.Endpoint__c = endpoint;
        log.RequestBody__c = body;
        log.Action__c = action;

        return log;
    }

}