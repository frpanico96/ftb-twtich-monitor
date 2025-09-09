public with sharing class FtbTwitchMonitorDto {

    public class TwitchAuthAppResponse{
        public String access_token;
        public Integer expires_in;
        public String token_type;
    }


    public class FacadeResponse {
        
        public List<SObject> sobjToUpsert;
        public String operationOutcome;

        public FacadeResponse(){
            this.sobjToUpsert = new List<SObject>();    
        }

    }

}