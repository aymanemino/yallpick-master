import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/cart_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/cart_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/product_details_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/show_custom_snakbar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/guest_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:provider/provider.dart';

class ProductWidget extends StatefulWidget {
  final Product productModel;

  ProductWidget({@required this.productModel});

  @override
  _ProductWidgetState createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isAddingToCart = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true); // Repeats the animation

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addToCart(Product product) async {
    var cartProvider = Provider.of<CartProvider>(context, listen: false);

    // Check if product is already in cart
    bool isInCart = cartProvider.cartList.any((item) => item.id == product.id);

    if (isInCart) {
      showCustomSnackBar('Product already in cart', context);
      return;
    }

    // Check if user is logged in
    if (!Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
      showDialog(context: context, builder: (_) => GuestDialog());
      return;
    }

    // Show loading state
    setState(() {
      _isAddingToCart = true;
    });

    try {
      // Create CartModel with proper parameters
      CartModel cart = CartModel(
        product.id,
        product.thumbnail, // image
        product.name,
        product.addedBy == 'seller' ? 'seller' : 'admin', // seller
        product.unitPrice, // price
        product.unitPrice, // discountedPrice
        1, // quantity
        product.minQty ?? 1, // maxQuantity
        '', // variant
        '', // color
        "" // variation
        product.discount,
        product.discountType,
        product.tax,
        product.taxType,
        1, // shippingMethodId
        '', // cartGroupId
        product.userId, // sellerId
        '', // sellerIs
        product.thumbnail, // thumbnail
        '', // shopInfo
        product.choiceOptions ?? [],
        [], // variationIndexes
      );

      // Add to cart using the API method
      await cartProvider.addToCartAPI(
        cart,
        (success, message) {
          if (success) {
            showCustomSnackBar(getTranslated('added_to_cart', context), context,
                isError: false);
            // Refresh the cart data
            cartProvider.getCartDataAPI(context);
          } else {
            showCustomSnackBar('Failed to add product: $message', context);
          }
        },
        context,
        product.choiceOptions ?? [],
        [],
      );
    } catch (e) {
      showCustomSnackBar('Error adding product to cart: $e', context);
    } finally {
      setState(() {
        _isAddingToCart = false;
      });
    }
  }

  Widget _buildPriceWidget() {
    double price = widget.productModel.unitPrice;
    if (widget.productModel.discount > 0) {
      if (widget.productModel.discountType == 'percent') {
        price = price - (price * widget.productModel.discount / 100);
      } else {
        price = price - widget.productModel.discount;
      }
    }

    String priceString = price.toStringAsFixed(2);
    List<String> parts = priceString.split('.');
    String mainPrice = parts[0];
    String decimalPrice = parts[1];

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          mainPrice,
          style: robotoBold.copyWith(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            height: 1.0,
          ),
        ),
        Text(
          '.$decimalPrice',
          style: robotoBold.copyWith(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            height: 1.0,
          ),
        ),
        SizedBox(width: 2),
        Text(
          'AED',
          style: robotoBold.copyWith(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            height: 1.0,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 200),
            pageBuilder: (context, anim1, anim2) =>
                ProductDetails(product: widget.productModel),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.all(2), // Reduced margin for minimal spacing
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(20), // More rounded for modern look
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.15),
              spreadRadius: 0,
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.orange.withOpacity(0.05),
              spreadRadius: 0,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.orange.withOpacity(0.1), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min, // Use minimum size for the column
          children: [
            // Product Image
            Container(
              height: 190, // Reduced height to minimize space around image
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.orange.withOpacity(0.02),
                    Colors.orange.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Image.network(
                  '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productThumbnailUrl}/${widget.productModel.thumbnail}',
                  fit: BoxFit.contain, // Show full image without cropping
                  width: double.infinity, // Ensure image takes full width
                  height: double.infinity, // Ensure image takes full height
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                      Images.placeholder,
                      fit: BoxFit
                          .contain, // Show full placeholder without cropping
                      width: double.infinity,
                      height: double.infinity),
                ),
              ),
            ),
            Container(
              height: 1,
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.orange.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            // Product Details
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.PADDING_SIZE_SMALL,
                vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Take only the space needed
                children: [
                  Text(
                    widget.productModel.name ?? '',
                    style: robotoRegular.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[900]!!,
                      height: 1.3,
                    ),
                    maxLines: 2, // Allow 2 lines for better readability
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left side: Choice and Free Delivery badges
                      Row(
                        children: [
                          // Choice badge
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6, vertical: 3), // Reduced padding
                            decoration: BoxDecoration(
                              color: Colors.yellow[
                                  400], // Yellow background as requested
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.yellow.withOpacity(0.3),
                                  blurRadius: 3,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Text(
                              getTranslated(
                                  'Choice', context), // Use translation here
                              style: robotoBold.copyWith(
                                color: Colors.black, // Black text as requested
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: 4), // Reduced space
                          // Free Delivery badge
                          FadeTransition(
                            opacity: _animation,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green[50],
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                    color: Colors.green[300], width: 1),
                              ),
                              child: Text(
                                getTranslated('Free_Delivery', context),
                                style: robotoRegular.copyWith(
                                  color: Colors
                                      .green[700], // Green color as requested
                                  fontSize: 8,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Right side: Rating display
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(4),
                          border:
                              Border.all(color: Colors.orange[200], width: 1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.productModel.rating != null
                                  ? widget.productModel.rating.isNotEmpty
                                      ? double.parse(widget
                                              .productModel.rating[0].average)
                                          .toStringAsFixed(1)
                                      : '0.0'
                                  : '0.0',
                              style: robotoRegular.copyWith(
                                color: Colors.orange[700],
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 2),
                            Icon(
                              Icons.star_rounded,
                              color: Colors.orange[600],
                              size: 11,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  // Discount Label with Welcome Deal
                  if (widget.productModel.discount > 0)
                    Row(
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.orange[500], Colors.orange[700]],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.3),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            getTranslated('Welcome_Deal', context),
                            style: robotoBold.copyWith(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                            width:
                                6), // Space between Welcome Deal and Discount
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange[100],
                            borderRadius: BorderRadius.circular(6),
                            border:
                                Border.all(color: Colors.orange[300], width: 1),
                          ),
                          child: Text(
                            PriceConverter.percentageCalculation(
                              context,
                              widget.productModel.unitPrice,
                              widget.productModel.discount,
                              widget.productModel.discountType,
                            ),
                            style: robotoRegular.copyWith(
                              color: Colors.orange[800],
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 10), // Space before Choice Free Delivery
                  // Price with Add to Cart Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price display
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.orange[400], Colors.orange[600]],
                          ),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withOpacity(0.3),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: _buildPriceWidget(),
                      ),
                      // Add to Cart Button in corner
                      GestureDetector(
                        onTap: _isAddingToCart
                            ? null
                            : () => _addToCart(widget.productModel),
                        child: Container(
                          padding: EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: _isAddingToCart
                                  ? [
                                      Colors.orange[400].withOpacity(0.6),
                                      Colors.orange[500].withOpacity(0.6)
                                    ]
                                  : [Colors.orange[500], Colors.orange[700]],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.orange.withOpacity(0.3),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: _isAddingToCart
                              ? SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : Icon(
                                  Icons.add_shopping_cart_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                        ),
                      ),
                    ],
                  ),
                  // International Delivery for user_id = 1
                  if (widget.productModel.userId == 1) ...[
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.green[500], Colors.green[700]],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.3),
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.language_rounded,
                              color: Colors.white,
                              size: 14,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'International Delivery',
                              style: robotoBold.copyWith(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                        height:
                            10), // Bottom spacing only when International Delivery is shown
                  ]
                  // No bottom spacing for products without International Delivery
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
