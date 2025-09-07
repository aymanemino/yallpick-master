import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/address_model.dart';
import 'package:flutter_sixvalley_ecommerce/data/model/response/city_model.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/location_provider.dart';
import 'package:flutter_sixvalley_ecommerce/provider/profile_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/button/custom_button.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/my_dialog.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/textfield/custom_textfield.dart';
import 'package:flutter_sixvalley_ecommerce/view/screen/address/select_location_screen.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class AddNewAddressScreen extends StatefulWidget {
  final bool isEnableUpdate;
  final bool fromCheckout;
  final AddressModel address;
  final bool isBilling;

  AddNewAddressScreen(
      {this.isEnableUpdate = false,
      this.address,
      this.fromCheckout = false,
      this.isBilling});

  @override
  State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  final TextEditingController _contactPersonNameController =
      TextEditingController();
  final TextEditingController _contactPersonNumberController =
      TextEditingController();

  // final TextEditingController _cityController = TextEditingController();
  String selectedCity = '';
  final TextEditingController _zipCodeController = TextEditingController();
  final FocusNode _addressNode = FocusNode();
  final FocusNode _nameNode = FocusNode();
  final FocusNode _numberNode = FocusNode();
  final FocusNode _cityNode = FocusNode();
  final FocusNode _zipNode = FocusNode();
  late GoogleMapController _controller;
  late CameraPosition _cameraPosition;
  bool _updateAddress = true;

  final addressCities = <AddressCity>[];

  @override
  void initState() {
    super.initState();
    Provider.of<LocationProvider>(context, listen: false)
        .initializeAllAddressType(context: context);
    Provider.of<LocationProvider>(context, listen: false)
        .updateAddressStatusMessae(message: '');
    Provider.of<LocationProvider>(context, listen: false)
        .updateErrorMessage(message: '');
    Provider.of<ProfileProvider>(context, listen: false)
        .getAllCity()
        .then((value) => setState(() {
              addressCities.clear();
              addressCities.addAll(value);
            }));
    _checkPermission(
        () => Provider.of<LocationProvider>(context, listen: false)
            .getCurrentLocation(context, true, mapController: _controller),
        context);
    if (widget.isEnableUpdate && widget.address != null) {
      _updateAddress = false;
      Provider.of<LocationProvider>(context, listen: false).updatePosition(
          CameraPosition(
              target: LatLng(double.parse(widget.address.latitude ?? "0"),
                  double.parse(widget.address.longitude ?? "0"))),
          true,
          widget.address.address ?? "",
          context);
      _contactPersonNameController.text = '${widget.address.contactPersonName}';
      _contactPersonNumberController.text = '${widget.address.phone}';
      if (widget.address.addressType == 'Home') {
        Provider.of<LocationProvider>(context, listen: false)
            .updateAddressIndex(0, false);
      } else if (widget.address.addressType == 'Workplace') {
        Provider.of<LocationProvider>(context, listen: false)
            .updateAddressIndex(1, false);
      } else {
        Provider.of<LocationProvider>(context, listen: false)
            .updateAddressIndex(2, false);
      }
    } else {
      if (Provider.of<ProfileProvider>(context, listen: false).userInfoModel !=
          null) {
        _contactPersonNameController.text =
            '${Provider.of<ProfileProvider>(context, listen: false).userInfoModel.fName ?? ''}'
            ' ${Provider.of<ProfileProvider>(context, listen: false).userInfoModel.lName ?? ''}';
        _contactPersonNumberController.text =
            Provider.of<ProfileProvider>(context, listen: false)
                    .userInfoModel
                    .phone ??
                '';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<ProfileProvider>(context, listen: false)
        .initAddressList(context);
    Provider.of<ProfileProvider>(context, listen: false)
        .initAddressTypeList(context);

    return Scaffold(
      backgroundColor: Colors.grey[50]!!,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            // Dismiss keyboard when tapping outside of the text fields
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomAppBar(
                    title: widget.isEnableUpdate
                        ? getTranslated('update_address', context)
                        : getTranslated('add_new_address', context)),
                Consumer<LocationProvider>(
                  builder: (context, locationProvider, child) {
                    return Container(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                        children: [
                          Expanded(
                            child: Scrollbar(
                              child: SingleChildScrollView(
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Map Section
                                    Container(
                                      margin: EdgeInsets.only(bottom: 20),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            blurRadius: 10,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 200,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(16),
                                                topRight: Radius.circular(16),
                                              ),
                                              child: Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  GoogleMap(
                                                    mapType: MapType.normal,
                                                    initialCameraPosition:
                                                        CameraPosition(
                                                      target: widget
                                                              .isEnableUpdate
                                                          ? LatLng(
                                                              double.parse(widget
                                                                      .address
                                                                      .latitude ?? "0") ??
                                                                  0.0,
                                                              double.parse(widget
                                                                      .address
                                                                      .longitude ?? "0") ??
                                                                  0.0)
                                                          : LatLng(
                                                              locationProvider
                                                                      .position
                                                                      .latitude ??
                                                                  0.0,
                                                              locationProvider
                                                                      .position
                                                                      .longitude ??
                                                                  0.0),
                                                      zoom: 17,
                                                    ),
                                                    onTap: (latLng) {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (BuildContext
                                                                      context) =>
                                                                  SelectLocationScreen(
                                                                      googleMapController:
                                                                          _controller)));
                                                    },
                                                    zoomControlsEnabled: false,
                                                    compassEnabled: false,
                                                    indoorViewEnabled: true,
                                                    mapToolbarEnabled: false,
                                                    onCameraIdle: () {
                                                      if (_updateAddress) {
                                                        locationProvider
                                                            .updatePosition(
                                                                _cameraPosition,
                                                                true,
                                                                ""
                                                                context);
                                                      } else {
                                                        _updateAddress = true;
                                                      }
                                                    },
                                                    onCameraMove:
                                                        ((_position) =>
                                                            _cameraPosition =
                                                                _position),
                                                    onMapCreated:
                                                        (GoogleMapController
                                                            controller) {
                                                      _controller = controller;
                                                      if (!widget
                                                              .isEnableUpdate &&
                                                          _controller != null) {
                                                        Provider.of<LocationProvider>(
                                                                context,
                                                                listen: false)
                                                            .getCurrentLocation(
                                                                context, true,
                                                                mapController:
                                                                    _controller);
                                                      }
                                                    },
                                                  ),
                                                  locationProvider.loading
                                                      ? Center(
                                                          child: CircularProgressIndicator(
                                                              valueColor:
                                                                  AlwaysStoppedAnimation<
                                                                          Color>(
                                                                      Color(
                                                                          0xFFFF6B35))))
                                                      : SizedBox(),
                                                  Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                      alignment:
                                                          Alignment.center,
                                                      height: 200,
                                                      child: Icon(
                                                        Icons.location_on,
                                                        size: 40,
                                                        color:
                                                            Color(0xFFFF6B35),
                                                      )),
                                                  Positioned(
                                                    bottom: 15,
                                                    right: 15,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.1),
                                                            blurRadius: 8,
                                                            offset:
                                                                Offset(0, 2),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Material(
                                                        color:
                                                            Colors.transparent,
                                                        child: InkWell(
                                                          onTap: () {
                                                            _checkPermission(
                                                                () => locationProvider
                                                                    .getCurrentLocation(
                                                                        context,
                                                                        true,
                                                                        mapController:
                                                                            _controller),
                                                                context);
                                                          },
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          child: Container(
                                                            width: 48,
                                                            height: 48,
                                                            child: Icon(
                                                              Icons.my_location,
                                                              color: Color(
                                                                  0xFFFF6B35),
                                                              size: 24,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 15,
                                                    right: 15,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.1),
                                                            blurRadius: 8,
                                                            offset:
                                                                Offset(0, 2),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Material(
                                                        color:
                                                            Colors.transparent,
                                                        child: InkWell(
                                                          onTap: () {
                                                            Navigator.of(context).push(MaterialPageRoute(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    SelectLocationScreen(
                                                                        googleMapController:
                                                                            _controller)));
                                                          },
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          child: Container(
                                                            width: 48,
                                                            height: 48,
                                                            child: Icon(
                                                              Icons.fullscreen,
                                                              color: Color(
                                                                  0xFFFF6B35),
                                                              size: 24,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.all(16),
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding: EdgeInsets.all(8),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFFFF6B35)
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Icon(
                                                    Icons.info_outline,
                                                    color: Color(0xFFFF6B35),
                                                    size: 20,
                                                  ),
                                                ),
                                                SizedBox(width: 12),
                                                Expanded(
                                                  child: Text(
                                                    getTranslated(
                                                        'add_the_location_correctly',
                                                        context),
                                                    style: TextStyle(
                                                      color: Colors.grey[700]!!,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Address Type Selection
                                    Container(
                                      margin: EdgeInsets.only(bottom: 20),
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            blurRadius: 10,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFFF6B35)
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Icon(
                                                  Icons.label,
                                                  color: Color(0xFFFF6B35),
                                                  size: 20,
                                                ),
                                              ),
                                              SizedBox(width: 12),
                                              Text(
                                                getTranslated(
                                                    'label_us', context),
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 16),
                                          Container(
                                            height: 50,
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              physics: BouncingScrollPhysics(),
                                              itemCount: locationProvider
                                                  .getAllAddressType.length,
                                              itemBuilder: (context, index) =>
                                                  Container(
                                                margin:
                                                    EdgeInsets.only(right: 12),
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    onTap: () {
                                                      locationProvider
                                                          .updateAddressIndex(
                                                              index, true);
                                                    },
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 20,
                                                              vertical: 12),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                        color: locationProvider
                                                                    .selectAddressIndex ==
                                                                index
                                                            ? Color(0xFFFF6B35)
                                                            : Colors.grey[100]!!,
                                                        border: Border.all(
                                                          color: locationProvider
                                                                      .selectAddressIndex ==
                                                                  index
                                                              ? Color(
                                                                  0xFFFF6B35)
                                                              : Colors
                                                                  .grey[300],
                                                          width: 1,
                                                        ),
                                                      ),
                                                      child: Text(
                                                        getTranslated(
                                                            locationProvider
                                                                .getAllAddressType[
                                                                    index]
                                                                .toLowerCase(),
                                                            context),
                                                        style: TextStyle(
                                                          color: locationProvider
                                                                      .selectAddressIndex ==
                                                                  index
                                                              ? Colors.white
                                                              : Colors
                                                                  .grey[700],
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Delivery Address Form
                                    Container(
                                      margin: EdgeInsets.only(bottom: 20),
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            blurRadius: 10,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFFF6B35)
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Icon(
                                                  Icons.location_city,
                                                  color: Color(0xFFFF6B35),
                                                  size: 20,
                                                ),
                                              ),
                                              SizedBox(width: 12),
                                              Text(
                                                getTranslated(
                                                    'delivery_address',
                                                    context),
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 20),
                                          // Address Field
                                          Text(
                                            getTranslated(
                                                'address_line_01', context),
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[700]!!,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[50]!!,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: Color(0xFFFF6B35)
                                                    .withOpacity(0.2),
                                                width: 1,
                                              ),
                                            ),
                                            child: TextField(
                                              controller: locationProvider
                                                  .locationController,
                                              focusNode: _addressNode,
                                              textInputAction:
                                                  TextInputAction.next,
                                              keyboardType:
                                                  TextInputType.streetAddress,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black87,
                                              ),
                                              decoration: InputDecoration(
                                                hintText: getTranslated(
                                                    'address_line_02', context),
                                                hintStyle: TextStyle(
                                                  color: Colors.grey[600]!!,
                                                  fontSize: 14,
                                                ),
                                                border: InputBorder.none,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          // City Field
                                          Text(
                                            getTranslated('city', context),
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[700]!!,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[50]!!,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: Color(0xFFFF6B35)
                                                    .withOpacity(0.2),
                                                width: 1,
                                              ),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16),
                                            child: DropdownButton(
                                              value: selectedCity,
                                              isExpanded: true,
                                              underline: SizedBox.shrink(),
                                              hint: Text(
                                                getTranslated('city', context),
                                                style: TextStyle(
                                                  color: Colors.grey[600]!!,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              items: addressCities
                                                  .map(
                                                    (e) => DropdownMenuItem(
                                                      value: e.name,
                                                      child: Text(
                                                        e.name,
                                                        style: TextStyle(
                                                          color: Colors.black87,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                              onChanged: (v) {
                                                setState(() {
                                                  selectedCity = v.toString();
                                                });
                                              },
                                            ),
                                          ),
                                          // CustomTextField(
                                          //   hintText: getTranslated('city', context),
                                          //   textInputType: TextInputType.streetAddress,
                                          //   textInputAction: TextInputAction.next,
                                          //   focusNode: _cityNode,
                                          //   nextNode: _zipNode,
                                          //   controller: _cityController,
                                          // ),
                                          SizedBox(height: 16),
                                          // Zip Code Field
                                          Text(
                                            getTranslated(
                                                'address_line_03', context),
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[700]!!,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[50]!!,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: Color(0xFFFF6B35)
                                                    .withOpacity(0.2),
                                                width: 1,
                                              ),
                                            ),
                                            child: TextField(
                                              controller: _zipCodeController,
                                              focusNode: _zipNode,
                                              textInputAction:
                                                  TextInputAction.next,
                                              keyboardType: TextInputType.text,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black87,
                                              ),
                                              decoration: InputDecoration(
                                                hintText: getTranslated(
                                                    'address_line_02', context),
                                                hintStyle: TextStyle(
                                                  color: Colors.grey[600]!!,
                                                  fontSize: 14,
                                                ),
                                                border: InputBorder.none,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Contact Information
                                    Container(
                                      margin: EdgeInsets.only(bottom: 20),
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            blurRadius: 10,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: Color(0xFFFF6B35)
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Icon(
                                                  Icons.person,
                                                  color: Color(0xFFFF6B35),
                                                  size: 20,
                                                ),
                                              ),
                                              SizedBox(width: 12),
                                              Text(
                                                getTranslated(
                                                    'contact_person_name',
                                                    context),
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 20),
                                          // Contact Person Name
                                          Text(
                                            getTranslated(
                                                'contact_person_name', context),
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[700]!!,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[50]!!,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: Color(0xFFFF6B35)
                                                    .withOpacity(0.2),
                                                width: 1,
                                              ),
                                            ),
                                            child: TextField(
                                              controller:
                                                  _contactPersonNameController,
                                              focusNode: _nameNode,
                                              textInputAction:
                                                  TextInputAction.next,
                                              keyboardType: TextInputType.name,
                                              textCapitalization:
                                                  TextCapitalization.words,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black87,
                                              ),
                                              decoration: InputDecoration(
                                                hintText: getTranslated(
                                                    'enter_contact_person_name',
                                                    context),
                                                hintStyle: TextStyle(
                                                  color: Colors.grey[600]!!,
                                                  fontSize: 14,
                                                ),
                                                border: InputBorder.none,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 16),
                                          // Contact Person Number
                                          Text(
                                            getTranslated(
                                                'contact_person_number',
                                                context),
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey[700]!!,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[50]!!,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: Color(0xFFFF6B35)
                                                    .withOpacity(0.2),
                                                width: 1,
                                              ),
                                            ),
                                            child: TextField(
                                              controller:
                                                  _contactPersonNumberController,
                                              focusNode: _numberNode,
                                              textInputAction:
                                                  TextInputAction.done,
                                              keyboardType: TextInputType.phone,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black87,
                                              ),
                                              decoration: InputDecoration(
                                                hintText: getTranslated(
                                                    'enter_contact_person_number',
                                                    context),
                                                hintStyle: TextStyle(
                                                  color: Colors.grey[600]!!,
                                                  fontSize: 14,
                                                ),
                                                border: InputBorder.none,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                  horizontal: 16,
                                                  vertical: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Save Button
                                    Container(
                                      margin: EdgeInsets.only(bottom: 20),
                                      child: !locationProvider.isLoading
                                          ? Container(
                                              width: double.infinity,
                                              height: 56,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Color(0xFFFF6B35),
                                                    Color(0xFFFF8C42)
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Color(0xFFFF6B35)
                                                        .withOpacity(0.3),
                                                    blurRadius: 12,
                                                    offset: Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                              child: Material(
                                                color: Colors.transparent,
                                                child: InkWell(
                                                  onTap:
                                                      locationProvider.loading
                                                          ? null
                                                          : () {
                                                              // Create full address without city and country
                                                              String
                                                                  fullAddress =
                                                                  locationProvider
                                                                          .locationController
                                                                          .text ??
                                                                      '';
                                                              if (_zipCodeController
                                                                  .text
                                                                  .isNotEmpty) {
                                                                fullAddress +=
                                                                    ', ${_zipCodeController.text}';
                                                              }

                                                              AddressModel
                                                                  addressModel =
                                                                  AddressModel(
                                                                addressType: locationProvider
                                                                        .getAllAddressType[
                                                                    locationProvider
                                                                        .selectAddressIndex],
                                                                contactPersonName:
                                                                    _contactPersonNameController
                                                                            .text ??
                                                                        '',
                                                                phone: _contactPersonNumberController
                                                                        .text ??
                                                                    '',
                                                                city:
                                                                    selectedCity ??
                                                                        '',
                                                                country: locationProvider
                                                                        .address
                                                                        .country ??
                                                                    locationProvider
                                                                        .pickAddress
                                                                        .country,
                                                                zip: _zipCodeController
                                                                        .text ??
                                                                    '',
                                                                isBilling: widget
                                                                        .isBilling
                                                                    ? 1
                                                                    : 0,
                                                                address:
                                                                    fullAddress, // Use the full address without city and country
                                                                latitude: widget
                                                                        .isEnableUpdate
                                                                    ? locationProvider
                                                                            .position
                                                                            .latitude
                                                                            .toString() ??
                                                                        widget
                                                                            .address
                                                                            .latitude
                                                                    : locationProvider
                                                                            .position
                                                                            .latitude
                                                                            .toString() ??
                                                                        '',
                                                                longitude: widget
                                                                        .isEnableUpdate
                                                                    ? locationProvider
                                                                            .position
                                                                            .longitude
                                                                            .toString() ??
                                                                        widget
                                                                            .address
                                                                            .longitude
                                                                    : locationProvider
                                                                            .position
                                                                            .longitude
                                                                            .toString() ??
                                                                        '',
                                                              );

                                                              if (widget
                                                                  .isEnableUpdate) {
                                                                addressModel
                                                                        .id =
                                                                    widget
                                                                        .address
                                                                        .id;
                                                                addressModel
                                                                        .id =
                                                                    widget
                                                                        .address
                                                                        .id;
                                                                // addressModel.method = 'put';
                                                                locationProvider
                                                                    .updateAddress(
                                                                        context,
                                                                        addressModel:
                                                                            addressModel,
                                                                        addressId:
                                                                            addressModel
                                                                                .id)
                                                                    .then(
                                                                        (value) {});
                                                              } else {
                                                                locationProvider
                                                                    .addAddress(
                                                                        addressModel,
                                                                        context)
                                                                    .then(
                                                                        (value) async {
                                                                  if (value
                                                                      .isSuccess) {
                                                                    Provider.of<ProfileProvider>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .initAddressList(
                                                                            context);

                                                                    Navigator.pop(
                                                                        context);

                                                                    if (widget
                                                                        .fromCheckout) {
                                                                      await Provider.of<ProfileProvider>(
                                                                              context,
                                                                              listen:
                                                                                  false)
                                                                          .initAddressList(
                                                                              context);
                                                                      // Provider.of<OrderProvider>(
                                                                      //         context,
                                                                      //         listen: false)
                                                                      //     .setAddressIndex(-1);
                                                                    } else {
                                                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                          content: Text(value
                                                                              .message),
                                                                          duration: Duration(
                                                                              milliseconds:
                                                                                  600),
                                                                          backgroundColor:
                                                                              Colors.green));
                                                                    }
                                                                  } else {
                                                                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                        content: Text(value
                                                                            .message),
                                                                        duration: Duration(
                                                                            milliseconds:
                                                                                600),
                                                                        backgroundColor:
                                                                            Colors.red));
                                                                  }
                                                                });
                                                              }
                                                            },
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  child: Container(
                                                    width: double.infinity,
                                                    height: 56,
                                                    child: Center(
                                                      child: Text(
                                                        widget.isEnableUpdate
                                                            ? getTranslated(
                                                                'update_address',
                                                                context)
                                                            : getTranslated(
                                                                'save_location',
                                                                context),
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container(
                                              width: double.infinity,
                                              height: 56,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200]!!,
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                              Color>(
                                                          Color(0xFFFF6B35)),
                                                ),
                                              ),
                                            ),
                                    ),
                                    SizedBox(height: 100),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Status Messages
                          if (locationProvider.addressStatusMessage != null &&
                              locationProvider.addressStatusMessage.isNotEmpty)
                            Container(
                              margin: EdgeInsets.all(16),
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.green.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 20,
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      locationProvider.addressStatusMessage ??
                                          "",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.green[700],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else if (locationProvider.errorMessage.isNotEmpty)
                            Container(
                              margin: EdgeInsets.all(16),
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Color(0xFFFF6B35).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Color(0xFFFF6B35).withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Color(0xFFFF6B35),
                                    size: 20,
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      locationProvider.errorMessage ?? "",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFFFF6B35),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _checkPermission(Function callback, BuildContext context) async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.whileInUse) {
      InkWell(
          onTap: () async {
            Navigator.pop(context);
            await Geolocator.requestPermission();
            _checkPermission(callback, context);
          },
          child: AlertDialog(
              content: MyDialog(
                  icon: Icons.location_on_outlined,
                  title: '',
                  description: getTranslated('you_denied', context))));
    } else if (permission == LocationPermission.deniedForever) {
      InkWell(
          onTap: () async {
            Navigator.pop(context);
            await Geolocator.openAppSettings();
            _checkPermission(callback, context);
          },
          child: AlertDialog(
              content: MyDialog(
                  icon: Icons.location_on_outlined,
                  title: '',
                  description: getTranslated('you_denied', context))));
    } else {
      callback();
    }
  }
}
