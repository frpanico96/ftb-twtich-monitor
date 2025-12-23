public with sharing class FtbTwitchException extends Exception {

    public FtbTwitchException(String message, String action){
        TwitchLog__c log = FtbTwitchTelemetryService.logException(message, action, new TwitchLog__c());
        new DML()
            .toInsert(log)
            .identifier('FtbTwitchException.messageAction')
            .commitWork();
    }

    public FtbTwitchException(String message, String action, TwitchLog__c log){
        log = FtbTwitchTelemetryService.logException(message, action, log);
        new DML()
            .toInsert(log)
            .identifier('FtbTwitchException.messageActionLog')
            .commitWork();
    }
}