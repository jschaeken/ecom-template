import 'package:ecom_template/features/bag/domain/entities/bag_item.dart';
import 'package:ecom_template/features/checkout/domain/entities/line_item.dart';

class BagItemsToLineItems {
  Future<List<ShopLineItem>> call({required List<BagItem> bagItems}) async {
    return bagItems
        .map((bagItem) => ShopLineItem(
              id: bagItem.id,
              variantId: bagItem.id,
              title: bagItem.title,
              quantity: bagItem.quantity,
              discountAllocations: const [],
              customAttributes: const [],
            ))
        .toList();
  }
}
