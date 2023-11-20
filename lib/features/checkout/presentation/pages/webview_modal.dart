import 'dart:io';

import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewModal extends StatefulWidget {
  final String url;
  final String title;

  const WebViewModal({required this.url, required this.title, Key? key})
      : super(key: key);

  @override
  State<WebViewModal> createState() => _WebViewModalState();
}

class _WebViewModalState extends State<WebViewModal> {
  late WebViewController controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlatformState();
  }

  void initPlatformState() async {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(),
      )
      ..loadRequest(Uri.parse('https://flutter.dev'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child:
            //Check if iOS or Android
            Platform.isAndroid || Platform.isIOS
                ? Column(
                    children: [
                      const Text('WebView Launch'),
                      ElevatedButton(
                          onPressed: () {
                            controller.loadRequest(Uri.parse(widget.url));
                          },
                          child: const Text('Launch WebView')),
                      WebViewWidget(
                        controller: controller,
                      ),
                    ],
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
