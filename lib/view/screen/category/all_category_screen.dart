import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/category.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/category_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/splash_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/product/brand_and_category_product_screen.dart';
import 'package:provider/provider.dart';

class AllCategoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      body: Column(
        children: [
          CustomAppBar(title: getTranslated('CATEGORY', context)),
          Expanded(child: Consumer<CategoryProvider>(
            builder: (context, categoryProvider, child) {
              return categoryProvider.categoryList.length != 0
                  ? Row(children: [
                // Left Sidebar - Main Categories
                Container(
                  width: 120,
                  margin: EdgeInsets.only(top: 8, left: 8, bottom: 8),
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                          color: Color(0xFFE9ECEF).withOpacity(0.8),
                          spreadRadius: 1,
                          blurRadius: 8,
                          offset: Offset(0, 2))
                    ],
                  ),
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: categoryProvider.categoryList.length,
                    padding: EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      Category _category =
                      categoryProvider.categoryList[index];
                      return InkWell(
                        onTap: () {
                          Provider.of<CategoryProvider>(context,
                              listen: false)
                              .changeSelectedIndex(index);
                        },
                        child: CategoryItem(
                          title: _category.name,
                          icon: _category.icon,
                          isSelected:
                          categoryProvider.categorySelectedIndex ==
                              index,
                        ),
                      );
                    },
                  ),
                ),

                // Right Side - Subcategories and Sub-subcategories
                Expanded(
                    child: Container(
                        margin:
                        EdgeInsets.only(top: 8, right: 8, bottom: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                                color: Color(0xFFE9ECEF).withOpacity(0.8),
                                spreadRadius: 1,
                                blurRadius: 8,
                                offset: Offset(0, 2))
                          ],
                        ),
                        child: ListView.builder(
                          padding: EdgeInsets.all(16),
                          itemCount: categoryProvider
                              .categoryList[categoryProvider
                              .categorySelectedIndex]
                              .subCategories
                              .length +
                              1,
                          itemBuilder: (context, index) {
                            SubCategory _subCategory;
                            if (index != 0) {
                              _subCategory = categoryProvider
                                  .categoryList[categoryProvider
                                  .categorySelectedIndex]
                                  .subCategories[index - 1];
                            }
                            if (index == 0) {
                              return _buildAllCategoryTile(
                                  context, categoryProvider);
                            } else if (_subCategory
                                .subSubCategories.length !=
                                0) {
                              return _buildSubCategoryWithSubSubCategories(
                                  context, _subCategory);
                            } else {
                              return _buildSubCategoryTile(context,
                                  _subCategory, categoryProvider);
                            }
                          },
                        ))),
              ])
                  : Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFFFF6B35))));
            },
          )),
        ],
      ),
    );
  }

  Widget _buildAllCategoryTile(
      BuildContext context, CategoryProvider categoryProvider) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFF6B35), Color(0xFFFF8A65)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFFF6B35).withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BrandAndCategoryProductScreen(
                  isBrand: false,
                  id: categoryProvider
                      .categoryList[categoryProvider.categorySelectedIndex].id
                      .toString(),
                  name: categoryProvider
                      .categoryList[categoryProvider.categorySelectedIndex]
                      .name,
                  subcategory: categoryProvider
                      .categoryList[categoryProvider.categorySelectedIndex]
                      .subCategories,
                ),
              ),
            );
          },
          child: Container(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.category,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getTranslated('all', context),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${categoryProvider.categoryList[categoryProvider.categorySelectedIndex].subCategories.length} subcategories',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubCategoryTile(BuildContext context, SubCategory subCategory,
      CategoryProvider categoryProvider) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0xFFE9ECEF),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => BrandAndCategoryProductScreen(
                      isBrand: false,
                      id: subCategory.id.toString(),
                      name: subCategory.name,
                      subcategory: categoryProvider
                          .categoryList[
                      categoryProvider.categorySelectedIndex]
                          .subCategories,
                    )));
          },
          child: Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                // Subcategory Image
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Color(0xFFE2F0FF),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Color(0xFFE9ECEF),
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child:
                    subCategory.icon != null && subCategory.icon.isNotEmpty
                        ? FadeInImage.assetNetwork(
                      placeholder: Images.placeholder,
                      fit: BoxFit.cover,
                      image:
                      '${Provider.of<SplashProvider>(context, listen: false).baseUrls.categoryImageUrl}/${subCategory.icon}',
                      imageErrorBuilder: (c, o, s) => Icon(
                        Icons.category,
                        color: Color(0xFF92C6FF),
                        size: 24,
                      ),
                    )
                        : Icon(
                      Icons.category,
                      color: Color(0xFF92C6FF),
                      size: 24,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subCategory.name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Tap to explore',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9E9E9E),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFF9E9E9E),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubCategoryWithSubSubCategories(
      BuildContext context, SubCategory subCategory) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Color(0xFFE9ECEF),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFE9ECEF).withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Provider.of<ThemeProvider>(context).darkTheme
            ? ThemeData.dark()
            : ThemeData.light(),
        child: ExpansionTile(
          key: Key(
              '${Provider.of<CategoryProvider>(context).categorySelectedIndex}${subCategory.id}'),
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xFFE2F0FF),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Color(0xFFE9ECEF),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: subCategory.icon != null && subCategory.icon.isNotEmpty
                  ? FadeInImage.assetNetwork(
                placeholder: Images.placeholder,
                fit: BoxFit.cover,
                image:
                '${Provider.of<SplashProvider>(context, listen: false).baseUrls.categoryImageUrl}/${subCategory.icon}',
                imageErrorBuilder: (c, o, s) => Icon(
                  Icons.category,
                  color: Color(0xFF92C6FF),
                  size: 20,
                ),
              )
                  : Icon(
                Icons.category,
                color: Color(0xFF92C6FF),
                size: 20,
              ),
            ),
          ),
          title: Text(
            subCategory.name,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          subtitle: Text(
            '${subCategory.subSubCategories.length} items',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF9E9E9E),
            ),
          ),
          children: _getSubSubCategories(context, subCategory),
        ),
      ),
    );
  }

  List<Widget> _getSubSubCategories(
      BuildContext context, SubCategory subCategory) {
    List<Widget> _subSubCategories = [];

    // Add "All" option
    _subSubCategories.add(Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xFFFF6B35).withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Color(0xFFFF6B35).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Color(0xFFFF6B35),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.all_inclusive,
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          getTranslated('all', context),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFFFF6B35),
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BrandAndCategoryProductScreen(
                isBrand: false,
                id: subCategory.id.toString(),
                name: subCategory.name,
                subcategory: List<SubCategory>.from(
                  subCategory.subSubCategories.map(
                        (e) => SubCategory(
                      id: e.id ?? 0,
                      name: e.name,
                      slug: e.slug,
                      icon: e.icon,
                      parentId: e.parentId,
                      position: e.position,
                      createdAt: e.createdAt,
                      updatedAt: e.updatedAt,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ));

    // Add sub-subcategories
    for (int index = 0; index < subCategory.subSubCategories.length; index++) {
      _subSubCategories.add(Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Color(0xFFE9ECEF),
            width: 1,
          ),
        ),
        child: ListTile(
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(0xFFE2F0FF),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Color(0xFFE9ECEF),
                width: 1,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: subCategory.subSubCategories[index].icon != null &&
                  subCategory.subSubCategories[index].icon.isNotEmpty
                  ? FadeInImage.assetNetwork(
                placeholder: Images.placeholder,
                fit: BoxFit.cover,
                image:
                '${Provider.of<SplashProvider>(context, listen: false).baseUrls.categoryImageUrl}/${subCategory.subSubCategories[index].icon}',
                imageErrorBuilder: (c, o, s) => Icon(
                  Icons.category,
                  color: Color(0xFF92C6FF),
                  size: 18,
                ),
              )
                  : Icon(
                Icons.category,
                color: Color(0xFF92C6FF),
                size: 18,
              ),
            ),
          ),
          title: Text(
            subCategory.subSubCategories[index].name,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1A1A),
            ),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Color(0xFF9E9E9E),
            size: 14,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BrandAndCategoryProductScreen(
                  isBrand: false,
                  id: subCategory.subSubCategories[index].id.toString(),
                  name: subCategory.subSubCategories[index].name,
                  subcategory: List<SubCategory>.from(
                    subCategory.subSubCategories.map(
                          (e) => SubCategory(
                        id: e.id ?? 0,
                        name: e.name,
                        slug: e.slug,
                        icon: e.icon,
                        parentId: e.parentId,
                        position: e.position,
                        createdAt: e.createdAt,
                        updatedAt: e.updatedAt,
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ));
    }
    return _subSubCategories;
  }
}

class CategoryItem extends StatelessWidget {
  final String title;
  final String icon;
  final bool isSelected;

  CategoryItem(
      {@required this.title, @required this.icon, @required this.isSelected});

  Widget build(BuildContext context) {
    return Container(
      width: 104,
      height: 104,
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isSelected ? Color(0xFFFF6B35) : Colors.white,
        border: Border.all(
          color: isSelected ? Color(0xFFFF6B35) : Color(0xFFE9ECEF),
          width: 2,
        ),
        boxShadow: isSelected
            ? [
          BoxShadow(
            color: Color(0xFFFF6B35).withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ]
            : [
          BoxShadow(
            color: Color(0xFFE9ECEF).withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child:
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      width: 2,
                      color:
                      isSelected ? Color(0xFFFF6B35) : Color(0xFFE9ECEF)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: FadeInImage.assetNetwork(
                    placeholder: Images.placeholder,
                    fit: BoxFit.cover,
                    image:
                    '${Provider.of<SplashProvider>(context, listen: false).baseUrls.categoryImageUrl}/$icon',
                    imageErrorBuilder: (c, o, s) => Icon(
                      Icons.category,
                      color: isSelected ? Color(0xFFFF6B35) : Color(0xFF9E9E9E),
                      size: 24,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Text(title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : Color(0xFF1A1A1A),
                    )),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
