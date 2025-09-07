import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/category_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/search_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/no_internet_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/product_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/search_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/search/widget/search_product_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';


class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration.zero,
          () {
        Provider.of<SearchProvider>(context, listen: false)
            .cleanSearchProduct();
        Provider.of<SearchProvider>(context, listen: false).initHistoryList();
        Provider.of<CategoryProvider>(context, listen: false)
            .getCategoryList(false, context);
      },
    );

    return Scaffold(
      backgroundColor: ColorResources.getIconBg(context),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          // for tool bar
          Consumer<SearchProvider>(builder: (context, search, child) {
            return Consumer<CategoryProvider>(
                builder: (context, categoryProvider, child2) {
                  return SearchWidget(
                    hintText: getTranslated('SEARCH_HINT', context),
                    onTextChanged: (String text) {
                      if (text.isEmpty) {
                        search.cleanSearchProduct();
                        return;
                      }
                      // Use simple search for better performance
                      search.searchProduct(
                          text,
                          categoryProvider.categorySelectedIndex == 0
                              ? '0'
                              : categoryProvider.categoryIds[
                          categoryProvider.categorySelectedIndex]
                              .toString(),
                          context);
                    },
                    onSubmit: (String text) {
                      // Use simple search for better performance
                      search.searchProduct(
                        text,
                        categoryProvider.categorySelectedIndex == 0
                            ? '0'
                            : categoryProvider
                            .categoryIds[categoryProvider.categorySelectedIndex]
                            .toString(),
                        context,
                      );
                      search.saveSearchAddress(text);

                      search.getCountryList(context);
                    },
                    onClearPressed: () {
                      search.cleanSearchProduct();
                    },
                    onCategoryIdChange: (text, categoryId) {
                      if (categoryId != 0) {
                        // Use simple search for better performance
                        search.searchProduct(
                          text,
                          categoryId,
                          /* search.countryIds[search.countryIndex].toString(),
                        search.stateIds[search.stateIndex].toString(),
                        search.cityIds[search.cityIndex].toString(), */
                          context,
                        );
                      }
                    },
                  );
                });
          }),

          Consumer<SearchProvider>(
            builder: (context, searchProvider, child) {
              final isLoading = searchProvider.searchProductList == null &&
                  !searchProvider.isClear;
              return !searchProvider.isClear
                  ? isLoading
                  ? Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Searching...',
                          style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              )
                  : searchProvider.searchProductList != null
                  ? searchProvider.searchProductList.length > 0
                  ? Expanded(
                  child: SearchProductWidget(
                    products: searchProvider.searchProductList,
                    isViewScrollable: true,
                  ))
                  : Expanded(
                child: NoInternetOrDataScreen(
                    isNoInternet: false),
              )
                  : Expanded(
                  child: ProductShimmer(
                      isHomePage: false,
                      isEnabled:
                      Provider.of<SearchProvider>(context)
                          .searchProductList ==
                          null))
                  : Expanded(
                flex: 4,
                child: Container(
                  padding:
                  EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Consumer<SearchProvider>(
                        builder: (context, searchProvider, child) =>
                            StaggeredGridView.countBuilder(
                              crossAxisCount: 3,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: searchProvider.historyList.length,
                              itemBuilder: (context, index) => Container(
                                alignment: Alignment.center,
                                child: InkWell(
                                  onTap: () {
                                    // Use simple search for better performance
                                    searchProvider.searchProduct(
                                      searchProvider.historyList[index],
                                      '0',
                                      context,
                                    );

                                    if (searchProvider.countryList == null) {
                                      searchProvider.getCountryList(context);
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.white,
                                          Colors.orange.shade50,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Colors.orange.withOpacity(0.2),
                                        width: 1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color:
                                          Colors.orange.withOpacity(0.1),
                                          blurRadius: 8,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.history_rounded,
                                          color: Colors.orange.shade600,
                                          size: 16,
                                        ),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            Provider.of<SearchProvider>(
                                                context,
                                                listen: false)
                                                .historyList[index] ??
                                                "",
                                            style: robotoRegular.copyWith(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.orange.shade800,
                                            ),
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              staggeredTileBuilder: (int index) =>
                              new StaggeredTile.fit(1),
                              mainAxisSpacing: 4.0,
                              crossAxisSpacing: 4.0,
                            ),
                      ),
                      Positioned(
                        top: -5,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.orange.shade400,
                                    Colors.orange.shade600,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.orange.withOpacity(0.3),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.history_rounded,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    getTranslated(
                                        'SEARCH_HISTORY', context),
                                    style: robotoBold.copyWith(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () {
                                Provider.of<SearchProvider>(context,
                                    listen: false)
                                    .clearSearchAddress();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.orange.shade300,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.clear_all_rounded,
                                      color: Colors.orange.shade700,
                                      size: 16,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      getTranslated('REMOVE', context),
                                      style: robotoRegular.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.orange.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
