import 'dart:developer';

import 'package:ecom_template/core/error/exceptions.dart';
import 'package:ecom_template/features/customer/data/datasources/customer_info_datasource.dart';
import 'package:ecom_template/features/customer/data/models/shopify_user_model.dart';
import 'package:shopify_flutter/mixins/src/shopfiy_error.dart';
import 'package:shopify_flutter/models/models.dart';
import 'package:shopify_flutter/shopify/src/shopify_auth.dart';

abstract class CustomerAuthDatasource {
  Future<ShopShopifyUserModel> signInWithEmailAndPassword(
      {required String email, required String password});

  Future<ShopShopifyUserModel?> getCurrentUser();

  Future<void> signOut();

  Future<ShopShopifyUserModel> createAccount({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
    String? phone,
    bool? acceptsMarketing,
  });
}

class CustomerAuthDatasourceImpl implements CustomerAuthDatasource {
  final ShopifyAuth shopifyAuth;
  final CustomerInfoDataSource customerInfoDataSource;

  CustomerAuthDatasourceImpl({
    required this.shopifyAuth,
    required this.customerInfoDataSource,
  });

  @override
  Future<ShopShopifyUserModel> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final ShopifyUser response = await shopifyAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _setToken();
      return ShopShopifyUserModel.fromShopifyUser(response);
    } on ShopifyException catch (e) {
      throw AuthException(
        message: e.errors?.first.toString() ??
            'An unknown error occured while signing in',
      );
    } catch (e, s) {
      log('e.runtimeType: ${e.runtimeType}');
      log(s.toString());
      throw AuthException(
        message: 'An error occured while signing in: ${e.toString()}',
      );
    }
  }

  @override
  Future<ShopShopifyUserModel?> getCurrentUser() async {
    try {
      final ShopifyUser? response = await shopifyAuth.currentUser();
      if (response != null) {
        _setToken();
        return ShopShopifyUserModel.fromShopifyUser(response);
      } else {
        return null;
      }
    } on ShopifyException catch (e) {
      throw AuthException(
        message: e.errors?.first.toString() ??
            'An unknown error occured while signing in',
      );
    } catch (e) {
      throw AuthException(
        message: 'An unknown error occured while signing in ${e.toString()}',
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await shopifyAuth.signOutCurrentUser();
      return;
    } on ShopifyException catch (e) {
      throw AuthException(
        message: e.errors?.first.toString() ??
            'An unknown error occured while signing out',
      );
    } catch (e) {
      throw AuthException(
        message: 'An unknown error occured while signing out ${e.toString()}',
      );
    }
  }

  @override
  Future<ShopShopifyUserModel> createAccount({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
    String? phone,
    bool? acceptsMarketing,
  }) async {
    try {
      final ShopifyUser response =
          await shopifyAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
        firstName: firstName ?? '',
        lastName: lastName ?? '',
        phone: phone,
        acceptsMarketing: acceptsMarketing,
      );
      _setToken();
      return ShopShopifyUserModel.fromShopifyUser(response);
    } on ShopifyException catch (e) {
      throw AuthException(
        message: e.errors?.first.toString() ??
            'An unknown error occured while signing in',
      );
    } catch (e) {
      throw AuthException(
        message: 'An unknown error occured while signing in ${e.toString()}',
      );
    }
  }

  _setToken() async {
    final String? token = await shopifyAuth.currentCustomerAccessToken;
    if (token == null) {
      throw const AuthException(
        message: 'An unknown error occured while signing in',
      );
    }
    await customerInfoDataSource.setCustomerAccessToken(
      token: token,
    );
  }
}
