class TopSellerModel {
  int _id;
  String _sellerId;
  String _name;
  String _address;
  String _contact;
  String _image;
  String _createdAt;
  String _updatedAt;
  String _banner;
  String _latitude;
  String _longitude;
  Seller _seller;
  String _metaverseLink;
  String _showMetaverseLink;

  TopSellerModel({
    int? id,
    String? sellerId,
    String? name,
    String? address,
    String? contact,
    String? image,
    String? createdAt,
    String? updatedAt,
    String? banner,
    String? latitude,
    String? longitude,
    Seller? seller,
    String? metaverseLink,
    String? showMetaverseLink,
  }) {
    this._id = id;
    this._sellerId = sellerId;
    this._name = name;
    this._address = address;
    this._contact = contact;
    this._image = image;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._banner = banner;
    this._latitude = latitude;
    this._longitude = longitude;
    this._seller = seller;
    this._showMetaverseLink = showMetaverseLink;
    this._metaverseLink = metaverseLink;
  }

  int get id => _id;
  String get sellerId => _sellerId;
  String get name => _name;
  String get address => _address;
  String get contact => _contact;
  String get image => _image;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  String get banner => _banner;
  String get latitude => _latitude;
  String get longitude => _longitude;
  Seller get seller => _seller;
  String get showMetaverseLink => _showMetaverseLink;
  String get metaverseLink => _metaverseLink;

  TopSellerModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _sellerId = json['seller_id'].toString();
    _name = json['name'];
    _address = json['address'];
    _contact = json['contact'];
    _image = json['image'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _banner = json['banner'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _showMetaverseLink = json['show_metaverse_link'].toString();
    _metaverseLink = json['metaverse_link'];

    _seller =
        json['seller'] != null ? new Seller.fromJson(json['seller']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['seller_id'] = this._sellerId;
    data['name'] = this._name;
    data['address'] = this._address;
    data['contact'] = this._contact;
    data['image'] = this._image;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['banner'] = this._banner;
    data['latitude'] = this._latitude;
    data['longitude'] = this._longitude;
    data['show_metaverse_link'] = this._showMetaverseLink;
    data['metaverse_link'] = this._metaverseLink;

    if (this._seller != null) {
      data['seller'] = this._seller.toJson();
    }
    return data;
  }
}

class Seller {
  int _id;
  String _location;

  Seller({
    int? id,
    String? location,
  }) {
    this._id = id;
    this._location = location;
  }

  int get id => _id;
  String get location => _location;

  Seller.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _location = json['location'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['location'] = this._location;
    return data;
  }
}
