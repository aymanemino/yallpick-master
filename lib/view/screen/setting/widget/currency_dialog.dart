import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/brand_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/category_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/featured_deal_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/home_category_product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/localization_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/product_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/top_seller_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/button/custom_button.dart';
import 'package:provider/provider.dart';

class CurrencyDialog extends StatelessWidget {
  final bool isCurrency;
  final bool isSplash;
  final Function onPress;

  CurrencyDialog({this.isCurrency = true, this.isSplash = false, this.onPress});

  @override
  Widget build(BuildContext context) {
    int index;
    if (isCurrency) {
      index = Provider.of<SplashProvider>(context, listen: false).currencyIndex;
    } else {
      index = Provider.of<LocalizationProvider>(context, listen: false)
          .languageIndex;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
            isCurrency
                ? getTranslated('currency', context)
                : getTranslated('language', context),
            style: titilliumSemiBold.copyWith(
              fontSize: Dimensions.FONT_SIZE_OVER_LARGE,
              color: Colors.black,
            )),
        backgroundColor: Colors.white10,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_LARGE),
        child: Column(children: [
          SizedBox(
            height: 150,
            child: Consumer<SplashProvider>(
              builder: (context, splash, child) {
                List<String> _valueList = [];
                if (isCurrency) {
                  splash.configModel.currencyList
                      .forEach((currency) => _valueList.add(currency.name));
                } else {
                  AppConstants.languages.forEach(
                          (language) => _valueList.add(language.languageName));
                }
                return ListView.builder(
                  itemExtent: 40,
                  itemCount: _valueList.length,
                  itemBuilder: (context, i) => InkWell(
                    onTap: () {
                      index = i;
                      if (isCurrency) {
                        Provider.of<SplashProvider>(context, listen: false)
                            .setCurrency(index);
                      } else {
                        Provider.of<LocalizationProvider>(context,
                            listen: false)
                            .setLanguage(
                          Locale(
                            AppConstants.languages[index].languageCode,
                            AppConstants.languages[index].countryCode,
                          ),
                        );
                      }
                    },
                    child: index == i
                        ? Container(
                      decoration: BoxDecoration(
                        color: Color(0xff21BBF3FF),
                        borderRadius: BorderRadius.circular(
                            Dimensions.PADDING_SIZE_DEFAULT),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(
                            Dimensions.PADDING_SIZE_SMALL),
                        child: Row(
                          children: [
                            Text(
                              _valueList[i],
                              style: TextStyle(
                                fontWeight: isCurrency ? FontWeight.normal : FontWeight.bold, // Make language bold
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    .color,
                              ),
                            ),
                            Spacer(),
                            Icon(
                              Icons.done,
                              color: Colors.blue,
                            )
                          ],
                        ),
                      ),
                    )
                        : Row(
                      children: [
                        Text(
                          _valueList[i],
                          style: TextStyle(
                            fontWeight: isCurrency ? FontWeight.normal : FontWeight.bold, // Make language bold
                            color: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                .color,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              if (!isSplash)
                Expanded(
                  child: CustomButton(
                    onTap: () => Navigator.pop(context),
                    buttonText: getTranslated('CANCEL', context),
                  ),
                ),
              if (!isSplash)
                Container(
                  height: 50,
                  padding: EdgeInsets.symmetric(
                      vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  child: VerticalDivider(
                      width: Dimensions.PADDING_SIZE_EXTRA_SMALL,
                      color: Theme.of(context).hintColor),
                ),
              Expanded(
                child: CustomButton(
                  buttonText: getTranslated('GET_STARTED', context),
                  onTap: () {
                    if (isCurrency) {
                      Provider.of<SplashProvider>(context, listen: false)
                          .setCurrency(index);
                    } else {
                      Provider.of<LocalizationProvider>(context, listen: false)
                          .setLanguage(
                        Locale(
                          AppConstants.languages[index].languageCode,
                          AppConstants.languages[index].countryCode,
                        ),
                      );
                      Provider.of<CategoryProvider>(context, listen: false)
                          .getCategoryList(true, context);
                      Provider.of<HomeCategoryProductProvider>(context,
                          listen: false)
                          .getHomeCategoryProductList(true, context);
                      Provider.of<TopSellerProvider>(context, listen: false)
                          .getTopSellerList(true, context);
                      Provider.of<BrandProvider>(context, listen: false)
                          .getBrandList(true, context);
                      Provider.of<ProductProvider>(context, listen: false)
                          .getLatestProductList(1, context, reload: true);
                      Provider.of<ProductProvider>(context, listen: false)
                          .getFeaturedProductList('1', context, reload: true);
                      Provider.of<FeaturedDealProvider>(context, listen: false)
                          .getFeaturedDealList(true, context);
                      Provider.of<ProductProvider>(context, listen: false)
                          .getLProductList('1', context, reload: true);
                    }
                    Navigator.pop(context, true);
                    onPress();
                  },
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
