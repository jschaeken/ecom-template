import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

const CUSTOMER_INFO_BOX = 'customer_info';
const CUSTOMER_TOKEN = 'customer_access_token';

abstract class CustomerInfoDataSource {
  Future<String?> getCustomerAccessToken();
  Future<void> setCustomerAccessToken({
    required String token,
  });
}

class CustomerInfoDataSourceImpl implements CustomerInfoDataSource {
  final HiveInterface interface;

  CustomerInfoDataSourceImpl({
    required this.interface,
  });

  @override
  Future<String?> getCustomerAccessToken() async {
    final box = await _getCustomerInfoBox();
    final token = box.get(CUSTOMER_TOKEN);
    debugPrint('Getting Customer Access Token: $token');
    return token;
  }

  Future<Box<String>> _getCustomerInfoBox() async {
    final box = await interface.openBox<String>(CUSTOMER_INFO_BOX);
    return box;
  }

  @override
  Future<void> setCustomerAccessToken({
    required String token,
  }) async {
    final box = await _getCustomerInfoBox();
    debugPrint('Setting Customer Access Token: $token');
    await box.put(CUSTOMER_TOKEN, token);
  }

  Future<void> clearCustomerAccessToken() async {
    final box = await _getCustomerInfoBox();
    debugPrint('Clearing Customer Access Token');
    await box.delete(CUSTOMER_TOKEN);
  }
}
