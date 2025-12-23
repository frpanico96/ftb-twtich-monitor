public with sharing class FtbTwitchScopePickerController {


    @AuraEnabled
    public static FtbTwitchMonitorDto.TwitchScopePickerDto getTwitchScopeForBoxList(){
       return FtbTwitchScopePickerService.getOrganizedScopes();
    }

}