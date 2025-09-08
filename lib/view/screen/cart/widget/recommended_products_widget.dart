import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/product_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/cart_model.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/cart_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/auth_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/show_custom_snakbar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/product_shimmer.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/product_details_screen.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/guest_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'dart:math';
import 'package:provider/provider.dart';

class RecommendedProductsWidget extends StatefulWidget {
  const RecommendedProductsWidget({Key key}) : super(key: key);

  // Method to refresh recommendations from parent
  static void refreshRecommendations(BuildContext context) {
    final state =
        context.findAncestorStateOfType<_RecommendedProductsWidgetState>();
    state?.refreshRecommendations();
  }

  @override
  _RecommendedProductsWidgetState createState() =>
      _RecommendedProductsWidgetState();
}

class _RecommendedProductsWidgetState extends State<RecommendedProductsWidget> {
  bool _isLoading = false;
  bool _isLoadingMore = false;
  List<Product> _allProducts = [];
  List<Product> _recommendedProducts = [];
  Map<int, bool> _productLoadingStates = {};
  int _currentPage = 1;
  int _productsPerPage = 6; // Show 6 products per page for better performance
  bool _hasMoreProducts = true;
  Random _random = Random();

  @override
  void initState() {
    super.initState();
    _loadRecommendedProducts();

    // Retry loading products after a delay if initial load failed
    Future.delayed(Duration(seconds: 5), () {
      if (mounted && _allProducts.isEmpty) {
        _loadRecommendedProducts();
      }
    });

    // Listen for cart refresh events
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupCartRefreshListener();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadRecommendedProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var productProvider =
          Provider.of<ProductProvider>(context, listen: false);
      var cartProvider = Provider.of<CartProvider>(context, listen: false);

      // Try multiple product sources to ensure we always have products
      _allProducts = [];

      // 1. Try featured products first
      try {
        await productProvider.getFeaturedProductList('1', context,
            reload: true);
        if (productProvider.featuredProductList != null &&
            productProvider.featuredProductList.isNotEmpty) {
          _allProducts.addAll(productProvider.featuredProductList);
        }
      } catch (e) {
        print('Error loading featured products: $e');
      }

      // 2. Try latest products
      try {
        await productProvider.getLatestProductList(1, context, reload: true);
        if (productProvider.latestProductList != null &&
            productProvider.latestProductList.isNotEmpty) {
          _allProducts.addAll(productProvider.latestProductList);
        }
      } catch (e) {
        print('Error loading latest products: $e');
      }

      // 3. If still no products, try LProductList as fallback
      if (_allProducts.isEmpty) {
        try {
          await productProvider.getLProductList('1', context, reload: true);
          if (productProvider.lProductList != null &&
              productProvider.lProductList.isNotEmpty) {
            _allProducts.addAll(productProvider.lProductList);
          }
        } catch (e) {
          print('Error loading L products: $e');
        }
      }

      // 4. If still no products, create dummy products to prevent empty state
      if (_allProducts.isEmpty) {
        _createFallbackProducts();
      }

      // Remove duplicates and filter out cart products (if any)
      _allProducts = _allProducts.toSet().toList();
      if (cartProvider.cartList.isNotEmpty) {
        _allProducts = _allProducts
            .where((product) => !cartProvider.cartList
                .any((cartItem) => cartItem.id == product.id))
            .toList();
      }

      // Ensure we have at least some products after filtering
      if (_allProducts.isEmpty) {
        _createFallbackProducts();
      }

      // Shuffle products to get random order (only on fresh load)
      if (_recommendedProducts.isEmpty) {
        _allProducts.shuffle(_random);
      }

      // Take first 6 products initially for better performance
      // But preserve existing count if this is a retry
      int targetCount =
          _recommendedProducts.isEmpty ? 6 : _recommendedProducts.length;
      _recommendedProducts = _allProducts.take(targetCount).toList();
      _currentPage = (targetCount / _productsPerPage).ceil();
      _hasMoreProducts = _allProducts.length > targetCount;
    } catch (e) {
      print('Error loading recommended products: $e');
      // Create fallback products if everything fails
      _createFallbackProducts();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _createFallbackProducts() {
    // Create some fallback products to ensure we always have recommendations
    _allProducts = List.generate(20, (index) {
      return Product(
        id: -index - 1, // Negative IDs to avoid conflicts
        name: 'Product ${index + 1}',
        thumbnail: 'placeholder.jpg',
        unitPrice: 10.0 + (index * 2.0),
        discount: 0.0,
        discountType: 'amount',
        tax: 0.0,
        taxType: 'amount',
        minQty: 1,
        choiceOptions: [],
        variation: [],
        colors: [],
        addedBy: 'admin',
        userId: 1,
        categoryIds: [],
        slug: 'product-${index + 1}',
        status: 1,
        featuredStatus: 1,
        rating: [],
      );
    });
  }

  void _refreshRecommendationsAfterCartUpdate() {
    // Filter out products that are now in cart
    var cartProvider = Provider.of<CartProvider>(context, listen: false);
    if (cartProvider.cartList.isNotEmpty) {
      _allProducts = _allProducts
          .where((product) => !cartProvider.cartList
              .any((cartItem) => cartItem.id == product.id))
          .toList();

      // Update recommended products - preserve loaded count
      int currentCount = _recommendedProducts.length;
      _recommendedProducts = _allProducts.take(currentCount).toList();
      _currentPage = (currentCount / _productsPerPage).ceil();
      _hasMoreProducts = _allProducts.length > currentCount;

      setState(() {});
    }
  }

  // Method to force refresh recommendations with new random products
  void refreshRecommendations() {
    setState(() {
      // Reset to initial state
      _recommendedProducts.clear();
      _currentPage = 1;
      _hasMoreProducts = true;
    });

    // Reload products with new random order
    _loadRecommendedProducts();
  }

  void _setupCartRefreshListener() {
    // This method can be used to detect cart refresh events
    // For now, we'll rely on the parent cart page to call refreshRecommendations()
  }

  Future<void> _loadMoreProducts() async {
    if (_isLoadingMore || !_hasMoreProducts) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      // Simulate loading delay for better UX
      await Future.delayed(Duration(milliseconds: 500));

      int startIndex = _currentPage * _productsPerPage;
      int endIndex = startIndex + _productsPerPage;

      if (startIndex < _allProducts.length) {
        List<Product> newProducts =
            _allProducts.skip(startIndex).take(_productsPerPage).toList();
        _recommendedProducts.addAll(newProducts);
        _currentPage++;
        _hasMoreProducts = endIndex < _allProducts.length;
      } else {
        _hasMoreProducts = false;
      }
    } catch (e) {
      print('Error loading more products: $e');
    } finally {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  void _addToCart(Product product) async {
    var cartProvider = Provider.of<CartProvider>(context, listen: false);

    // Check if product is already in cart
    bool isInCart = cartProvider.cartList.any((item) => item.id == product.id);

    if (isInCart) {
      showCustomSnackBar('Product already in cart', context);
      return;
    }

    // Check if user is logged in
    if (!Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
      showDialog(context: context, builder: (_) => GuestDialog());
      return;
    }

    // Show loading state for this specific product
    setState(() {
      _productLoadingStates[product.id] = true;
    });

    try {
      // Create CartModel with proper parameters (same as product page)
      CartModel cart = CartModel(
        product.id ?? 0,
        product.thumbnail, // image
        product.name,
        product.addedBy == 'seller' ? 'seller' : 'admin', // seller
        product.unitPrice, // price
        product.unitPrice, // discountedPrice
        1, // quantity
        product.minQty ?? 1, // maxQuantity
        '', // variant
        '', // color
        "", // variation
        product.discount,
        product.discountType,
        product.tax,
        product.taxType,
        1, // shippingMethodId
        '', // cartGroupId
        product.userId, // sellerId
        '', // sellerIs
        product.thumbnail, // thumbnail
        '', // shopInfo
        product.choiceOptions ?? [],
        [], // variationIndexes
      );

      // Add to cart using the API method (same as product page)
      await cartProvider.addToCartAPI(
        cart,
        (success, message) {
          if (success) {
            showCustomSnackBar(getTranslated('added_to_cart', context), context,
                isError: false);
            // Refresh the cart data
            cartProvider.getCartDataAPI(context);
            // Refresh recommended products to hide the added product
            _refreshRecommendationsAfterCartUpdate();
          } else {
            showCustomSnackBar('Failed to add product: $message', context);
          }
        },
        context,
        product.choiceOptions ?? [],
        [],
      );
    } catch (e) {
      showCustomSnackBar('Error adding product to cart: $e', context);
    } finally {
      setState(() {
        _productLoadingStates[product.id] = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<CartProvider>(context, listen: false);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                Icon(
                  Icons.recommend,
                  color: Color(0xFFFF6B35),
                  size: 24,
                ),
                SizedBox(width: 12),
                Text(
                  cartProvider.cartList.isNotEmpty
                      ? 'Recommended for You'
                      : 'Discover Products',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
          ),

          // Products Grid
          if (_isLoading)
            ProductShimmer(isHomePage: false, isEnabled: true)
          else if (_recommendedProducts.isNotEmpty)
            Column(
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio:
                        0.8, // Increased aspect ratio to prevent overflow
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: _recommendedProducts.length,
                  itemBuilder: (context, index) {
                    return _buildProductCard(_recommendedProducts[index]);
                  },
                ),

                // Load More Button
                if (_hasMoreProducts && !_isLoadingMore)
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      children: [
                        SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: _loadMoreProducts,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFF6B35),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.expand_more, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Show More Products',
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

                // Loading More Indicator
                if (_isLoadingMore)
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Column(
                        children: [
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFFFF6B35)),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Loading more products...',
                            style: TextStyle(
                              color: Color(0xFF6C757D),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // End of products indicator
                if (!_hasMoreProducts && _recommendedProducts.isNotEmpty)
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: Text(
                        'All products loaded',
                        style: TextStyle(
                          color: Color(0xFF6C757D),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            )
          else
            Container(
              padding: EdgeInsets.symmetric(vertical: 32),
              child: Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xFFFF6B35)),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Loading more products...',
                      style: TextStyle(
                        color: Color(0xFF6C757D),
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 8),
                    TextButton(
                      onPressed: _loadRecommendedProducts,
                      child: Text(
                        'Retry',
                        style: TextStyle(
                          color: Color(0xFFFF6B35),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Container(
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
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetails(product: product),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Image.network(
                    '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productThumbnailUrl}/${product.thumbnail}',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      Images.placeholder,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Product Info
          Expanded(
            flex: 2,
            child: Container(
              padding:
                  EdgeInsets.all(10), // Reduced padding to prevent overflow
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetails(product: product),
                        ),
                      );
                    },
                    child: Text(
                      product.name ?? '',
                      style: TextStyle(
                        fontSize: 11, // Reduced font size to prevent overflow
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  SizedBox(height: 4), // Reduced spacing to prevent overflow

                  // Price and Add to Cart Button
                  Row(
                    children: [
                      Expanded(
                        child: _buildPriceWithDecimal(product.unitPrice ?? 0.0),
                      ),

                      // Easy Add to Cart Button
                      GestureDetector(
                        onTap: _productLoadingStates[product.id] == true
                            ? null
                            : () => _addToCart(product),
                        child: Container(
                          padding: EdgeInsets.all(
                              6), // Reduced padding to prevent overflow
                          decoration: BoxDecoration(
                            color: _productLoadingStates[product.id] == true
                                ? Color(0xFFFF6B35).withOpacity(0.6)
                                : Color(0xFFFF6B35),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: _productLoadingStates[product.id] == true
                              ? SizedBox(
                                  width: 14, // Reduced size to prevent overflow
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : Icon(
                                  Icons.add_shopping_cart,
                                  color: Colors.white,
                                  size: 14, // Reduced size to prevent overflow
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceWithDecimal(double price) {
    String priceString = price.toStringAsFixed(2);

    // Check if price has decimal part
    if (priceString.contains('.')) {
      // Split the price into whole and decimal parts
      List<String> parts = priceString.split('.');
      String wholePart = parts[0];
      String decimalPart = parts[1];

      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            wholePart,
            style: TextStyle(
              color: Color(0xFFFF6B35),
              fontSize: 14, // Reduced from 16 to prevent overflow
              fontWeight: FontWeight.w700,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '.$decimalPart',
                style: TextStyle(
                  color: Color(0xFFFF6B35),
                  fontSize: 10, // Reduced from 12 to prevent overflow
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'AED',
                style: TextStyle(
                  color: Color(0xFFFF6B35),
                  fontSize: 8, // Reduced from 10 to prevent overflow
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      );
    }

    // If no decimal part, return normal price with AED
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          priceString,
          style: TextStyle(
            color: Color(0xFFFF6B35),
            fontSize: 14, // Reduced from 16 to prevent overflow
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(width: 4),
        Text(
          'AED',
          style: TextStyle(
            color: Color(0xFFFF6B35),
            fontSize: 8, // Reduced from 10 to prevent overflow
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
