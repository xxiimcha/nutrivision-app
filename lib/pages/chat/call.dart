import 'package:flutter/material.dart';
import 'package:webview_windows/webview_windows.dart';

class CallWebView extends StatefulWidget {
  final String roomLink;

  const CallWebView({required this.roomLink, Key? key}) : super(key: key);

  @override
  State<CallWebView> createState() => _CallWebViewState();
}

class _CallWebViewState extends State<CallWebView> {
  final _controller = WebviewController();

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  Future<void> _initWebView() async {
    try {
      await _controller.initialize();
      print('WebView initialized');

      // Ensure the URL starts with 'http' or 'https'
      String url = widget.roomLink;
      if (!url.startsWith('http')) {
        url = 'https://$url';
      }

      if (_controller.value.isInitialized) {
        await _controller.loadUrl(url);
        print('WebView URL Loaded: $url');
        setState(() {}); // Trigger rebuild to display the WebView
      }
    } catch (e) {
      print('Error initializing WebView: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Call Room'),
      ),
      body: _controller.value.isInitialized
          ? Webview(_controller, permissionRequested: _onPermissionRequested)
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Future<WebviewPermissionDecision> _onPermissionRequested(
    String url, WebviewPermissionKind kind, bool isUserInitiated,
  ) async {
    // Handle camera/microphone permissions
    if (kind == WebviewPermissionKind.microphone || kind == WebviewPermissionKind.camera) {
      return WebviewPermissionDecision.allow;
    }
    return WebviewPermissionDecision.deny;
  }
}
