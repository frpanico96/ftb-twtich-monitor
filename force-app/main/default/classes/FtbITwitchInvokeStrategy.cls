public interface FtbITwitchInvokeStrategy {

    FtbTwitchMonitorDto.StrategyDoExecuteCalloutDto doExecuteCallout(String keyParam);
    HttpRequest setParamsOrBody(HttpRequest req, String params);
    HttpRequest setAdditionalHeaders(HttpRequest req);
    FtbTwitchMonitorDto.FacadeResponse handleResponse(HttpResponse res);
}