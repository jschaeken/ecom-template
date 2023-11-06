import 'package:ecom_template/core/constants.dart';
import 'package:ecom_template/features/shop/domain/entities/shop_product_image.dart';
import 'package:flutter/material.dart';

class ImageGallery extends StatefulWidget {
  const ImageGallery({
    super.key,
    required this.images,
    required this.onTap,
  });

  final List<ShopProductImage> images;
  final Function(String imageUrl) onTap;

  @override
  State<ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  int imageIndex = 0;
  double scrollPosition = 0;
  PageController imageController = PageController();
  double screenWidth = 500;
  double indicatorWidth = 170;
  late final imageCount;

  @override
  void initState() {
    super.initState();
    imageController.addListener(() {
      setState(() {
        scrollPosition = imageController.page ?? 0;
      });
      if (imageController.hasClients &&
          imageController.page != null &&
          (imageController.page! + 0.5).toInt() != imageIndex) {
        setState(() {
          imageIndex = (imageController.page! + 0.5).toInt();
        });
      }
    });
    imageCount = widget.images.length;
    if (imageCount > 2) {
      // postFrame callback to get the width of the progress indicator
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          screenWidth = MediaQuery.of(context).size.width;
          indicatorWidth = (screenWidth -
                  (Constants.padding.left + Constants.padding.right)) /
              imageCount;
        });
      });
    }
  }

  void onDispose() {
    imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 468,
      child: GestureDetector(
        onTap: () => widget.onTap(widget.images[imageIndex].originalSrc),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Product Image
            PageView.builder(
              controller: imageController,
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                return Image.network(
                  widget.images[index].originalSrc,
                  fit: BoxFit.cover,
                );
              },
            ),

            // Progress Indicator
            if (imageCount > 1)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                    padding: Constants.padding,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      fit: StackFit.expand,
                      children: [
                        Positioned(
                          right: screenWidth -
                              (indicatorWidth * (scrollPosition + 1)) -
                              (Constants.padding.right +
                                  Constants.padding.left),
                          child: Container(
                            height: 5,
                            width: indicatorWidth,
                            decoration: BoxDecoration(
                              borderRadius: Constants.borderRadius,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                    )),
              ),

            // Expand Indicator
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: Constants.padding.copyWith(bottom: 40),
                child: GestureDetector(
                  onTap: () =>
                      widget.onTap(widget.images[imageIndex].originalSrc),
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Theme.of(context).canvasColor,
                    ),
                    child: const Icon(Icons.fullscreen),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
