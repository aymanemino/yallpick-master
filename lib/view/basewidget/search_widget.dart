import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/provider/category_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/search_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/theme_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:provider/provider.dart';


class SearchWidget extends StatefulWidget {
  final String hintText;
  final Function onTextChanged;
  final Function onClearPressed;
  final Function onSubmit;
  final Function onCategoryIdChange;

  SearchWidget(
      {required this.hintText,
        this.onTextChanged,
        required this.onClearPressed,
        required this.onCategoryIdChange,
        this.onSubmit});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    Provider.of<CategoryProvider>(context, listen: false)
        .getCategoryList(true, context);
    // Provider.of<BrandProvider>(context, listen: false)
    //     .getBrandList(true, context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white,
            Colors.orange.shade50,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.15),
            blurRadius: 12,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.orange.withOpacity(0.05),
            blurRadius: 20,
            offset: Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(children: [
        // Back button with modern styling
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.orange.shade400,
                Colors.orange.shade600,
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withOpacity(0.3),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded,
                size: 18, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
          ),
        ),
        SizedBox(width: 12),
        // Modern search box
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.orange.shade50,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.orange.withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.15),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.orange.withOpacity(0.05),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              children: [
                // Modern search icon
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.orange.shade400,
                        Colors.orange.shade600,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.3),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child:
                  Icon(Icons.search_rounded, color: Colors.white, size: 18),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    onFieldSubmitted: (query) {
                      widget.onSubmit(query);
                    },
                    onChanged: (query) {
                      widget.onTextChanged(query);
                      setState(
                            () {
                          _controller.selection = TextSelection.fromPosition(
                              TextPosition(offset: _controller.text.length));
                        },
                      );
                    },
                    textInputAction: TextInputAction.search,
                    maxLines: 1,
                    textAlignVertical: TextAlignVertical.center,
                    style: robotoRegular.copyWith(
                      color: Colors.orange.shade800,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                      isDense: true,
                      hintStyle: robotoRegular.copyWith(
                        color: Colors.orange.shade600,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      border: InputBorder.none,
                      suffixIcon: Provider.of<SearchProvider>(context)
                          .searchText
                          .isNotEmpty
                          ? Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.clear_rounded,
                              color: Colors.orange.shade700, size: 16),
                          onPressed: () {
                            widget.onClearPressed();
                            _controller.clear();
                          },
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                        ),
                      )
                          : _controller.text.isNotEmpty
                          ? Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.clear_rounded,
                              color: Colors.orange.shade700,
                              size: 16),
                          onPressed: () {
                            widget.onClearPressed();
                            _controller.clear();
                          },
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                        ),
                      )
                          : ""
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
