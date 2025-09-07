import 'package:flutter_sixvalley_ecommerce/data/model/response/shipping_method_model.dart';

class ShippingModel{
  int? shippingIndex;
  String? groupId;
  List<ShippingMethodModel>? shippingMethodList;

  ShippingModel(int? shippingIndex, String? groupId, List<ShippingMethodModel>? shippingMethodList) {
    this.shippingIndex = shippingIndex ?? 0;
    this.groupId = groupId ?? '';
    this.shippingMethodList = shippingMethodList ?? [];
  }
}
