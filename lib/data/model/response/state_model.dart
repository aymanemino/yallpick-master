class StateModel {
  List<States> _states;

  StateModel({List<States>? states}) {
    this._states = states;
  }

  List<States> get countries => _states;

  StateModel.fromJson(Map<String, dynamic> json) {
    if (json['states'] != null) {
      _states = [];
      json['states'].forEach((v) {
        _states.add(new States.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._states != null) {
      data['states'] = this._states.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class States {
  int _id;
  String _countryId;
  String _name;
  String _status;

  States({
    int id,
    String countryId,
    String name,
    String status,
  }) {
    this._id = id;
    this._countryId = countryId;
    this._name = name;
    this._status = status;
  }

  int get id => _id;
  String get countryId => _countryId;
  String get name => _name;
  String get status => _status;

  States.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _countryId = json['country_id'];
    _name = json['name'];
    _status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['country_id'] = this._countryId;
    data['name'] = this._name;
    data['status'] = this._status;
    return data;
  }
}
