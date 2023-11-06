import 'package:ecom_template/features/bag/presentation/bloc/bag/bag_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:ecom_template/core/constants.dart';
import 'package:ecom_template/core/presentation/widgets/text_components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotiIcon extends StatelessWidget {
  final IconData icon;

  const NotiIcon({required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Icon(
          icon,
        ),
        BlocBuilder<BagBloc, BagState>(
          builder: (context, state) {
            if (state is BagLoadedState && state.bagItems.isNotEmpty) {
              return Positioned(
                right: 0,
                top: 0,
                child: Container(
                  margin: EdgeInsets.zero,
                  padding: Constants.innerPadding,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Center(
                    child: TextBody(
                      text: state.bagItems.length.toString(),
                      color: Theme.of(context).canvasColor,
                    ),
                  ),
                ).animate().scaleXY(
                      curve: Curves.bounceOut,
                    ),
              );
            } else {
              return const SizedBox();
            }
          },
        )
      ],
    );
  }
}
