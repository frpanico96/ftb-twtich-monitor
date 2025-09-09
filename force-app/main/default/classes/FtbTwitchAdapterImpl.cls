public with sharing class FtbTwitchAdapterImpl implements FtbITwitchAdapter{

    public HttpResponse submitRequest(HttpRequest req){
        Http h = new Http();
        return h.send(req);
    }

}