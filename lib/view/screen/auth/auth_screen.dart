import 'dart:math' as math;
import 'package:flutter/material.dart';

import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/auth/widget/sign_in_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/auth/widget/sign_up_widget.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget{
  final int initialPage;
  AuthScreen({this.initialPage = 0});

  @override
  Widget build(BuildContext context) {
    Provider.of<ProfileProvider>(context, listen: false).initAddressTypeList(context);
    Provider.of<AuthProvider>(context, listen: false).isRemember;
    PageController _pageController = PageController(initialPage: initialPage);

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Color(0xFFFF6B35).withOpacity(0.08),
              Color(0xFFFF8C42).withOpacity(0.05),
              Colors.white,
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Floating geometric shapes
            Positioned(
              top: 50,
              left: 30,
              child: Container(
                width: 60,
                height: 60,
                child: CustomPaint(
                  painter: TrianglePainter(
                    color: Color(0xFFFF6B35).withOpacity(0.3),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 80,
              right: 40,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Color(0xFFFF8C42).withOpacity(0.4),
                      Color(0xFFFF8C42).withOpacity(0.1),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              left: 50,
              child: Transform.rotate(
                angle: math.pi / 4,
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Color(0xFFFF6B35).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 80,
              right: 60,
              child: Container(
                width: 90,
                height: 90,
                child: CustomPaint(
                  painter: HexagonPainter(
                    color: Color(0xFFFF6B35).withOpacity(0.25),
                  ),
                ),
              ),
            ),

            // Main content
            Consumer<AuthProvider>(
              builder: (context, auth, child) => SafeArea(
                child: Column(
                  children: [
                    // Top section with logo and branding
                    Container(
                      padding: EdgeInsets.only(top: 10, left: 30, right: 30, bottom: 10),
                      child: Column(
                        children: [
                          // App logo with modern design - smaller
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFFFF6B35).withOpacity(0.15),
                                  Color(0xFFFF8C42).withOpacity(0.1),
                                  Colors.white,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFFFF6B35).withOpacity(0.3),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),

                          ),
                          SizedBox(height: 8),

                          // App name
                          Text(
                            'YALLAPICK',
                            style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF6B35),
                              letterSpacing: 1.2,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Your Shopping Companion',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600]!!!,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Modern tab navigation
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            spreadRadius: 1,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Consumer<AuthProvider>(
                        builder: (context, authProvider, child) => Row(
                          children: [
                            // Sign In Tab
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _pageController.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.easeInOut),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: authProvider.selectedIndex == 0
                                        ? Color(0xFFFF6B35)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                  child: Text(
                                    getTranslated('SIGN_IN', context),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: authProvider.selectedIndex == 0
                                          ? Colors.white
                                          : Colors.grey[600]!!!,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Sign Up Tab
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _pageController.animateToPage(1, duration: Duration(milliseconds: 300), curve: Curves.easeInOut),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                    color: authProvider.selectedIndex == 1
                                        ? Color(0xFFFF6B35)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                  child: Text(
                                    getTranslated('SIGN_UP', context),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: authProvider.selectedIndex == 1
                                          ? Colors.white
                                          : Colors.grey[600]!!!,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 10),

                    // Form content
                    Expanded(
                      child: Consumer<AuthProvider>(
                        builder: (context, authProvider, child) => PageView.builder(
                          itemCount: 2,
                          controller: _pageController,
                          itemBuilder: (context, index) {
                            if (authProvider.selectedIndex == 0) {
                              return SignInWidget();
                            } else {
                              return SignUpWidget();
                            }
                          },
                          onPageChanged: (index) {
                            authProvider.updateSelectedIndex(index);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for triangle
class TrianglePainter extends CustomPainter {
  final Color color;
  TrianglePainter({this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Custom painter for hexagon
class HexagonPainter extends CustomPainter {
  final Color color;
  HexagonPainter({this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    for (int i = 0; i < 6; i++) {
      final angle = i * math.pi / 3;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

