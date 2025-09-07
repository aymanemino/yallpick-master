import 'package:flutter_sixvalley_ecommerce/data/model/response/chat_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/seller_model.dart';

class ChatInfoModel {
  LastChat _lastChat = LastChat();
  List<ChatModel> _chatList = [];
  List<UniqueShops> _uniqueShops = [];

  ChatInfoModel(
      {LastChat? lastChat,
      List<ChatModel>? chatList,
      List<UniqueShops>? uniqueShops}) {
    this._lastChat = lastChat ?? LastChat();
    this._chatList = chatList ?? [];
    this._uniqueShops = uniqueShops ?? [];
  }

  LastChat get lastChat => _lastChat;
  List<ChatModel> get chatList => _chatList;
  List<UniqueShops> get uniqueShops => _uniqueShops;

  ChatInfoModel.fromJson(Map<String, dynamic> json) {
    _lastChat = json['last_chat'] != null
        ? new LastChat.fromJson(json['last_chat'])
        : LastChat();
    if (json['chat_list'] != null) {
      _chatList = [];
      json['chat_list'].forEach((v) {
        _chatList.add(new ChatModel.fromJson(v));
      });
    } else {
      _chatList = [];
    }
    if (json['unique_shops'] != null) {
      _uniqueShops = [];
      json['unique_shops'].forEach((v) {
        _uniqueShops.add(new UniqueShops.fromJson(v));
      });
    } else {
      _uniqueShops = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._lastChat != null) {
      data['last_chat'] = this._lastChat.toJson();
    }
    if (this._chatList != null) {
      data['chat_list'] = this._chatList.map((v) => v.toJson()).toList();
    }
    if (this._uniqueShops != null) {
      data['unique_shops'] = this._uniqueShops.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LastChat {
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

  LastChat(
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

  LastChat.fromJson(Map<String, dynamic> json) {
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

class UniqueShops {
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
  SellerModel _sellerInfo = SellerModel();
  Shop _shop = Shop();

  UniqueShops(
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
      int? shopId,
      SellerModel? sellerInfo,
      Shop? shop}) {
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
    this._sellerInfo = sellerInfo ?? SellerModel();
    this._shop = shop ?? Shop();
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
  SellerModel get sellerInfo => _sellerInfo;
  Shop get shop => _shop;

  UniqueShops.fromJson(Map<String, dynamic> json) {
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
    _sellerInfo = json['seller_info'] != null
        ? new SellerModel.fromJson(json['seller_info'])
        : SellerModel();
    _shop = json['shop'] != null ? new Shop.fromJson(json['shop']) : Shop();
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
    if (this._sellerInfo != null) {
      data['seller_info'] = this._sellerInfo.toJson();
    }
    if (this._shop != null) {
      data['shop'] = this._shop.toJson();
    }
    return data;
  }
}
