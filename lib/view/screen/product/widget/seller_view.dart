import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/seller_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/utill/map_utils.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/animated_custom_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/guest_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/show_custom_snakbar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/title_row.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/chat/chat_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/seller/seller_screen.dart';
import 'package:provider/provider.dart';

import '../../more/web_view_screen.dart';

class SellerView extends StatelessWidget {
  final String sellerId;
  SellerView({@required this.sellerId});

  @override
  Widget build(BuildContext context) {
    Provider.of<SellerProvider>(context, listen: false)
        .initSeller(sellerId, context);

    return Consumer<SellerProvider>(
      builder: (context, seller, child) {
        return Container(
          margin: EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
          color: Theme.of(context).cardColor,
          child: Column(children: [
            TitleRow(
                title: getTranslated('seller', context), isDetailsPage: true),
            Row(children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                SellerScreen(seller: seller.sellerModel)));
                  },
                  child: Text(
                    seller.sellerModel != null
                        ? '${seller.sellerModel.shop.name ?? ''}'
                        : '',
                    style: titilliumSemiBold.copyWith(
                        fontSize: Dimensions.FONT_SIZE_LARGE,
                        color: ColorResources.SELLER_TXT),
                  ),
                ),
              ),
              if(seller.sellerModel!=null)
              seller.sellerModel.shop != null &&
                      seller.sellerModel.shop.showMetaverseLink != null &&
                      seller.sellerModel.shop.showMetaverseLink == '1'
                  ? IconButton(
                      constraints: BoxConstraints(),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => WebViewScreen(
                                      url:
                                          seller.sellerModel.shop.metaverseLink,
                                      title: 'Metaverse',
                                    )));
                      },
                      icon: Image.asset(Images.metaverse,
                          color: ColorResources.SELLER_TXT,
                          height: Dimensions.ICON_SIZE_DEFAULT),
                    )
                  : SizedBox(),
              if(seller.sellerModel!=null)
                seller.sellerModel.shop != null &&
                      seller.sellerModel.location == "1"
                  ? IconButton(
                      constraints: BoxConstraints(),
                      onPressed: () {
                        if (seller.sellerModel.shop.latitude == null ||
                            seller.sellerModel.shop.longitude == null) {
                          showCustomSnackBar('Location not available', context);
                          return;
                        }
                        MapUtils.openMap(
                            double.parse(seller.sellerModel.shop.latitude),
                            double.parse(seller.sellerModel.shop.longitude));
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
                    showAnimatedDialog(context, GuestDialog(), isFlip: true);
                  } else if (seller.sellerModel != null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                ChatScreen(seller: seller.sellerModel)));
                  }
                },
                icon: Image.asset(Images.chat_image,
                    color: ColorResources.SELLER_TXT,
                    height: Dimensions.ICON_SIZE_DEFAULT),
              ),
            ]),
          ]),
        );
      },
    );
  }
}
