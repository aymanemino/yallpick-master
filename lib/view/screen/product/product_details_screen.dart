import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/banner_provider.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/seller_view.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/product_model.dart';

import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_details_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/wishlist_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/cart_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/no_internet_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/title_row.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/product_image_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/product_specification_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/product_title_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/related_product_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/review_widget.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/widget/youtube_view.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/dashboard/dashboard_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/cart/cart_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/category/all_category_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/order/order_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/more/more_screen.dart';

import 'package:provider/provider.dart';

import 'faq_and_review_screen.dart';

class ProductDetails extends StatefulWidget {
  final Product product;
  final bool banner;
  ProductDetails({@required this.product, this.banner = false});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int _pageIndex = 0;

  _loadData(BuildContext context) async {
    if (widget.banner) {
      Provider.of<BannerProvider>(
        context,
        listen: false,
      ).getProductDetails(context, widget.product.slug.toString());
      Provider.of<ProductDetailsProvider>(context, listen: false)
          .removePrevReview();
      Provider.of<ProductDetailsProvider>(context, listen: false)
          .initProduct(widget.product, context);
      Provider.of<ProductProvider>(context, listen: false)
          .removePrevRelatedProduct();
      Provider.of<ProductProvider>(context, listen: false)
          .initRelatedProductList(widget.product.id.toString(), context);
      Provider.of<ProductDetailsProvider>(context, listen: false)
          .getCount(widget.product.id.toString(), context);
      Provider.of<ProductDetailsProvider>(context, listen: false)
          .getSharableLink(widget.product.slug.toString(), context);
      if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
        Provider.of<WishListProvider>(context, listen: false)
            .checkWishList(widget.product.id.toString(), context);
      }
    } else {
      Provider.of<ProductDetailsProvider>(context, listen: false)
          .removePrevReview();
      Provider.of<ProductDetailsProvider>(context, listen: false)
          .initProduct(widget.product, context);
      Provider.of<ProductProvider>(context, listen: false)
          .removePrevRelatedProduct();
      Provider.of<ProductProvider>(context, listen: false)
          .initRelatedProductList(widget.product.id.toString(), context);
      Provider.of<ProductDetailsProvider>(context, listen: false)
          .getCount(widget.product.id.toString(), context);
      Provider.of<ProductDetailsProvider>(context, listen: false)
          .getSharableLink(widget.product.slug.toString(), context);
      if (Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
        Provider.of<WishListProvider>(context, listen: false)
            .checkWishList(widget.product.id.toString(), context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadData(context);
    return Consumer<ProductDetailsProvider>(
      builder: (context, details, child) {
        return details.hasConnection
            ? Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                InkWell(
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Theme.of(context).textTheme.bodyText1.color,
                    size: 20,
                  ),
                  onTap: () => Navigator.pop(context),
                ),
                SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                Text(
                  getTranslated('product_details', context),
                  style: robotoRegular.copyWith(
                    fontSize: 20,
                    color: Theme.of(context).textTheme.bodyText1.color,
                  ),
                ),
                Spacer(), // This pushes the home icon to the right side
                InkWell(
                  child: Icon(
                    Icons.home,
                    color: Theme.of(context).textTheme.bodyText1.color,
                    size: 24, // Adjust size as needed
                  ),
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DashBoardScreen()),
                          (Route<dynamic> route) =>
                      false, // This removes all previous routes
                    );
                  },
                ),
              ],
            ),
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: Provider.of<ThemeProvider>(context).darkTheme
                ? Colors.black
                : Colors.white.withOpacity(0.5),
          ),
          bottomNavigationBar: _buildBottomNavigationBar(),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                widget.banner &&
                    Provider.of<BannerProvider>(context,
                        listen: false)
                        .product !=
                        null
                    ? Consumer<BannerProvider>(
                    builder: (context, bannerP, _) {
                      print('====>XYZ======>${bannerP.product}');
                      return bannerP.product != null
                          ? Column(
                        children: [
                          ProductImageView(
                              productModel: bannerP.product),
                          ProductTitleView(
                              productModel: bannerP.product),
                          // International Delivery for user_id = 1
                          if (bannerP.product.userId == 1)
                            Container(
                              margin: EdgeInsets.symmetric(
                                horizontal:
                                Dimensions.PADDING_SIZE_SMALL,
                                vertical: Dimensions
                                    .PADDING_SIZE_EXTRA_SMALL,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius:
                                      BorderRadius.circular(
                                          6),
                                    ),
                                    child: Row(
                                      mainAxisSize:
                                      MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.language,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          'International Delivery',
                                          style:
                                          robotoBold.copyWith(
                                            color: Colors.white,
                                            fontSize: Dimensions
                                                .FONT_SIZE_SMALL,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    '6-8 Days Delivery',
                                    style: robotoRegular.copyWith(
                                      color: Colors.black87,
                                      fontSize: Dimensions
                                          .FONT_SIZE_SMALL,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      )
                          : SizedBox();
                    })
                    : Column(
                  children: [
                    ProductImageView(productModel: widget.product),
                    ProductTitleView(productModel: widget.product),
                    // International Delivery for user_id = 1
                    if (widget.product.userId == 1)
                      Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_SMALL,
                          vertical:
                          Dimensions.PADDING_SIZE_EXTRA_SMALL,
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius:
                                BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.language,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'International Delivery',
                                    style: robotoBold.copyWith(
                                      color: Colors.white,
                                      fontSize: Dimensions
                                          .FONT_SIZE_SMALL,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              '6-8 Days Delivery',
                              style: robotoRegular.copyWith(
                                color: Colors.black87,
                                fontSize:
                                Dimensions.FONT_SIZE_SMALL,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),

                // Seller

                widget.banner &&
                    Provider.of<BannerProvider>(context,
                        listen: false)
                        .product !=
                        null
                    ? Provider.of<BannerProvider>(context, listen: false)
                    .product !=
                    null &&
                    Provider.of<BannerProvider>(context,
                        listen: false)
                        .product
                        .addedBy ==
                        'seller'
                    ? SellerView(
                    sellerId: Provider.of<BannerProvider>(context,
                        listen: false)
                        .product
                        .userId
                        .toString())
                    : SizedBox.shrink()
                    : widget.product.addedBy == 'seller'
                    ? SellerView(
                    sellerId: widget.product.userId.toString())
                    : SizedBox.shrink(),

                if ((widget.product.videoUrl ?? '').isNotEmpty)
                  Container(
                    margin: EdgeInsets.only(
                        top: Dimensions.PADDING_SIZE_SMALL),
                    padding:
                    EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                    color: Theme.of(context).highlightColor,
                    child: YoutubeView(
                        videoUrl: widget.product.videoUrl ?? ''),
                  ),

                // Specification
                widget.banner &&
                    Provider.of<BannerProvider>(context,
                        listen: false)
                        .product !=
                        null
                    ? (Provider.of<BannerProvider>(context, listen: false)
                    .product !=
                    null)
                    ? Container(
                  margin: EdgeInsets.only(
                      top: Dimensions.PADDING_SIZE_SMALL),
                  padding: EdgeInsets.all(
                      Dimensions.PADDING_SIZE_SMALL),
                  color: Theme.of(context).highlightColor,
                  child: ProductSpecification(
                      productSpecification:
                      Provider.of<BannerProvider>(context,
                          listen: false)
                          .product
                          .details ??
                          ''),
                )
                    : SizedBox()
                    : (widget.product.details != null &&
                    widget.product.details.isNotEmpty)
                    ? Container(
                  margin: EdgeInsets.only(
                      top: Dimensions.PADDING_SIZE_SMALL),
                  padding: EdgeInsets.all(
                      Dimensions.PADDING_SIZE_SMALL),
                  color: Theme.of(context).highlightColor,
                  child: ProductSpecification(
                      productSpecification:
                      widget.product.details ?? ''),
                )
                    : SizedBox(),

                // Reviews
                Container(
                  margin:
                  EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  color: Theme.of(context).highlightColor,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleRow(
                            title: getTranslated('reviews', context) +
                                '(${details.reviewList != null ? details.reviewList.length : 0})',
                            isDetailsPage: true,
                            onTap: () {
                              if (details.reviewList != null) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => ReviewScreen(
                                            reviewList:
                                            details.reviewList)));
                              }
                            }),
                        Divider(),
                        details.reviewList != null
                            ? details.reviewList.length != 0
                            ? ReviewWidget(
                            reviewModel: details.reviewList[0])
                            : Center(
                            child: Text(getTranslated(
                                'no_review', context)))
                            : ReviewShimmer(),
                      ]),
                ),

                // Related Products
                Container(
                  margin:
                  EdgeInsets.only(top: Dimensions.PADDING_SIZE_SMALL),
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  color: Theme.of(context).highlightColor,
                  child: Column(
                    children: [
                      TitleRow(
                          title:
                          getTranslated('related_products', context),
                          isDetailsPage: true),
                      SizedBox(height: 5),
                      RelatedProductView(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )
            : Scaffold(
            body: NoInternetOrDataScreen(
                isNoInternet: true,
                child: ProductDetails(product: widget.product)));
      },
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
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
    );
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
    } else if (pageIndex == 0) {
      // Navigate to home
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => DashBoardScreen()),
            (Route<dynamic> route) => false,
      );
    } else if (pageIndex == 1) {
      // Navigate to category
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => DashBoardScreen(initialPageIndex: 1)),
            (Route<dynamic> route) => false,
      );
    } else if (pageIndex == 3) {
      // Navigate to orders
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => DashBoardScreen(initialPageIndex: 3)),
            (Route<dynamic> route) => false,
      );
    } else if (pageIndex == 4) {
      // Navigate to profile
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => DashBoardScreen(initialPageIndex: 4)),
            (Route<dynamic> route) => false,
      );
    }
  }
}
