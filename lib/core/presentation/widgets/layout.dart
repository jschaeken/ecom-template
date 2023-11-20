import 'package:ecom_template/core/constants.dart';
import 'package:ecom_template/core/presentation/widgets/icon_components.dart';
import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:ecom_template/features/shop/presentation/bloc/searching/searching_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HeaderRow extends StatelessWidget {
  const HeaderRow({
    super.key,
    required this.pageTitle,
    required this.accountInitials,
    this.child,
    this.shadow = true,
    this.centerTitle = false,
  });

  final String pageTitle;
  final String accountInitials;
  final Widget? child;
  final bool shadow;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        boxShadow: [
          if (shadow)
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
        ],
      ),
      child: Padding(
        padding: Constants.padding,
        child: Column(
          children: [
            centerTitle
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextHeadline(text: pageTitle),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextHeadline(text: pageTitle),
                      CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        child: TextBody(
                          text: accountInitials,
                          color: Theme.of(context).canvasColor,
                        ),
                      ),
                    ],
                  ),
            Visibility(
                visible: child != null,
                child: Column(
                  children: [
                    const StandardSpacing(),
                    child ?? const SizedBox(),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

class CustomActiveSearchBar extends StatefulWidget {
  const CustomActiveSearchBar({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  State<CustomActiveSearchBar> createState() => _CustomActiveSearchBarState();
}

class _CustomActiveSearchBarState extends State<CustomActiveSearchBar> {
  late final FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        BlocProvider.of<SearchingBloc>(context).add(SearchingInitialEvent());
      } else {
        BlocProvider.of<SearchingBloc>(context).add(SearchingCancelEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: Constants.borderRadius,
        color: Theme.of(context).cardColor,
      ),
      child: Padding(
        padding: Constants.innerPadding,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                // do not unfocus when tapping outside
                onTapOutside: (event) {},

                focusNode: focusNode,
                controller: widget.controller,
                cursorColor: Theme.of(context).primaryColor,
                decoration: const InputDecoration(
                  hintText: 'Try a product or category',
                  prefixIcon: CustomIcon(CupertinoIcons.search),
                  border: InputBorder.none,
                ),
              ),
            ),
            !focusNode.hasFocus
                ? const SizedBox()
                : IconButton(
                    onPressed: () {
                      widget.controller.clear();
                      focusNode.unfocus();
                    },
                    icon: CustomIcon(
                      CupertinoIcons.clear,
                      color: Theme.of(context).unselectedWidgetColor,
                    ),
                  )
          ],
        ),
      ),
    );
  }
}

class StandardSpacing extends StatelessWidget {
  const StandardSpacing({
    super.key,
    this.multiplier = 1,
    this.horizontalAxis = false,
  });

  final double multiplier;
  final bool horizontalAxis;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: horizontalAxis
            ? Constants.padding.copyWith(
                left: 0,
                right: Constants.padding.right * multiplier,
              )
            : Constants.padding.copyWith(
                top: 0,
                bottom: Constants.padding.bottom * multiplier,
              ),
      ),
    );
  }
}
