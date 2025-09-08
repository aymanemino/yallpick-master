import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/provider/home_category_product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/product_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/title_row.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/brand_and_category_product_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/product_details_screen.dart';
import 'package:provider/provider.dart';

class HomeCategoryProductView extends StatelessWidget {
  final bool isHomePage;

  HomeCategoryProductView({this.isHomePage});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeCategoryProductProvider>(
      builder: (context, homeCategoryProductProvider, child) {
        return homeCategoryProductProvider.homeCategoryProductList.length != 0
            ? ListView.builder(
                itemCount:
                    homeCategoryProductProvider.homeCategoryProductList.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (ctx, index) {
                  // Shuffle the list of products in each section
                  homeCategoryProductProvider
                      .homeCategoryProductList[index].products
                      ?.shuffle();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      isHomePage
                          ? Padding(
                              padding: EdgeInsets.fromLTRB(
                                  Dimensions.PADDING_SIZE_SMALL,
                                  20,
                                  Dimensions.PADDING_SIZE_SMALL,
                                  Dimensions.PADDING_SIZE_SMALL),
                              child: TitleRow(
                                title: homeCategoryProductProvider
                                    .homeCategoryProductList[index].name,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          BrandAndCategoryProductScreen(
                                        isBrand: false,
                                        id: homeCategoryProductProvider
                                            .homeCategoryProductList[index].id
                                            .toString(),
                                        name: homeCategoryProductProvider
                                            .homeCategoryProductList[index]
                                            .name,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : SizedBox(),
                      ConstrainedBox(
                        constraints: homeCategoryProductProvider
                                    .homeCategoryProductList[index]
                                    .products
                                    ?.length ??
                                0 > 0
                            ? BoxConstraints(maxHeight: 315)
                            : BoxConstraints(maxHeight: 0),
                        child: ListView.builder(
                            itemCount: homeCategoryProductProvider
                                    .homeCategoryProductList[index]
                                    .products
                                    ?.length ??
                                0,
                            padding: EdgeInsets.symmetric(
                                horizontal:
                                    0), // No padding to eliminate edge spacing
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int i) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        transitionDuration:
                                            Duration(milliseconds: 1000),
                                        pageBuilder: (context, anim1, anim2) =>
                                            ProductDetails(
                                                product:
                                                    homeCategoryProductProvider
                                                        .productList[i]),
                                      ));
                                },
                                child: Container(
                                    width: (MediaQuery.of(context).size.width /
                                            2) -
                                        8,
                                    margin: EdgeInsets.only(
                                        right:
                                            2), // Minimal margin between products
                                    child: ProductWidget(
                                        productModel:
                                            homeCategoryProductProvider
                                                    .homeCategoryProductList[
                                                        index]
                                                    .products?[i] ??
                                                Product())),
                              );
                            }),
                      )
                    ],
                  );
                })
            : SizedBox();
      },
    );
  }
}
