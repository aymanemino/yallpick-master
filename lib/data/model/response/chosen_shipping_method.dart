class ChosenShippingMethodModel {
  int _id = 0;
  String _cartGroupId = '';
  int _shippingMethodId = 0;
  double _shippingCost = 0.0;
  String _createdAt = '';
  String _updatedAt = '';

  ChosenShippingMethodModel(
      {int? id,
      String? cartGroupId,
      int? shippingMethodId,
      double? shippingCost,
      String? createdAt,
      String? updatedAt}) {
    this._id = id ?? 0;
    this._cartGroupId = cartGroupId ?? '';
    this._shippingMethodId = shippingMethodId ?? 0;
    this._shippingCost = shippingCost ?? 0.0;
    this._createdAt = createdAt ?? '';
    this._updatedAt = updatedAt ?? '';
  }

  int get id => _id;
  String get cartGroupId => _cartGroupId;
  int get shippingMethodId => _shippingMethodId;
  double get shippingCost => _shippingCost;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;

  ChosenShippingMethodModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'] ?? 0;
    _cartGroupId = json['cart_group_id'] ?? '';
    _shippingMethodId =
        int.tryParse(json['shipping_method_id']?.toString() ?? '0') ?? 0;
    _shippingCost =
        double.tryParse(json['shipping_cost']?.toString() ?? '0.0') ?? 0.0;
    _createdAt = json['created_at'] ?? '';
    _updatedAt = json['updated_at'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['cart_group_id'] = this._cartGroupId;
    data['shipping_method_id'] = this._shippingMethodId;
    data['shipping_cost'] = this._shippingCost;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    return data;
  }
}
