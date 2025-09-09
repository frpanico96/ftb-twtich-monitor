public abstract with sharing class FtbTwitchBaseClass {

    public virtual TwitchLog__c logRequest(String reqBody, TwitchLog__c log){
        throw new FtbTwitchException('Unimplemented method');
    }

}