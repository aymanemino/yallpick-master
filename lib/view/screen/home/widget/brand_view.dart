import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/provider/brand_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/brand_and_category_product_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class BrandView extends StatelessWidget {
  final bool isHomePage;

  BrandView({@required this.isHomePage});

  @override
  Widget build(BuildContext context) {
    return Consumer<BrandProvider>(
      builder: (context, brandProvider, child) {
        // Shuffle the list of brands
        brandProvider.brandList.shuffle();

        return brandProvider.brandList.length != 0
            ? GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: (1 / 1.3),
            mainAxisSpacing: 10,
            crossAxisSpacing: 5,
          ),
          itemCount: brandProvider.brandList.length != 0
              ? isHomePage
              ? brandProvider.brandList.length > 8
              ? 4
              : brandProvider.brandList.length
              : brandProvider.brandList.length
              : 8,
          shrinkWrap: true,
          physics: isHomePage
              ? NeverScrollableScrollPhysics()
              : BouncingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BrandAndCategoryProductScreen(
                      isBrand: true,
                      id: brandProvider.brandList[index].id.toString(),
                      name: brandProvider.brandList[index].name,
                      image: brandProvider.brandList[index].image,
                    ),
                  ),
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.zero, // Remove padding to ensure maximum available space
                      margin: EdgeInsets.zero,  // Remove margin so the image takes full available space
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).highlightColor, // White background
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.15),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10), // Keep rounded corners for the container
                        child: Image.network(
                          Provider.of<SplashProvider>(context, listen: false)
                              .baseUrls
                              .brandImageUrl +
                              '/' +
                              brandProvider.brandList[index].image,
                          fit: BoxFit.contain,  // Ensures image fits fully inside without distortion or pixelation
                          width: double.infinity, // Ensure the image takes the full width
                          height: double.infinity, // Ensure the image takes the full height
                          errorBuilder: (context, error, stackTrace) => Icon(Icons.error), // Show an error icon if the image fails to load
                          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                    ),




                  ),
                  SizedBox(
                    height: (MediaQuery.of(context).size.width / 4) * 0.3,
                    child: Center(
                      child: Text(
                        brandProvider.brandList[index].name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: titilliumSemiBold.copyWith(
                          fontSize: Dimensions.FONT_SIZE_SMALL,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        )
            : BrandShimmer(isHomePage: isHomePage);
      },
    );
  }
}

class BrandShimmer extends StatelessWidget {
  final bool isHomePage;

  BrandShimmer({@required this.isHomePage});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: (1 / 1.3),
        mainAxisSpacing: 10,
        crossAxisSpacing: 5,
      ),
      itemCount: isHomePage ? 8 : 30,
      shrinkWrap: true,
      physics: isHomePage ? NeverScrollableScrollPhysics() : null,
      itemBuilder: (BuildContext context, int index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          enabled: Provider.of<BrandProvider>(context).brandList.length == 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorResources.WHITE,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Container(
                height: 10,
                color: ColorResources.WHITE,
                margin: EdgeInsets.only(left: 25, right: 25),
              ),
            ],
          ),
        );
      },
    );
  }
}
