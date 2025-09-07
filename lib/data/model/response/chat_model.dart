class ChatModel {
  int _id = 0;
  int _userId = 0;
  int _sellerId = 0;
  String _message = '';
  int _sentByCustomer = 0;
  int _sentBySeller = 0;
  int _seenByCustomer = 0;
  int _seenBySeller = 0;
  int _status = 0;
  String _createdAt = '';
  String _updatedAt = '';
  int _shopId = 0;

  ChatModel(
      {int? id,
      int? userId,
      int? sellerId,
      String? message,
      int? sentByCustomer,
      int? sentBySeller,
      int? seenByCustomer,
      int? seenBySeller,
      int? status,
      String? createdAt,
      String? updatedAt,
      int? shopId}) {
    this._id = id ?? 0;
    this._userId = userId ?? 0;
    this._sellerId = sellerId ?? 0;
    this._message = message ?? '';
    this._sentByCustomer = sentByCustomer ?? 0;
    this._sentBySeller = sentBySeller ?? 0;
    this._seenByCustomer = seenByCustomer ?? 0;
    this._seenBySeller = seenBySeller ?? 0;
    this._status = status ?? 0;
    this._createdAt = createdAt ?? '';
    this._updatedAt = updatedAt ?? '';
    this._shopId = shopId ?? 0;
  }

  int get id => _id;
  int get userId => _userId;
  int get sellerId => _sellerId;
  String get message => _message;
  int get sentByCustomer => _sentByCustomer;
  int get sentBySeller => _sentBySeller;
  int get seenByCustomer => _seenByCustomer;
  int get seenBySeller => _seenBySeller;
  int get status => _status;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  int get shopId => _shopId;

  ChatModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'] ?? 0;
    _userId = json['user_id'] ?? 0;
    _sellerId = json['seller_id'] ?? 0;
    _message = json['message'] ?? '';
    _sentByCustomer = json['sent_by_customer'] ?? 0;
    _sentBySeller = json['sent_by_seller'] ?? 0;
    _seenByCustomer = json['seen_by_customer'] ?? 0;
    _seenBySeller = json['seen_by_seller'] ?? 0;
    _status = json['status'] ?? 0;
    _createdAt = json['created_at'] ?? '';
    _updatedAt = json['updated_at'] ?? '';
    _shopId = json['shop_id'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['user_id'] = this._userId;
    data['seller_id'] = this._sellerId;
    data['message'] = this._message;
    data['sent_by_customer'] = this._sentByCustomer;
    data['sent_by_seller'] = this._sentBySeller;
    data['seen_by_customer'] = this._seenByCustomer;
    data['seen_by_seller'] = this._seenBySeller;
    data['status'] = this._status;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['shop_id'] = this._shopId;
    return data;
  }
}
