import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/order_model.dart';
import 'package:flutter_sixvalley_ecommerce/helper/date_converter.dart';
import 'package:flutter_sixvalley_ecommerce/helper/price_converter.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/order/order_details_screen.dart';

class OrderWidget extends StatelessWidget {
  final OrderModel orderModel;
  OrderWidget({this.orderModel});

  @override
  Widget build(BuildContext context) {
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
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => OrderDetailsScreen(
              orderModel: orderModel,
              orderId: orderModel.id ?? 0,
              orderType: orderModel.orderType,
              extraDiscount: orderModel.extraDiscount,
              extraDiscountType: orderModel.extraDiscountType,
            ),
          ));
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row with Order ID and Status
              Row(
                children: [
                  // Order ID Section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.receipt_outlined,
                              size: 16,
                              color: Color(0xFF6C757D),
                            ),
                            SizedBox(width: 8),
                            Text(
                              getTranslated('ORDER_ID', context) ?? 'ORDER ID',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF6C757D),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          '#${orderModel.id}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Status Badge
                  _buildStatusBadge(context),
                ],
              ),

              SizedBox(height: 20),

              // Order Details Row
              Row(
                children: [
                  // Date Section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                            DateTime.parse(orderModel.createdAt),
                          ),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Price Section
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          getTranslated('total_amount', context) ??
                              'Total Amount',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF6C757D),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          PriceConverter.convertPrice(
                              context, orderModel.orderAmount),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF6B35),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),

              // View Details Button (centered)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Color(0xFFFF6B35),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          getTranslated('view_details', context) ??
                              'View Details',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 12,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    Color statusColor;
    Color backgroundColor;
    IconData statusIcon;

    switch (orderModel.orderStatus.toLowerCase()) {
      case 'pending':
      case 'processing':
      case 'confirmed':
        statusColor = Color(0xFFFFA500);
        backgroundColor = Color(0xFFFFF8E1);
        statusIcon = Icons.schedule;
        break;
      case 'delivered':
      case 'completed':
        statusColor = Color(0xFF28A745);
        backgroundColor = Color(0xFFE8F5E8);
        statusIcon = Icons.check_circle;
        break;
      case 'canceled':
      case 'cancelled':
        statusColor = Color(0xFFDC3545);
        backgroundColor = Color(0xFFFFEBEE);
        statusIcon = Icons.cancel;
        break;
      case 'shipped':
        statusColor = Color(0xFF17A2B8);
        backgroundColor = Color(0xFFE3F2FD);
        statusIcon = Icons.local_shipping;
        break;
      default:
        statusColor = Color(0xFF6C757D);
        backgroundColor = Color(0xFFF8F9FA);
        statusIcon = Icons.info;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusIcon,
            size: 14,
            color: statusColor,
          ),
          SizedBox(width: 6),
          Text(
            orderModel.orderStatus.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: statusColor,
            ),
          ),
        ],
      ),
    );
  }
}
