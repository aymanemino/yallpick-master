import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/helper/network_info.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/cart_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/cart/cart_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/home/home_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/more/more_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/order/order_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/category/all_category_screen.dart'; // Import the Category Screen
import 'package:provider/provider.dart';

class DashBoardScreen extends StatefulWidget {
  final int initialPageIndex;

  DashBoardScreen({this.initialPageIndex = 0});

  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  int _pageIndex = 0;

  GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    NetworkInfo.checkConnectivity(context);
    _pageIndex = widget.initialPageIndex;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_pageIndex != 0) {
          _setPage(0); // Set page to Home when back button is pressed
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: Container(
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
            child: Container(
              height: 70,
              padding: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(
                    icon: Icons.home_rounded,
                    label: getTranslated('home', context) ?? 'Home',
                    isSelected: _pageIndex == 0,
                    onTap: () => _setPage(0),
                  ),
                  _buildNavItem(
                    icon: Icons.apps_rounded,
                    label: getTranslated('CATEGORY', context) ?? 'Category',
                    isSelected: _pageIndex == 1,
                    onTap: () => _setPage(1),
                  ),
                  _buildCartItem(),
                  _buildNavItem(
                    icon: Icons.receipt_long_rounded,
                    label: getTranslated('orders', context) ?? 'Orders',
                    isSelected: _pageIndex == 3,
                    onTap: () => _setPage(3),
                  ),
                  _buildNavItem(
                    icon: Icons.account_circle_rounded,
                    label: getTranslated('PROFILE', context) ?? 'Profile',
                    isSelected: _pageIndex == 4,
                    onTap: () => _setPage(4),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: _getBody(), // This method will return the appropriate screen
      ),
    );
  }

  void _setPage(int pageIndex) {
    if (pageIndex == 2) {
      // Open CartScreen in full screen without the bottom navigation bar
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => CartScreen()),
      ).then((_) {
        // When coming back from the cart, reset to the home page
        setState(() {
          _pageIndex = 0; // Reset to Home when returning
        });
      });
    } else {
      setState(() {
        _pageIndex = pageIndex; // Update the page index for other screens
      });
    }
  }

  Widget _getBody() {
    switch (_pageIndex) {
      case 0:
        return HomePage();
      case 1:
        return AllCategoryScreen(); // Now this is directly rendered
      case 3:
        return OrderScreen(isBacButtonExist: true);
      case 4:
        return MoreScreen();
      default:
        return Container();
    }
  }

  Widget _buildNavItem({
    IconData icon,
    String label,
    bool isSelected = false,
    VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
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
      onTap: () => _setPage(2),
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
                  color: _pageIndex == 2 ? Color(0xFFFF6B35) : Colors.black87,
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
                color: _pageIndex == 2 ? Color(0xFFFF6B35) : Colors.black87,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
