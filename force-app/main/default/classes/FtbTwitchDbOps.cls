public with sharing class FtbTwitchDbOps {

    public static List<SObject> getSobject(List<SObject> sobjs){

        SObjectAccessDecision decision = Security.stripInaccessible(AccessType.READABLE, sobjs);
        return decision.getRecords();

    }

    public static Database.SaveResult[] insertSobject(List<SObject> sobjs){
        Database.SaveResult[] saveResults = Database.insert(sobjs, false, AccessLevel.USER_MODE);
        return saveResults;
    }

    public static void insertSobject(SObject sobj){
        Database.SaveResult[] saveResults = Database.insert(new List<SObject>{sobj}, false, AccessLevel.USER_MODE);
        // return saveResults;
    }

    public static void upsertSobject(List<SObject> sobjs){
        Database.UpsertResult[] upsertResults = Database.upsert(sobjs, false, AccessLevel.USER_MODE);
    }

}