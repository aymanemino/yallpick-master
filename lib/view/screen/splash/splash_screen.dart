import 'dart:async';
import 'dart:math' as math;
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/no_internet_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/auth/auth_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/dashboard/dashboard_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/maintenance/maintenance_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/onboarding/onboarding_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/splash/widget/splash_painter.dart';
import 'package:provider/provider.dart';

import 'package:flutter_sixvalley_ecommerce/view/basewidget/animated_custom_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/setting/widget/currency_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/helper/app_update_service.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
  late StreamSubscription<ConnectivityResult> _onConnectivityChanged;

  // Animation controllers
  late AnimationController _logoController;
  late AnimationController _backgroundController;
  late AnimationController _particleController;
  late AnimationController _floatingController;

  // Animations
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _logoRotation;
  late Animation<double> _backgroundOpacity;
  late Animation<double> _particleOpacity;
  late Animation<double> _floatingRotation;

  // Animation state
  bool _animationsComplete = false;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _logoController = AnimationController(
      duration: Duration(milliseconds: 2500),
      vsync: this,
    );

    _backgroundController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );

    _particleController = AnimationController(
      duration: Duration(milliseconds: 3000),
      vsync: this,
    );

    _floatingController = AnimationController(
      duration: Duration(milliseconds: 4000),
      vsync: this,
    );

    // Setup animations
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeIn),
    );

    _logoRotation = Tween<double>(begin: -0.5, end: 0.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _backgroundOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.easeIn),
    );

    _particleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.easeInOut),
    );

    _floatingRotation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.linear),
    );

    // Start animations
    _startAnimations();

    bool _firstTime = true;
    _onConnectivityChanged = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (!_firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi &&
            result != ConnectivityResult.mobile;
        isNotConnected
            ? SizedBox()
            : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected
                ? getTranslated('no_connection', context)
                : getTranslated('connected', context),
            textAlign: TextAlign.center,
          ),
        ));
        if (!isNotConnected) {
          _route();
        }
      }
      _firstTime = false;
    });

    if (Provider.of<SplashProvider>(context, listen: false).showIntro() ==
            null ||
        Provider.of<SplashProvider>(context, listen: false).showIntro() ==
            true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showAnimatedDialog(
            context,
            CurrencyDialog(
                isCurrency: false,
                isSplash: true,
                onPress: () {
                  // Only navigate if animations are complete
                  if (_animationsComplete) {
                    _route();
                  }
                }),
            dismissible: false);
      });
    } else {
      // Wait for animations to complete before auto-navigation
      Timer(Duration(milliseconds: 4500), () {
        if (mounted && _animationsComplete) {
          _route();
        }
      });
    }
  }

  void _startAnimations() async {
    // Start background animation
    _backgroundController.forward();

    // Wait a bit then start logo animation
    await Future.delayed(Duration(milliseconds: 300));
    _logoController.forward();

    // Start floating elements
    _floatingController.repeat();

    // Wait for logo animation to complete then start particles
    await Future.delayed(Duration(milliseconds: 1500));
    _particleController.forward();

    // Wait for all animations to complete before allowing navigation
    await Future.delayed(Duration(milliseconds: 1000));

    // Set a flag to indicate animations are complete
    if (mounted) {
      setState(() {
        _animationsComplete = true;
      });
    }

    // Auto-navigate after animations complete
    Timer(Duration(milliseconds: 1000), () {
      if (mounted && _animationsComplete) {
        _route();
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _backgroundController.dispose();
    _particleController.dispose();
    _floatingController.dispose();
    _onConnectivityChanged.cancel();
    super.dispose();
  }

  void _route() async {
    Provider.of<SplashProvider>(context, listen: false)
        .initConfig(context)
        .then((bool isSuccess) async {
      if (isSuccess) {
        Provider.of<SplashProvider>(context, listen: false)
            .initSharedPrefData();

        // Wait for animations to complete
        await Future.delayed(Duration(milliseconds: 500));

        if (Provider.of<SplashProvider>(context, listen: false)
            .configModel
            .maintenanceMode) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => MaintenanceScreen()));
        } else {
          // Check for blocking updates before proceeding
          print('🔒 SPLASH: Checking for blocking updates...');
          final canProceed =
              await AppUpdateService.checkForUpdateBlocking(context);

          if (canProceed) {
            print('✅ SPLASH: Update check passed, proceeding to app...');
            _navigateToApp();
          } else {
            print('🚫 SPLASH: Update dismissed, proceeding to app...');
            _navigateToApp();
          }
        }
      }
    });
  }

  void _navigateToApp() {
    if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
      Provider.of<AuthProvider>(context, listen: false).updateToken(context);
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => DashBoardScreen()));
    } else {
      if (Provider.of<SplashProvider>(context, listen: false).showIntro()) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => OnBoardingScreen(
                  indicatorColor: ColorResources.GREY,
                  selectedIndicatorColor: Theme.of(context).primaryColor,
                )));
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => DashBoardScreen()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: Colors.white,
      body: Provider.of<SplashProvider>(context).hasConnection
          ? Stack(
              clipBehavior: Clip.none,
              children: [
                // Beautiful gradient background
                AnimatedBuilder(
                  animation: _backgroundController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _backgroundOpacity.value,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white,
                              ColorResources.LIGHT_SKY_BLUE.withOpacity(0.08),
                              ColorResources.YELLOW.withOpacity(0.05),
                              Colors.white,
                            ],
                            stops: [0.0, 0.3, 0.7, 1.0],
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // Floating geometric shapes
                AnimatedBuilder(
                  animation: _floatingController,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _floatingRotation.value,
                      child: Stack(
                        children: [
                          // Top left triangle
                          Positioned(
                            top: 50,
                            left: 30,
                            child: Container(
                              width: 60,
                              height: 60,
                              child: CustomPaint(
                                painter: TrianglePainter(
                                  color: ColorResources.LIGHT_SKY_BLUE
                                      .withOpacity(0.3),
                                ),
                              ),
                            ),
                          ),
                          // Top right circle
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
                                    ColorResources.YELLOW.withOpacity(0.4),
                                    ColorResources.YELLOW.withOpacity(0.1),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Bottom left square
                          Positioned(
                            bottom: 100,
                            left: 50,
                            child: Transform.rotate(
                              angle: math.pi / 4,
                              child: Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: ColorResources.SELLER_TXT
                                      .withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                          // Bottom right hexagon
                          Positioned(
                            bottom: 80,
                            right: 60,
                            child: Container(
                              width: 90,
                              height: 90,
                              child: CustomPaint(
                                painter: HexagonPainter(
                                  color: ColorResources.LIGHT_SKY_BLUE
                                      .withOpacity(0.25),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),

                // Subtle background patterns
                AnimatedBuilder(
                  animation: _particleController,
                  builder: (context, child) {
                    return Opacity(
                      opacity: _particleOpacity.value * 0.4,
                      child: CustomPaint(
                        painter: SplashPainter(),
                      ),
                    );
                  },
                ),

                // Main content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Spacer to push logo down more (less space at top)
                      SizedBox(height: 200),

                      // Animated logo with circle container
                      AnimatedBuilder(
                        animation: _logoController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _logoScale.value,
                            child: Transform.rotate(
                              angle: _logoRotation.value,
                              child: Opacity(
                                opacity: _logoOpacity.value,
                                child: Container(
                                  width: 240,
                                  height: 240,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        ColorResources.LIGHT_SKY_BLUE
                                            .withOpacity(0.15),
                                        ColorResources.SELLER_TXT
                                            .withOpacity(0.1),
                                        ColorResources.YELLOW.withOpacity(0.08),
                                        Colors.white,
                                      ],
                                      stops: [0.0, 0.3, 0.7, 1.0],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: ColorResources.LIGHT_SKY_BLUE
                                            .withOpacity(0.3),
                                        blurRadius: 40,
                                        spreadRadius: 5,
                                        offset: Offset(0, 15),
                                      ),
                                      BoxShadow(
                                        color: ColorResources.YELLOW
                                            .withOpacity(0.2),
                                        blurRadius: 30,
                                        spreadRadius: 3,
                                        offset: Offset(0, -10),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: Container(
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.08),
                                            blurRadius: 20,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: Image.asset(
                                        Images.splash_logo,
                                        height: 160.0,
                                        width: 160.0,
                                        fit: BoxFit.scaleDown,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      // Spacer to push loading to bottom
                      Expanded(
                        child: SizedBox(),
                      ),

                      // Loading indicator at bottom
                      Container(
                        margin: EdgeInsets.only(bottom: 100),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              ColorResources.SELLER_TXT),
                          strokeWidth: 5,
                          backgroundColor:
                              ColorResources.YELLOW.withOpacity(0.15),
                        ),
                      ),

                      SizedBox(height: 50),
                    ],
                  ),
                ),
              ],
            )
          : NoInternetOrDataScreen(isNoInternet: true, child: SplashScreen()),
    );
  }
}

// Custom painter for triangle
class TrianglePainter extends CustomPainter {
  final Color? color;
  TrianglePainter({this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color ?? Colors.blue
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
  final Color? color;
  HexagonPainter({this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color ?? Colors.blue
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
