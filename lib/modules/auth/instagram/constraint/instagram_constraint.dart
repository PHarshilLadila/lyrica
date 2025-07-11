// class InstagramConstant {
//   static InstagramConstant? _instance;
//   static InstagramConstant get instance {
//     _instance ??= InstagramConstant._init();
//     return _instance!;
//   }

//   InstagramConstant._init();

//   // static const String clientID = '377289444572944'; //'718353975697969';
//   static const String clientID = '582295874936894'; //'718353975697969';
//   // static const String appSecret =
//   //     'a04e27281d98a14fc90b317b1c8c8cc3';  ;
//   static const String appSecret =
//       'c9e9918cfcf3d82e2092af2887df5942';  ;
//   // static const String redirectUri =
//   //     'https://lyrica-88a25.firebaseapp.com/__/auth/handler';
//   static const String redirectUri =
//       'https://lyrica-35d7c.firebaseapp.com/__/auth/handler';
//   // 'https://www.example.com/';
//   static const String scope = 'user_profile,user_media';
//   static const String responseType = 'code';
//   // final String url =
//   //     'https://api.instagram.com/oauth/authorize?client_id=$clientID&redirect_uri=$redirectUri&scope=user_profile,user_media&response_type=$responseType';

//   final String url = Uri.encodeFull(
//     'https://api.instagram.com/oauth/authorize'
//     '?client_id=$clientID'
//     '&redirect_uri=$redirectUri'
//     '&scope=$scope'
//     '&response_type=$responseType',
//   );
// }

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
