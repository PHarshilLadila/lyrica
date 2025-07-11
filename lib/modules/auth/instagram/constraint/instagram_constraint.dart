class InstagramConstant {
  static const String clientID = '1225775395543198';
  static const String appSecret = '7dd6f089bb1cc52b2fe849c8abc89f73';
  static const String redirectUri = 'https://food-app-dusky-two.vercel.app/';
  static const String scope =
      'instagram_business_basic,instagram_business_manage_messages,instagram_business_manage_comments,instagram_business_content_publish,instagram_business_manage_insights';
  static const String responseType = 'code';

  static String get authorizationUrl {
    return 'https://www.instagram.com/oauth/authorize?'
        'client_id=$clientID&'
        'redirect_uri=${Uri.encodeComponent(redirectUri)}&'
        'scope=${Uri.encodeComponent(scope)}&'
        'response_type=$responseType&'
        'state=flutter_auth&'
        'force_reauth=true';
  }

  static String get tokenUrl => 'https://api.instagram.com/oauth/access_token';
  static String get graphUrl => 'https://graph.instagram.com';
}
