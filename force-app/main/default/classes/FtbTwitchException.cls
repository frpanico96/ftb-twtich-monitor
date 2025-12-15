public with sharing class FtbTwitchException extends Exception {

    public FtbTwitchException(String message, String action){
        TwitchLog__c log = FtbTwitchTelemetryService.logException(message, action, new TwitchLog__c());
        FtbTwitchDbOps.insertSobject(log);
    }

    public FtbTwitchException(String message, String action, TwitchLog__c log){
        log = FtbTwitchTelemetryService.logException(message, action, log);
        FtbTwitchDbOps.insertSobject(log);
    }
}