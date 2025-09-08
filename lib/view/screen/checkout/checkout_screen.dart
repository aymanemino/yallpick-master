import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/body/order_place_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/cart_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/response_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/cart_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/coupon_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/order_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/amount_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/animated_custom_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/my_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/textfield/custom_textfield.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/title_row.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/address/add_new_address_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/address/saved_address_list_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/address/saved_billing_Address_list_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/checkout/widget/custom_check_box.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/dashboard/dashboard_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/payment/payment_screen.dart';
import 'package:provider/provider.dart';

import '../payment/payment_card_widget.dart';

class CheckoutScreen extends StatefulWidget {
  final List<CartModel> cartList;
  final bool fromProductDetails;
  final double totalOrderAmount;
  final double shippingFee;
  final double discount;
  final double tax;
  final int sellerId;

  CheckoutScreen(
      {required this.cartList,
      this.fromProductDetails = false,
      required this.discount,
      required this.tax,
      required this.totalOrderAmount,
      required this.shippingFee,
      this.sellerId});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _orderNoteController = TextEditingController();
  final FocusNode _orderNoteNode = FocusNode();
  double _order = 0;
  bool _digitalPayment = false;
  bool _cod = false;

  @override
  void initState() {
    super.initState();
    Provider.of<ProfileProvider>(context, listen: false)
        .initAddressList(context);
    Provider.of<ProfileProvider>(context, listen: false)
        .initAddressTypeList(context);
    Provider.of<CouponProvider>(context, listen: false).removePrevCouponData();
    Provider.of<CartProvider>(context, listen: false).getCartDataAPI(context);
    Provider.of<CartProvider>(context, listen: false)
        .getChosenShippingMethod(context);
    _digitalPayment = Provider.of<SplashProvider>(context, listen: false)
        .configModel
        .digitalPayment;
    _cod = Provider.of<SplashProvider>(context, listen: false).configModel.cod;

    Provider.of<OrderProvider>(context, listen: false).shippingAddressNull();
    Provider.of<OrderProvider>(context, listen: false).billingAddressNull();
  }

  @override
  Widget build(BuildContext context) {
    _order = widget.totalOrderAmount + widget.discount;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      backgroundColor: Colors.grey[50]!!!,
      bottomNavigationBar: Container(
        height: 80,
        padding: EdgeInsets.symmetric(
            horizontal: Dimensions.PADDING_SIZE_LARGE,
            vertical: Dimensions.PADDING_SIZE_DEFAULT),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF6B35), Color(0xFFFF8C42)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: Consumer<OrderProvider>(
          builder: (context, order, child) {
            return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Amount',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Consumer<CouponProvider>(
                          builder: (context, coupon, child) {
                        double _couponDiscount =
                            coupon.discount != null ? coupon.discount : 0;
                        return Text(
                          PriceConverter.convertPrice(
                              context,
                              (widget.totalOrderAmount +
                                  widget.shippingFee +
                                  widget.tax -
                                  _couponDiscount)),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }),
                    ],
                  ),
                  !Provider.of<OrderProvider>(context).isLoading
                      ? Builder(
                          builder: (context) => Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextButton(
                              onPressed: () async {
                                if (Provider.of<OrderProvider>(context,
                                            listen: false)
                                        .addressIndex ==
                                    null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(getTranslated(
                                              'select_a_shipping_address',
                                              context)),
                                          backgroundColor: Colors.red));
                                } else if (Provider.of<OrderProvider>(context,
                                            listen: false)
                                        .billingAddressIndex ==
                                    null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(getTranslated(
                                              'select_a_billing_address',
                                              context)),
                                          backgroundColor: Colors.red));
                                } else {
                                  // Check minimum order amount for JD products (sellerId = 1)
                                  bool hasJdProducts = false;

                                  // Check if cart has JD products
                                  for (var cartItem in widget.cartList) {
                                    if (cartItem.sellerId == 1) {
                                      hasJdProducts = true;
                                      break;
                                    }
                                  }

                                  // If cart has JD products, get minimum order amount from API and check requirement
                                  if (hasJdProducts) {
                                    double minimumOrderAmount =
                                        await Provider.of<CartProvider>(context,
                                                listen: false)
                                            .getJdMinimumOrderAmount();

                                    // widget.totalOrderAmount already includes shipping, so use it directly
                                    if (widget.totalOrderAmount <
                                        minimumOrderAmount) {
                                      double remainingAmount =
                                          minimumOrderAmount -
                                              widget.totalOrderAmount;
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  "You have international delivery items in your cart. Minimum order amount for international products is ${minimumOrderAmount.toStringAsFixed(0)} AED. You need to add ${remainingAmount.toStringAsFixed(0)} AED more to proceed."),
                                              backgroundColor: Colors.red,
                                              duration: Duration(seconds: 5)));
                                      return;
                                    }
                                  }
                                  List<CartModel> _cartList = [];
                                  _cartList.addAll(widget.cartList);

                                  for (int index = 0;
                                      index < widget.cartList.length;
                                      index++) {
                                    for (int i = 0;
                                        i <
                                            Provider.of<CartProvider>(context,
                                                    listen: false)
                                                .chosenShippingList
                                                .length;
                                        i++) {
                                      if (Provider.of<CartProvider>(context,
                                                  listen: false)
                                              .chosenShippingList[i]
                                              .cartGroupId ==
                                          widget.cartList[index].cartGroupId) {
                                        _cartList[index].shippingMethodId =
                                            Provider.of<CartProvider>(context,
                                                    listen: false)
                                                .chosenShippingList[i]
                                                .id;
                                        break;
                                      }
                                    }
                                  }

                                  String orderNote =
                                      _orderNoteController.text.trim();
                                  double couponDiscount =
                                      Provider.of<CouponProvider>(context,
                                                      listen: false)
                                                  .discount !=
                                              null
                                          ? Provider.of<CouponProvider>(context,
                                                  listen: false)
                                              .discount
                                          : 0;
                                  String couponCode =
                                      Provider.of<CouponProvider>(context,
                                                      listen: false)
                                                  .discount !=
                                              null
                                          ? Provider.of<CouponProvider>(context,
                                                  listen: false)
                                              .coupon
                                              .code
                                          : '';
                                  if (Provider.of<OrderProvider>(context,
                                              listen: false)
                                          .paymentMethodIndex ==
                                      0) {
                                    Provider.of<OrderProvider>(context,
                                            listen: false)
                                        .placeOrder(
                                            OrderPlaceModel(
                                              CustomerInfo(
                                                  Provider.of<ProfileProvider>(context, listen: false)
                                                      .addressList[
                                                          Provider.of<OrderProvider>(context, listen: false)
                                                              .addressIndex]
                                                      .id
                                                      .toString(),
                                                  Provider.of<ProfileProvider>(context, listen: false)
                                                          .addressList[
                                                              Provider.of<OrderProvider>(context, listen: false)
                                                                  .addressIndex]
                                                          .address ??
                                                      "",
                                                  Provider.of<ProfileProvider>(context, listen: false)
                                                      .billingAddressList[
                                                          Provider.of<OrderProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .billingAddressIndex]
                                                      .id
                                                      .toString(),
                                                  Provider.of<ProfileProvider>(context, listen: false)
                                                          .billingAddressList[Provider.of<OrderProvider>(context, listen: false).billingAddressIndex]
                                                          .address ??
                                                      "",
                                                  orderNote),
                                              _cartList,
                                              order.paymentMethodIndex == 0
                                                  ? 'cash_on_delivery'
                                                  : '',
                                              couponDiscount,
                                            ),
                                            _callback,
                                            _cartList,
                                            Provider.of<ProfileProvider>(
                                                    context,
                                                    listen: false)
                                                .addressList[
                                                    Provider.of<OrderProvider>(
                                                            context,
                                                            listen: false)
                                                        .addressIndex]
                                                .id
                                                .toString(),
                                            couponCode,
                                            Provider.of<ProfileProvider>(
                                                    context,
                                                    listen: false)
                                                .billingAddressList[
                                                    Provider.of<OrderProvider>(
                                                            context,
                                                            listen: false)
                                                        .billingAddressIndex]
                                                .id
                                                .toString(),
                                            orderNote);
                                  } else {
                                    String userID =
                                        await Provider.of<ProfileProvider>(
                                                context,
                                                listen: false)
                                            .getUserInfo(context);
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => PaymentScreen(
                                                  customerID: userID,
                                                  addressID: Provider.of<
                                                              ProfileProvider>(
                                                          context,
                                                          listen: false)
                                                      .addressList[Provider.of<
                                                                  OrderProvider>(
                                                              context,
                                                              listen: false)
                                                          .addressIndex]
                                                      .id
                                                      .toString(),
                                                  couponCode:
                                                      Provider.of<CouponProvider>(
                                                                      context,
                                                                      listen:
                                                                          false)
                                                                  .discount !=
                                                              null
                                                          ? Provider.of<
                                                                      CouponProvider>(
                                                                  context,
                                                                  listen: false)
                                                              .coupon
                                                              .code
                                                          : '',
                                                  billingId: Provider.of<
                                                              ProfileProvider>(
                                                          context,
                                                          listen: false)
                                                      .billingAddressList[Provider
                                                              .of<OrderProvider>(
                                                                  context,
                                                                  listen: false)
                                                          .billingAddressIndex]
                                                      .id
                                                      .toString(),
                                                  orderNote: orderNote,
                                                )));
                                  }
                                }
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    getTranslated('proceed', context),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFF6B35),
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    size: 16,
                                    color: Color(0xFFFF6B35),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container(
                          height: 30,
                          width: 30,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).highlightColor)),
                        ),
                ]);
          },
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            CustomAppBar(title: getTranslated('checkout', context)),
            Expanded(
              child: ListView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(16),
                  children: [
                    // Shipping Details
                    Container(
                      margin: EdgeInsets.only(bottom: 16),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFF6B35).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.location_on,
                                  color: Color(0xFFFF6B35),
                                  size: 20,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getTranslated('SHIPPING_TO', context),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600]!!!,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      Provider.of<OrderProvider>(context,
                                                      listen: false)
                                                  .addressIndex ==
                                              null
                                          ? getTranslated(
                                              'add_your_address', context)
                                          : Provider.of<ProfileProvider>(
                                                      context,
                                                      listen: false)
                                                  .addressList[Provider.of<
                                                              OrderProvider>(
                                                          context,
                                                          listen: false)
                                                      .addressIndex]
                                                  .address ??
                                              "",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFFF6B35),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextButton.icon(
                                  onPressed: () {
                                    int len = Provider.of<ProfileProvider>(
                                            context,
                                            listen: false)
                                        .addressList
                                        .length;

                                    return Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                AddNewAddressScreen(
                                                    isBilling: false)))
                                        .then((value) async {
                                      await Provider.of<ProfileProvider>(
                                              context,
                                              listen: false)
                                          .initAddressList(context);

                                      if (Provider.of<ProfileProvider>(context,
                                                  listen: false)
                                              .addressList
                                              .length >
                                          len) {
                                        Provider.of<OrderProvider>(context,
                                                listen: false)
                                            .setAddressIndex(
                                                Provider.of<ProfileProvider>(
                                                            context,
                                                            listen: false)
                                                        .addressList
                                                        .length -
                                                    1);
                                      }
                                    });
                                  },
                                  icon: Icon(Icons.add,
                                      size: 16, color: Colors.white),
                                  label: Text(
                                    'Add',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200]!!!,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextButton.icon(
                                  onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              SavedAddressListScreen())),
                                  icon: Icon(Icons.edit,
                                      size: 16, color: Colors.grey[700]!!!),
                                  label: Text(
                                    getTranslated('select', context),
                                    style: TextStyle(
                                      color: Colors.grey[700]!!!,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFF6B35).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.receipt_long,
                                  color: Color(0xFFFF6B35),
                                  size: 20,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      getTranslated('billing_address', context),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600]!!!,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      Provider.of<OrderProvider>(context)
                                                  .billingAddressIndex ==
                                              null
                                          ? getTranslated(
                                              'add_your_address', context)
                                          : Provider.of<ProfileProvider>(
                                                      context,
                                                      listen: false)
                                                  .billingAddressList[Provider
                                                          .of<OrderProvider>(
                                                              context,
                                                              listen: false)
                                                      .billingAddressIndex]
                                                  .address ??
                                              "",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFFF6B35),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextButton.icon(
                                  onPressed: () {
                                    int len = Provider.of<ProfileProvider>(
                                            context,
                                            listen: false)
                                        .billingAddressList
                                        .length;

                                    return Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                AddNewAddressScreen(
                                                    isBilling: true)))
                                        .then((value) async {
                                      await Provider.of<ProfileProvider>(
                                              context,
                                              listen: false)
                                          .initAddressList(context);

                                      if (Provider.of<ProfileProvider>(context,
                                                  listen: false)
                                              .billingAddressList
                                              .length >
                                          len) {
                                        Provider.of<OrderProvider>(context,
                                                listen: false)
                                            .setBillingAddressIndex(
                                                Provider.of<ProfileProvider>(
                                                            context,
                                                            listen: false)
                                                        .billingAddressList
                                                        .length -
                                                    1);
                                      }
                                    });
                                  },
                                  icon: Icon(Icons.add,
                                      size: 16, color: Colors.white),
                                  label: Text(
                                    'Add',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200]!!!,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextButton.icon(
                                  onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              SavedBillingAddressListScreen())),
                                  icon: Icon(Icons.edit,
                                      size: 16, color: Colors.grey[700]!!!),
                                  label: Text(
                                    getTranslated('select', context),
                                    style: TextStyle(
                                      color: Colors.grey[700]!!!,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Order Details
                    Container(
                      margin: EdgeInsets.only(bottom: 16),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFF6B35).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.shopping_bag,
                                  color: Color(0xFFFF6B35),
                                  size: 20,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                getTranslated('ORDER_DETAILS', context),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          ConstrainedBox(
                            constraints: Provider.of<CartProvider>(context,
                                            listen: false)
                                        .cartList
                                        .length >
                                    0
                                ? BoxConstraints(
                                    maxHeight: 120 *
                                        Provider.of<CartProvider>(context,
                                                listen: false)
                                            .cartList
                                            .length
                                            .toDouble())
                                : BoxConstraints(maxHeight: 0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: Provider.of<CartProvider>(context,
                                      listen: false)
                                  .cartList
                                  .length,
                              itemBuilder: (ctx, index) {
                                return Container(
                                  margin: EdgeInsets.only(bottom: 12),
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50]!!!,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey[200]!!!,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.1),
                                              blurRadius: 4,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: FadeInImage.assetNetwork(
                                            placeholder: Images.placeholder,
                                            fit: BoxFit.cover,
                                            image:
                                                '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productThumbnailUrl}/${Provider.of<CartProvider>(context, listen: false).cartList[index].thumbnail}',
                                            imageErrorBuilder: (c, o, s) =>
                                                Image.asset(
                                              Images.placeholder,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              Provider.of<CartProvider>(context,
                                                      listen: false)
                                                  .cartList[index]
                                                  .name,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(height: 8),
                                            Row(
                                              children: [
                                                Text(
                                                  PriceConverter.convertPrice(
                                                    context,
                                                    Provider.of<CartProvider>(
                                                            context,
                                                            listen: false)
                                                        .cartList[index]
                                                        .price,
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFFFF6B35),
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFFF6B35)
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Text(
                                                    'Qty: ${Provider.of<CartProvider>(context, listen: false).cartList[index].quantity}',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(0xFFFF6B35),
                                                    ),
                                                  ),
                                                ),
                                                Spacer(),
                                                if (Provider.of<CartProvider>(
                                                            context,
                                                            listen: false)
                                                        .cartList[index]
                                                        .discount >
                                                    0)
                                                  Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                            vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: Colors.green
                                                          .withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                    child: Text(
                                                      PriceConverter
                                                          .percentageCalculation(
                                                        context,
                                                        Provider.of<CartProvider>(
                                                                context,
                                                                listen: false)
                                                            .cartList[index]
                                                            .price,
                                                        Provider.of<CartProvider>(
                                                                context,
                                                                listen: false)
                                                            .cartList[index]
                                                            .discount,
                                                        Provider.of<CartProvider>(
                                                                context,
                                                                listen: false)
                                                            .cartList[index]
                                                            .discountType,
                                                      ),
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Colors.green[700],
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),

                          SizedBox(height: 25), // Adding space here

                          // Coupon
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color(0xFFFF6B35).withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Color(0xFFFF6B35).withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.local_offer,
                                  color: Color(0xFFFF6B35),
                                  size: 20,
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: TextField(
                                    controller: _controller,
                                    decoration: InputDecoration(
                                      hintText: getTranslated(
                                          'have_a_coupon', context),
                                      hintStyle: TextStyle(
                                        color: Colors.grey[600]!!!,
                                        fontSize: 14,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 0,
                                      ),
                                    ),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                !Provider.of<CouponProvider>(context).isLoading
                                    ? Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFFFF6B35),
                                              Color(0xFFFF8C42)
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: TextButton(
                                          onPressed: () {
                                            if (_controller.text.isNotEmpty) {
                                              Provider.of<CouponProvider>(
                                                      context,
                                                      listen: false)
                                                  .initCoupon(
                                                      _controller.text, _order)
                                                  .then((value) {
                                                if (value > 0) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          'You got ${PriceConverter.convertPrice(context, value)} discount'),
                                                      backgroundColor:
                                                          Colors.green,
                                                    ),
                                                  );
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(getTranslated(
                                                          'invalid_coupon_or',
                                                          context)),
                                                      backgroundColor:
                                                          Colors.red,
                                                    ),
                                                  );
                                                }
                                              });
                                            }
                                          },
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 8,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          child: Text(
                                            getTranslated('APPLY', context),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Color(0xFFFF6B35)),
                                        ),
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Total bill
                    Container(
                      margin: EdgeInsets.only(bottom: 16),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Consumer<OrderProvider>(
                        builder: (context, order, child) {
                          double _couponDiscount =
                              Provider.of<CouponProvider>(context).discount !=
                                      null
                                  ? Provider.of<CouponProvider>(context)
                                      .discount
                                  : 0;

                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color:
                                            Color(0xFFFF6B35).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.receipt,
                                        color: Color(0xFFFF6B35),
                                        size: 20,
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      getTranslated('TOTAL', context),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                _buildAmountRow(
                                  getTranslated('ORDER', context),
                                  PriceConverter.convertPrice(context, _order),
                                  false,
                                ),
                                _buildAmountRow(
                                  getTranslated('SHIPPING_FEE', context),
                                  PriceConverter.convertPrice(
                                      context, widget.shippingFee),
                                  false,
                                ),
                                _buildAmountRow(
                                  getTranslated('DISCOUNT', context),
                                  PriceConverter.convertPrice(
                                      context, widget.discount),
                                  true,
                                ),
                                _buildAmountRow(
                                  getTranslated('coupon_voucher', context),
                                  PriceConverter.convertPrice(
                                      context, _couponDiscount),
                                  true,
                                ),
                                _buildAmountRow(
                                  getTranslated('TAX', context),
                                  PriceConverter.convertPrice(
                                      context, widget.tax),
                                  false,
                                ),
                                SizedBox(height: 12),
                                Container(
                                  height: 1,
                                  color: Colors.grey[300]!!!,
                                ),
                                SizedBox(height: 12),
                                _buildAmountRow(
                                  getTranslated('TOTAL_PAYABLE', context),
                                  PriceConverter.convertPrice(
                                      context,
                                      (_order +
                                          widget.shippingFee -
                                          widget.discount -
                                          _couponDiscount +
                                          widget.tax)),
                                  false,
                                  isTotal: true,
                                ),
                              ]);
                        },
                      ),
                    ),

                    // Payment Method
                    Container(
                      margin: EdgeInsets.only(bottom: 16),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFF6B35).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.payment,
                                  color: Color(0xFFFF6B35),
                                  size: 20,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                getTranslated('payment_method', context),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          if (_digitalPayment)
                            PaymentCardWidget(
                                index: 1, path: 'assets/images/Payment.jpg'),
                          if (_cod)
                            PaymentCardWidget(
                                index: 0, path: "assets/images/cod.jpg"),
                        ],
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.only(bottom: 16),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFF6B35).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.note_alt,
                                  color: Color(0xFFFF6B35),
                                  size: 20,
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                getTranslated('order_note', context),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[50]!!!,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Color(0xFFFF6B35).withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: TextField(
                                keyboardType: TextInputType.multiline,
                                maxLines: 3,
                                controller: _orderNoteController,
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                ),
                                decoration: InputDecoration(
                                  hintText:
                                      getTranslated('enter_note', context),
                                  hintStyle: TextStyle(
                                    color: Colors.grey[600]!!!,
                                    fontSize: 14,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountRow(String title, String amount, bool isDiscount,
      {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal ? Colors.black87 : Colors.grey[700]!!!,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isTotal
                  ? Color(0xFFFF6B35)
                  : (isDiscount ? Colors.green[700] : Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  void _callback(bool isSuccess, String message, String orderID,
      List<CartModel> carts) async {
    if (isSuccess) {
      Provider.of<ProductProvider>(context, listen: false).getLatestProductList(
        1,
        context,
        reload: true,
      );
      if (Provider.of<OrderProvider>(context, listen: false)
              .paymentMethodIndex ==
          0) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => DashBoardScreen()),
            (route) => false);
        showAnimatedDialog(
            context,
            MyDialog(
              icon: Icons.check,
              title: getTranslated('order_placed', context),
              description: getTranslated('your_order_placed', context),
              isFailed: false,
            ),
            dismissible: false,
            isFlip: true);
      } else {}
      Provider.of<OrderProvider>(context, listen: false).stopLoader();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message), backgroundColor: ColorResources.RED));
    }
  }
}

class PaymentButton extends StatelessWidget {
  final String image;
  final Function onTap;

  PaymentButton({required this.image, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap as void Function()?,
      child: Container(
        height: 45,
        margin: EdgeInsets.symmetric(
            horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: ColorResources.getGrey(context)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.asset(image),
      ),
    );
  }
}
