class ResponseModel {
  String _message = '';
  bool _isSuccess = false;

  ResponseModel(String? message, bool? isSuccess) {
    this._message = message ?? '';
    this._isSuccess = isSuccess ?? false;
  }

  bool get isSuccess => _isSuccess;
  String get message => _message;
}
