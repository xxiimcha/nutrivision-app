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
    await _controller.initialize();
    _controller.loadUrl(widget.roomLink);
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
    return WebviewPermissionDecision.allow;
  }
}
