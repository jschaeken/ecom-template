import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shopify_flutter/shopify/shopify.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final ShopifyAuth shopifyAuth = ShopifyAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {
                shopifyAuth.signInWithEmailAndPassword(
                  email: 'essencesoftwaredevelopment@gmail.com',
                  password: 'Qwerty12!',
                );
              },
              child: const Text('Sign In'),
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                final res = await shopifyAuth.currentCustomerAccessToken;
                log(res.toString());
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Saving ${res.toString()}'),
                  ),
                );
                await Hive.openBox('customer_info');
                final box = Hive.box('customer_info');
                box.put('customer_access_token', res.toString());
              },
              child: const Text('Get Access Token')),
        ],
      ),
    );
  }
}
