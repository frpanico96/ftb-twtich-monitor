public with sharing class FtbTwitchMonitorDto {

    public class TwitchAuthAppResponse{
        public String access_token;
        public Integer expires_in;
        public String token_type;
    }

    public class TwitchAuthUserResponse {
        public String access_token;
        public Integer expires_in;
        public String refresh_token;
        public List<String> scope;
        public String token_type;
    }

    public class TwitchGetUserResponse{
        public List<TwitchUserResponseData> data;
    }

    public class TwitchUserResponseData{
        public String id;
        public String login;
        public String display_name;
        public String type;
        public String broadcaster_type;
        public String description;
        public String profile_image_url;
        public String offline_image_url;
        public Integer view_count;
        public String created_at;
    }

    public class FacadeResponse {
        
        public List<SObject> sobjToUpsert;
        public String operationOutcome;

        public FacadeResponse(){
            this.sobjToUpsert = new List<SObject>();    
        }

    }

    public class StrategyDoExecuteCalloutDto{

        public Boolean executeCallout;
        public String outcome;

        public StrategyDoExecuteCalloutDto(Boolean executeCallout){
            this.executeCallout = executeCallout;
            this.outcome = String.valueOf(FtbTwitchEnums.FtbTwitchOutcome.SUCCESS);
        }
    }

    public class ClientResponse {
        public Boolean isError;
        public String message; 
    }

    public class TwitchScopePickerDto {
        public Map<String, TwitchScope> organizedScopes;
        public List<String> suggestedScopes;
        public List<TwitchScopeBoxListDto> boxListScopes;
    }

    public class TwitchScope {
        public String label;
        public String description;
        public Boolean isSuggested;

        public TwitchScope(String label, String description, Boolean isSuggested){
            this.label = label;
            this.description = description;
            this.isSuggested = isSuggested;
        }

    }

    public class TwitchScopeBoxListDto {

        public String label;
        public String value;

        public TwitchScopeBoxListDto(String label, String value){
            this.label = label;
            this.value = value;
        }
    }

}