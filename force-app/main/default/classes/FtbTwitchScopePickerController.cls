public with sharing class FtbTwitchScopePickerController {


    @AuraEnabled
    public static String getTwitchScopeForBoxList(){
       return JSON.serialize(FtbTwitchScopePickerService.getOrganizedScopes());
    }

}