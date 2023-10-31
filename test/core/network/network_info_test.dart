import 'package:ecom_template/core/network/network_info.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';

class MockInternetConnectionChecker extends Mock
    implements InternetConnectionChecker {}

void main() {
  late NetworkInfoImpl networkInfoImpl;
  late MockInternetConnectionChecker mockInternetConnectionChecker;

  setUp(() {
    mockInternetConnectionChecker = MockInternetConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(mockInternetConnectionChecker);
  });

  group('isConected', () {
    test('should forward the call to InternetConnectionChecker', () async {
      // arrange
      final tHasConnectionFuture = Future.value(true);

      when(() => mockInternetConnectionChecker.hasConnection)
          .thenAnswer((invocation) async => tHasConnectionFuture);

      // act
      final result = await networkInfoImpl.isConnected;

      // assert
      verify(() => mockInternetConnectionChecker.hasConnection);
      expect(result, await tHasConnectionFuture);
    });
  });
}
