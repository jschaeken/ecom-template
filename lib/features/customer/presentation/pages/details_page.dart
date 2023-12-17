import 'package:ecom_template/core/constants.dart';
import 'package:ecom_template/core/presentation/widgets/layout.dart';
import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:ecom_template/features/customer/presentation/bloc/customer_auth_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const TextHeadline(text: 'My Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: Constants.padding,
          child: Column(
            children: [
              BlocBuilder<CustomerAuthBloc, CustomerAuthState>(
                builder: (context, state) {
                  if (state is CustomerAuthenticated) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DetailDisplayCard(
                          title: 'Name',
                          text: state.user.displayName ?? '',
                          isLocked: true,
                        ),
                        const StandardSpacing(multiplier: 1.5),
                        DetailDisplayCard(
                          title: 'Email',
                          text: state.user.email ?? '',
                          isLocked: true,
                        ),
                        const StandardSpacing(multiplier: 1.5),
                        DetailDisplayCard(
                          title: 'Phone',
                          text: state.user.phone ?? '-',
                          isLocked: true,
                        ),
                        const StandardSpacing(multiplier: 1.5),
                      ],
                    );
                  } else {
                    return const TextBody(text: 'Not logged in');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailDisplayCard extends StatelessWidget {
  const DetailDisplayCard({
    super.key,
    required this.title,
    required this.text,
    required this.isLocked,
  });

  final String title;
  final String text;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextSubHeadline(
          text: title,
        ),
        const StandardSpacing(multiplier: 0.5),
        Container(
          width: double.infinity,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            borderRadius: Constants.borderRadius,
            color: Theme.of(context).cardColor,
          ),
          child: Padding(
            padding: Constants.padding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextBody(
                  text: text,
                  color:
                      isLocked ? Theme.of(context).unselectedWidgetColor : null,
                ),
                isLocked
                    ? Icon(CupertinoIcons.lock_fill,
                        color: Theme.of(context).unselectedWidgetColor)
                    : Container(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
