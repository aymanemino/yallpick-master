import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/cart_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/response_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/cart_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/animated_custom_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/guest_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/no_internet_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/show_custom_snakbar.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/cart/widget/cart_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/checkout/checkout_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/checkout/widget/shipping_method_bottom_sheet.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/dashboard/dashboard_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/cart/widget/recommended_products_widget.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  final bool fromCheckout;
  final int sellerId;
  CartScreen({this.fromCheckout = false, this.sellerId = 1});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final GlobalKey _recommendedProductsKey = GlobalKey();

  @override
  void initState() {
    if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
      // Clear shipping method selection when entering cart
      Provider.of<CartProvider>(context, listen: false)
          .clearShippingMethodSelection();

      Provider.of<CartProvider>(context, listen: false).getCartDataAPI(context);
      Provider.of<CartProvider>(context, listen: false).setCartData();

      if (Provider.of<SplashProvider>(context, listen: false)
          .configModel
          .shippingMethod !=
          'sellerwise_shipping') {
        // Get admin shipping methods without loading chosen methods
        Provider.of<CartProvider>(context, listen: false)
            .getAdminShippingMethodListWithoutChosen(context);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, cart, child) {
      double amount = 0.0;
      double shippingAmount = 0.0;
      double discount = 0.0;
      double tax = 0.0;
      List<CartModel> cartList = [];
      cartList.addAll(cart.cartList);

      List<String> sellerList = [];
      List<CartModel> sellerGroupList = [];
      List<List<CartModel>> cartProductList = [];
      List<List<int>> cartProductIndexList = [];
      cartList.forEach((cart) {
        if (!sellerList.contains(cart.cartGroupId)) {
          sellerList.add(cart.cartGroupId);
          sellerGroupList.add(cart);
        }
      });

      sellerList.forEach((seller) {
        List<CartModel> cartLists = [];
        List<int> indexList = [];
        cartList.forEach((cart) {
          if (seller == cart.cartGroupId) {
            cartLists.add(cart);
            indexList.add(cartList.indexOf(cart));
          }
        });
        cartProductList.add(cartLists);
        cartProductIndexList.add(indexList);
      });

      if (cart.getData &&
          Provider.of<AuthProvider>(context, listen: false).isLoggedIn() &&
          Provider.of<SplashProvider>(context, listen: false)
              .configModel
              .shippingMethod ==
              'sellerwise_shipping') {
        // Get sellerwise shipping methods without loading chosen methods
        Provider.of<CartProvider>(context, listen: false)
            .getShippingMethodWithoutChosen(context, cartProductList);
      }

      for (int i = 0; i < cart.cartList.length; i++) {
        amount += (cart.cartList[i].price - cart.cartList[i].discount) *
            cart.cartList[i].quantity;
        discount += cart.cartList[i].discount * cart.cartList[i].quantity;
        tax += cart.cartList[i].tax * cart.cartList[i].quantity;
      }
      for (int i = 0; i < cart.chosenShippingList.length; i++) {
        shippingAmount += cart.chosenShippingList[i].shippingCost;
      }

      return Scaffold(
        backgroundColor: Color(0xFFF8F9FA),
        appBar: CustomAppBar(
          title: getTranslated('CART', context),
        ),
        body: sellerList.length != 0
            ? RefreshIndicator(
          onRefresh: () async {
            if (Provider.of<AuthProvider>(context, listen: false)
                .isLoggedIn()) {
              await Provider.of<CartProvider>(context, listen: false)
                  .getCartDataAPI(context);

              // Refresh recommended products with new random products
              if (_recommendedProductsKey.currentState != null) {
                RecommendedProductsWidget.refreshRecommendations(context);
              }
            }
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Cart Items
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: sellerList.length,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 20,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Seller Info
                          if (sellerGroupList[index].shopInfo.isNotEmpty)
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Color(0xFFF8F9FA),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.store_outlined,
                                    color: Color(0xFFFF6B35),
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      sellerGroupList[index].shopInfo,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1A1A1A),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          // Cart Items
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.all(0),
                            itemCount: cartProductList[index].length,
                            itemBuilder: (context, i) => CartWidget(
                              cartModel: cartProductList[index][i],
                              index: cartProductIndexList[index][i],
                              fromCheckout: widget.fromCheckout,
                            ),
                          ),

                          // Shipping Method
                          if (Provider.of<SplashProvider>(context,
                              listen: false)
                              .configModel
                              .shippingMethod ==
                              'sellerwise_shipping')
                            Container(
                              margin: EdgeInsets.all(16),
                              child: InkWell(
                                onTap: () {
                                  if (Provider.of<AuthProvider>(context,
                                      listen: false)
                                      .isLoggedIn()) {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) =>
                                          ShippingMethodBottomSheet(
                                            groupId: sellerGroupList[index]
                                                .cartGroupId,
                                            sellerIndex: index,
                                            sellerId:
                                            sellerGroupList[index].id ?? 0,
                                          ),
                                    );
                                  } else {
                                    showCustomSnackBar(
                                        'not_logged_in', context);
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF8F9FA),
                                    borderRadius:
                                    BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Color(0xFFE9ECEF),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.local_shipping_outlined,
                                            color: Color(0xFFFF6B35),
                                            size: 20,
                                          ),
                                          SizedBox(width: 12),
                                          Text(
                                            getTranslated(
                                                'SHIPPING_PARTNER',
                                                context),
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF1A1A1A),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            (cart.shippingList ==
                                                null ||
                                                cart.shippingList
                                                    .length <=
                                                    index ||
                                                cart.shippingList[index] ==
                                                    null ||
                                                cart
                                                    .shippingList[
                                                index]
                                                    .shippingMethodList ==
                                                    null ||
                                                cart.chosenShippingList
                                                    .length ==
                                                    0 ||
                                                cart
                                                    .shippingList[
                                                index]
                                                    .shippingIndex ==
                                                    -1 ||
                                                cart
                                                    .shippingList[
                                                index]
                                                    .shippingIndex >=
                                                    cart
                                                        .shippingList[
                                                    index]
                                                        .shippingMethodList
                                                        .length)
                                                ? 'Select'
                                                : '${cart.shippingList[index].shippingMethodList[cart.shippingList[index].shippingIndex].title.toString()}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFFFF6B35),
                                            ),
                                            maxLines: 1,
                                            overflow:
                                            TextOverflow.ellipsis,
                                          ),
                                          SizedBox(width: 8),
                                          Icon(
                                            Icons.keyboard_arrow_down,
                                            color: Color(0xFFFF6B35),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),

                // Global Shipping Method
                if (Provider.of<SplashProvider>(context, listen: false)
                    .configModel
                    .shippingMethod !=
                    'sellerwise_shipping')
                  Container(
                    margin: EdgeInsets.all(16),
                    child: InkWell(
                      onTap: () {
                        if (Provider.of<AuthProvider>(context,
                            listen: false)
                            .isLoggedIn()) {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) =>
                                ShippingMethodBottomSheet(
                                  groupId: 'all_cart_group',
                                  sellerIndex: 0,
                                  sellerId: 1,
                                ),
                          );
                        } else {
                          showCustomSnackBar('not_logged_in', context);
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Color(0xFFE9ECEF),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 20,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.local_shipping_outlined,
                                  color: Color(0xFFFF6B35),
                                  size: 20,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  getTranslated(
                                      'SHIPPING_PARTNER', context),
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF1A1A1A),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  (cart.shippingList == null ||
                                      cart.shippingList.length == 0 ||
                                      cart.shippingList[0] == null ||
                                      cart.chosenShippingList
                                          .length ==
                                          0 ||
                                      cart.shippingList[0]
                                          .shippingMethodList ==
                                          null ||
                                      cart.shippingList[0]
                                          .shippingIndex ==
                                          -1 ||
                                      cart.shippingList[0]
                                          .shippingIndex >=
                                          cart
                                              .shippingList[0]
                                              .shippingMethodList
                                              .length)
                                      ? 'Select'
                                      : '${cart.shippingList[0].shippingMethodList[cart.shippingList[0].shippingIndex].title.toString()}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFFFF6B35),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(width: 8),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Color(0xFFFF6B35),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // Recommended Products Section (show even when cart is empty)
                RecommendedProductsWidget(key: _recommendedProductsKey),

                // Add some bottom padding to prevent overflow
                SizedBox(height: 100),
              ],
            ),
          ),
        )
            : Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.6,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 80,
                  color: Color(0xFF6C757D),
                ),
                SizedBox(height: 16),
                Text(
                  'Your cart is empty',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Add some products to get started',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF6C757D),
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) =>
                            DashBoardScreen(initialPageIndex: 0),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF6B35),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.shopping_bag, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Start Shopping',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Checkout Button and Bottom Navigation Bar
        bottomNavigationBar: (!widget.fromCheckout)
            ? Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 0,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Checkout Button (only show when cart has items)
                if (cart.cartList.isNotEmpty)
                  Container(
                    height: 80,
                    padding: EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Total Amount',
                                style: TextStyle(
                                  color: Color(0xFF6C757D),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 2),
                              _buildTotalPriceWithDecimal(
                                  context, amount + shippingAmount),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (Provider.of<AuthProvider>(context,
                                    listen: false)
                                    .isLoggedIn()) {
                                  if (cart.cartList.length == 0) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(getTranslated(
                                          'select_at_least_one_product',
                                          context)),
                                      backgroundColor: Colors.red,
                                    ));
                                  } else if (cart.chosenShippingList ==
                                      null ||
                                      cart.chosenShippingList.length ==
                                          0) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(getTranslated(
                                          'select_shipping_method',
                                          context)),
                                      backgroundColor: Colors.red,
                                    ));
                                  } else if (cart
                                      .chosenShippingList.length <
                                      cartProductList.length &&
                                      Provider.of<SplashProvider>(context,
                                          listen: false)
                                          .configModel
                                          .shippingMethod ==
                                          'sellerwise_shipping') {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(getTranslated(
                                          'select_all_shipping_method',
                                          context)),
                                      backgroundColor: Colors.red,
                                    ));
                                  } else {
                                    // Check minimum order amount for JD products (sellerId = 1)
                                    bool hasJdProducts = false;
                                    double jdProductsTotal = 0.0;

                                    // Check if cart has JD products and calculate their total
                                    for (var cartItem in cartList) {
                                      if (cartItem.sellerId == 1) {
                                        hasJdProducts = true;
                                        double price =
                                            cartItem.discountedPrice ??
                                                cartItem.price ??
                                                0.0;
                                        int quantity =
                                            cartItem.quantity ?? 1;
                                        jdProductsTotal +=
                                        (price * quantity);
                                      }
                                    }

                                    // If cart has JD products, get minimum order amount from API and check requirement
                                    if (hasJdProducts) {
                                      double minimumOrderAmount =
                                      await Provider.of<CartProvider>(
                                          context,
                                          listen: false)
                                          .getJdMinimumOrderAmount();

                                      // Calculate total amount including shipping
                                      double totalAmount =
                                          amount + shippingAmount;

                                      if (totalAmount <
                                          minimumOrderAmount) {
                                        double remainingAmount =
                                            minimumOrderAmount -
                                                totalAmount;
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              "You have international delivery items in your cart. Minimum order amount for international products is ${minimumOrderAmount.toStringAsFixed(0)} AED. You need to add ${remainingAmount.toStringAsFixed(0)} AED more to proceed."),
                                          backgroundColor: Colors.red,
                                          duration: Duration(seconds: 5),
                                        ));
                                        return;
                                      }
                                    }

                                    // If validation passes, proceed to checkout
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => CheckoutScreen(
                                          cartList: cartList,
                                          totalOrderAmount:
                                          amount + shippingAmount,
                                          shippingFee: shippingAmount,
                                          discount: discount,
                                          tax: tax,
                                        ),
                                      ),
                                    );
                                  }
                                } else {
                                  showAnimatedDialog(
                                      context, GuestDialog(),
                                      isFlip: true);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFFF6B35),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.shopping_cart_checkout,
                                      size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    getTranslated('checkout', context),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                // Bottom Navigation Bar
                Container(
                  height: 70,
                  padding:
                  EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavItem(
                        icon: Icons.home_rounded,
                        label: getTranslated('home', context) ?? 'Home',
                        isSelected: false,
                        onTap: () => _navigateToPage(0),
                      ),
                      _buildNavItem(
                        icon: Icons.apps_rounded,
                        label: getTranslated('CATEGORY', context) ??
                            'Category',
                        isSelected: false,
                        onTap: () => _navigateToPage(1),
                      ),
                      _buildCartItem(),
                      _buildNavItem(
                        icon: Icons.receipt_long_rounded,
                        label:
                        getTranslated('orders', context) ?? 'Orders',
                        isSelected: false,
                        onTap: () => _navigateToPage(3),
                      ),
                      _buildNavItem(
                        icon: Icons.account_circle_rounded,
                        label: getTranslated('PROFILE', context) ??
                            'Profile',
                        isSelected: false,
                        onTap: () => _navigateToPage(4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
            : ""
      );
    });
  }

  Widget _buildNavItem({
    IconData icon,
    String label,
    bool isSelected = false,
    VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 28,
              color: isSelected ? Color(0xFFFF6B35) : Colors.black87,
            ),
            SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: isSelected ? Color(0xFFFF6B35) : Colors.black87,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItem() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  Icons.shopping_cart_rounded,
                  size: 28,
                  color: Color(0xFFFF6B35),
                ),
                Positioned(
                  top: -8,
                  right: -8,
                  child: Consumer<CartProvider>(
                    builder: (context, cart, child) {
                      if (cart.cartList.isEmpty) return SizedBox.shrink();
                      return Container(
                        padding:
                        EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          cart.cartList.length.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 3),
            Text(
              getTranslated('CART', context) ?? 'Cart',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: Color(0xFFFF6B35),
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalPriceWithDecimal(BuildContext context, double price) {
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
                color: Color(0xFF1A1A1A),
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              decimalPart,
              style: TextStyle(
                color: Color(0xFF1A1A1A),
                fontSize: 14,
                fontWeight: FontWeight.w600,
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
        color: Color(0xFF1A1A1A),
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  void _navigateToPage(int pageIndex) {
    if (pageIndex == 2) {
      // Already on cart page, do nothing
      return;
    }

    // Navigate to dashboard with the correct initial page
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => DashBoardScreen(initialPageIndex: pageIndex),
      ),
    );
  }
}
