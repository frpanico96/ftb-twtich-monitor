public with sharing class FtbTwitchInvokeFacade extends FtbTwitchBaseClass{

    private FtbTwitchAdapter__mdt adpaterImplSettings;
    
    private TwitchInvokerStrategy__mdt strategySettings;

    private FtbITwitchAdapter adapter;

    private FtbITwitchInvokeStrategy strategy;

    public FtbTwitchInvokeFacade(String strategyName) {
        TwitchInvokerStrategy__mdt strategyRecord = TwitchInvokerStrategy__mdt.getInstance(strategyName);
        
        if(strategyRecord?.Id == null || !strategyRecord?.Active__c){
            throw new FtbTwitchException('Unimplemented Strategy');
        }

        this.strategySettings = strategyRecord;
        this.adpaterImplSettings = FtbTwitchAdapter__mdt.getInstance('FtbTwitchAdapterImpl');

        adapter = (FtbITwitchAdapter)(Type.forName(this.adpaterImplSettings.DeveloperName)).newInstance();
        strategy = (FtbITwitchInvokeStrategy)(Type.forName(this.strategySettings.DeveloperName)).newInstance();
    }

    public String operate(){

        TwitchLog__c log = new TwitchLog__c();

        try{ 
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();

            req.setEndpoint(this.strategySettings.Endpoint__c);
            req.setMethod(this.strategySettings.Method__c);
            req.setTimeout(Integer.valueOf(this.strategySettings.Timeout__c));
    
            req = this.strategy.setAdditionalHeaders(req);
            req = this.strategy.setParamsOrBody(req);

            log = this.logRequest(req.getBody(), log);

            res = this.adapter.submitRequest(req);

            return this.strategy.handleResponse(res).operationOutcome;
        } catch(Exception e){
            throw new FtbTwitchException(e.getMessage(), this.strategySettings.DeveloperName, log);
        }


    }

    public override TwitchLog__c logRequest(String reqBody, TwitchLog__c log){
        return FtbTwitchTelemetryService.logCalloutRequest(
            this.strategySettings.Method__c,
            this.strategySettings.Method__c,
            reqBody,
            this.strategySettings.DeveloperName,
            log);
    }


}