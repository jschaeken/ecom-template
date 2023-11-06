import 'dart:async';

import 'package:ecom_template/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MultiImageBanner extends StatefulWidget {
  const MultiImageBanner({
    super.key,
    required this.images,
  });

  final List<String> images;

  @override
  State<MultiImageBanner> createState() => _MultiImageBannerState();
}

class _MultiImageBannerState extends State<MultiImageBanner>
    with
        SingleTickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<MultiImageBanner> {
  @override
  bool get wantKeepAlive => true;

  //Make the pageview scroll automatically every 5 seconds

  late Timer timer;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
    timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (pageController.page == widget.images.length - 1) {
        pageController.animateToPage(
          0,
          duration: const Duration(milliseconds: 1000),
          curve: Curves.fastOutSlowIn,
        );
      } else {
        pageController.nextPage(
          duration: const Duration(milliseconds: 1000),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SizedBox(
      height: 230,
      child: PageView(
        controller: pageController,
        scrollDirection: Axis.vertical,
        children: [
          for (int i = 0; i < widget.images.length; i++)
            ClipRRect(
              borderRadius: Constants.borderRadius,
              child: Image.network(widget.images[i], fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/images/placeholder-image.png')
                    .animate()
                    .fadeIn();
              }),
            )
        ],
      ),
    );
  }
}
