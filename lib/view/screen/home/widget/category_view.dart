import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/category_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/brand_and_category_product_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:shimmer/shimmer.dart';

class CategoryView extends StatefulWidget {
  final bool isHomePage;

  CategoryView({@required this.isHomePage});

  @override
  _CategoryViewState createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        return categoryProvider.categoryList.length != 0
            ? Column(
                children: [
                  SizedBox(
                    height: 90, // Adjust height to fit one line of categories
                    child: GridView.builder(
                      controller: _scrollController,
                      scrollDirection: Axis.horizontal,
                      physics:
                          BouncingScrollPhysics(), // Adjusted physics for smoother scrolling
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1, // One row
                        mainAxisExtent: 90, // Width of each item (reduced)
                        crossAxisSpacing:
                            8, // Minimized space between categories
                        mainAxisSpacing: 0, // Minimized space between rows
                      ),
                      itemCount: categoryProvider.categoryList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BrandAndCategoryProductScreen(
                                  isBrand: false,
                                  id: categoryProvider.categoryList[index].id
                                      .toString(),
                                  name:
                                      categoryProvider.categoryList[index].name,
                                  subcategory: categoryProvider
                                      .categoryList[index].subCategories,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 2), // Reduced margin between items
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                FadeInImage.assetNetwork(
                                  placeholder: Images.placeholder,
                                  image:
                                      '${Provider.of<SplashProvider>(context, listen: false).baseUrls.categoryImageUrl}/${categoryProvider.categoryList[index].icon}',
                                  fit: BoxFit.cover,
                                  imageErrorBuilder: (c, o, s) =>
                                      Image.asset(Images.placeholder),
                                ),
                                Container(
                                  padding: EdgeInsets.only(
                                      top: 5, bottom: 0), // Reduced padding
                                  child: Text(
                                    categoryProvider.categoryList[index].name,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize:
                                          Dimensions.FONT_SIZE_EXTRA_SMALL,
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
                ],
              )
            : CategoryShimmer();
      },
    );
  }
}

class CategoryShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1, // One row for shimmer as well
        childAspectRatio: (1 / 1),
        crossAxisSpacing: 4, // Reduced spacing
        mainAxisSpacing: 4, // Reduced spacing
      ),
      itemCount: 4, // Reduced item count for one line
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
                color: Colors.grey[Provider.of<CategoryProvider>(context)
                            .categoryList
                            .length ==
                        0
                    ? 700
                    : 200],
                spreadRadius: 2,
                blurRadius: 5)
          ]),
          margin: EdgeInsets.all(2), // Reduced margin
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Expanded(
              flex: 7,
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!!!,
                highlightColor: Colors.grey[100]!!!,
                enabled: true,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: ColorResources.getTextBg(context),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300]!!!,
                  highlightColor: Colors.grey[100]!!!,
                  enabled: true,
                  child: Container(
                    height: 10,
                    color: Colors.white,
                    margin: EdgeInsets.only(
                        left: 5, right: 5), // Reduced padding inside shimmer
                  ),
                ),
              ),
            ),
          ]),
        );
      },
    );
  }
}
