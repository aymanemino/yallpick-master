import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/provider/cart_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/localization_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/wishlist_provider.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/chat/inbox_screen.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/brand/all_brand_screen.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/animated_custom_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/guest_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/cart/cart_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/category/all_category_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/more/contact_us.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/more/widget/html_view_Screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/more/widget/sign_out_confirmation_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/notification/notification_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/offer/offers_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/order/order_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/profile/address_list_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/profile/profile_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/setting/settings_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/support/support_ticket_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/wishlist/wishlist_screen.dart';
import 'package:provider/provider.dart';

import 'faq_screen.dart';

class MoreScreen extends StatefulWidget {
  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  bool isGuestMode = false;
  String version = '';
  @override
  void initState() {
    isGuestMode =
        !Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if (!isGuestMode) {
      Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
      Provider.of<WishListProvider>(context, listen: false).initWishList(
        context,
        Provider.of<LocalizationProvider>(context, listen: false)
            .locale
            .countryCode,
      );
      version = Provider.of<SplashProvider>(context, listen: false)
                  .configModel
                  .version !=
              null
          ? Provider.of<SplashProvider>(context, listen: false)
              .configModel
              .version
          : 'version';
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        // Modern Background with New Design
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFF6B35),
                  Color(0xFFFF8A65),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Modern geometric patterns
                Positioned(
                  top: -50,
                  right: -50,
                  child: Transform.rotate(
                    angle: 0.785398, // 45 degrees
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 20,
                  left: -40,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -30,
                  right: 80,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
                // Floating dots pattern
                Positioned(
                  top: 40,
                  right: 120,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  top: 70,
                  right: 80,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Positioned(
                  top: 100,
                  right: 140,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Modern AppBar with Icon
        Positioned(
          top: 30,
          left: Dimensions.PADDING_SIZE_SMALL,
          right: Dimensions.PADDING_SIZE_SMALL,
          child: Consumer<ProfileProvider>(
            builder: (context, profile, child) {
              return Row(children: [
                // Logo with enhanced modern styling
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.25),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Image.asset(
                    Images.logo_with_name_image,
                    height: 28,
                    color: Colors.white,
                  ),
                ),
                Expanded(child: SizedBox.shrink()),
                // Profile section with icon instead of image
                InkWell(
                  onTap: () {
                    if (isGuestMode) {
                      showAnimatedDialog(context, GuestDialog(), isFlip: true);
                    } else {
                      if (Provider.of<ProfileProvider>(context, listen: false)
                              .userInfoModel !=
                          null) {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ProfileScreen()));
                      }
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.25),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(children: [
                      Text(
                        !isGuestMode
                            ? profile.userInfoModel != null
                                ? '${profile.userInfoModel.fName} ${profile.userInfoModel.lName}'
                                : 'Full Name'
                            : 'Guest',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          letterSpacing: 0.3,
                        ),
                      ),
                      SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                      // User icon with modern styling
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          Icons.person_rounded,
                          size: 22,
                          color: Colors.white,
                        ),
                      ),
                    ]),
                  ),
                ),
              ]);
            },
          ),
        ),

        Container(
          margin: EdgeInsets.only(top: 140),
          decoration: BoxDecoration(
            color: ColorResources.getIconBg(context),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                  // Top Row Items - Enhanced Design
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SquareButton(
                            image: Images.shopping_image,
                            title: getTranslated('orders', context),
                            navigateTo: OrderScreen(),
                            count: 1,
                            hasCount: false,
                          ),
                          SquareButton(
                            image: Images.cart_image,
                            title: getTranslated('CART', context),
                            navigateTo: CartScreen(),
                            count: Provider.of<CartProvider>(context,
                                    listen: false)
                                .cartList
                                .length,
                            hasCount: true,
                          ),
                          SquareButton(
                            image: Images.offers,
                            title: getTranslated('offers', context),
                            navigateTo: OffersScreen(),
                            count: 0,
                            hasCount: false,
                          ),
                          SquareButton(
                            image: Images.wishlist,
                            title: getTranslated('wishlist', context),
                            navigateTo: WishListScreen(),
                            count: Provider.of<AuthProvider>(context,
                                            listen: false)
                                        .isLoggedIn() &&
                                    Provider.of<WishListProvider>(context,
                                                listen: false)
                                            .wishList !=
                                        null &&
                                    Provider.of<WishListProvider>(context,
                                                listen: false)
                                            .wishList
                                            .length >
                                        0
                                ? Provider.of<WishListProvider>(context,
                                        listen: false)
                                    .wishList
                                    .length
                                : 0,
                            hasCount: false,
                          ),
                        ]),
                  ),
                  SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT + 10),

                  // Modern Menu Section Header
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 24,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFFFF6B35),
                                Color(0xFFFF8A65),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(3),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFFF6B35).withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                        Text(
                          getTranslated('QUICK_ACTIONS', context) ??
                              'Quick Actions',
                          style: TextStyle(
                            fontSize: Dimensions.FONT_SIZE_LARGE,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFFF6B35),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                  // Modern Menu Items
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                    child: Column(
                      children: [
                        ModernTitleButton(
                            image: Images.fast_delivery,
                            title: getTranslated('address', context),
                            subtitle:
                                getTranslated('manage_addresses', context) ??
                                    'Manage your addresses',
                            navigateTo: AddressListScreen()),
                        ModernTitleButton(
                            image: Images.more_filled_image,
                            title: getTranslated('all_category', context),
                            subtitle:
                                getTranslated('browse_categories', context) ??
                                    'Browse all categories',
                            navigateTo: AllCategoryScreen()),
                        ModernTitleButton(
                            image: Images.shopping_image,
                            title: getTranslated('all_brand', context),
                            subtitle:
                                getTranslated('explore_brands', context) ??
                                    'Explore all brands',
                            navigateTo: AllBrandScreen()),
                        ModernTitleButton(
                            image: Images.notification_filled,
                            title: getTranslated('notification', context),
                            subtitle:
                                getTranslated('view_notifications', context) ??
                                    'View your notifications',
                            navigateTo: NotificationScreen()),
                      ],
                    ),
                  ),

                  SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT + 10),

                  // Support Section Header
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 24,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFFFF6B35),
                                Color(0xFFFF8A65),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(3),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFFF6B35).withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                        Text(
                          getTranslated('SUPPORT', context) ?? 'Support',
                          style: TextStyle(
                            fontSize: Dimensions.FONT_SIZE_LARGE,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFFF6B35),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                  // Support Menu Items
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                    child: Column(
                      children: [
                        ModernTitleButton(
                            image: Images.chats,
                            title: getTranslated('chats', context),
                            subtitle:
                                getTranslated('chat_with_seller', context) ??
                                    'Chat with sellers',
                            navigateTo: InboxScreen()),
                        ModernTitleButton(
                            image: Images.preference,
                            title: getTranslated('support_ticket', context),
                            subtitle: getTranslated('get_help', context) ??
                                'Get help and support',
                            navigateTo: SupportTicketScreen()),
                        ModernTitleButton(
                            image: Images.help_center,
                            title: getTranslated('faq', context),
                            subtitle:
                                getTranslated('frequently_asked', context) ??
                                    'Frequently asked questions',
                            navigateTo: FaqScreen(
                              title: getTranslated('faq', context),
                            )),
                      ],
                    ),
                  ),

                  SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT + 10),

                  // Settings Section Header
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 24,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFFFF6B35),
                                Color(0xFFFF8A65),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(3),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFFF6B35).withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                        Text(
                          getTranslated('SETTINGS', context) ?? 'Settings',
                          style: TextStyle(
                            fontSize: Dimensions.FONT_SIZE_LARGE,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFFF6B35),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                  // Settings Menu Items
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                    child: Column(
                      children: [
                        ModernTitleButton(
                            image: Images.settings,
                            title: getTranslated('settings', context),
                            subtitle:
                                getTranslated('app_preferences', context) ??
                                    'App preferences',
                            navigateTo: SettingsScreen()),
                        ModernTitleButton(
                            image: Images.term_condition,
                            title: getTranslated('terms_condition', context),
                            subtitle: getTranslated('read_terms', context) ??
                                'Read terms and conditions',
                            navigateTo: HtmlViewScreen(
                              title: getTranslated('terms_condition', context),
                              url: Provider.of<SplashProvider>(context,
                                      listen: false)
                                  .configModel
                                  .termsConditions,
                            )),
                        ModernTitleButton(
                            image: Images.privacy_policy,
                            title: getTranslated('privacy_policy', context),
                            subtitle: getTranslated('privacy_info', context) ??
                                'Privacy information',
                            navigateTo: HtmlViewScreen(
                              title: getTranslated('privacy_policy', context),
                              url: Provider.of<SplashProvider>(context,
                                      listen: false)
                                  .configModel
                                  .privacyPolicy,
                            )),
                      ],
                    ),
                  ),

                  SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT + 10),

                  // About Section Header
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 24,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color(0xFFFF6B35),
                                Color(0xFFFF8A65),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(3),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFFF6B35).withOpacity(0.3),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                        Text(
                          getTranslated('ABOUT', context) ?? 'About',
                          style: TextStyle(
                            fontSize: Dimensions.FONT_SIZE_LARGE,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFFF6B35),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                  // About Menu Items
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                    child: Column(
                      children: [
                        ModernTitleButton(
                            image: Images.about_us,
                            title: getTranslated('about_us', context),
                            subtitle: getTranslated('company_info', context) ??
                                'Learn about our company',
                            navigateTo: HtmlViewScreen(
                              title: getTranslated('about_us', context),
                              url: Provider.of<SplashProvider>(context,
                                      listen: false)
                                  .configModel
                                  .aboutUs,
                            )),
                        ModernTitleButton(
                            image: Images.contact_us,
                            title: getTranslated('contact_us', context),
                            subtitle: getTranslated('get_in_touch', context) ??
                                'Get in touch with us',
                            navigateTo: ContactUs(
                              title: getTranslated('contact_us', context),
                            )),
                      ],
                    ),
                  ),

                  SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),

                  // Sign Out Button
                  isGuestMode
                      ? SizedBox()
                      : Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFFFF6B35).withOpacity(0.05),
                                Color(0xFFFF8A65).withOpacity(0.08),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Color(0xFFFF6B35).withOpacity(0.2),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFFFF6B35).withOpacity(0.1),
                                blurRadius: 15,
                                offset: Offset(0, 6),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(
                                Dimensions.PADDING_SIZE_DEFAULT + 4),
                            leading: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFFF6B35).withOpacity(0.15),
                                    Color(0xFFFF8A65).withOpacity(0.2),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Color(0xFFFF6B35).withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Icon(
                                Icons.logout_rounded,
                                color: Color(0xFFFF6B35),
                                size: 22,
                              ),
                            ),
                            title: Text(
                              getTranslated('sign_out', context),
                              style: TextStyle(
                                fontSize: Dimensions.FONT_SIZE_LARGE,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFFF6B35),
                                letterSpacing: 0.2,
                              ),
                            ),
                            onTap: () => showAnimatedDialog(
                                context, SignOutConfirmationDialog(),
                                isFlip: true),
                          ),
                        ),

                  SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                ]),
          ),
        ),
      ]),
    );
  }
}

class SquareButton extends StatelessWidget {
  final String image;
  final String title;
  final Widget navigateTo;
  final int count;
  final bool hasCount;

  SquareButton(
      {@required this.image,
      @required this.title,
      @required this.navigateTo,
      @required this.count,
      @required this.hasCount});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 100;
    return InkWell(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => navigateTo)),
      child: Column(children: [
        Container(
          width: width / 4,
          height: width / 4,
          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFF6B35),
                Color(0xFFFF8A65),
                Color(0xFFFFAB91),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Color(0xFFFF6B35).withOpacity(0.4),
                blurRadius: 20,
                offset: Offset(0, 8),
                spreadRadius: 2,
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Image.asset(image, color: Theme.of(context).highlightColor),
              hasCount
                  ? Positioned(
                      top: -4,
                      right: -4,
                      child: Consumer<CartProvider>(
                          builder: (context, cart, child) {
                        return Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: ColorResources.RED,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: ColorResources.RED.withOpacity(0.3),
                                blurRadius: 5,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            count.toString(),
                            style: titilliumSemiBold.copyWith(
                              color: ColorResources.WHITE,
                              fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
                            ),
                          ),
                        );
                      }),
                    )
                  : SizedBox(),
            ],
          ),
        ),
        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            title,
            style: titilliumSemiBold.copyWith(
              fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ]),
    );
  }
}

class TitleButton extends StatelessWidget {
  final String image;
  final String title;
  final Widget navigateTo;
  TitleButton(
      {@required this.image, @required this.title, @required this.navigateTo});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(image,
          width: 25,
          height: 25,
          fit: BoxFit.fill,
          color: ColorResources.getPrimary(context)),
      title: Text(title,
          style:
              titilliumRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => navigateTo),
      ),
    );
  }
}

class ModernTitleButton extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final Widget navigateTo;

  ModernTitleButton({
    @required this.image,
    @required this.title,
    @required this.subtitle,
    @required this.navigateTo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => navigateTo),
          ),
          child: Padding(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT + 4),
            child: Row(
              children: [
                // Icon Container with Orange Theme
                Container(
                  padding: EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFFF6B35).withOpacity(0.1),
                        Color(0xFFFF8A65).withOpacity(0.15),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Color(0xFFFF6B35).withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Image.asset(
                    image,
                    width: 26,
                    height: 26,
                    fit: BoxFit.fill,
                    color: Color(0xFFFF6B35),
                  ),
                ),

                SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT + 4),

                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: Dimensions.FONT_SIZE_LARGE,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          letterSpacing: 0.2,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: Dimensions.FONT_SIZE_SMALL,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[600]!!,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ],
                  ),
                ),

                // Modern Arrow Icon
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFFFF6B35).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Color(0xFFFF6B35),
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
