import 'package:flutter/material.dart';

class DummyProvider extends ChangeNotifier {
  bool isLoadingProduct = false;
  final product = <String>[];

  Future<void> fetchProduct() async {
    isLoadingProduct = true;
    notifyListeners();

     await Future.delayed(Duration(seconds: 3));
    product.add("value");
    isLoadingProduct = false;
    notifyListeners();

  }
}
