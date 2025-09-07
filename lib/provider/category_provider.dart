import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/category.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/category_repo.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryRepo categoryRepo;

  CategoryProvider({required this.categoryRepo});

  List<Category> _categoryList = [];
  int _categorySelectedIndex;

  List<int> _categoryIds = [];

  List<Category> get categoryList => _categoryList;
  int get categorySelectedIndex => _categorySelectedIndex;
  List<int> get categoryIds => _categoryIds;

  Future<void> getCategoryList(bool reload, BuildContext context) async {
    _categoryIds = [];
    _categoryIds.add(0);

    if (_categoryList.length == 0 || reload) {
      ApiResponse apiResponse = await categoryRepo.getCategoryList();
      if (apiResponse.response != null &&
          apiResponse.response.statusCode == 200) {
        _categoryList.clear();
        apiResponse.response.data.forEach(
            (category) => _categoryList.add(Category.fromJson(category)));
        _categorySelectedIndex = 0;

        for (int index = 0; index < _categoryList.length; index++) {
          _categoryIds.add(_categoryList[index].id);
        }
      } else {
        ApiChecker.checkApi(context, apiResponse);
      }

      notifyListeners();
    }
  }

  void changeSelectedIndex(int selectedIndex) {
    _categorySelectedIndex = selectedIndex;
    notifyListeners();
  }
}
