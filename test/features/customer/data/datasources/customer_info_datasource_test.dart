import 'package:ecom_template/features/customer/data/datasources/customer_info_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mocktail/mocktail.dart';

class MockHiveInterface extends Mock implements HiveInterface {}

class MockHiveBox extends Mock implements Box<String> {}

void main() {
  late MockHiveInterface mockHiveInterface;
  late CustomerInfoDataSourceImpl customerInfoDataSourceImpl;
  late MockHiveBox mockHiveBox;

  setUp(() {
    mockHiveInterface = MockHiveInterface();
    mockHiveBox = MockHiveBox();
    customerInfoDataSourceImpl = CustomerInfoDataSourceImpl(
      hive: mockHiveInterface,
    );
  });

  const String testTokenValue = 'testTokenValue';

  void runTestsWithValidBox(Function body) {
    group('with valid box', () {
      setUp(() {
        when(() => mockHiveInterface.openBox<String>(CUSTOMER_INFO_BOX))
            .thenAnswer((_) async => mockHiveBox);
        when(() => mockHiveBox.get(CUSTOMER_TOKEN)).thenReturn(testTokenValue);
        when(() => mockHiveBox.put(CUSTOMER_TOKEN, any()))
            .thenAnswer((_) async => {});
      });
      body();
    });
  }

  group('getCustomerAccessToken', () {
    runTestsWithValidBox(() {
      test(
        'should return customer info box when given the global constant CUSTOMER_INFO_BOX',
        () async {
          // act
          final result =
              await customerInfoDataSourceImpl.getCustomerAccessToken();
          // assert
          expect(result, equals(testTokenValue));
        },
      );
    });
  });
}
