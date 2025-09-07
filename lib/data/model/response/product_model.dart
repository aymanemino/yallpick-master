import 'package:flutter_sixvalley_ecommerce/data/model/response/seller_model.dart';

class ProductModel {
  int _totalSize = 0;
  int _limit = 0;
  int _offset = 0;
  List<Product> _products = [];

  ProductModel(
      {int? totalSize,
      int? limit,
      int? offset,
      List<Product>? products,
      int? status}) {
    this._totalSize = totalSize ?? 0;
    this._limit = limit ?? 0;
    this._offset = offset ?? 0;
    this._products = products ?? [];
  }

  int get totalSize => _totalSize;

  int get limit => _limit;

  int get offset => _offset;

  List<Product> get products => _products;

  ProductModel.fromJson(Map<String, dynamic> json) {
    _totalSize = json['total_size'];
    _limit = json['limit'];
    _offset = json['offset'];
    if (json['products'] != null) {
      _products = [];
      json['products'].forEach((v) {
        _products.add(new Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_size'] = this._totalSize;
    data['limit'] = this._limit;
    data['offset'] = this._offset;
    if (this._products != null) {
      data['products'] = this._products.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Product {
  int _id = 0;
  String _addedBy = '';
  int _userId = 0;
  String _name = '';
  String _videoUrl = '';
  String _slug = '';
  dynamic _categoryIds;

  // List<CategoryIds> _categoryIds;
  // int _categoryIds;
  String _unit = '';
  List<String> _images = [];
  String _thumbnail = '';
  List<ProductColors> _colors = [];
  List<String> _attributes = [];
  List<ChoiceOptions> _choiceOptions = [];
  List<Variation> _variation = [];
  double _unitPrice = 0.0;
  double _purchasePrice = 0.0;
  double _tax = 0.0;
  int _minQty = 0;
  String _taxType = '';
  double _discount = 0.0;
  String _discountType = '';
  int _currentStock = 0;
  String _details = '';
  String _createdAt = '';
  String _updatedAt = '';
  List<Rating> _rating = [];
  String _countryId = '';
  String _stateId = '';
  String _cityId = '';
  Shop _shop = Shop();
  int _status = 0;

  Product({
    int? id,
    String? addedBy,
    int? userId,
    String? name,
    String? videoUrl,
    String? slug,
    // int categoryIds,
    // List<CategoryIds> categoryIds,
    dynamic categoryIds,
    String? unit,
    int? minQty,
    List<String>? images,
    String? thumbnail,
    List<ProductColors>? colors,
    String? variantProduct,
    List<String>? attributes,
    List<ChoiceOptions>? choiceOptions,
    List<Variation>? variation,
    double? unitPrice,
    double? purchasePrice,
    double? tax,
    String? taxType,
    double? discount,
    String? discountType,
    int? currentStock,
    String? details,
    String? attachment,
    String? createdAt,
    String? updatedAt,
    int? featuredStatus,
    List<Rating>? rating,
    String? countryId,
    String? stateId,
    String? cityId,
    Shop? shop,
    int? status,
  }) {
    this._id = id ?? 0;
    this._addedBy = addedBy ?? '';
    this._userId = userId ?? 0;
    this._name = name ?? '';
    this._videoUrl = videoUrl ?? '';
    this._slug = slug ?? '';
    this._categoryIds = categoryIds;
    this._unit = unit ?? '';
    this._minQty = minQty ?? 0;
    this._images = images ?? [];
    this._thumbnail = thumbnail ?? '';
    this._colors = colors ?? [];
    this._attributes = attributes ?? [];
    this._choiceOptions = choiceOptions ?? [];
    this._variation = variation ?? [];
    this._unitPrice = unitPrice ?? 0.0;
    this._purchasePrice = purchasePrice ?? 0.0;
    this._tax = tax ?? 0.0;
    this._taxType = taxType ?? '';
    this._discount = discount ?? 0.0;
    this._discountType = discountType ?? '';
    this._currentStock = currentStock ?? 0;
    this._details = details ?? '';
    this._createdAt = createdAt ?? '';
    this._updatedAt = updatedAt ?? '';
    this._rating = rating ?? [];
    this._countryId = countryId ?? '';
    this._stateId = stateId ?? '';
    this._cityId = cityId ?? '';
    this._shop = shop ?? Shop();
    this._status = status ?? 0;
  }

  int get id => _id;

  String get addedBy => _addedBy;

  int get userId => _userId;

  String get name => _name;

  String get videoUrl => _videoUrl;

  String get slug => _slug;

  dynamic get categoryIds => _categoryIds;

  // List<CategoryIds> get categoryIds => _categoryIds;
  // int get categoryIds => _categoryIds;
  String get unit => _unit;

  int get minQty => _minQty;

  List<String> get images => _images ?? [];

  String get thumbnail => _thumbnail;

  List<ProductColors> get colors => _colors;

  List<String> get attributes => _attributes;

  List<ChoiceOptions> get choiceOptions => _choiceOptions;

  List<Variation> get variation => _variation;

  double get unitPrice => _unitPrice;

  double get purchasePrice => _purchasePrice;

  double get tax => _tax;

  String get taxType => _taxType;

  double get discount => _discount;

  String get discountType => _discountType;

  int get currentStock => _currentStock;

  String get details => _details;

  String get createdAt => _createdAt;

  String get updatedAt => _updatedAt;

  List<Rating> get rating => _rating;

  String get countryId => _countryId;

  String get stateId => _stateId;

  String get cityId => _cityId;

  Shop get shop => _shop;

  int get status => _status;

  Product.fromJson(Map<String, dynamic> json) {
    _id = json['id'] ?? 0;
    _addedBy = json['added_by'] ?? '';
    _userId = json['user_id'] ?? 0;
    _name = json['name'] ?? '';
    _videoUrl = json['video_url'] ?? '';
    _slug = json['slug'] ?? '';
    // _categoryIds = json['category_ids'];
    if (json['category_ids'] != null) {
      if (json['category_ids'] is int) {
        _categoryIds = json['category_ids'];
      } else {
        _categoryIds = [];
        json['category_ids'].forEach((v) {
          _categoryIds.add(new CategoryIds.fromJson(v));
        });
      }
    }
    _unit = json['unit'] ?? '';
    _minQty = json['min_qty'] ?? 0;
    _images = json['images'] != null ? json['images'].cast<String>() : [];
    _thumbnail = json['thumbnail'] ?? '';
    if (json['colors'] != null) {
      _colors = [];
      json['colors'].forEach((v) {
        _colors.add(new ProductColors.fromJson(v));
      });
    }
    if (json['attributes'] != null) {
      _attributes = json['attributes'].cast<String>();
    }
    if (json['choice_options'] != null) {
      _choiceOptions = [];
      json['choice_options'].forEach((v) {
        _choiceOptions.add(new ChoiceOptions.fromJson(v));
      });
    }
    if (json['variation'] != null) {
      _variation = [];
      json['variation'].forEach((v) {
        _variation.add(new Variation.fromJson(v));
      });
    }
    if (json['unit_price'] != null) {
      _unitPrice = json['unit_price'].toDouble();
    }
    if (json['purchase_price'] != null) {
      _purchasePrice = json['purchase_price'].toDouble();
    }

    if (json['tax'] != null) {
      _tax = json['tax'].toDouble();
    }
    _taxType = json['tax_type'] ?? '';
    if (json['discount'] != null) {
      _discount = json['discount'].toDouble();
    }
    _discountType = json['discount_type'] ?? '';
    _currentStock = json['current_stock'] ?? 0;
    _details = json['details'] ?? '';
    _createdAt = json['created_at'] ?? '';
    _updatedAt = json['updated_at'] ?? '';

    _countryId = json['country_id']?.toString() ?? '';
    _stateId = json['state_id']?.toString() ?? '';
    _cityId = json['city_id']?.toString() ?? '';

    if (json['rating'] != null) {
      _rating = [];
      json['rating'].forEach((v) {
        _rating.add(new Rating.fromJson(v));
      });
    }

    _shop = json['shop'] != null ? new Shop.fromJson(json['shop']) : Shop();
    _status = json['status'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['added_by'] = this._addedBy;
    data['user_id'] = this._userId;
    data['name'] = this._name;
    data['video_url'] = this._videoUrl;
    data['slug'] = this._slug;
    if (this._categoryIds != null) {
      if (this._categoryIds is int) {
        data['category_ids'] = this._categoryIds;
      } else {
        data['category_ids'] =
            this._categoryIds.map((v) => v.toJson()).toList();
      }
    }
    data['unit'] = this._unit;
    data['min_qty'] = this._minQty;
    data['images'] = this._images;
    data['thumbnail'] = this._thumbnail;
    if (this._colors != null) {
      data['colors'] = this._colors.map((v) => v.toJson()).toList();
    }
    data['attributes'] = this._attributes;
    if (this._choiceOptions != null) {
      data['choice_options'] =
          this._choiceOptions.map((v) => v.toJson()).toList();
    }
    if (this._variation != null) {
      data['variation'] = this._variation.map((v) => v.toJson()).toList();
    }
    data['unit_price'] = this._unitPrice;
    data['purchase_price'] = this._purchasePrice;
    data['tax'] = this._tax;
    data['tax_type'] = this._taxType;
    data['discount'] = this._discount;
    data['discount_type'] = this._discountType;
    data['current_stock'] = this._currentStock;
    data['details'] = this._details;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['country_id'] = this._countryId;
    data['state_id'] = this._stateId;
    data['city_id'] = this._cityId;
    if (this._rating != null) {
      data['rating'] = this._rating.map((v) => v.toJson()).toList();
    }

    if (this._shop != null) {
      data['shop'] = this._shop.toJson();
    }
    if (this._status != 0) {
      data['status'] = this.status;
    }
    return data;
  }
}

class CategoryIds {
  int _position = 0;

  CategoryIds({int? position}) {
    this._position = position ?? 0;
  }

  int get position => _position;

  CategoryIds.fromJson(Map<String, dynamic> json) {
    _position = json['position'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['position'] = this._position;
    return data;
  }
}

class ProductColors {
  String _name = '';
  String _code = '';

  ProductColors({String? name, String? code}) {
    this._name = name ?? '';
    this._code = code ?? '';
  }

  String get name => _name;

  String get code => _code;

  ProductColors.fromJson(Map<String, dynamic> json) {
    _name = json['name'] ?? '';
    _code = json['code'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this._name;
    data['code'] = this._code;
    return data;
  }
}

class ChoiceOptions {
  String _name = '';
  String _title = '';
  List<String> _options = [];

  ChoiceOptions({String? name, String? title, List<String>? options}) {
    this._name = name ?? '';
    this._title = title ?? '';
    this._options = options ?? [];
  }

  String get name => _name;

  String get title => _title;

  List<String> get options => _options;

  ChoiceOptions.fromJson(Map<String, dynamic> json) {
    _name = json['name'] ?? '';
    _title = json['title'] ?? '';
    _options = json['options']?.cast<String>() ?? [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this._name;
    data['title'] = this._title;
    data['options'] = this._options;
    return data;
  }
}

class Variation {
  String _type = '';
  double _price = 0.0;
  String _sku = '';
  int _qty = 0;

  Variation({String? type, double? price, String? sku, int? qty}) {
    this._type = type ?? '';
    this._price = price ?? 0.0;
    this._sku = sku ?? '';
    this._qty = qty ?? 0;
  }

  String get type => _type;

  double get price => _price;

  String get sku => _sku;

  int get qty => _qty;

  Variation.fromJson(Map<String, dynamic> json) {
    _type = json['type'] ?? '';
    _price = (json['price'] ?? 0.0).toDouble();
    _sku = json['sku'] ?? '';
    _qty = json['qty'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this._type;
    data['price'] = this._price;
    data['sku'] = this._sku;
    data['qty'] = this._qty;
    return data;
  }
}

class Rating {
  String _average = '';
  int _productId = 0;

  Rating({String? average, int? productId}) {
    this._average = average ?? '';
    this._productId = productId ?? 0;
  }

  String get average => _average;

  int get productId => _productId;

  Rating.fromJson(Map<String, dynamic> json) {
    _average = json['average']?.toString() ?? '';
    _productId = json['product_id'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['average'] = this._average;
    data['product_id'] = this._productId;
    return data;
  }
}
