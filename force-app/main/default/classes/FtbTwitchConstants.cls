public with sharing class FtbTwitchConstants {

    public static final String REDIRECT_URI = Url.getOrgDomainUrl().toExternalForm() + '/apex/ftbTwitchInitializerFinalizePage';

    public static final String TWITCH_LOGIN_BASE_URL = 'https://id.twitch.tv/oauth2/authorize';

    public static final String TWITCH_LOGIN_CODE = 'code';

}