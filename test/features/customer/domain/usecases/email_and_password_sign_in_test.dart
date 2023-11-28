import 'package:dartz/dartz.dart';
import 'package:ecom_template/features/customer/domain/entities/shopify_user.dart';
import 'package:ecom_template/features/customer/domain/repositories/customer_auth_repository.dart';
import 'package:ecom_template/features/customer/domain/usecases/email_and_password_sign_in.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCustomerAuthRepository extends Mock
    implements CustomerAuthRepository {}

void main() {
  late MockCustomerAuthRepository mockCustomerAuthRepository;
  late EmailAndPasswordSignIn usecase;

  setUp(() {
    mockCustomerAuthRepository = MockCustomerAuthRepository();
    usecase = EmailAndPasswordSignIn(repository: mockCustomerAuthRepository);
  });

  const tEmail = '';
  const tPassword = '';

  test(
    'should get user from the repository',
    () async {
      // arrange
      when(() => mockCustomerAuthRepository.signInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => const Right(ShopShopifyUser()));
      // act
      final response = await usecase(
        const EmailAndPasswordSignInParams(email: tEmail, password: tPassword),
      );
      // assert
      verify(() => mockCustomerAuthRepository.signInWithEmailAndPassword(
            email: tEmail,
            password: tPassword,
          ));
      expect(response, const Right(ShopShopifyUser()));
      verifyNoMoreInteractions(mockCustomerAuthRepository);
    },
  );
}
