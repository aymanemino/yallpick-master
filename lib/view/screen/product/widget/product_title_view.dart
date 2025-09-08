import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_details_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/wishlist_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/rating_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/show_custom_snakbar.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/cart_bottom_sheet.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/guest_dialog.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class ProductTitleView extends StatelessWidget {
  final Product productModel;
  ProductTitleView({required this.productModel});

  @override
  Widget build(BuildContext context) {
    double _startingPrice = 0;
    double _endingPrice = 0.0;
    if (productModel.variation != null && productModel.variation.length != 0) {
      List<double> _priceList = [];
      productModel.variation
          .forEach((variation) => _priceList.add(variation.price));
      _priceList.sort((a, b) => a.compareTo(b));
      _startingPrice = _priceList[0];
      if (_priceList[0] < _priceList[_priceList.length - 1]) {
        _endingPrice = _priceList[_priceList.length - 1];
      }
    } else {
      _startingPrice = productModel.unitPrice;
    }

    return Container(
      color: Theme.of(context).highlightColor,
      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
      margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
      child: Consumer<ProductDetailsProvider>(
        builder: (context, details, child) {
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  _buildPriceDisplay(
                    context,
                    _startingPrice != null
                        ? PriceConverter.convertPrice(context, _startingPrice,
                        discount: productModel.discount == null
                            ? 0
                            : productModel.discount,
                        discountType: productModel.discountType)
                        : '',
                    _endingPrice != null
                        ? PriceConverter.convertPrice(context, _endingPrice,
                        discount: productModel.discount == null
                            ? 0
                            : productModel.discount,
                        discountType: productModel.discountType)
                        : '',
                  ),
                  SizedBox(width: 20),
                  (productModel.discount == null ? 0 : productModel.discount) >
                      0
                      ? Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 3), // Add padding for larger numbers
                    height: 20, // Increase height
                    decoration: BoxDecoration(
                      color: Colors.red, // Set background color to red
                      borderRadius: BorderRadius.circular(50),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      PriceConverter.percentageCalculation(
                          context,
                          productModel.unitPrice,
                          productModel.discount == null
                              ? 0
                              : productModel.discount,
                          productModel.discountType),
                      style: titilliumRegular.copyWith(
                        color: Colors.white, // Set text color to white
                        fontSize: 10, // Adjust font size as needed
                      ),
                    ),
                  )
                      : SizedBox.shrink(),
                  Expanded(child: SizedBox.shrink()),
                  InkWell(
                    onTap: () {
                      if (Provider.of<ProductDetailsProvider>(context,
                          listen: false)
                          .sharableLink !=
                          null) {
                        Share.share(Provider.of<ProductDetailsProvider>(context,
                            listen: false)
                            .sharableLink);
                      }
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Theme.of(context).highlightColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[
                            Provider.of<ThemeProvider>(context).darkTheme
                                ? 700
                                : 200]!,
                            spreadRadius: 1,
                            blurRadius: 5,
                          )
                        ],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.share,
                        color: ColorResources.getPrimary(context),
                        size: Dimensions.ICON_SIZE_SMALL,
                      ),
                    ),
                  ),
                ]),

                (productModel.discount == null ? 0 : productModel.discount) > 0
                    ? Text(
                  '${PriceConverter.convertPrice(context, _startingPrice)}'
                      '${_endingPrice != null ? ' - ${PriceConverter.convertPrice(context, _endingPrice)}' : ''}',
                  style: titilliumRegular.copyWith(
                      color: Theme.of(context).hintColor,
                      decoration: TextDecoration.lineThrough),
                )
                    : SizedBox(),
                Text(productModel.name ?? '',
                    style: titilliumSemiBold.copyWith(
                        fontSize: Dimensions.FONT_SIZE_LARGE),
                    maxLines: 4),

                // Action Buttons Row - Add to Cart and Wishlist
                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                Row(
                  children: [
                    // Add to Cart Button
                    Expanded(
                      child: Container(
                        height: 65,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              ColorResources.getPrimary(context),
                              ColorResources.getPrimary(context)
                                  .withOpacity(0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: ColorResources.getPrimary(context)
                                  .withOpacity(0.3),
                              offset: Offset(0, 8),
                              blurRadius: 20,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (con) => CartBottomSheet(
                                    product: productModel,
                                    callback: () {
                                      showCustomSnackBar(
                                          getTranslated(
                                              'added_to_cart', context),
                                          context,
                                          isError: false);
                                    },
                                  ));
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.shopping_cart_rounded,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Text(
                                    getTranslated('add_to_cart', context),
                                    style: titilliumSemiBold.copyWith(
                                      color: Colors.white,
                                      fontSize: Dimensions.FONT_SIZE_LARGE,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 16),

                    // Wishlist Button
                    Container(
                      height: 65,
                      width: 65,
                      decoration: BoxDecoration(
                        color: Theme.of(context).highlightColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: ColorResources.getPrimary(context)
                              .withOpacity(0.3),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            offset: Offset(0, 4),
                            blurRadius: 15,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: Consumer<WishListProvider>(
                          builder: (context, wishListProvider, child) {
                            bool isGuestMode = !Provider.of<AuthProvider>(
                                context,
                                listen: false)
                                .isLoggedIn();

                            return InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                if (isGuestMode) {
                                  showDialog(
                                      context: context,
                                      builder: (_) => GuestDialog());
                                } else {
                                  wishListProvider.isWish
                                      ? wishListProvider
                                      .removeWishList(productModel.id ?? 0,
                                      feedbackMessage: (message) {
                                        if (message != '') {
                                          showCustomSnackBar(message, context,
                                              isError: false);
                                        }
                                      })
                                      : wishListProvider
                                      .addWishList(productModel.id ?? 0,
                                      feedbackMessage: (message) {
                                        if (message != '') {
                                          showCustomSnackBar(message, context,
                                              isError: false);
                                        }
                                      });
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: wishListProvider.isWish
                                      ? Colors.red.withOpacity(0.1)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  wishListProvider.isWish
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  color: wishListProvider.isWish
                                      ? Colors.red
                                      : ColorResources.getPrimary(context),
                                  size: 28,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),

                // Row(children: [
                //   Text(
                //       productModel.rating != null
                //           ? productModel.rating.length > 0
                //               ? double.parse(productModel.rating[0].average)
                //                   .toStringAsFixed(1)
                //               : '0.0'
                //           : '0.0',
                //       style: titilliumSemiBold.copyWith(
                //         color: Theme.of(context).hintColor,
                //         fontSize: Dimensions.FONT_SIZE_LARGE,
                //       )),
                //   SizedBox(width: 5),
                //   RatingBar(
                //       rating: productModel.rating != null
                //           ? productModel.rating.length > 0
                //               ? double.parse(productModel.rating[0].average)
                //               : 0.0
                //           : 0.0),
                //   Expanded(child: SizedBox.shrink()),
                //   Text(
                //       '${details.reviewList != null ? details.reviewList.length : 0} ' +
                //           getTranslated('reviews', context) +
                //           ' | ',
                //       style: titilliumRegular.copyWith(
                //         color: Theme.of(context).hintColor,
                //         fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                //       )),
                //   Text(
                //       '${details.orderCount} ' +
                //           getTranslated('orders', context) +
                //           ' | ',
                //       style: titilliumRegular.copyWith(
                //         color: Theme.of(context).hintColor,
                //         fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                //       )),
                //   Text('${details.wishCount} ' + getTranslated('wish', context),
                //       style: titilliumRegular.copyWith(
                //         color: Theme.of(context).hintColor,
                //         fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                //       )),
                // ]),
              ]);
        },
      ),
    );
  }

  Widget _buildPriceDisplay(
      BuildContext context, String startingPrice, String endingPrice) {
    if (startingPrice.isEmpty) return SizedBox.shrink();

    return RichText(
      text: TextSpan(
        children: [
          if (endingPrice.isNotEmpty && startingPrice != endingPrice) ...[
            // Starting price
            ..._buildPriceSpans(context, startingPrice),
            TextSpan(
              text: ' - ',
              style: titilliumBold.copyWith(
                color: ColorResources.getPrimary(context),
                fontSize: Dimensions.FONT_SIZE_LARGE,
              ),
            ),
            // Ending price
            ..._buildPriceSpans(context, endingPrice),
          ] else ...[
            // Single price
            ..._buildPriceSpans(context, startingPrice),
          ],
        ],
      ),
    );
  }

  List<InlineSpan> _buildPriceSpans(BuildContext context, String price) {
    if (price.isEmpty) return [];

    // Split price into parts (e.g., "1,045.00AED" -> ["1,045", ".", "00", "AED"])
    List<String> parts = [];
    String currentPart = '';
    bool isDecimal = false;

    for (int i = 0; i < price.length; i++) {
      String char = price[i];

      if (char == '.') {
        if (currentPart.isNotEmpty) {
          parts.add(currentPart);
          currentPart = '';
        }
        parts.add('.');
        isDecimal = true;
      } else if (isDecimal && RegExp(r'[0-9]').hasMatch(char)) {
        currentPart += char;
      } else if (RegExp(r'[0-9]').hasMatch(char) || char == ',') {
        currentPart += char;
      } else {
        // Currency or other text
        if (currentPart.isNotEmpty) {
          parts.add(currentPart);
          currentPart = '';
        }
        currentPart += char;
      }
    }

    if (currentPart.isNotEmpty) {
      parts.add(currentPart);
    }

    List<InlineSpan> spans = [];
    for (int i = 0; i < parts.length; i++) {
      String part = parts[i];

      if (part == '.') {
        // Check if the next part is a decimal number
        bool hasDecimalAfter =
            i + 1 < parts.length && RegExp(r'^[0-9]+$').hasMatch(parts[i + 1]);

        if (hasDecimalAfter) {
          // Group the dot and decimal numbers together in a WidgetSpan
          String decimalPart = parts[i + 1];
          spans.add(WidgetSpan(
            child: Transform.translate(
              offset: Offset(0, -8), // Move up by 8 pixels
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '.',
                      style: titilliumRegular.copyWith(
                        color: ColorResources.getPrimary(context),
                        fontSize:
                        Dimensions.FONT_SIZE_LARGE + 4, // Make dot bigger
                      ),
                    ),
                    TextSpan(
                      text: decimalPart,
                      style: titilliumRegular.copyWith(
                        color: ColorResources.getPrimary(context),
                        fontSize: Dimensions
                            .FONT_SIZE_SMALL, // Keep decimal numbers small
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ));
          // Skip the next part since we've already included it
          i++;
        } else {
          // Just a dot without decimal numbers
          spans.add(TextSpan(
            text: '.',
            style: titilliumBold.copyWith(
              color: ColorResources.getPrimary(context),
              fontSize: Dimensions.FONT_SIZE_LARGE,
            ),
          ));
        }
      } else if (RegExp(r'^[0-9,]+$').hasMatch(part)) {
        // Check if this is a decimal part (after the dot)
        bool isDecimalPart = i > 0 && parts[i - 1] == '.';

        if (!isDecimalPart) {
          // Only add if it's not already handled with the dot
          spans.add(TextSpan(
            text: part,
            style: titilliumBold.copyWith(
              color: ColorResources.getPrimary(context),
              fontSize:
              Dimensions.FONT_SIZE_LARGE + 4, // Make whole numbers bigger
            ),
          ));
        }
      } else {
        // Currency or other text
        spans.add(TextSpan(
          text: part,
          style: titilliumBold.copyWith(
            color: ColorResources.getPrimary(context),
            fontSize: Dimensions.FONT_SIZE_LARGE,
          ),
        ));
      }
    }

    return spans;
  }
}
