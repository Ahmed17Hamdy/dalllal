import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MemeberPage extends StatefulWidget {
  @override
  _MemeberPageState createState() => _MemeberPageState();
}

class _MemeberPageState extends State<MemeberPage> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('العضوية الذهبية'),
      ),
      body: WebView(
        initialUrl: 'https://dalllal.com/pages/member',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
    );
  }
}
