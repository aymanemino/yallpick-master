import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/order_provider.dart';

class PaymentCardWidget extends StatelessWidget {
  final String path;
  final int index;

  const PaymentCardWidget({
    Key key,
    this.index,
    this.path,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, order, child) => GestureDetector(
        onTap: () => order.setPaymentMethod(index),
        child: Container(
          height: 120, // Adjusted height of the container
          margin: EdgeInsets.only(top: 12),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: order.paymentMethodIndex == index
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
              width: 4, // Adjust the width here for a thicker border
            ),
          ),
          child: Image.asset(
            path,
            height: 100, // Adjusted height of the image
            width: MediaQuery.of(context).size.width * 0.8,
            fit: BoxFit.contain, // Fit the image content within the specified height
          ),
        ),
      ),
    );
  }
}
