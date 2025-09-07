class CityModel {
  List<Cities> _cities;

  CityModel({List<Cities>? cities}) {
    this._cities = cities;
  }

  List<Cities> get cities => _cities;

  CityModel.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      _cities = [];
      json['products'].forEach((v) {
        _cities.add(new Cities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._cities != null) {
      data['products'] = this._cities.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cities {
  int _id;
  String _stateId;
  String _name;
  String _status;

  Cities({
    int id,
    String countryId,
    String name,
    String status,
  }) {
    this._id = id;
    this._stateId = countryId;
    this._name = name;
    this._status = status;
  }

  int get id => _id;
  String get countryId => _stateId;
  String get name => _name;
  String get status => _status;

  Cities.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _stateId = json['state_id'];
    _name = json['name'];
    _status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['state_id'] = this._stateId;
    data['name'] = this._name;
    data['status'] = this._status;
    return data;
  }
}

class AddressCity {
  int id;
  int stateId;
  String name;
  int status;

  AddressCity({this.id, this.stateId, this.name, this.status});

  AddressCity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    stateId = json['state_id'];
    name = json['name'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['state_id'] = this.stateId;
    data['name'] = this.name;
    data['status'] = this.status;
    return data;
  }
}
