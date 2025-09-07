class CountryModel {
  List<Countries> _countries = [];

  CountryModel({List<Countries>? countries}) {
    this._countries = countries ?? [];
  }

  List<Countries> get countries => _countries;

  CountryModel.fromJson(Map<String, dynamic> json) {
    if (json['countries'] != null) {
      _countries = [];
      json['countries'].forEach((v) {
        _countries.add(new Countries.fromJson(v));
      });
    } else {
      _countries = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['countries'] = this._countries.map((v) => v.toJson()).toList();
    return data;
  }
}

class Countries {
  int _id = 0;
  String _name = '';
  String _status = '';

  Countries({
    int? id,
    String? name,
    String? status,
  }) {
    this._id = id ?? 0;
    this._name = name ?? '';
    this._status = status ?? '';
  }

  int get id => _id;
  String get name => _name;
  String get status => _status;

  Countries.fromJson(Map<String, dynamic> json) {
    _id = json['id'] ?? 0;
    _name = json['name'] ?? '';
    _status = json['status'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['status'] = this._status;
    return data;
  }
}
