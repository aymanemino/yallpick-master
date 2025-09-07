import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/cart_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/cart_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';

class CartWidget extends StatelessWidget {
  final CartModel cartModel;
  final int index;
  final bool fromCheckout;
  const CartWidget(
      {Key key,
        this.cartModel,
        @required this.index,
        @required this.fromCheckout});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0xFFE9ECEF),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Theme.of(context).highlightColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Color(0xFFE9ECEF),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productThumbnailUrl}/${cartModel.thumbnail}',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  Images.placeholder,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          SizedBox(width: 12),

          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                Text(
                  cartModel.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                    height: 1.2,
                  ),
                ),

                SizedBox(height: 6),

                // Price Row
                Row(
                  children: [
                    _buildPriceWithDecimal(context, cartModel.price),
                    if (cartModel.discount > 0) ...[
                      SizedBox(width: 6),
                      Container(
                        padding:
                        EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Color(0xFFFF6B35).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          PriceConverter.percentageCalculation(
                            context,
                            cartModel.price,
                            cartModel.discount,
                            cartModel.discountType,
                          ),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFF6B35),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                SizedBox(height: 8),

                // Quantity Controls and Remove Button in same row
                Row(
                  children: [
                    // Quantity Controls
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: Color(0xFFE9ECEF),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Decrease Button
                          InkWell(
                            onTap: () {
                              if (cartModel.quantity > 1) {
                                Provider.of<CartProvider>(context,
                                    listen: false)
                                    .updateCartProductQuantity(cartModel.id,
                                    cartModel.quantity - 1, context);
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(6),
                              child: Icon(
                                Icons.remove,
                                size: 16,
                                color: cartModel.quantity > 1
                                    ? Color(0xFFFF6B35)
                                    : Color(0xFFCED4DA),
                              ),
                            ),
                          ),

                          // Quantity Display
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 6),
                            child: Text(
                              '${cartModel.quantity}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1A1A1A),
                              ),
                            ),
                          ),

                          // Increase Button
                          InkWell(
                            onTap: () {
                              Provider.of<CartProvider>(context, listen: false)
                                  .updateCartProductQuantity(cartModel.id,
                                  cartModel.quantity + 1, context);
                            },
                            child: Container(
                              padding: EdgeInsets.all(6),
                              child: Icon(
                                Icons.add,
                                size: 16,
                                color: Color(0xFFFF6B35),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Spacer(),

                    // Remove Button
                    InkWell(
                      onTap: () {
                        if (Provider.of<AuthProvider>(context, listen: false)
                            .isLoggedIn()) {
                          Provider.of<CartProvider>(context, listen: false)
                              .removeFromCartAPI(context, cartModel.id);
                        } else {
                          Provider.of<CartProvider>(context, listen: false)
                              .removeFromCart(index);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Color(0xFFFF4757).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.delete_outline,
                          size: 18,
                          color: Color(0xFFFF4757),
                        ),
                      ),
                    ),
                  ],
                ),

                // International Delivery for seller_id = 1 (user_id = 1)
                if (cartModel.sellerId == 1) ...[
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding:
                        EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.language,
                              color: Colors.white,
                              size: 12,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'International Delivery',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '6-8 Days Delivery',
                        style: TextStyle(
                          color: Colors.grey[600]!!,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceWithDecimal(BuildContext context, double price) {
    String priceString = PriceConverter.convertPrice(context, price);

    // Check if price has decimal part
    if (priceString.contains('.') || priceString.contains(',')) {
      // Find the decimal separator
      int decimalIndex = priceString.indexOf('.');
      if (decimalIndex == -1) decimalIndex = priceString.indexOf(',');

      if (decimalIndex != -1) {
        String wholePart = priceString.substring(0, decimalIndex);
        String decimalPart = priceString.substring(decimalIndex);

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              wholePart,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFFFF6B35),
              ),
            ),
            Text(
              decimalPart,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFFFF6B35),
              ),
            ),
          ],
        );
      }
    }

    // If no decimal part, return normal price
    return Text(
      priceString,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: Color(0xFFFF6B35),
      ),
    );
  }
}
