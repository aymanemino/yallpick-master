import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/base/api_response.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/city_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/country_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/state_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/repository/search_repo.dart';
import 'package:flutter_sixvalley_ecommerce/helper/api_checker.dart';

class SearchProvider with ChangeNotifier {
  final SearchRepo searchRepo;

  SearchProvider({this.searchRepo});

  int _countryIndex = 0;
  int _stateIndex = 0;
  int _cityIndex = 0;
  List<int> _countryIds = [];
  List<int> _stateIds = [];
  List<int> _cityIds = [];

  CountryModel _countryModel = CountryModel();
  List<Countries> _countryList = [];

  StateModel _stateModel = StateModel();
  List<States> _stateList = [];

  CityModel _cityModel = CityModel();
  List<Cities> _cityList = [];

  int _filterIndex = 0;
  List<String> _historyList = [];

  int get filterIndex => _filterIndex;

  List<String> get historyList => _historyList;

  int get countryIndex => _countryIndex;

  int get stateIndex => _stateIndex;

  int get cityIndex => _cityIndex;

  List<int> get countryIds => _countryIds;

  List<int> get stateIds => _stateIds;

  List<int> get cityIds => _cityIds;

  List<Countries> get countryList => _countryList;

  CountryModel get countryModel => _countryModel;

  List<States> get stateList => _stateList;

  StateModel get stateModel => _stateModel;

  List<Cities> get cityList => _cityList;

  CityModel get cityModel => _cityModel;

  void setFilterIndex(int index) {
    _filterIndex = index;
    notifyListeners();
  }

  void setCountryIndex(int index, bool notify) {
    _countryIndex = index;
    if (notify) {
      notifyListeners();
    }
  }

  void setStateIndex(int index, bool notify) {
    _stateIndex = index;
    if (notify) {
      notifyListeners();
    }
  }

  void setCityIndex(int index, bool notify) {
    _cityIndex = index;
    if (notify) {
      notifyListeners();
    }
  }

  void sortSearchList(double startingPrice, double endingPrice) {
    _searchProductList = [];
    if (startingPrice > 0 && endingPrice > startingPrice) {
      _searchProductList.addAll(_filterProductList
          .where((product) =>
              (product.unitPrice) > startingPrice &&
              (product.unitPrice) < endingPrice)
          .toList());
    } else {
      _searchProductList.addAll(_filterProductList);
    }

    if (_filterIndex == 0) {
    } else if (_filterIndex == 1) {
      _searchProductList
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    } else if (_filterIndex == 2) {
      _searchProductList
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      Iterable iterable = _searchProductList.reversed;
      _searchProductList = iterable.toList();
    } else if (_filterIndex == 3) {
      _searchProductList.sort((a, b) => a.unitPrice.compareTo(b.unitPrice));
    } else if (_filterIndex == 4) {
      _searchProductList.sort((a, b) => a.unitPrice.compareTo(b.unitPrice));
      Iterable iterable = _searchProductList.reversed;
      _searchProductList = iterable.toList();
    }

    if (_cityIndex != 0) {
      _searchProductList = _searchProductList
          .where((i) =>
              i.shop.city.toLowerCase() ==
              _cityList[_cityIndex - 1].name.toString().toLowerCase())
          .toList();
    } else if (_stateIndex != 0) {
      _searchProductList = _searchProductList
          .where((i) =>
              i.shop.state.toLowerCase() ==
              _stateList[_stateIndex - 1].name.toString().toLowerCase())
          .toList();
    } else if (_countryIndex != 0) {
      _searchProductList = _searchProductList.where((i) {
        return i.shop.country.toLowerCase() ==
            _countryList[_countryIndex - 1].name.toString().toLowerCase();
      }).toList();
    }

    notifyListeners();
  }

  List<Product> _searchProductList = [];
  List<Product> _filterProductList = [];
  bool _isClear = true;
  String _searchText = '';

  List<Product> get searchProductList => _searchProductList;

  List<Product> get filterProductList => _filterProductList;

  bool get isClear => _isClear;

  String get searchText => _searchText;

  void setSearchText(String text) {
    _searchText = text;
    notifyListeners();
  }

  void cleanSearchProduct() {
    _searchProductList = [];
    _isClear = true;
    _searchText = '';
    notifyListeners();
  }

  void searchProduct(String query, String catId, BuildContext context) async {
    _searchText = query;
    _isClear = false;
    _searchProductList = null;
    _filterProductList = null;
    _countryIndex = 0;
    _stateIndex = 0;
    _cityIndex = 0;
    notifyListeners();

    ApiResponse apiResponse =
        await searchRepo.getSearchProductList(query, catId, '1000');
    if (apiResponse.response != null &&
        apiResponse.response.statusCode == 200) {
      if (query.isEmpty) {
        _searchProductList = [];
      } else {
        _searchProductList = [];
        _searchProductList
            .addAll(ProductModel.fromJson(apiResponse.response.data).products);
        _filterProductList = [];
        _filterProductList
            .addAll(ProductModel.fromJson(apiResponse.response.data).products);
      }
      debugPrint('SEARCH ======> ${searchProductList.length}');
      // debugPrint('SEARCH ======> ${_filterProductList.length}');
    } else {
      ApiChecker.checkApi(context, apiResponse);
    }
    notifyListeners();
  }

  void initHistoryList() {
    _historyList = [];
    _historyList.addAll(searchRepo.getSearchAddress());
    notifyListeners();
  }

  void saveSearchAddress(String searchAddress) async {
    searchRepo.saveSearchAddress(searchAddress);
    if (!_historyList.contains(searchAddress)) {
      _historyList.add(searchAddress);
    }
    notifyListeners();
  }

  void clearSearchAddress() async {
    searchRepo.clearSearchAddress();
    _historyList = [];
    notifyListeners();
  }

  Future<void> getCountryList(BuildContext context) async {
    _countryIds = [];
    _stateIds = [];
    _cityIds = [];
    _countryIds.add(0);
    _stateIds.add(0);
    _cityIds.add(0);

    _countryIndex = 0;
    _stateIndex = 0;
    _cityIndex = 0;

    ApiResponse response = await searchRepo.getCountryList();
    if (response.response != null && response.response.statusCode == 200) {
      _countryList = [];

      _countryModel = (CountryModel.fromJson(response.response.data));
      _countryList = _countryModel.countries;
      _countryIndex = 0;

      for (int index = 0; index < _countryList.length; index++) {
        _countryIds.add(_countryList[index].id);
      }
    } else {
      ApiChecker.checkApi(context, response);
    }
    notifyListeners();
  }

  Future<void> getStateList(
      BuildContext context, int selectedIndex, bool notify) async {
    _stateIndex = 0;
    if (countryIndex != 0) {
      ApiResponse response = await searchRepo
          .getStateList(_countryList[countryIndex - 1].id.toString());
      if (response.response != null && response.response.statusCode == 200) {
        _stateList = [];

        _stateModel = (StateModel.fromJson(response.response.data));
        _stateList = _stateModel.countries;
        _stateIndex = 0;

        for (int index = 0; index < _stateList.length; index++) {
          _stateIds.add(_stateList[index].id);
        }
      }
    } else {
      _stateList = [];
      _stateIds = [];
      _stateIds.add(0);
      _stateIndex = 0;

      _cityList = [];
      _cityIds = [];
      _cityIds.add(0);
      _cityIndex = 0;
    }

    if (notify) {
      _stateIds = [];
      _stateIds.add(0);
      _stateIndex = 0;
      _cityIds = [];
      _cityIds.add(0);
      _cityIndex = 0;
      _stateList.forEach((element) {
        _stateIds.add(element.id);
      });
      notifyListeners();
    }
  }

  Future<void> getCityList(
      BuildContext context, int selectedIndex, bool notify) async {
    _cityIndex = 0;
    if (stateIndex != 0) {
      ApiResponse response = await searchRepo
          .getCityList(_stateList[stateIndex - 1].id.toString());
      if (response.response != null && response.response.statusCode == 200) {
        _cityList = [];

        _cityModel = (CityModel.fromJson(response.response.data));
        _cityList = _cityModel.cities;
        _cityIndex = 0;

        for (int index = 0; index < _cityList.length; index++) {
          _cityIds.add(_cityList[index].id);
        }
      }
    } else {
      _cityList = [];
      _cityIds = [];
      _cityIds.add(0);
      _cityIndex = 0;
    }

    if (notify) {
      _cityIds = [];
      _cityIds.add(0);
      _cityIndex = 0;
      _cityList.forEach((element) {
        _cityIds.add(element.id);
      });
      notifyListeners();
    }
  }
}
