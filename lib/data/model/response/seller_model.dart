class SellerModel {
  int _id;
  String _sellerId;
  String _fName;
  String _lName;
  String _phone;
  String _image;
  String _location;
  Shop _shop;

  SellerModel(int? id, String? sellerId, String? fName, String? lName, String? phone,
      String? image, String? location, Shop? shop) {
    this._id = id;
    this._sellerId = sellerId;
    this._fName = fName;
    this._lName = lName;
    this._phone = phone;
    this._image = image;
    this._location = location;
    this._shop = shop;
  }

  int get id => _id;
  String get sellerId => _sellerId;
  String get fName => _fName;
  String get lName => _lName;
  String get phone => _phone;
  String get image => _image;
  String get location => _location;
  // ignore: unnecessary_getters_setters
  Shop get shop => _shop??Shop.fromJson({});
  // ignore: unnecessary_getters_setters
  set shop(Shop value) {
    _shop = value;
  }

  SellerModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _sellerId = json['seller_id'];
    _fName = json['f_name']??"";
    _lName = json['l_name']??"";
    _phone = json['phone']??"";
    _image = json['image'];
    _location = json['location'];
    _shop = json['shop'] != null ? new Shop.fromJson(json['shop']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['seller_id'] = this._sellerId;
    data['f_name'] = this._fName;
    data['l_name'] = this._lName;
    data['phone'] = this._phone;
    data['image'] = this._image;
    data['location'] = this._location;
    if (this._shop != null) {
      data['shop'] = this._shop.toJson();
    }
    return data;
  }
}

class Shop {
  int _id;
  String _name;
  String _address;
  String _contact;
  String _image;
  String _createdAt;
  String _updatedAt;
  String _latitude;
  String _longitude;
  String _country;
  String _state;
  String _city;
  String _sellerId;
  String _metaverseLink;
  String _showMetaverseLink;

  Shop({
    int id,
    String name,
    String address,
    String contact,
    String image,
    String createdAt,
    String updatedAt,
    String latitude,
    String longitude,
    String country,
    String state,
    String city,
    String sellerId,
    String metaverseLink,
    String showMetaverseLink,
  }) {
    this._id = id;
    this._name = name;
    this._address = address;
    this._contact = contact;
    this._image = image;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._latitude = latitude;
    this._longitude = longitude;
    this._country = country;
    this._state = state;
    this._city = city;
    this._sellerId = sellerId;
    this._showMetaverseLink = showMetaverseLink;
    this._metaverseLink = metaverseLink;
  }

  int get id => _id;
  String get name => _name;
  String get address => _address;
  String get contact => _contact;
  String get image => _image;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  String get latitude => _latitude;
  String get longitude => _longitude;
  String get country => _country;
  String get state => _state;
  String get city => _city;
  String get sellerId => _sellerId;
  String get showMetaverseLink => _showMetaverseLink;
  String get metaverseLink => _metaverseLink;

  Shop.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'].toString();
    _address = json['address'].toString();
    _contact = json['contact'].toString();
    _image = json['image'].toString();
    _createdAt = json['created_at'].toString();
    _updatedAt = json['updated_at'].toString();
    _latitude = json['latitude'].toString();
    _longitude = json['longitude'].toString();
    _country = json['country'].toString();
    _state = json['state'].toString();
    _city = json['city'].toString();
    _sellerId = json['seller_id'].toString();
    _showMetaverseLink = json['show_metaverse_link'].toString();
    _metaverseLink = json['metaverse_link'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['address'] = this._address;
    data['contact'] = this._contact;
    data['image'] = this._image;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['latitude'] = this._latitude;
    data['longitude'] = this._longitude;
    data['country'] = this._country;
    data['state'] = this._state;
    data['city'] = this._city;
    data['seller_id'] = this._sellerId;
    data['show_metaverse_link'] = this._showMetaverseLink;
    data['metaverse_link'] = this._metaverseLink;
    return data;
  }
}
