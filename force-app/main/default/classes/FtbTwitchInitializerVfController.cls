public with sharing class FtbTwitchInitializerVfController {


    public PageReference redirectToLwc(){
        String codeParam = ApexPages.currentPage().getParameters().get('code');
        String lwcUrl = '/lightning/cmp/c__ftbTwitchInitializerAuthFinalizer?c__code=' + codeParam;
        PageReference pageRef = new PageReference(lwcUrl);
        pageRef.setRedirect(true);
        return pageRef;
    }

}