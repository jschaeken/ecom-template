import 'package:ecom_template/core/constants.dart';
import 'package:ecom_template/core/presentation/widgets/icon_components.dart';
import 'package:ecom_template/core/presentation/widgets/layout.dart';
import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatelessWidget {
  final String pageTitle;

  AccountPage({required this.pageTitle, super.key});

  final List<AccountTileInfo> accountTileInfo = [
    AccountTileInfo(
      title: 'Orders',
      icon: CupertinoIcons.cube_box,
      onTap: () {},
    ),
    AccountTileInfo(
      title: 'My Details',
      icon: CupertinoIcons.person,
      onTap: () {},
    ),
    AccountTileInfo(
      title: 'Addresses',
      icon: CupertinoIcons.house,
      onTap: () {},
    ),
    AccountTileInfo(
      title: 'Settings',
      icon: CupertinoIcons.settings,
      onTap: () {},
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
                const TextHeadline(text: 'Hello, {Name}!'),
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
              itemBuilder: (context, index) {
                return AccountPageTile(
                  accountTileInfo: accountTileInfo[index],
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

  const AccountPageTile({
    super.key,
    required this.accountTileInfo,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: accountTileInfo.onTap,
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
  final Function() onTap;

  const AccountTileInfo({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}
