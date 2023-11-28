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
              onPressed: () async {
                try {
                  await shopifyAuth.signInWithEmailAndPassword(
                    email: 'essencesoftwaredevelopment@gmail.com',
                    password: 'Qwerty12!',
                  );
                } catch (e) {
                  log(e.toString());
                }
                final res = await shopifyAuth.currentCustomerAccessToken;
                log(res.runtimeType.toString());
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: res != null
                          ? Text('Saving $res')
                          : const Text('User not signed in. Please log in'),
                    ),
                  );
                }
                final box = await Hive.openBox('customer_info');
                box.put('customer_access_token', res.toString());
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
              final box = await Hive.openBox('customer_info');
              box.put('customer_access_token', res.toString());
            },
            child: const Text('Get Access Token'),
          ),
          ElevatedButton(
            onPressed: () async {
              await shopifyAuth.signOutCurrentUser();
              final box = await Hive.openBox<String>('customer_info');
              box.delete('customer_access_token');
            },
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
  }
}
