import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/category_provider.dart';
import '../provider/search_provider.dart';
import '../view/basewidget/no_internet_screen.dart';
import '../view/basewidget/product_shimmer.dart';
import '../view/basewidget/search_widget.dart';
import '../view/screen/search/widget/search_product_widget.dart';

class SpeechToTextResult extends StatefulWidget {
  final String searchQuery;

  const SpeechToTextResult({Key key, this.searchQuery}) : super(key: key);

  @override
  _SpeechToTextResultState createState() => _SpeechToTextResultState();
}

class _SpeechToTextResultState extends State<SpeechToTextResult> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration.zero,
      () {
        Provider.of<SearchProvider>(context, listen: false)
            .searchProduct(widget.searchQuery, '0', context,);
      },
    );
    return Scaffold(
      body: Column(
        children: [
          Consumer<SearchProvider>(
            builder: (context, search, child) {
              return Consumer<CategoryProvider>(
                builder: (context, categoryProvider, child2) {
                  return SearchWidget(
                    hintText: '${widget.searchQuery}',
                    onTextChanged: (String text) {
                      if (text.isEmpty) {
                        search.cleanSearchProduct();
                        return;
                      }
                      search.searchProduct(
                          text,
                          categoryProvider.categorySelectedIndex == 0
                              ? text
                              : categoryProvider.categoryIds[
                                      categoryProvider.categorySelectedIndex]
                                  .toString(),
                          context,);
                    },
                    onSubmit: (String text) {
                      search.searchProduct(
                          text,
                          categoryProvider.categorySelectedIndex == 0
                              ? text
                              : categoryProvider.categoryIds[
                                      categoryProvider.categorySelectedIndex]
                                  .toString(),
                          context,);
                      search.saveSearchAddress(text);

                      search.getCountryList(context);
                    },
                    onClearPressed: () {
                      search.cleanSearchProduct();
                    },
                    onCategoryIdChange: (text, categoryId) {
                      if (categoryId != 0) {
                        search.searchProduct(text, categoryId, context,);
                      }
                    },
                  );
                },
              );
            },
          ),
          Consumer<SearchProvider>(
            builder: (context, searchProvider, child) {
              return searchProvider.searchProductList != null
                  ? searchProvider.searchProductList.length > 0
                      ? Expanded(
                          child: SearchProductWidget(
                              products: searchProvider.searchProductList,
                              isViewScrollable: true),
                        )
                      : Expanded(
                          child: NoInternetOrDataScreen(isNoInternet: false))
                  : Expanded(
                      child: ProductShimmer(
                          isHomePage: false,
                          isEnabled: Provider.of<SearchProvider>(context)
                                  .searchProductList ==
                              null),
                    );
            },
          ),
        ],
      ),
    );
  }
}
