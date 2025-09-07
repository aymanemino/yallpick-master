import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/provider/banner_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/brand_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/category_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/featured_deal_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/home_category_product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_details_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/top_seller_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/brand_and_category_product_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/product_details_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/topSeller/top_seller_product_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class BannersView extends StatelessWidget {
  Future<void> _loadData(BuildContext context, bool reload) async {
    await Provider.of<BannerProvider>(context, listen: false).getBannerList(reload, context);
    await Provider.of<BannerProvider>(context, listen: false).getFooterBannerList(context);
    await Provider.of<CategoryProvider>(context, listen: false).getCategoryList(reload, context);
    await Provider.of<HomeCategoryProductProvider>(context, listen: false)
        .getHomeCategoryProductList(reload, context);
    await Provider.of<TopSellerProvider>(context, listen: false).getTopSellerList(reload, context);
    await Provider.of<BrandProvider>(context, listen: false).getBrandList(reload, context);
    await Provider.of<ProductProvider>(context, listen: false)
        .getLatestProductList(1, context, reload: reload);
    await Provider.of<ProductProvider>(context, listen: false)
        .getFeaturedProductList('1', context, reload: reload);
    await Provider.of<FeaturedDealProvider>(context, listen: false)
        .getFeaturedDealList(reload, context);
    await Provider.of<ProductProvider>(context, listen: false)
        .getLProductList('1', context, reload: reload);
    await Provider.of<ProductDetailsProvider>(context, listen: false)
        .initProduct(Provider.of<BannerProvider>(context, listen: false).product, context);
  }

  _clickBannerRedirect(BuildContext context, int id, String slug, String type) {
    final cIndex = Provider.of<CategoryProvider>(context, listen: false)
        .categoryList
        .indexWhere((element) => element.id == id);
    final bIndex = Provider.of<BrandProvider>(context, listen: false)
        .brandList
        .indexWhere((element) => element.id == id);
    final tIndex = Provider.of<TopSellerProvider>(context, listen: false)
        .topSellerList
        .indexWhere((element) => element.id == id);

    if (type == 'category') {
      if (Provider.of<CategoryProvider>(context, listen: false).categoryList[cIndex].name != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BrandAndCategoryProductScreen(
              isBrand: false,
              id: id.toString(),
              name:
                  '${Provider.of<CategoryProvider>(context, listen: false).categoryList[cIndex].name}',
              subcategory: Provider.of<CategoryProvider>(context, listen: false)
                  .categoryList[cIndex]
                  .subCategories,
            ),
          ),
        );
      }
    } else if (type == 'product') {
      print('product=====> ${id} ');
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ProductDetails(
                    product: Product(slug: slug, id: id),
                    banner: true,
                  )));
    } else if (type == 'brand') {
      if (Provider.of<BrandProvider>(context, listen: false).brandList[bIndex].name != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BrandAndCategoryProductScreen(
              isBrand: true,
              id: id.toString(),
              name: '${Provider.of<BrandProvider>(context, listen: false).brandList[bIndex].name}',
            ),
          ),
        );
      }
    } else if (type == 'shop') {
      if (Provider.of<TopSellerProvider>(context, listen: false).topSellerList[tIndex].name !=
          null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => TopSellerProductScreen(
                      // topSellerId: id.toString(),
                      topSellerId: Provider.of<TopSellerProvider>(context, listen: false)
                          .topSellerList[tIndex]
                          .sellerId,
                      topSeller: Provider.of<TopSellerProvider>(context, listen: false)
                          .topSellerList[tIndex],
                    )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadData(context, false);
    return Column(
      children: [
        Consumer<BannerProvider>(
          builder: (context, bannerProvider, child) {
            double _width = MediaQuery.of(context).size.width;
            return Container(
              width: _width,
              height: _width * 0.5,
              child: bannerProvider.mainBannerList != null
                  ? bannerProvider.mainBannerList.length != 0
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            CarouselSlider.builder(
                              options: CarouselOptions(
                                viewportFraction: .95,
                                autoPlay: true,
                                enlargeCenterPage: true,
                                disableCenter: true,
                                onPageChanged: (index, reason) {
                                  Provider.of<BannerProvider>(context, listen: false)
                                      .setCurrentIndex(index);
                                },
                              ),
                              itemCount: bannerProvider.mainBannerList.length == 0
                                  ? 1
                                  : bannerProvider.mainBannerList.length,
                              itemBuilder: (context, index, _) {
                                return InkWell(
                                  onTap: () {
                                    /*Provider.of<BannerProvider>(context,
                                            listen: false)
                                        .getProductDetails(
                                            context,
                                            bannerProvider.mainBannerList[index]
                                                .resourceId
                                                .toString());
                                    */
                                    if (bannerProvider.mainBannerList[index].product == null) {
                                      return;
                                    }

                                    _clickBannerRedirect(
                                        context,
                                        bannerProvider.mainBannerList[index].resourceType ==
                                                'product'
                                            ? bannerProvider.mainBannerList[index].product.id
                                            : bannerProvider.mainBannerList[index].resourceId,
                                        bannerProvider.mainBannerList[index].resourceType ==
                                                'product'
                                            ? bannerProvider.mainBannerList[index].product.slug
                                            : '',
                                        bannerProvider.mainBannerList[index].resourceType);
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
                                    child: Container(
                                      decoration:
                                          BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: FadeInImage.assetNetwork(
                                          placeholder: Images.placeholder,
                                          fit: BoxFit.fill,
                                          image:
                                              '${Provider.of<SplashProvider>(context, listen: false).baseUrls.bannerImageUrl}'
                                              '/${bannerProvider.mainBannerList[index].photo}',
                                          imageErrorBuilder: (c, o, s) =>
                                              Image.asset(Images.placeholder, fit: BoxFit.cover),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            // Positioned(
                            //   bottom: 5,
                            //   left: 0,
                            //   right: 0,
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     children:
                            //         bannerProvider.mainBannerList.map((banner) {
                            //       int index = bannerProvider.mainBannerList
                            //           .indexOf(banner);
                            //       return TabPageSelectorIndicator(
                            //         backgroundColor:
                            //             index == bannerProvider.currentIndex
                            //                 ? Theme.of(context).primaryColor
                            //                 : Colors.grey,
                            //         borderColor:
                            //             index == bannerProvider.currentIndex
                            //                 ? Theme.of(context).primaryColor
                            //                 : Colors.grey,
                            //         size: 10,
                            //       );
                            //     }).toList(),
                            //   ),
                            // ),
                          ],
                        )
                      : Center(child: Text('No banner available'))
                  : Shimmer.fromColors(
                      baseColor: Colors.grey[300]!!!,
                      highlightColor: Colors.grey[100]!!!,
                      enabled: bannerProvider.mainBannerList == ""
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: ColorResources.WHITE,
                        ),
                      ),
                    ),
            );
          },
        ),
        SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9.0),
          child: Consumer<BannerProvider>(
            builder: (context, footerBannerProvider, child) {
              return footerBannerProvider.footerBannerList != null &&
                      footerBannerProvider.footerBannerList.length != 0
                  ? GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: (2 / 1),
                      ),
                      itemCount: footerBannerProvider.footerBannerList.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            print(footerBannerProvider.footerBannerList[index].resourceId);
                            Provider.of<BannerProvider>(context, listen: false).getProductDetails(
                                context,
                                footerBannerProvider.footerBannerList[index].resourceId.toString());
                            _clickBannerRedirect(
                                context,
                                footerBannerProvider.footerBannerList[index].resourceType ==
                                        'product'
                                    ? footerBannerProvider.footerBannerList[index].product.id
                                    : footerBannerProvider.footerBannerList[index].resourceId,
                                footerBannerProvider.footerBannerList[index].resourceType ==
                                        'product'
                                    ? footerBannerProvider.footerBannerList[index].product.slug
                                    : '',
                                footerBannerProvider.footerBannerList[index].resourceType);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2.0),
                            child: Container(
                              decoration:
                                  BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5))),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                child: FadeInImage.assetNetwork(
                                  placeholder: Images.placeholder,
                                  fit: BoxFit.cover,
                                  image:
                                      '${Provider.of<SplashProvider>(context, listen: false).baseUrls.bannerImageUrl}'
                                      '/${footerBannerProvider.footerBannerList[index].photo}',
                                  imageErrorBuilder: (c, o, s) =>
                                      Image.asset(Images.placeholder, fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : Shimmer.fromColors(
                      baseColor: Colors.grey[300]!!!,
                      highlightColor: Colors.grey[100]!!!,
                      enabled: footerBannerProvider.footerBannerList == ""
                      child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: ColorResources.WHITE,
                          )),
                    );
            },
          ),
        )
      ],
    );
  }
}
