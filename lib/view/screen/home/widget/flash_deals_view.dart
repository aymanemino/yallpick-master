import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/provider/flash_deal_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/product_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:shimmer/shimmer.dart';

class FlashDealsView extends StatelessWidget {
  final bool isHomeScreen;
  FlashDealsView({this.isHomeScreen = true});

  @override
  Widget build(BuildContext context) {
    return Consumer<FlashDealProvider>(
      builder: (context, megaProvider, child) {
        return megaProvider.flashDealList.isNotEmpty
            ? ListView.builder(
          padding: EdgeInsets.all(0),
          scrollDirection: isHomeScreen ? Axis.horizontal : Axis.vertical,
          itemCount: megaProvider.flashDealList.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 1000),
                    pageBuilder: (context, anim1, anim2) =>
                        ProductDetails(product: megaProvider.flashDealList[index]),
                  ),
                );
              },
              child: Container(
                margin: EdgeInsets.all(5),
                width: isHomeScreen ? 300 : null,
                height: 180, // Adjusted height for the new labels
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).highlightColor,
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 5)
                  ],
                ),
                child: Stack(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Product image
                        Expanded(
                          flex: 5, // Increased flex value to make the image larger
                          child: Container(
                            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                            decoration: BoxDecoration(
                              color: ColorResources.getIconBg(context),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                            child: FadeInImage.assetNetwork(
                              placeholder: Images.placeholder,
                              fit: BoxFit.cover, // Changed to BoxFit.cover to fill the container
                              image:
                              '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productThumbnailUrl}/${megaProvider.flashDealList[index].thumbnail}',
                              imageErrorBuilder: (c, o, s) =>
                                  Image.asset(Images.placeholder, fit: BoxFit.cover), // Changed to BoxFit.cover
                            ),
                          ),
                        ),

                        // Product details
                        Expanded(
                          flex: 6,
                          child: Padding(
                            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  megaProvider.flashDealList[index].name,
                                  style: robotoRegular,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                Row(
                                  children: [
                                    Text(
                                      PriceConverter.convertPrice(
                                        context,
                                        megaProvider.flashDealList[index].unitPrice,
                                        discountType: megaProvider.flashDealList[index].discountType,
                                        discount: megaProvider.flashDealList[index].discount,
                                      ),
                                      style: robotoBold.copyWith(color: ColorResources.getPrimary(context)),
                                    ),
                                    SizedBox(width: 25), // Space between price and rating
                                    Text(
                                      megaProvider.flashDealList[index].rating.length != 0
                                          ? double.parse(megaProvider.flashDealList[index].rating[0].average)
                                          .toStringAsFixed(1)
                                          : '0.0',
                                      style: robotoRegular.copyWith(
                                        color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.white : Colors.orange,
                                        fontSize: Dimensions.FONT_SIZE_SMALL,
                                      ),
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: Provider.of<ThemeProvider>(context).darkTheme ? Colors.white : Colors.orange,
                                      size: 15,
                                    ),
                                  ],
                                ),
                                SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                // Discount and Welcome Deal labels
                                if (megaProvider.flashDealList[index].discount > 0)
                                  Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          getTranslated('Welcome_Deal', context),
                                          style: robotoBold.copyWith(color: Colors.white, fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL),
                                        ),
                                      ),
                                      SizedBox(width: 2),
                                      Text(
                                        PriceConverter.percentageCalculation(
                                          context,
                                          megaProvider.flashDealList[index].unitPrice,
                                          megaProvider.flashDealList[index].discount,
                                          megaProvider.flashDealList[index].discountType,
                                        ),
                                        style: robotoRegular.copyWith(color: Colors.red, fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL),
                                      ),
                                    ],
                                  ),
                                SizedBox(height: 10),
                                // Choice and Free Delivery labels
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.yellow,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        getTranslated('Choice', context),
                                        style: robotoBold.copyWith(color: Colors.black, fontSize: Dimensions.FONT_SIZE_SMALL),
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      getTranslated('Free_Delivery', context),
                                      style: robotoRegular.copyWith(color: Colors.green, fontSize: Dimensions.FONT_SIZE_SMALL),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        )
            : MegaDealShimmer(isHomeScreen: isHomeScreen);
      },
    );
  }
}

class MegaDealShimmer extends StatelessWidget {
  final bool isHomeScreen;
  MegaDealShimmer({@required this.isHomeScreen});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: isHomeScreen ? Axis.horizontal : Axis.vertical,
      itemCount: 2,
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.all(5),
          width: 300,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorResources.WHITE,
              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 1, blurRadius: 5)]),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            enabled: Provider.of<FlashDealProvider>(context).flashDealList.isEmpty,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                    decoration: BoxDecoration(
                      color: ColorResources.ICON_BG,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
                    ),
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 20, color: ColorResources.WHITE),
                        SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                        Row(children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(height: 20, width: 50, color: ColorResources.WHITE),
                              ],
                            ),
                          ),
                          Container(height: 10, width: 50, color: ColorResources.WHITE),
                          Icon(Icons.star, color: Colors.orange, size: 15),
                        ]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
