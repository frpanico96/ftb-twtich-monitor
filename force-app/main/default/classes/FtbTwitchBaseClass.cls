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

    protected TwitchSession__c createTwitchSession(String sessionId){
        return new TwitchSession__c(
            Name=sessionId,
            SessionId__c=sessionId);
    }

    protected String getTwitchSessionId(){
        List<TwitchSession__c> sessions = SOQL.of(TwitchSession__c.SObjectType)
            .with(TwitchSession__c.SessionId__c)
            .whereAre(SOQL.Filter.with(TwitchSession__c.CreatedById).equal(UserInfo.getUserId()))
            .orderBy(TwitchSession__c.CreatedDate)
            .sortDesc()
            .setLimit(1)
            .mockId('FtbTwitchUserUtility.getTwitchSessionId')
            .toList();
        
        if(sessions.isEmpty() || (!sessions.isEmpty() && String.isBlank(sessions[0].SessionId__c))){
            throw new FtbTwitchException('No session found', String.valueOf(FtbTwitchEnums.FtbTwitchErrors.AUTH_ERROR));
        }

        return sessions[0].SessionId__c;
    }

}