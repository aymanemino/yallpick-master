class OnboardingModel {
  String _imageUrl;
  String _title;
  String _description;

  get imageUrl => _imageUrl;
  get title => _title;
  get description => _description;

  OnboardingModel(String? imageUrl, String? title, String? description) {
    this._imageUrl = imageUrl ?? '';
    this._title = title ?? '';
    this._description = description ?? '';
  }
}
