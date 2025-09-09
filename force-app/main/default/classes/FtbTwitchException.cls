public with sharing class FtbTwitchException extends Exception {

    public FtbTwitchException(String message, String action, TwitchLog__c log){
        log = FtbTwitchTelemetryService.logException(message, action, log);
        Database.insert(log, false, AccessLevel.USER_MODE);
    }
}