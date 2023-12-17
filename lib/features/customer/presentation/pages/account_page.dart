import 'package:ecom_template/core/constants.dart';
import 'package:ecom_template/core/presentation/widgets/layout.dart';
import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:ecom_template/features/customer/presentation/bloc/customer_auth_bloc.dart';
import 'package:ecom_template/features/customer/presentation/pages/details_page.dart';
import 'package:ecom_template/features/customer/presentation/pages/settings_page.dart';
import 'package:ecom_template/features/order/presentation/pages/orders_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountPage extends StatelessWidget {
  final String pageTitle;

  AccountPage({required this.pageTitle, super.key});

  final List<AccountTileInfo> accountTileInfo = [
    const AccountTileInfo(
      title: 'Orders',
      icon: CupertinoIcons.cube_box,
      page: OrdersPage(),
    ),
    const AccountTileInfo(
      title: 'My Details',
      icon: CupertinoIcons.person,
      page: DetailsPage(),
    ),
    const AccountTileInfo(
      title: 'Settings',
      icon: CupertinoIcons.settings,
      page: SettingsPage(),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: Constants.padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            // Profile Picture and Greeting //
            Center(
                child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(context).cardColor,
                  child: const Icon(
                    CupertinoIcons.person,
                    size: 50,
                  ),
                ),
                const StandardSpacing(
                  multiplier: 1,
                ),
                BlocBuilder<CustomerAuthBloc, CustomerAuthState>(
                  builder: (context, state) {
                    if (state is CustomerAuthenticated) {
                      return TextHeadline(
                          text: 'Hello, ${state.user.firstName}!');
                    }
                    return const TextHeadline(text: 'Hey stranger!');
                  },
                ),
              ],
            )),

            const StandardSpacing(
              multiplier: 3,
            ),
            // Account //
            const TextSubHeadline(text: 'Account'),
            // Orders
            ListView.builder(
              shrinkWrap: true,
              itemCount: accountTileInfo.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return AccountPageTile(
                  accountTileInfo: accountTileInfo[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => accountTileInfo[index].page,
                      ),
                    );
                  },
                );
              },
            ),
            // My Details
            // Addresses
            // Settings

            // Support //

            // Logout //
          ],
        ),
      ),
    ));
  }
}

class AccountPageTile extends StatelessWidget {
  final AccountTileInfo accountTileInfo;
  final Function() onTap;

  const AccountPageTile({
    super.key,
    required this.accountTileInfo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: Constants.padding.top / 2),
        shape: RoundedRectangleBorder(
          borderRadius: Constants.borderRadius,
        ),
        child: Container(
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: Constants.borderRadius,
            color: Theme.of(context).cardColor,
          ),
          child: Padding(
            padding: Constants.padding,
            child: Row(
              children: [
                Icon(
                  accountTileInfo.icon,
                  size: 30,
                ),
                const StandardSpacing(
                  multiplier: 1,
                  horizontalAxis: true,
                ),
                TextSubHeadline(
                  text: accountTileInfo.title,
                ),
                const Spacer(),
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AccountTileInfo {
  final String title;
  final IconData icon;
  final Widget page;

  const AccountTileInfo({
    required this.title,
    required this.icon,
    required this.page,
  });
}
