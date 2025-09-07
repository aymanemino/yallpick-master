import 'package:flutter_sixvalley_ecommerce/data/model/response/product_model.dart';

class OrderDetailsModel {
  int _id = 0;
  int _orderId = 0;
  int _productId = 0;
  int _sellerId = 0;
  Product _productDetails = Product();
  int _qty = 0;
  double _price = 0.0;
  double _tax = 0.0;
  double _discount = 0.0;
  String _deliveryStatus = '';
  String _paymentStatus = '';
  String _createdAt = '';
  String _updatedAt = '';
  int _shippingMethodId = 0;
  String _variant = '';
  //List<Variation> _variation;

  OrderDetailsModel({
    int? id,
    int? orderId,
    int? productId,
    int? sellerId,
    Product? productDetails,
    int? qty,
    double? price,
    double? tax,
    double? discount,
    String? deliveryStatus,
    String? paymentStatus,
    String? createdAt,
    String? updatedAt,
    int? shippingMethodId,
    String? variant,
    //List<Variation> variation
  }) {
    this._id = id ?? 0;
    this._orderId = orderId ?? 0;
    this._productId = productId ?? 0;
    this._sellerId = sellerId ?? 0;
    this._productDetails = productDetails ?? Product();
    this._qty = qty ?? 0;
    this._price = price ?? 0.0;
    this._tax = tax ?? 0.0;
    this._discount = discount ?? 0.0;
    this._deliveryStatus = deliveryStatus ?? '';
    this._paymentStatus = paymentStatus ?? '';
    this._createdAt = createdAt ?? '';
    this._updatedAt = updatedAt ?? '';
    this._shippingMethodId = shippingMethodId ?? 0;
    this._variant = variant ?? '';
    //this._variation = variation;
  }

  int get id => _id;
  int get orderId => _orderId;
  int get productId => _productId;
  int get sellerId => _sellerId;
  Product get productDetails => _productDetails;
  int get qty => _qty;
  double get price => _price;
  double get tax => _tax;
  double get discount => _discount;
  String get deliveryStatus => _deliveryStatus;
  String get paymentStatus => _paymentStatus;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  int get shippingMethodId => _shippingMethodId;
  String get variant => _variant;

  OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'] ?? 0;
    _orderId = json['order_id'] ?? 0;
    _productId = json['product_id'] ?? 0;
    _sellerId = json['seller_id'] ?? 0;
    if (json['product_details'] != null) {
      _productDetails = Product.fromJson(json['product_details']);
    } else {
      _productDetails = Product();
    }
    _qty = json['qty'] ?? 0;
    _price = (json['price'] ?? 0.0).toDouble();
    _tax = (json['tax'] ?? 0.0).toDouble();
    _discount = (json['discount'] ?? 0.0).toDouble();
    _deliveryStatus = json['delivery_status'] ?? '';
    _paymentStatus = json['payment_status'] ?? '';
    _createdAt = json['created_at'] ?? '';
    _updatedAt = json['updated_at'] ?? '';
    _shippingMethodId = json['shipping_method_id'] ?? 0;
    _variant = json['variant'] ?? '';
    /*if (json['variation'] != null) {
      _variation = [];
      json['variation'].forEach((v) {
        _variation.add(new Variation.fromJson(v));
      });
    }*/
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['order_id'] = this._orderId;
    data['product_id'] = this._productId;
    data['seller_id'] = this._sellerId;
    if (this._productDetails != null) {
      data['product_details'] = this._productDetails.toJson();
    }
    data['qty'] = this._qty;
    data['price'] = this._price;
    data['tax'] = this._tax;
    data['discount'] = this._discount;
    data['delivery_status'] = this._deliveryStatus;
    data['payment_status'] = this._paymentStatus;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['shipping_method_id'] = this._shippingMethodId;
    data['variant'] = this._variant;
    /*if (this._variation != null) {
      data['variation'] = this._variation.map((v) => v.toJson()).toList();
    }*/
    return data;
  }
}
