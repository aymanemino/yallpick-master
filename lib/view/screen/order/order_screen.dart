import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter_sixvalley_ecommerce/provider/localization_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/shimmer_loading.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/seller/seller_screen.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/order_details.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/order_model.dart';

import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/order_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/seller_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/amount_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/button/custom_button.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/show_custom_snakbar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/title_row.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/order/widget/order_details_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/payment/payment_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/support/support_ticket_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/tracking/tracking_screen.dart';
import 'package:provider/provider.dart';

class OrderDetailsScreen extends StatefulWidget {
  OrderModel orderModel;
  final int orderId;
  final String orderType;
  final double extraDiscount;
  final String extraDiscountType;
  OrderDetailsScreen(
      {this.orderModel,
        this.orderId,
        this.orderType,
        this.extraDiscount,
        this.extraDiscountType});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  void _loadData(BuildContext context) async {
    await Provider.of<OrderProvider>(context, listen: false).initTrackingInfo(
        widget.orderId.toString(), widget.orderModel, true, context);

    if (widget.orderModel == null) {
      widget.orderModel =
          Provider.of<OrderProvider>(context, listen: false).trackingModel;
      await Provider.of<SplashProvider>(context, listen: false)
          .initConfig(context);
    }
    Provider.of<SellerProvider>(context, listen: false).removePrevOrderSeller();
    await Provider.of<ProfileProvider>(context, listen: false)
        .initAddressList(context);
    if (Provider.of<SplashProvider>(context, listen: false)
        .configModel
        .shippingMethod ==
        'sellerwise_shipping') {
      Provider.of<OrderProvider>(context, listen: false).initShippingList(
        context,
        Provider.of<OrderProvider>(context, listen: false)
            .trackingModel
            .sellerId,
      );
    } else {
      Provider.of<OrderProvider>(context, listen: false)
          .initShippingList(context, 1);
    }
    Provider.of<OrderProvider>(context, listen: false).getOrderDetails(
      widget.orderId.toString(),
      context,
      Provider.of<LocalizationProvider>(context, listen: false)
          .locale
          .countryCode ?? "",
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: CustomAppBar(
          title: getTranslated('ORDER_DETAILS', context),
          isBackButtonExist: true),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Consumer<OrderProvider>(
              builder: (context, order, child) {
                List<int> sellerList = [];
                List<List<OrderDetailsModel>> sellerProductList = [];
                double _order = 0;
                double _discount = 0;
                double eeDiscount = 0;
                double _tax = 0;
                String shippingPartner = '';
                double _shippingFee = 0;

                if (order.orderDetails != null) {
                  order.orderDetails.forEach((orderDetails) {
                    if (!sellerList
                        .contains(orderDetails.productDetails.userId)) {
                      sellerList.add(orderDetails.productDetails.userId);
                    }
                  });
                  sellerList.forEach((seller) {
                    Provider.of<SellerProvider>(context, listen: false)
                        .initSeller(seller.toString(), context);
                    List<OrderDetailsModel> orderList = [];
                    order.orderDetails.forEach((orderDetails) {
                      if (seller == orderDetails.productDetails.userId) {
                        orderList.add(orderDetails);
                      }
                    });
                    sellerProductList.add(orderList);
                  });

                  order.orderDetails.forEach((orderDetails) {
                    _order = _order + (orderDetails.price * orderDetails.qty);
                    _discount = _discount + orderDetails.discount;
                    _tax = _tax + orderDetails.tax;
                  });

                  if (widget.orderType == 'POS') {
                    if (widget.extraDiscountType == 'percent') {
                      eeDiscount = _order * (widget.extraDiscount / 100);
                    } else {
                      eeDiscount = widget.extraDiscount;
                    }
                  }

                  if (order.shippingList != null) {
                    order.shippingList.forEach((shipping) {
                      if (shipping.id == order.trackingModel.shippingMethodId) {
                        shippingPartner = shipping.title;
                        _shippingFee = shipping.cost;
                      }
                    });
                  }
                }

                return order.orderDetails != null
                    ? ListView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(16),
                  children: [
                    // Order Header Card
                    _buildOrderHeaderCard(context, order),

                    SizedBox(height: 16),

                    // Address Information Card
                    if (widget.orderType != 'POS')
                      _buildAddressCard(context, order),

                    SizedBox(height: 16),

                    // Order Note Card
                    if (widget.orderModel != null &&
                        widget.orderModel.orderNote != null &&
                        widget.orderModel.orderNote.isNotEmpty)
                      _buildOrderNoteCard(context),

                    SizedBox(height: 16),

                    // Products Section Header
                    _buildSectionHeader(
                      context,
                      getTranslated('ORDERED_PRODUCT', context),
                      Icons.shopping_bag_outlined,
                    ),

                    // Products List
                    ListView.builder(
                      itemCount: sellerList.length,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(0),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return _buildSellerProductsCard(
                          context,
                          sellerList[index],
                          sellerProductList[index],
                          order,
                        );
                      },
                    ),

                    SizedBox(height: 16),

                    // Order Summary Card
                    _buildOrderSummaryCard(
                      context,
                      _order,
                      _shippingFee,
                      _discount,
                      eeDiscount,
                      order,
                      _tax,
                    ),

                    SizedBox(height: 16),

                    // Payment Information Card
                    _buildPaymentCard(context, order),

                    SizedBox(height: 16),

                    // Action Buttons
                    _buildActionButtons(context),
                  ],
                )
                    : LoadingPage();
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildOrderHeaderCard(BuildContext context, OrderProvider order) {
    return Container(
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
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Color(0xFFFF6B35).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.receipt_long,
                    color: Color(0xFFFF6B35),
                    size: 24,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getTranslated('ORDER_ID', context) ?? 'ORDER ID',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF6C757D),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '#${order.trackingModel.id}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      getTranslated('order_date', context) ?? 'Order Date',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6C757D),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      DateConverter.localDateToIsoStringAMPM(
                        DateTime.parse(order.trackingModel.createdAt),
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard(BuildContext context, OrderProvider order) {
    String shippingPartner = '';
    if (order.shippingList != null) {
      order.shippingList.forEach((shipping) {
        if (shipping.id == order.trackingModel.shippingMethodId) {
          shippingPartner = shipping.title;
        }
      });
    }

    return Container(
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
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFF17A2B8).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.location_on_outlined,
                    color: Color(0xFF17A2B8),
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  getTranslated('SHIPPING_TO', context) ?? 'SHIPPING TO',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              widget.orderModel != null &&
                  widget.orderModel.shippingAddressData != null
                  ? widget.orderModel.shippingAddressData.address
                  : 'Address not available',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6C757D),
                height: 1.4,
              ),
            ),
            if (widget.orderModel != null &&
                widget.orderModel.billingAddressData != null) ...[
              SizedBox(height: 20),
              Divider(height: 1, color: Color(0xFFE9ECEF)),
              SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xFF28A745).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.account_balance_wallet_outlined,
                      color: Color(0xFF28A745),
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    getTranslated('billing_address', context) ??
                        'BILLING ADDRESS',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                widget.orderModel.billingAddressData.address ?? "",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6C757D),
                  height: 1.4,
                ),
              ),
            ],
            if (shippingPartner.isNotEmpty) ...[
              SizedBox(height: 20),
              Divider(height: 1, color: Color(0xFFE9ECEF)),
              SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xFFFF6B35).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.local_shipping_outlined,
                      color: Color(0xFFFF6B35),
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      getTranslated('chosen_shipping', context) ??
                          'CHOSEN SHIPPING',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                  Text(
                    shippingPartner,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFF6B35),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOrderNoteCard(BuildContext context) {
    return Container(
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
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFFFFC107).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.note_outlined,
                    color: Color(0xFFFFC107),
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  getTranslated('order_note', context) ?? 'ORDER NOTE',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              widget.orderModel.orderNote,
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF6C757D),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
      BuildContext context, String title, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFFFF6B35).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Color(0xFFFF6B35),
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSellerProductsCard(
      BuildContext context,
      int sellerId,
      List<OrderDetailsModel> products,
      OrderProvider order,
      ) {
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
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seller Info
            InkWell(
              onTap: () {
                if (Provider.of<SellerProvider>(context, listen: false)
                    .orderSellerList
                    .length !=
                    0 &&
                    sellerId != 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SellerScreen(
                        seller:
                        Provider.of<SellerProvider>(context, listen: false)
                            .orderSellerList[sellerId],
                      ),
                    ),
                  );
                }
              },
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xFF6F42C1).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.store_outlined,
                      color: Color(0xFF6F42C1),
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getTranslated('seller', context) ?? 'SELLER',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF6C757D),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          sellerId == 1
                              ? 'Admin'
                              : _getSellerName(context, sellerId),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (sellerId != 1)
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xFFFF6B35).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.chat_outlined,
                        color: Color(0xFFFF6B35),
                        size: 20,
                      ),
                    ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Products List
            ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.all(0),
              itemCount: products.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, i) => OrderDetailsWidget(
                orderDetailsModel: products[i],
                callback: () {
                  showCustomSnackBar(
                    'Review submitted successfully',
                    context,
                    isError: false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummaryCard(
      BuildContext context,
      double orderAmount,
      double shippingFee,
      double discount,
      double extraDiscount,
      OrderProvider order,
      double tax,
      ) {
    return Container(
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
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFF28A745).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.receipt_long_outlined,
                    color: Color(0xFF28A745),
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  getTranslated('TOTAL', context) ?? 'ORDER SUMMARY',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            _buildAmountRow(
              getTranslated('ORDER', context) ?? 'Order',
              PriceConverter.convertPrice(context, orderAmount),
              false,
            ),
            _buildAmountRow(
              getTranslated('SHIPPING_FEE', context) ?? 'Shipping Fee',
              PriceConverter.convertPrice(context, shippingFee),
              false,
            ),
            _buildAmountRow(
              getTranslated('DISCOUNT', context) ?? 'Discount',
              PriceConverter.convertPrice(context, discount),
              true,
            ),
            if (widget.orderType == "POS")
              _buildAmountRow(
                getTranslated('EXTRA_DISCOUNT', context) ?? 'Extra Discount',
                PriceConverter.convertPrice(context, extraDiscount),
                true,
              ),
            _buildAmountRow(
              getTranslated('coupon_voucher', context) ?? 'Coupon/Voucher',
              PriceConverter.convertPrice(
                  context, order.trackingModel.discountAmount),
              true,
            ),
            _buildAmountRow(
              getTranslated('TAX', context) ?? 'Tax',
              PriceConverter.convertPrice(context, tax),
              false,
            ),
            Divider(height: 32, color: Color(0xFFE9ECEF)),
            _buildAmountRow(
              getTranslated('TOTAL_PAYABLE', context) ?? 'Total Payable',
              PriceConverter.convertPrice(
                context,
                (orderAmount +
                    shippingFee -
                    extraDiscount -
                    discount -
                    order.trackingModel.discountAmount +
                    tax),
              ),
              false,
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountRow(String title, String amount, bool isDiscount,
      {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              color: isTotal ? Color(0xFF1A1A1A) : Color(0xFF6C757D),
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isTotal
                  ? Color(0xFFFF6B35)
                  : isDiscount
                  ? Color(0xFF28A745)
                  : Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(BuildContext context, OrderProvider order) {
    return Container(
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
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFFDC3545).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.payment_outlined,
                    color: Color(0xFFDC3545),
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  getTranslated('PAYMENT', context) ?? 'PAYMENT',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            _buildPaymentRow(
              getTranslated('PAYMENT_STATUS', context) ?? 'Payment Status',
              Text(
                (order.trackingModel.paymentStatus != null &&
                    order.trackingModel.paymentStatus.isNotEmpty)
                    ? order.trackingModel.paymentStatus
                    : getTranslated('digital_payment', context) ??
                    'Digital Payment',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ),
            _buildPaymentRow(
              getTranslated('PAYMENT_PLATFORM', context) ?? 'Payment Platform',
              order.trackingModel.paymentMethod != 'cash_on_delivery' &&
                  order.trackingModel.paymentStatus == 'unpaid'
                  ? _buildPayNowButton(context, order)
                  : Text(
                order.trackingModel.paymentMethod != null
                    ? order.trackingModel.paymentMethod
                    .replaceAll('_', ' ')
                    : 'Digital Payment',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFF6B35),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentRow(String title, Widget value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6C757D),
            ),
          ),
          value,
        ],
      ),
    );
  }

  Widget _buildPayNowButton(BuildContext context, OrderProvider order) {
    return InkWell(
      onTap: () async {
        String userID =
        await Provider.of<ProfileProvider>(context, listen: false)
            .getUserInfo(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentScreen(
              customerID: userID,
              couponCode: '',
              addressID: order.trackingModel.shippingAddress.toString(),
              billingId: widget.orderModel.billingAddress.toString(),
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Color(0xFFFF6B35),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          getTranslated('pay_now', context) ?? 'Pay Now',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  String _getSellerName(BuildContext context, int sellerId) {
    final sellerProvider = Provider.of<SellerProvider>(context, listen: false);
    if (sellerProvider.orderSellerList.isNotEmpty) {
      // Find the seller by ID in the orderSellerList
      for (var seller in sellerProvider.orderSellerList) {
        if (seller.id == sellerId) {
          return '${seller.fName} ${seller.lName}';
        }
      }
    }
    // Fallback to seller ID if name not found
    return 'Seller #$sellerId';
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TrackingScreen(
                    orderID: widget.orderId.toString(),
                  ),
                ),
              ),
              icon: Icon(Icons.track_changes, color: Colors.white, size: 20),
              label: Text(
                getTranslated('TRACK_ORDER', context) ?? 'TRACK ORDER',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFF6B35),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Container(
            height: 50,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SupportTicketScreen(),
                ),
              ),
              icon:
              Icon(Icons.support_agent, color: Color(0xFFFF6B35), size: 20),
              label: Text(
                getTranslated('SUPPORT_CENTER', context) ?? 'SUPPORT',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFF6B35),
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Color(0xFFFF6B35), width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
