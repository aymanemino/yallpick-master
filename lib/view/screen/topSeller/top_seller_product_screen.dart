import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/top_seller_model.dart';

import 'package:flutter_sixvalley_ecommerce/helper/product_type.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/utill/map_utils.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/animated_custom_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/guest_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/search_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/show_custom_snakbar.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/chat/top_seller_chat_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/home/widget/products_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/more/web_view_screen.dart';
import 'package:provider/provider.dart';

class TopSellerProductScreen extends StatelessWidget {
  final TopSellerModel topSeller;
  final String topSellerId;

  TopSellerProductScreen({@required this.topSeller, this.topSellerId});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      Provider.of<ProductProvider>(context, listen: false).clearSellerData();
      Provider.of<ProductProvider>(context, listen: false)
          .initSellerProductList(topSellerId.toString(), 1, context);
    });
    ScrollController _scrollController = ScrollController();

    return Scaffold(
      backgroundColor: ColorResources.getIconBg(context),
      body: Column(
        children: [
          SearchWidget(
            hintText: 'Search product...',
            onTextChanged: (String newText) =>
                Provider.of<ProductProvider>(context, listen: false)
                    .filterData(newText),
            onClearPressed: () {},
          ),
          Expanded(
            child: ListView(
              controller: _scrollController,
              physics: BouncingScrollPhysics(),
              // padding: EdgeInsets.all(0),
              padding:
              EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
              children: [
                // Banner
                ClipRRect(
                  // borderRadius: BorderRadius.circular(10),
                  child: FadeInImage.assetNetwork(
                    placeholder: Images.placeholder,
                    height: 120,
                    fit: BoxFit.cover,
                    image:
                        '${Provider.of<SplashProvider>(context, listen: false).baseUrls.shopImageUrl}/banner/${topSeller.banner != null ? topSeller.banner : ''}',
                    imageErrorBuilder: (c, o, s) => Image.asset(
                        Images.placeholder,
                        height: 120,
                        fit: BoxFit.cover),
                  ),
                ),

                Container(
                  color: Theme.of(context).highlightColor,
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: Column(children: [
                    // Seller Info
                    Row(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(40),
                        child: FadeInImage.assetNetwork(
                          placeholder: Images.placeholder,
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                          image:
                              '${Provider.of<SplashProvider>(context, listen: false).baseUrls.shopImageUrl}/${topSeller.image}',
                          imageErrorBuilder: (c, o, s) => Image.asset(
                              Images.placeholder,
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover),
                        ),
                      ),
                      SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                      Expanded(
                        child: Text(
                          topSeller.name,
                          style: titilliumSemiBold.copyWith(
                              fontSize: Dimensions.FONT_SIZE_LARGE),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      topSeller != null && topSeller.showMetaverseLink == '1'
                          ? IconButton(
                              constraints: BoxConstraints(),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => WebViewScreen(
                                              url: topSeller.metaverseLink,
                                              title: 'Metaverse',
                                            )));
                              },
                              icon: Image.asset(Images.metaverse,
                                  color: ColorResources.SELLER_TXT,
                                  height: Dimensions.ICON_SIZE_DEFAULT),
                            )
                          : SizedBox(),
                      topSeller != null &&
                              topSeller.latitude != null &&
                              topSeller.longitude != null &&
                              topSeller.seller.location == "1"
                          ? IconButton(
                              constraints: BoxConstraints(),
                              onPressed: () {
                                if (topSeller.longitude == null ||
                                    topSeller.longitude == null) {
                                  showCustomSnackBar(
                                      'Location not available', context);
                                  return;
                                }
                                MapUtils.openMap(
                                    double.parse(topSeller.latitude),
                                    double.parse(topSeller.longitude));
                              },
                              icon: Image.asset(Images.map_marker,
                                  color: ColorResources.SELLER_TXT,
                                  height: Dimensions.ICON_SIZE_DEFAULT),
                            )
                          : SizedBox(),
                      IconButton(
                        onPressed: () {
                          if (!Provider.of<AuthProvider>(context, listen: false)
                              .isLoggedIn()) {
                            showAnimatedDialog(context, GuestDialog(),
                                isFlip: true);
                          } else if (topSeller != null) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => TopSellerChatScreen(
                                        topSeller: topSeller)));
                          }
                        },
                        icon: Image.asset(Images.chat_image,
                            color: ColorResources.SELLER_TXT,
                            height: Dimensions.ICON_SIZE_DEFAULT),
                      ),
                    ]),
                  ]),
                ),
                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  child: ProductView(
                      isHomePage: false,
                      productType: ProductType.SELLER_PRODUCT,
                      scrollController: _scrollController,
                      sellerId: topSeller.id.toString()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
