import 'dart:io';

import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final String title;

  const WebViewPage({required this.url, required this.title, Key? key})
      : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController controller;
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  void initPlatformState() async {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            if (request.url.contains('thank_you')) {
              Navigator.of(context).pop(true);
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child:
            //Check if iOS or Android
            Platform.isAndroid || Platform.isIOS
                ? WebViewWidget(
                    controller: controller,
                  )
                : const Center(
                    child: TextBody(
                      text: 'WebView is only available on Android and iOS',
                    ),
                  ),
      ),
    );
  }
}
