import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/helper/product_type.dart';
import 'package:flutter_sixvalley_ecommerce/provider/localization_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/home/widget/products_view.dart';
import 'package:provider/provider.dart';

class AllProductScreen extends StatefulWidget {
  final ProductType productType;
  AllProductScreen({@required this.productType});

  @override
  _AllProductScreenState createState() => _AllProductScreenState();
}

class _AllProductScreenState extends State<AllProductScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadData(context, false);
  }

  Future<void> _loadData(BuildContext context, bool reload) async {
    await Provider.of<ProductProvider>(context, listen: false)
        .getLatestProductList(1, context, reload: reload);  // Corrected call
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.getHomeBg(context),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Provider.of<ThemeProvider>(context).darkTheme
            ? Colors.black
            : Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(5),
                bottomLeft: Radius.circular(5))),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              size: 20, color: ColorResources.WHITE),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
            widget.productType == ProductType.FEATURED_PRODUCT
                ? 'Featured Product'
                : 'Latest Product',
            style: titilliumRegular.copyWith(
                fontSize: 20, color: ColorResources.WHITE)),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          backgroundColor: Theme.of(context).primaryColor,
          onRefresh: () async {
            await _loadData(context, true);
            return true;
          },
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: ProductView(
                      isHomePage: false,
                      productType: widget.productType,
                      scrollController: _scrollController),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
