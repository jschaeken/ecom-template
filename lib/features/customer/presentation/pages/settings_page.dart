import 'package:ecom_template/core/config.dart';
import 'package:ecom_template/core/constants.dart';
import 'package:ecom_template/core/presentation/state_managment/navigation_provider.dart';
import 'package:ecom_template/core/presentation/widgets/buttons.dart';
import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:ecom_template/features/bag/presentation/bloc/bag/bag_bloc.dart';
import 'package:ecom_template/features/customer/presentation/bloc/customer_auth_bloc.dart';
import 'package:ecom_template/features/favorites/presentation/bloc/favorites_page/favorites_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: Constants.padding,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const SizedBox(
              width: double.infinity,
            ),
            CtaButton(
              color: Theme.of(context).primaryColor,
              onTap: () {
                context
                    .read<PageNavigationProvider>()
                    .changeIndex(TabBarItems.explore.idx);
                BlocProvider.of<BagBloc>(context).add(
                  ClearBagEvent(),
                );
                BlocProvider.of<FavoritesBloc>(context).add(
                  ClearFavoritesEvent(),
                );
                BlocProvider.of<CustomerAuthBloc>(context).add(
                  SignOutEvent(),
                );
              },
              child: TextSubHeadline(
                  text: 'Sign Out', color: Theme.of(context).canvasColor),
            )
          ],
        ),
      ),
    );
  }
}
