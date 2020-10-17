import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CommossionPage extends StatefulWidget {
  @override
  _CommossionPageState createState() => _CommossionPageState();
}

class _CommossionPageState extends State<CommossionPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('عمولة الموقع'),
      ),
      body: WebView(
        initialUrl: 'https://dalllal.com/commission',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
    );
  }
}
