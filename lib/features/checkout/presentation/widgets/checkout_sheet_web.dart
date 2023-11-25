import 'dart:developer';
import 'dart:io';

import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:ecom_template/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:ecom_template/features/shop/presentation/widgets/state_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CheckoutSheetWeb extends StatefulWidget {
  final String checkoutId;
  final Function(bool) onComplete;

  const CheckoutSheetWeb(
      {required this.checkoutId, required this.onComplete, super.key});

  @override
  State<CheckoutSheetWeb> createState() => _CheckoutSheetWebState();
}

class _CheckoutSheetWebState extends State<CheckoutSheetWeb> {
  late WebViewController controller;
  late Future<bool> webViewReady;

  @override
  void initState() {
    super.initState();
    webViewReady = initPlatformState();
  }

  Future<bool> initPlatformState() async {
    if (Platform.isAndroid || Platform.isIOS) {
      controller = WebViewController();
      await controller.setJavaScriptMode(JavaScriptMode.unrestricted);
      await controller.setBackgroundColor(const Color(0x00000000));
      await controller.setNavigationDelegate(
        NavigationDelegate(
          onUrlChange: (url) {
            log(url.url.toString());
            if ((url.url ?? '').contains('thank-you')) {
              log('Checkout Complete');
              widget.onComplete(true);
            }
          },
        ),
      );
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CheckoutBloc, CheckoutState>(
        builder: (context, checkoutState) {
          if (checkoutState is CheckoutLoaded &&
              checkoutState.checkout.webUrl != null) {
            if (Platform.isAndroid || Platform.isIOS) {
              controller.loadRequest(Uri.parse(checkoutState.checkout.webUrl!));
            }
          }
          switch (checkoutState.runtimeType) {
            case CheckoutLoading:
              checkoutState as CheckoutLoading;
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              );
            case CheckoutError:
              checkoutState as CheckoutError;
              return Center(
                child: IconTextError(
                  failure: checkoutState.failure,
                ),
              );
            case CheckoutLoaded:
              checkoutState as CheckoutLoaded;
              log('weburl: ${checkoutState.checkout.webUrl}');
              return Center(
                child: Platform.isAndroid || Platform.isIOS
                    ? Builder(
                        builder: (context) {
                          return FutureBuilder(
                              future: webViewReady,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return WebViewWidget(
                                    controller: controller,
                                  );
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  );
                                }
                              });
                        },
                      )
                    : const Center(
                        child: TextBody(
                          text: 'Checkout is only available on Android and iOS',
                        ),
                      ),
              );
            default:
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              );
          }
        },
      ),
    );
  }
}
