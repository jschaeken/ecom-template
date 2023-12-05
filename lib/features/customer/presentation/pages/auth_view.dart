import 'package:ecom_template/core/constants.dart';
import 'package:ecom_template/core/error/failures.dart';
import 'package:ecom_template/core/presentation/main_view.dart';
import 'package:ecom_template/core/presentation/widgets/buttons.dart';
import 'package:ecom_template/core/presentation/widgets/layout.dart';
import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:ecom_template/features/customer/presentation/bloc/customer_auth_bloc.dart';
import 'package:ecom_template/features/customer/presentation/pages/base_page.dart';
import 'package:ecom_template/features/customer/presentation/pages/login_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AuthView extends StatelessWidget {
  AuthView({super.key});

  final Future<PackageInfo> packageInfoFuture = PackageInfo.fromPlatform();

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CustomerAuthBloc>(context).add(
      GetAuthStateEvent(),
    );
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: BlocBuilder<CustomerAuthBloc, CustomerAuthState>(
        builder: (context, customerAuthState) {
          switch (customerAuthState.runtimeType) {
            case CustomerAuthInitial:
              return SplashScreen(packageInfoFuture: packageInfoFuture);
            case CustomerAuthLoading:
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                ),
              );
            case CustomerAuthenticated:
              return const MainView();
            case CustomerUnauthenticatedCreateAccount:
              customerAuthState as CustomerUnauthenticatedCreateAccount;
              return BasePage(
                errors: customerAuthState.errors,
              );
            case CustomerUnauthenticatedLogin:
              customerAuthState as CustomerUnauthenticatedLogin;
              return LoginPage(
                errors: customerAuthState.errors,
              );
            case CustomerAuthError:
              customerAuthState as CustomerAuthError;
              return AuthError(
                failure: customerAuthState.failure,
              );
            default:
              return SplashScreen(packageInfoFuture: packageInfoFuture);
          }
        },
      ),
    );
  }
}

class AuthError extends StatelessWidget {
  final Failure failure;

  const AuthError({
    super.key,
    required this.failure,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: Constants.padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextBody(
              text: 'CustomerAuthError: ${failure.message}',
              maxLines: 10,
            ),
            const StandardSpacing(
              multiplier: 3,
            ),
            CtaButton(
              onTap: () {
                BlocProvider.of<CustomerAuthBloc>(context).add(
                  GetAuthStateEvent(),
                );
              },
              child: const TextBody(text: 'Retry'),
            )
          ],
        ),
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({
    super.key,
    required this.packageInfoFuture,
  });

  final Future<PackageInfo> packageInfoFuture;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder(
          future: packageInfoFuture,
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.done
                ? TextBody(
                    text: snapshot.data?.appName ?? '',
                  )
                : CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  );
          }),
    );
  }
}
