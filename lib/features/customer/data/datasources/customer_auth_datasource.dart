import 'package:ecom_template/core/error/exceptions.dart';
import 'package:ecom_template/features/customer/data/models/shopify_user_model.dart';
import 'package:shopify_flutter/mixins/src/shopfiy_error.dart';
import 'package:shopify_flutter/models/models.dart';
import 'package:shopify_flutter/shopify/src/shopify_auth.dart';

abstract class CustomerAuthDatasource {
  Future<ShopShopifyUserModel> signInWithEmailAndPassword(
      {required String email, required String password});
}

class CustomerAuthDatasourceImpl implements CustomerAuthDatasource {
  final ShopifyAuth shopifyAuth;

  CustomerAuthDatasourceImpl({
    required this.shopifyAuth,
  });

  @override
  Future<ShopShopifyUserModel> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final ShopifyUser response = await shopifyAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return ShopShopifyUserModel.fromShopifyUser(response);
    } on ShopifyException catch (e) {
      throw AuthException(
        message: e.errors?.first.toString() ??
            'An unknown error occured while signing in',
      );
    } catch (e) {
      throw const AuthException(
        message: 'An unknown error occured while signing in',
      );
    }
  }
}
