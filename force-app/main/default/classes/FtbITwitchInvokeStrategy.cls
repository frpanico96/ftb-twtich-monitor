public interface FtbITwitchInvokeStrategy {

    HttpRequest setParamsOrBody(HttpRequest req);
    HttpRequest setAdditionalHeaders(HttpRequest req);
    FtbTwitchMonitorDto.FacadeResponse handleResponse(HttpResponse res);
}