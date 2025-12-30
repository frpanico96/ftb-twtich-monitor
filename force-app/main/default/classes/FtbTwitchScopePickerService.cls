public with sharing class FtbTwitchScopePickerService {

    public static FtbTwitchUserUtility twitchUserUtility = new FtbTwitchUserUtility();


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

    public static void upsertAdditionalScopes(String additionalScopes){

        List<String> scopes = (FtbTwitchConstants.DEFAULT_SCOPES + ' ' + additionalScopes).split(' ');
        List<TwitchUserScope__c> scopesToUpsert = new List<TwitchUserScope__c>();


        String twitchUserId = twitchUserUtility.getTwitchUserBySessionId().Id;

        try{

            Map<String, TwitchScope__c> scopeMap = (Map<String, TwitchScope__c>) SOQL.of(TwitchScope__c.SObjectType)
                .with(TwitchScope__c.ScopeApiName__c)
                .whereAre(SOQL.Filter.with(TwitchScope__c.ScopeApiName__c).isIn(scopes))
                .mockId('FtbTwitchScopePickerService.upsertAdditionalScopes')
                .toMap(TwitchScope__c.ScopeApiName__c);
    
            Map<String, TwitchUserScope__c> existingUserScopesMap = (Map<String, TwitchUserScope__c>) SOQL.of(TwitchUserScope__c.SObjectType)
                .with(TwitchUserScope__c.Id)
                .with('TwitchScope__r', TwitchScope__c.ScopeApiName__c)
                .whereAre(SOQL.Filter.with(TwitchUserScope__c.TwitchUser__c).equal(twitchUserId))
                .mockId('FtbTwitchScopePickerService.upsertAdditionalScopes.existingUserScopesMap')
                .toMap('TwitchScope__r', TwitchScope__c.ScopeApiName__c);
    
            for(String scope : scopes){
    
                if(scopeMap.get(scope) == null){
                    continue;
                }
    
                if(existingUserScopesMap.get(scope) != null){
                    existingUserScopesMap.remove(scope);
                    continue;
                }
                TwitchUserScope__c userScope = new TwitchUserScope__c(
                    TwitchUser__c = twitchUserId,
                    TwitchScope__c = scopeMap.get(scope).Id,
                    Active__c = true
                );
                scopesToUpsert.add(userScope);
    
            }
    
            /* Deactivate existing scopes that have not been selected */
            for(TwitchUserScope__c existingScope : existingUserScopesMap.values()){
                scopesToUpsert.add(new TwitchUserScope__c(
                    Id = existingScope.Id,
                    Active__c = false
                ));
            }
    
            new DML()
                .toUpsert(scopesToUpsert)
                .commitWork();

        }catch(Exception e){
            throw new FtbTwitchException('Error upserting additional scopes: ' + e.getMessage());
        }

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