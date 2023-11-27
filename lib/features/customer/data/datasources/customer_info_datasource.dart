import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

const CUSTOMER_INFO_BOX = 'customer_info';
const CUSTOMER_TOKEN = 'customer_access_token';

abstract class CustomerInfoDataSource {
  Future<String?> getCustomerAccessToken();
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
    return token;
  }

  Future<Box<String>> _getCustomerInfoBox() async {
    final box = await interface.openBox<String>(CUSTOMER_INFO_BOX);
    return box;
  }
}
