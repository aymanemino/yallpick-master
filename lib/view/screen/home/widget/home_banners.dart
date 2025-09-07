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

class HomeBanners extends StatelessWidget {
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

  void _clickBannerRedirect(BuildContext context, int id, String slug, String type) {
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
              name: '${Provider.of<CategoryProvider>(context, listen: false).categoryList[cIndex].name}',
              subcategory: Provider.of<CategoryProvider>(context, listen: false)
                  .categoryList[cIndex]
                  .subCategories,
            ),
          ),
        );
      }
    } else if (type == 'product') {
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
      if (Provider.of<TopSellerProvider>(context, listen: false).topSellerList[tIndex].name != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => TopSellerProductScreen(
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

            // Filter the banners with IDs 57, 56, and 58
            List filteredBannerList = bannerProvider.footerBannerList
                .where((banner) => [57, 56, 58].contains(banner.id))
                .toList();

            // Return an empty Container if no banners are available
            if (filteredBannerList.isEmpty) {
              return Container(); // This will prevent any space from being taken up
            }

            // Render the banners if they are available
            return Container(
              width: _width,
              height: _width * 0.25,
              child: Stack(
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
                    itemCount: filteredBannerList.length,
                    itemBuilder: (context, index, _) {
                      return InkWell(
                        onTap: () {
                          if (filteredBannerList[index].product == null) {
                            return;
                          }
                          _clickBannerRedirect(
                            context,
                            filteredBannerList[index].resourceType == 'product'
                                ? filteredBannerList[index].product.id
                                : filteredBannerList[index].resourceId,
                            filteredBannerList[index].resourceType == 'product'
                                ? filteredBannerList[index].product.slug
                                : '',
                            filteredBannerList[index].resourceType,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: FadeInImage.assetNetwork(
                                placeholder: Images.placeholder,
                                fit: BoxFit.fill,
                                image:
                                '${Provider.of<SplashProvider>(context, listen: false).baseUrls.bannerImageUrl}'
                                    '/${filteredBannerList[index].photo}',
                                imageErrorBuilder: (c, o, s) =>
                                    Image.asset(Images.placeholder, fit: BoxFit.cover),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(height: 6),
        // Removed the footer banners section here
      ],
    );
  }
}
