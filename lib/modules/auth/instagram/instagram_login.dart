import 'package:flutter/material.dart';
import 'package:lyrica/common/widget/app_text.dart';
import 'package:lyrica/modules/auth/instagram/constraint/instagram_constraint.dart';
import 'package:lyrica/modules/auth/instagram/model/instagram_model.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InstagramView extends StatefulWidget {
  const InstagramView({super.key});

  @override
  State<InstagramView> createState() => _InstagramViewState();
}

class _InstagramViewState extends State<InstagramView> {
  late final WebViewController _controller;
  final InstagramModel _instagramModel = InstagramModel();
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(Colors.white)
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                setState(() {
                  _isLoading = progress < 100;
                });
              },
              onPageStarted: (String url) {
                debugPrint('Page started: $url');
                setState(() {
                  _isLoading = true;
                  _hasError = false;
                });
              },
              onPageFinished: (String url) {
                debugPrint('Page finished: $url');
                setState(() {
                  _isLoading = false;
                });
              },
              onWebResourceError: (WebResourceError error) {
                debugPrint('WebView error: ${error.description}');
                setState(() {
                  _hasError = true;
                  _isLoading = false;
                });
              },
              onNavigationRequest: (NavigationRequest request) {
                final url = request.url;
                debugPrint('Navigation request: $url');

                if (url.startsWith('lyricaapp://auth')) {
                  _instagramModel.getAuthorizationCode(url);
                  _handleInstagramAuth();
                  return NavigationDecision.prevent;
                }

                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(InstagramConstant.authorizationUrl));
  }

  Future<void> _clearCacheAndReload() async {
    final cookieManager = WebViewCookieManager();
    await cookieManager.clearCookies();
    await _controller.clearCache();

    debugPrint("Cleared cookies and cache. Reloading login page...");
    _controller.loadRequest(Uri.parse(InstagramConstant.authorizationUrl));
  }

  Future<void> _handleInstagramAuth() async {
    if (_instagramModel.error != null) {
      _showError(_instagramModel.error!);
      return;
    }

    final gotToken = await _instagramModel.getTokenAndUserID();
    if (!gotToken) {
      _showError(_instagramModel.error ?? 'Failed to get access token');
      return;
    }

    final gotProfile = await _instagramModel.getUserProfile();
    if (!gotProfile) {
      _showError(_instagramModel.error ?? 'Failed to get user profile');
      return;
    }

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder:
              (context) => AuthSuccessScreen(
                username: _instagramModel.username ?? 'No username',
                accessToken: _instagramModel.accessToken ?? 'No token',
                userId: _instagramModel.userID ?? 'No user ID',
              ),
        ),
      );
    }
  }

  Future<void> _reloadWebView() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    await _controller.clearCache();
    await _controller.loadRequest(
      Uri.parse(InstagramConstant.authorizationUrl),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 5)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(textName: 'Instagram Login'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Clear Cache & Reload',
            onPressed: _clearCacheAndReload,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _reloadWebView,
            tooltip: 'Reload',
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
          if (_hasError)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppText(
                    textColor: Colors.red,
                    textName: 'Failed to load Instagram',
                    fontSize: 18,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _reloadWebView,
                    child: AppText(textName: 'Try Again'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class AuthSuccessScreen extends StatelessWidget {
  final String username;
  final String accessToken;
  final String userId;

  const AuthSuccessScreen({
    super.key,
    required this.username,
    required this.accessToken,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Authentication Success')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(textName: 'Username: $username', fontSize: 18),
            const SizedBox(height: 10),
            AppText(textName: 'User ID: $userId', fontSize: 18),
            const SizedBox(height: 20),
            const AppText(textName: 'Access Token:', fontSize: 18),
            SelectableText(
              accessToken,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
