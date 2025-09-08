import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/helper/email_checker.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/contact_us_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/button/custom_button.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/textfield/custom_textfield.dart';
import 'package:provider/provider.dart';

class ContactUs extends StatefulWidget {
  final String title;
  ContactUs({required this.title});

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final FocusNode _nameNode = FocusNode();
  final FocusNode _emailNode = FocusNode();
  final FocusNode _subjectNode = FocusNode();
  final FocusNode _phoneNode = FocusNode();
  final FocusNode _messageNode = FocusNode();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(title: widget.title),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                child: Column(
                  children: [
                    SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_LARGE),
                    Image.asset(
                      'assets/images/contact_banner.png',
                      width: MediaQuery.of(context).size.width * 0.8,
                    ),
                    SizedBox(height: Dimensions.MARGIN_SIZE_EXTRA_LARGE),
                    Text(getTranslated('send_us_a_message', context),
                        style: titilliumBold.copyWith(
                            fontSize: Dimensions.FONT_SIZE_OVER_LARGE)),

                    SizedBox(height: Dimensions.MARGIN_SIZE_LARGE),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        getTranslated('your_name', context),
                        style: robotoRegular.copyWith(
                            color: ColorResources.getHint(context)),
                      ),
                    ),
                    SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                    CustomTextField(
                      hintText: 'John Doe',
                      textInputType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      focusNode: _nameNode,
                      nextNode: _emailNode,
                      controller: _nameController,
                    ),
                    SizedBox(height: Dimensions.MARGIN_SIZE_DEFAULT),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        getTranslated('email_address', context),
                        style: robotoRegular.copyWith(
                            color: ColorResources.getHint(context)),
                      ),
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    CustomTextField(
                      hintText: 'johndoe@email.com',
                      textInputType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      focusNode: _emailNode,
                      nextNode: _phoneNode,
                      controller: _emailController,
                    ),
                    SizedBox(height: Dimensions.MARGIN_SIZE_DEFAULT),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        getTranslated('your_phone', context),
                        style: robotoRegular.copyWith(
                            color: ColorResources.getHint(context)),
                      ),
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    CustomTextField(
                      hintText: getTranslated('contact_no', context),
                      textInputType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      isPhoneNumber: true,
                      focusNode: _phoneNode,
                      nextNode: _subjectNode,
                      controller: _phoneController,
                    ),
                    SizedBox(height: Dimensions.MARGIN_SIZE_DEFAULT),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        getTranslated('subject', context),
                        style: robotoRegular.copyWith(
                            color: ColorResources.getHint(context)),
                      ),
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    CustomTextField(
                      hintText: getTranslated('short_title', context),
                      textInputType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      focusNode: _subjectNode,
                      nextNode: _messageNode,
                      controller: _subjectController,
                    ),
                    SizedBox(height: Dimensions.MARGIN_SIZE_DEFAULT),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        getTranslated('message', context),
                        style: robotoRegular.copyWith(
                            color: ColorResources.getHint(context)),
                      ),
                    ),
                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                    CustomTextField(
                      height: 100,
                      textInputType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      maxLine: 5,
                      focusNode: _messageNode,
                      controller: _messageController,
                    ),
                    SizedBox(height: Dimensions.MARGIN_SIZE_LARGE),
                    Consumer<ContactUsProvider>(
                        builder: (ctx, contactUsProvider, child) {
                      return !contactUsProvider.isLoading
                          ? CustomButton(
                              buttonText: getTranslated('send', context),
                              onTap: () {
                                if (_nameController.text.trim().isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              getTranslated(
                                                  'enter_your_name', context),
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          backgroundColor: Colors.red));
                                } else if (_emailController.text
                                    .trim()
                                    .isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              getTranslated(
                                                  'ENTER_YOUR_EMAIL', context),
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          backgroundColor: Colors.red));
                                } else if (EmailChecker.isNotValid(
                                    _emailController.text.trim())) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              getTranslated(
                                                  'enter_valid_email_address',
                                                  context),
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          backgroundColor: Colors.red));
                                } else if (_phoneController.text
                                    .trim()
                                    .isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              getTranslated(
                                                  'enter_phone_number',
                                                  context),
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          backgroundColor: Colors.red));
                                } else if (_subjectController.text
                                    .trim()
                                    .isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              getTranslated(
                                                  'enter_subject', context),
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          backgroundColor: Colors.red));
                                } else if (_messageController.text
                                    .trim()
                                    .isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              getTranslated(
                                                  'enter_message', context),
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          backgroundColor: Colors.red));
                                } else {
                                  contactUsProvider.sendData(context,
                                      name: _nameController.text.trim(),
                                      email: _emailController.text.trim(),
                                      phone: _phoneController.text.trim(),
                                      subject: _subjectController.text.trim(),
                                      message: _messageController.text.trim());
                                }
                              },
                            )
                          : Center(
                              child: CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  Theme.of(context).primaryColor),
                            ));
                    }),
                    SizedBox(height: Dimensions.MARGIN_SIZE_LARGE),

                    // Provider.of<SplashProvider>(context).configModel.faq != null &&
                    //         Provider.of<SplashProvider>(context).configModel.faq?.length ?? 0 >
                    //             0
                    //     ? Expanded(
                    //         child: ListView.builder(
                    //             itemCount: Provider.of<SplashProvider>(context)
                    //                 .configModel
                    //                 .faq
                    //                 .length,
                    //             itemBuilder: (ctx, index) {
                    //               return Consumer<SplashProvider>(
                    //                 builder: (ctx, faq, child) {
                    //                   return Column(
                    //                     crossAxisAlignment: CrossAxisAlignment.start,
                    //                     children: [
                    //                       Row(
                    //                         children: [
                    //                           Flexible(
                    //                               child: ExpansionTile(
                    //                             iconColor: Theme.of(context).primaryColor,
                    //                             title: Text(
                    //                                 faq.configModel.faq?[index].question ?? "",
                    //                                 style: robotoBold.copyWith(
                    //                                     color:
                    //                                         ColorResources.getTextTitle(
                    //                                             context))),
                    //                             leading: Icon(
                    //                                 Icons.collections_bookmark_outlined,
                    //                                 color: ColorResources.getTextTitle(
                    //                                     context)),
                    //                             children: <Widget>[
                    //                               Padding(
                    //                                 padding: const EdgeInsets.all(8.0),
                    //                                 child: Text(
                    //                                   faq.configModel.faq?[index].answer ?? "",
                    //                                   style: robotoRegular,
                    //                                   textAlign: TextAlign.justify,
                    //                                 ),
                    //                               )
                    //                             ],
                    //                           )),
                    //                         ],
                    //                       ),
                    //                     ],
                    //                   );
                    //                 },
                    //               );
                    //             }),
                    //       )
                    //     : NoInternetOrDataScreen(isNoInternet: false)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
