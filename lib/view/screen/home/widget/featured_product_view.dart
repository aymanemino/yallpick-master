import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/product_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/product_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class FeaturedProductView extends StatelessWidget {
  final ScrollController scrollController;
  final bool isHome;

  FeaturedProductView({this.scrollController, @required this.isHome});

  @override
  Widget build(BuildContext context) {
    int offset = 1;
    scrollController?.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels &&
          Provider.of<ProductProvider>(context, listen: false)
              .featuredProductList
              .length !=
              0 &&
          !Provider.of<ProductProvider>(context, listen: false)
              .isFeaturedLoading) {
        int pageSize;

        pageSize = Provider.of<ProductProvider>(context, listen: false)
            .featuredPageSize;

        if (offset < pageSize) {
          offset++;
          print('end of the page');
          Provider.of<ProductProvider>(context, listen: false)
              .showBottomLoader();

          Provider.of<ProductProvider>(context, listen: false)
              .getLatestProductList(offset, context);
        }
      }
    });

    return Consumer<ProductProvider>(
      builder: (context, prodProvider, child) {
        List<Product> productList;
        productList = List.from(prodProvider.featuredProductList);

        // Shuffle the list of featured products
        if (productList.isNotEmpty) {
          productList.shuffle();
        }

        return Column(children: [
          prodProvider.firstFeaturedLoading
              ? ProductShimmer(
              isHomePage: true,
              isEnabled: prodProvider.firstFeaturedLoading)
              : productList.length > 0
              ? Container(
            height: isHome
                ? 350
                : null, // Reduced height to accommodate dynamic card sizing
            child: isHome
                ? ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(
                    horizontal:
                    0), // No padding to eliminate edge spacing
                itemCount: productList.length,
                itemBuilder: (ctx, index) {
                  return Container(
                      width: (MediaQuery.of(context).size.width /
                          2) -
                          4, // Reduced spacing for better fit
                      margin: EdgeInsets.only(
                          right:
                          2), // Minimal margin between products
                      child: ProductWidget(
                          productModel: productList[index]));
                })
                : StaggeredGridView.countBuilder(
              itemCount: productList.length,
              crossAxisCount: 2,
              padding: EdgeInsets.all(
                  0), // No padding to eliminate edge spacing
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              mainAxisSpacing:
              2, // Minimal spacing between rows
              crossAxisSpacing:
              2, // Minimal spacing between columns
              staggeredTileBuilder: (int index) =>
                  StaggeredTile.fit(1),
              itemBuilder: (BuildContext context, int index) {
                return ProductWidget(
                    productModel: productList[index]);
              },
            ),
          )
              : SizedBox.shrink(),
          prodProvider.isFeaturedLoading
              ? Center(
              child: Padding(
                padding: EdgeInsets.all(Dimensions.ICON_SIZE_EXTRA_SMALL),
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor)),
              ))
              : SizedBox.shrink(),
        ]);
      },
    );
  }
}
