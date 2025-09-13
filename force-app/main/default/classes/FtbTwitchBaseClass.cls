public abstract with sharing class FtbTwitchBaseClass {

    public virtual TwitchLog__c logRequest(String reqBody, TwitchLog__c log){
        throw new FtbTwitchException('Unimplemented method', String.valueOf(FtbTwitchEnums.FtbTwitchErrors.UNIMPLEMENTED_ERROR));
    }

    public virtual TwitchLog__c logResponse(String resBody, Integer statusCode, TwitchLog__c log){
        throw new FtbTwitchException('Unimplemented method', String.valueOf(FtbTwitchEnums.FtbTwitchErrors.UNIMPLEMENTED_ERROR));
    }

    protected String encryptBody(String body){
        String algo = 'AES128';
        Blob key = Crypto.generateAesKey(128);
        Blob data = Blob.valueOf(body);
        return String.valueOf(Crypto.encryptWithManagedIV(algo, key, data));
    }

}