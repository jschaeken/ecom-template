import 'package:ecom_template/features/bag/presentation/bloc/bag/bag_bloc.dart';
import 'package:ecom_template/features/favorites/presentation/bloc/favorites_page/favorites_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotiIcon extends StatelessWidget {
  final IconData icon;
  final bool visible;
  final bool isUnder;
  final String? text;

  const NotiIcon({
    required this.icon,
    this.isUnder = false,
    this.text,
    required this.visible,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: visible && isUnder ? 3 : 0),
          child: Icon(
            icon,
          ),
        ),
        visible
            ? Container(
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(
                  minWidth: 5,
                  minHeight: 5,
                ),
              ).animate().scaleXY(
                  curve: Curves.bounceOut,
                )
            : const SizedBox(),
      ],
    );
  }
}

class FavoritesNotiIcon extends StatelessWidget {
  final IconData iconData;
  const FavoritesNotiIcon({
    super.key,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (context, state) {
        if ((state is FavoritesAddedLoaded ||
                state is FavoritesRemovedLoaded ||
                state is FavoritesLoaded) &&
            state.favorites.isNotEmpty) {
          return NotiIcon(
            icon: iconData,
            visible: true,
            isUnder: true,
          );
        } else {
          return NotiIcon(
            icon: iconData,
            visible: false,
          );
        }
      },
    );
  }
}

class BagNotiIcon extends StatelessWidget {
  final IconData iconData;
  const BagNotiIcon({
    super.key,
    required this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BagBloc, BagState>(
      builder: (context, state) {
        if ((state is BagLoadedState ||
                state is BagLoadedAddedState ||
                state is BagLoadedRemovedState) &&
            state.bagItems.isNotEmpty) {
          return NotiIcon(
            isUnder: false,
            icon: iconData,
            visible: true,
            text: state.bagItems.length.toString(),
          );
        } else {
          return NotiIcon(
            icon: iconData,
            visible: false,
          );
        }
      },
    );
  }
}
