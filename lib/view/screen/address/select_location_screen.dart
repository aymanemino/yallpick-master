import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/provider/location_provider.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/button/custom_button.dart';
import 'package:flutter_sixvalley_ecommerce/view/basewidget/custom_app_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class SelectLocationScreen extends StatefulWidget {
  final GoogleMapController googleMapController;

  SelectLocationScreen({@required this.googleMapController});

  @override
  _SelectLocationScreenState createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  late GoogleMapController _controller;
  late CameraPosition _cameraPosition;

  @override
  void initState() {
    super.initState();

    Provider.of<LocationProvider>(context, listen: false).setPickData();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              CustomAppBar(
                  title: getTranslated('select_delivery_address', context)),
              Expanded(
                child: Container(
                  child: Consumer<LocationProvider>(
                    builder: (context, locationProvider, child) => Stack(
                      clipBehavior: Clip.none,
                      children: [
                        GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(locationProvider.position.latitude,
                                locationProvider.position.longitude),
                            zoom: 17,
                          ),
                          zoomControlsEnabled: true, // Enable zoom controls
                          compassEnabled: false,
                          indoorViewEnabled: true,
                          mapToolbarEnabled: true,
                          onCameraIdle: () {
                            locationProvider.updatePosition(
                                _cameraPosition, false, null, context);
                          },
                          onCameraMove: ((_position) =>
                              _cameraPosition = _position),
                          // markers: Set<Marker>.of(locationProvider.markers),
                          onMapCreated: (GoogleMapController controller) {
                            _controller = controller;
                          },
                        ),
                        Positioned(
                          bottom: 15,
                          right: 0,
                          left: 0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  locationProvider.getCurrentLocation(
                                      context, false,
                                      mapController: _controller);
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  margin: EdgeInsets.only(
                                      right: Dimensions.PADDING_SIZE_LARGE),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.PADDING_SIZE_SMALL),
                                    color: ColorResources.getChatIcon(context),
                                  ),
                                  child: Icon(
                                    Icons.my_location,
                                    color: Theme.of(context).primaryColor,
                                    size: 35,
                                  ),
                                ),
                              ),
                              Center(
                                child: Container(
                                  width: 250, // Adjust the width as needed
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                        Dimensions.PADDING_SIZE_LARGE),
                                    child: CustomButton(
                                      buttonText: getTranslated(
                                          'select_location', context),
                                      onTap: () {
                                        if (widget.googleMapController !=
                                            null) {
                                          widget.googleMapController.moveCamera(
                                            CameraUpdate.newCameraPosition(
                                              CameraPosition(
                                                target: LatLng(
                                                  locationProvider
                                                      .pickPosition.latitude,
                                                  locationProvider
                                                      .pickPosition.longitude,
                                                ),
                                                zoom: 17,
                                              ),
                                            ),
                                          );
                                          locationProvider.setAddAddressData();
                                        }
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Center(
                            child: Icon(
                          Icons.location_on,
                          color: Theme.of(context).primaryColor,
                          size: 50,
                        )),
                        locationProvider.loading
                            ? Center(
                                child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Theme.of(context).primaryColor)))
                            : SizedBox(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
