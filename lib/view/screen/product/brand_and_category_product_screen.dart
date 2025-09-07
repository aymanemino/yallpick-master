import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/no_internet_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/product_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/product_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/search_widget.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:provider/provider.dart';

import '../../../data/model/response/category.dart';

class BrandAndCategoryProductScreen extends StatelessWidget {
  final bool isBrand;
  final String id;
  final String name;
  final String image;
  final int status;
  final List<SubCategory> subcategory;

  BrandAndCategoryProductScreen({
    @required this.isBrand,
    @required this.id ?? 0,
    @required this.name,
    this.image,
    this.status,
    this.subcategory,
  });

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      Provider.of<ProductProvider>(context, listen: false).clearSellerData();
      Provider.of<ProductProvider>(context, listen: false)
          .initBrandOrCategoryProductList(isBrand, id, context);
    });
    ScrollController _scrollController = ScrollController();

    return Scaffold(
      backgroundColor: ColorResources.getIconBg(context),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            // CustomAppBar(title: name),
            SearchWidget(
              hintText: getTranslated('search_category', context),
              onTextChanged: (String newText) =>
                  Provider.of<ProductProvider>(context, listen: false).brandFilterData(newText),
              onClearPressed: () {
                productProvider.initBrandOrCategoryProductList(isBrand, id, context);
              },
            ),
            !isBrand && subcategory.length != 0
                ? SizedBox(
              height: 100, // Adjust height to fit one row of categories
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 15),
                child: GridView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(), // Adjusted physics for smoother scrolling
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1, // One row
                    mainAxisExtent: 90, // Width of each item (adjusted)
                    crossAxisSpacing: 8, // Space between items
                    mainAxisSpacing: 0,  // Minimized space between rows
                  ),
                  itemCount: subcategory.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BrandAndCategoryProductScreen(
                              isBrand: false,
                              id: subcategory[index].id.toString(),
                              name: subcategory[index].name,
                              subcategory: subcategory[index].subSubCategories != null
                                  ? List<SubCategory>.from(
                                subcategory[index].subSubCategories.map(
                                      (e) => SubCategory(
                                    id: e.id ?? 0,
                                    name: e.name,
                                    slug: e.slug,
                                    icon: e.icon,
                                    parentId: e.parentId,
                                    position: e.position,
                                    createdAt: e.createdAt,
                                    updatedAt: e.updatedAt,
                                  ),
                                ),
                              )
                                  : ""
                            ),
                          ),
                        ).then((value) {
                          Provider.of<ProductProvider>(context, listen: false)
                              .clearSellerData();
                          Provider.of<ProductProvider>(context, listen: false)
                              .initBrandOrCategoryProductList(
                              isBrand, id.toString(), context);
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 2), // Reduced margin between items
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            FadeInImage.assetNetwork(
                              placeholder: Images.placeholder,
                              image:
                              '${Provider.of<SplashProvider>(context, listen: false).baseUrls.categoryImageUrl}/${subcategory[index].icon}',
                              fit: BoxFit.cover,
                              imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 5, bottom: 0), // Reduced padding
                              child: Text(
                                subcategory[index].name,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
                : Container(),

            // Brand Details
            isBrand
                ? Container(
                    height: 100,
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                    margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                    color: Theme.of(context).highlightColor,
                    child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                      FadeInImage.assetNetwork(
                        placeholder: Images.placeholder,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        image:
                            '${Provider.of<SplashProvider>(context, listen: false).baseUrls.brandImageUrl}/$image',
                        imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder,
                            width: 80, height: 80, fit: BoxFit.cover),
                      ),
                      SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                      Text(name,
                          style: titilliumSemiBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                    ]),
                  )
                : SizedBox.shrink(),

            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

            // Products
            productProvider.brandOrCategoryProductList.length > 0
                ? Expanded(
                    child: StaggeredGridView.countBuilder(
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                      physics: BouncingScrollPhysics(),
                      crossAxisCount: 2,
                      itemCount: productProvider.brandOrCategoryProductList.length,
                      shrinkWrap: true,
                      staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
                      itemBuilder: (BuildContext context, int index) {
                        return ProductWidget(
                            productModel: productProvider.brandOrCategoryProductList[index]);
                      },
                    ),
                  )
                : Expanded(
                    child: Center(
                    child: productProvider.hasData
                        ? ProductShimmer(
                            isHomePage: false,
                            isEnabled: Provider.of<ProductProvider>(context)
                                    .brandOrCategoryProductList
                                    .length ==
                                0)
                        : NoInternetOrDataScreen(isNoInternet: false),
                  )),
          ]);
        },
      ),
    );
  }
}
