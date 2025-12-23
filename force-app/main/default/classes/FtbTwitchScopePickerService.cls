public with sharing class FtbTwitchScopePickerService {


    public static FtbTwitchMonitorDto.TwitchScopePickerDto getOrganizedScopes(){

        FtbTwitchMonitorDto.TwitchScopePickerDto result = new FtbTwitchMonitorDto.TwitchScopePickerDto();
        result.organizedScopes = new Map<String, FtbTwitchMonitorDto.TwitchScope>();
        result.suggestedScopes = new List<String>();
        result.boxListScopes = new List<FtbTwitchMonitorDto.TwitchScopeBoxListDto>();
 

        List<TwitchScope__c> scopes = getAllScopes();
        for(TwitchScope__c scope: scopes){
            result.organizedScopes.put(scope.ScopeApiName__c, 
                new FtbTwitchMonitorDto.TwitchScope(scope.Name, scope.Description__c, scope.Suggested__c));
            result.boxListScopes.add(new FtbTwitchMonitorDto.TwitchScopeBoxListDto(scope.Name, scope.ScopeApiName__c));
            if(scope.Suggested__c){
                result.suggestedScopes.add(scope.ScopeApiName__c);
            }

        }
        return result;

    }

    private static List<TwitchScope__c> getAllScopes(){

        return SOQL.of(TwitchScope__c.SObjectType)
            .with(TwitchScope__c.Description__c, TwitchScope__c.Name,
                  TwitchScope__c.Suggested__c,
                  TwitchScope__c.ScopeApiName__c)
            .whereAre(SOQL.Filter.with(TwitchScope__c.Active__c).isTrue())
            .mockId('FtbTwitchScopePickerService.getAllScopes')
            .toList();
 
    }


}