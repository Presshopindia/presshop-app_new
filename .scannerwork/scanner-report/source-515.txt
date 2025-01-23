/*
import 'dart:convert';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:location/location.dart' as lc;
import 'package:presshop/utils/Common.dart';
import 'package:presshop/utils/CommonExtensions.dart';
import 'package:presshop/utils/CommonSharedPrefrence.dart';
import 'package:presshop/utils/CommonTextField.dart';
import 'package:presshop/utils/CommonWigdets.dart';
import 'package:presshop/utils/networkOperations/NetworkResponse.dart';
import 'package:http/http.dart' as http;
import '../../main.dart';
import '../../utils/CommonAppBar.dart';
import '../../utils/networkOperations/NetworkClass.dart';
import 'authentication/SignUpScreen.dart';
import 'dashboard/Dashboard.dart';

class MyProfile1 extends StatefulWidget {
  bool editProfileScreen;
  String screenType;

  MyProfile1(
      {super.key, required this.editProfileScreen, required this.screenType});

  @override
  State<StatefulWidget> createState() {
    return MyProfile1State();
  }
}

class MyProfile1State extends State<MyProfile1> implements NetworkResponse {
  late Size size;

  var formKey = GlobalKey<FormState>();
  var scrollController = ScrollController();

  TextEditingController userNameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController postCodeController = TextEditingController();
  TextEditingController apartmentAndHouseNameController =
      TextEditingController();
  TextEditingController cityNameController = TextEditingController();
  TextEditingController countryNameController = TextEditingController();
  List<dynamic> placeList = [];
  List<AvatarsData> avatarList = [];
  MyProfileData? myProfileData;
  String selectedCountryCode = "",
      userImagePath = "",
      latitude = "",
      longitude = "",
      sessionToken = "";
  bool userNameAutoFocus = false,
      userNameAlreadyExists = false,
      emailAlreadyExists = false,
      phoneAlreadyExists = false,
      showAddressError = false,
      showApartmentNumberError = false,
      showPostalCodeError = false,
      showList = false;
  lc.LocationData? locationData;
  lc.Location location = lc.Location();
  Placemark? placeMark;


  @override
  void initState() {
    debugPrint("class:::: $runtimeType");
    super.initState();
    debugPrint("editStatus===> ${widget.editProfileScreen}");
    setUserNameListener();
    setPhoneListener();
    setEmailListener();
    Future.delayed(Duration.zero, () {
      myProfileApi();
      getAvatarsApi();
    });
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return */
/*WillPopScope(
      onWillPop: () async {
        if (widget.editProfileScreen) {
          widget.editProfileScreen = false;
        }
        return true;
      },
      child:*//*

        Scaffold(
      appBar: CommonAppBar(
        elevation: 0,
        hideLeading: false,
        title: Text(
          widget.screenType,
          */
/* widget.editProfileScreen
              ? editProfileText.toTitleCase()
              : myProfileText.toTitleCase(),*//*

          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: size.width * appBarHeadingFontSize),
        ),
        centerTitle: false,
        titleSpacing: 0,
        size: size,
        showActions: true,
        leadingFxn: () {
          */
/*  if (widget.editProfileScreen) {
              widget.editProfileScreen = false;
            }*//*

          Navigator.pop(context);
        },
        actionWidget: [
          InkWell(
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => Dashboard(initialPosition: 2)),
                  (route) => false);
            },
            child: Image.asset(
              "${commonImagePath}rabbitLogo.png",
              width: size.width * numD13,
            ),
          ),
          SizedBox(
            width: size.width * numD02,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: scrollController,
          child: Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * numD06),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  topProfileWidget(),
                  SizedBox(
                    height: size.width * numD06,
                  ),
                  Text("${userText.toTitleCase()} $nameText",
                      style: commonTextStyle(
                          size: size,
                          fontSize: size.width * numD032,
                          color: Colors.black,
                          fontWeight: FontWeight.normal)),
                  SizedBox(
                    height: size.width * numD02,
                  ),
                  CommonTextField(
                    size: size,
                    maxLines: 1,
                    textInputFormatters: null,
                    borderColor: colorTextFieldBorder,
                    controller: userNameController,
                    hintText: "${enterText.toTitleCase()} $userText $nameText",
                    prefixIcon: const ImageIcon(
                      AssetImage(
                        "${iconsPath}ic_user.png",
                      ),
                    ),
                    hidePassword: false,
                    keyboardType: TextInputType.text,
                    validator: null */
/*userNameValidator*//*
,
                    enableValidations: false,
                    filled: true,
                    filledColor: colorLightGrey,
                    autofocus: userNameAutoFocus,
                    readOnly: true,
                    prefixIconHeight: size.width * numD045,
                    suffixIconIconHeight: size.width * numD04,
                    suffixIcon: */
/*widget.editProfileScreen &&
                              userNameController.text.trim().isNotEmpty &&
                              userNameController.text.trim().length >= 4
                          ? userNameAlreadyExists
                              ? const Icon(
                                  Icons.highlight_remove,
                                  color: Colors.red,
                                )
                              : const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                )
                          :*//*

                        null,
                  ),
                  SizedBox(
                    height: size.width * numD06,
                  ),
                  Text("${firstText.toTitleCase()} $nameText",
                      style: commonTextStyle(
                          size: size,
                          fontSize: size.width * numD032,
                          color: Colors.black,
                          fontWeight: FontWeight.normal)),
                  SizedBox(
                    height: size.width * numD02,
                  ),
                  CommonTextField(
                    size: size,
                    maxLines: 1,
                    textInputFormatters: null,
                    borderColor: colorTextFieldBorder,
                    controller: firstNameController,
                    hintText: "${enterText.toTitleCase()} $firstText $nameText",
                    prefixIcon: const ImageIcon(
                      AssetImage(
                        "${iconsPath}ic_user.png",
                      ),
                    ),
                    prefixIconHeight: size.width * numD045,
                    suffixIconIconHeight: 0,
                    suffixIcon: null,
                    hidePassword: false,
                    keyboardType: TextInputType.text,
                    validator: checkRequiredValidator,
                    enableValidations: true,
                    filled: true,
                    filledColor: colorLightGrey,
                    autofocus: false,
                    readOnly: widget.editProfileScreen ? false : true,
                  ),
                  SizedBox(
                    height: size.width * numD06,
                  ),
                  Text("${lastText.toTitleCase()} $nameText",
                      style: commonTextStyle(
                          size: size,
                          fontSize: size.width * numD032,
                          color: Colors.black,
                          fontWeight: FontWeight.normal)),
                  SizedBox(
                    height: size.width * numD02,
                  ),
                  CommonTextField(
                    size: size,
                    maxLines: 1,
                    textInputFormatters: null,
                    borderColor: colorTextFieldBorder,
                    controller: lastNameController,
                    hintText: "${enterText.toTitleCase()} $lastText $nameText",
                    prefixIcon: const ImageIcon(
                      AssetImage(
                        "${iconsPath}ic_user.png",
                      ),
                    ),
                    prefixIconHeight: size.width * numD045,
                    suffixIconIconHeight: 0,
                    suffixIcon: null,
                    hidePassword: false,
                    keyboardType: TextInputType.text,
                    validator: checkRequiredValidator,
                    enableValidations: true,
                    filled: true,
                    filledColor: colorLightGrey,
                    autofocus: false,
                    readOnly: widget.editProfileScreen ? false : true,
                  ),
                  SizedBox(
                    height: size.width * numD06,
                  ),
                  Text("${phoneText.toTitleCase()} $numberText",
                      style: commonTextStyle(
                          size: size,
                          fontSize: size.width * numD032,
                          color: Colors.black,
                          fontWeight: FontWeight.normal)),
                  SizedBox(
                    height: size.width * numD02,
                  ),
                  CommonTextField(
                    size: size,
                    maxLines: 1,
                    textInputFormatters: null,
                    borderColor: colorTextFieldBorder,
                    controller: phoneNumberController,
                    hintText:
                        "${enterText.toTitleCase()} $phoneText $numberText",
                    prefixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const ImageIcon(
                          AssetImage(
                            "${iconsPath}ic_phone.png",
                          ),
                        ),
                        SizedBox(
                          width: size.width * numD02,
                        ),
                        Text(
                          selectedCountryCode,
                          style: commonTextStyle(
                              size: size,
                              fontSize: size.width * numD032,
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          width: size.width * 0.01,
                        ),
                        Image.asset(
                          "${iconsPath}ic_drop_down.png",
                          width: size.width * 0.025,
                        ),
                        SizedBox(
                          width: size.width * 0.01,
                        ),

                        */
/*  InkWell(
                          onTap: () {},
                          child: Row(
                            children: [
                              Text(
                                selectedCountryCode,
                                style: commonTextStyle(
                                    size: size,
                                    fontSize: size.width * numD035,
                                    color: Colors.black,
                                    fontWeight: FontWeight.normal),
                              ),
                              SizedBox(
                                height: size.width*numD06,
                                child: Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: Colors.black,
                                  size: size.width * numD07,
                                ),
                              )
                            ],
                          ),
                        )*//*

                      ],
                    ),
                    prefixIconHeight: size.width * numD045,
                    suffixIconIconHeight: 0,
                    suffixIcon: null,
                    hidePassword: false,
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: false, signed: true),
                    validator: null */
/*checkSignupPhoneValidator*//*
,
                    enableValidations: false,
                    filled: true,
                    filledColor: colorLightGrey,
                    autofocus: false,
                    readOnly: true,
                  ),
                  SizedBox(
                    height: size.width * numD06,
                  ),
                  Text(emailAddressText,
                      style: commonTextStyle(
                          size: size,
                          fontSize: size.width * numD032,
                          color: Colors.black,
                          fontWeight: FontWeight.normal)),
                  SizedBox(
                    height: size.width * numD02,
                  ),
                  CommonTextField(
                    size: size,
                    maxLines: 1,
                    textInputFormatters: null,
                    borderColor: colorTextFieldBorder,
                    controller: emailAddressController,
                    hintText: "${enterText.toTitleCase()} $emailAddressText",
                    prefixIcon: const ImageIcon(
                      AssetImage(
                        "${iconsPath}ic_email.png",
                      ),
                    ),
                    prefixIconHeight: size.width * numD045,
                    suffixIconIconHeight: 0,
                    suffixIcon: null,
                    hidePassword: false,
                    keyboardType: TextInputType.emailAddress,
                    validator: null */
/*checkSignupEmailValidator*//*
,
                    enableValidations: false,
                    filled: true,
                    filledColor: colorLightGrey,
                    autofocus: false,
                    readOnly: true,
                  ),
                  SizedBox(
                    height: size.width * numD06,
                  ),

                  /// Apartment Number and House Number
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(apartmentNoHintText,
                          style: commonTextStyle(
                              size: size,
                              fontSize: size.width * numD032,
                              color: Colors.black,
                              fontWeight: FontWeight.normal)),
                      SizedBox(
                        height: size.width * numD02,
                      ),
                      CommonTextField(
                        size: size,
                        maxLines: 1,
                        textInputFormatters: null,
                        borderColor: colorTextFieldBorder,
                        controller: apartmentAndHouseNameController,
                        hintText: apartmentNoHintText,
                        prefixIcon: const ImageIcon(
                          AssetImage(
                            "${iconsPath}ic_location.png",
                          ),
                        ),
                        prefixIconHeight: size.width * numD045,
                        suffixIconIconHeight: 0,
                        suffixIcon: null,
                        hidePassword: false,
                        keyboardType: TextInputType.text,
                        validator: checkRequiredValidator,
                        enableValidations: true,
                        filled: true,
                        filledColor: colorLightGrey,
                        autofocus: false,
                        readOnly: widget.editProfileScreen ? false : true,
                      ),
                    ],
                  ),
                  showApartmentNumberError &&
                          apartmentAndHouseNameController.text.trim().isEmpty
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * numD04,
                              vertical: size.width * numD01),
                          child: Text(
                            requiredText,
                            style: commonTextStyle(
                                size: size,
                                fontSize: size.width * numD03,
                                color: Colors.red.shade700,
                                fontWeight: FontWeight.normal),
                          ),
                        )
                      : Container(),
                  SizedBox(
                    height: size.width * numD06,
                  ),
                  Text(postalCodeText,
                      style: commonTextStyle(
                          size: size,
                          fontSize: size.width * numD032,
                          color: Colors.black,
                          fontWeight: FontWeight.normal)),
                  SizedBox(
                    height: size.width * numD02,
                  ),
                  */
/* CommonTextField(
                    size: size,
                    maxLines: 1,
                    textInputFormatters: null,
                    borderColor: colorTextFieldBorder,
                    controller: addressController,
                    hintText: "${enterText.toTitleCase()} $addressText",
                    prefixIcon: const ImageIcon(
                      AssetImage(
                        "${iconsPath}ic_location.png",
                      ),
                    ),
                    prefixIconHeight: size.width * numD045,
                    suffixIconIconHeight: 0,
                    suffixIcon: null,
                    hidePassword: false,
                    keyboardType: TextInputType.text,
                    validator: checkRequiredValidator,
                    enableValidations: true,
                    filled: true,
                    filledColor: colorLightGrey,
                    autofocus: false,
                    readOnly: widget.editProfileScreen ? false : true,
                  ),
                  SizedBox(
                    height: size.width * numD06,
                  ),
                  Text(postalCodeText,
                      style: commonTextStyle(
                          size: size,
                          fontSize: size.width * numD032,
                          color: Colors.black,
                          fontWeight: FontWeight.normal)),
                  SizedBox(
                    height: size.width * numD02,
                  ),
                  CommonTextField(
                    size: size,
                    maxLines: 1,
                    textInputFormatters: null,
                    borderColor: colorTextFieldBorder,
                    controller: postCodeController,
                    hintText: "${enterText.toTitleCase()} $postalCodeText",
                    prefixIcon: const ImageIcon(
                      AssetImage(
                        "${iconsPath}ic_location.png",
                      ),
                    ),
                    prefixIconHeight: size.width * numD045,
                    suffixIconIconHeight: 0,
                    suffixIcon: null,
                    hidePassword: false,
                    keyboardType: TextInputType.text,
                    validator: checkRequiredValidator,
                    enableValidations: true,
                    filled: true,
                    filledColor: colorLightGrey,
                    autofocus: false,
                    readOnly: widget.editProfileScreen ? false : true,
                  ),*//*


                  widget.editProfileScreen
                      ? SizedBox(
                          height: size.width * numD13,
                          child: GooglePlaceAutoCompleteTextField(
                            textEditingController: postCodeController,
                            googleAPIKey:
                                "AIzaSyAzccAqyrfD-V43gI9eBXqLf0qpqlm0Gu0",
                            boxDecoration: BoxDecoration(
                                color: colorLightGrey,
                                borderRadius:
                                    BorderRadius.circular(size.width * 0.03),
                                border: Border.all(
                                    color: colorTextFieldBorder, width: 1)),
                            textStyle: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: Colors.black,
                                fontSize: size.width * numD032,
                                fontFamily: 'AirbnbCereal_W_Md'),
                            inputDecoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: size.width * numD038),
                              filled: false,
                              hintText:
                                  "${enterText.toTitleCase()} $postalCodeText",
                              hintStyle: TextStyle(
                                  color: colorHint,
                                  fontSize: size.width * numD035,
                                  fontFamily: 'AirbnbCereal_W_Md'),
                              prefixIcon: Padding(
                                padding:
                                    EdgeInsets.only(right: size.width * numD02),
                                child: const ImageIcon(
                                  AssetImage(
                                    "${iconsPath}ic_location.png",
                                  ),
                                ),
                              ),
                              prefixIconConstraints: BoxConstraints(
                                  maxHeight: size.width * numD045),
                              prefixIconColor: colorTextFieldIcon,
                            ),
                            debounceTime: 800,
                            countries: const ["uk", "in"],
                            isLatLngRequired: true,
                            getPlaceDetailWithLatLng: (Prediction prediction) {
                              latitude = prediction.lat.toString();
                              longitude = prediction.lng.toString();
                              debugPrint("placeDetails :: ${prediction.lng}");
                              debugPrint("placeDetails :: ${prediction.lat}");
                              getCurrentLocationFxn(prediction.lat ?? "",
                                      prediction.lng ?? "")
                                  .then((value) {
                                if (value.isNotEmpty) {
                                  postCodeController.text =
                                      value.first.postalCode ?? '';
                                  cityNameController.text =
                                      value.first.locality ?? '';
                                  countryNameController.text =
                                      value.first.country ?? '';
                                }
                              });
                              showAddressError = false;
                              setState(() {});
                            },
                            itemClick: (Prediction prediction) {
                              addressController.text = prediction.description
                                      .toString()
                                      .split(", ")
                                      .last ??
                                  "";
                              latitude = prediction.lat ?? "";
                              longitude = prediction.lng ?? "";

                              String postalCode =
                                  prediction?.structuredFormatting?.mainText ??
                                      '';
                              debugPrint("postalCode=======> $postalCode");

                              addressController.selection =
                                  TextSelection.fromPosition(TextPosition(
                                      offset: prediction.description != null
                                          ? prediction.description!.length
                                          : 0));
                            },
                            isCrossBtnShown: true,
                          ),
                        )
                      : CommonTextField(
                          size: size,
                          maxLines: 1,
                          textInputFormatters: null,
                          borderColor: colorTextFieldBorder,
                          controller: postCodeController,
                          hintText:
                              "${enterText.toTitleCase()} $postalCodeText",
                          prefixIcon: const ImageIcon(
                            AssetImage(
                              "${iconsPath}ic_location.png",
                            ),
                          ),
                          prefixIconHeight: size.width * numD045,
                          suffixIconIconHeight: 0,
                          suffixIcon: null,
                          hidePassword: false,
                          keyboardType: TextInputType.text,
                          validator: checkRequiredValidator,
                          enableValidations: true,
                          filled: true,
                          filledColor: colorLightGrey,
                          autofocus: false,
                          readOnly: true,
                        ),

                  showPostalCodeError && postCodeController.text.trim().isEmpty
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * numD04,
                              vertical: size.width * numD01),
                          child: Text(
                            requiredText,
                            style: commonTextStyle(
                                size: size,
                                fontSize: size.width * numD03,
                                color: Colors.red.shade700,
                                fontWeight: FontWeight.normal),
                          ),
                        )
                      : Container(),
                  SizedBox(height: size.width * numD06),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(addressText,
                          style: commonTextStyle(
                              size: size,
                              fontSize: size.width * numD032,
                              color: Colors.black,
                              fontWeight: FontWeight.normal)),
                      SizedBox(
                        height: size.width * numD02,
                      ),
                      */
/*widget.editProfileScreen
                          ? SizedBox(
                             height: size.width*numD13,
                            child: GooglePlaceAutoCompleteTextField(
                                textEditingController: addressController,
                                googleAPIKey:
                                    "AIzaSyAzccAqyrfD-V43gI9eBXqLf0qpqlm0Gu0",
                                boxDecoration: BoxDecoration(
                                    color: colorLightGrey,
                                    borderRadius:
                                        BorderRadius.circular(size.width * 0.03),
                                    border: Border.all(
                                        color: colorTextFieldBorder, width: 1)),
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: size.width * numD032,
                                    fontFamily: 'AirbnbCereal_W_Md'),
                                inputDecoration: InputDecoration(
                                  helperMaxLines: 1,
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: size.width * numD038),
                                  filled: false,
                                  hintText:
                                      "${enterText.toTitleCase()} ${addressText.toLowerCase()}",
                                  hintStyle: TextStyle(
                                      color: colorHint,
                                      fontSize: size.width * numD035,
                                      fontFamily: 'AirbnbCereal_W_Md'),
                                  suffixIcon:
                                      addressController.text.trim().isNotEmpty
                                          ? SizedBox(
                                              height: size.width * numD03,
                                              child: IconButton(
                                                  padding: EdgeInsets.zero,
                                                  onPressed: () {
                                                    addressController.clear();
                                                  },
                                                  icon: const Icon(
                                                    Icons.close,
                                                    color: Colors.black,
                                                  )),
                                            )
                                          : null,
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.only(
                                        right: size.width * numD02),
                                    child: const ImageIcon(
                                      AssetImage(
                                        "${iconsPath}ic_location.png",
                                      ),
                                    ),
                                  ),
                                  prefixIconConstraints: BoxConstraints(
                                      maxHeight: size.width * numD045),
                                  prefixIconColor: colorTextFieldIcon,
                                ),
                                debounceTime: 800,
                                countries: const ["uk", "in"],
                                isLatLngRequired: true,
                                getPlaceDetailWithLatLng:
                                    (Prediction prediction) {
                                  latitude = prediction.lat.toString();
                                  longitude = prediction.lng.toString();
                                  debugPrint("placeDetails :: ${prediction.lng}");
                                  debugPrint("placeDetails :: ${prediction.lat}");
                                  getCurrentLocationFxn(prediction.lat ?? "",
                                          prediction.lng ?? "")
                                      .then((value) {
                                    if (value.isNotEmpty) {
                                      if (postCodeController.text.isEmpty) {
                                        postCodeController.text =
                                            value.first.postalCode ?? '';
                                      }

                                      cityNameController.text =
                                          value.first.locality ?? '';
                                      countryNameController.text =
                                          value.first.country ?? '';
                                    }
                                  });
                                  showAddressError = false;
                                  setState(() {});
                                },
                                // this callback is called when isLatLngRequired is true

                                itemClick: (Prediction prediction) {
                                  addressController.text =
                                      prediction.description ?? "";
                                  latitude = prediction.lat ?? "";
                                  longitude = prediction.lng ?? "";

                                  String postalCode = prediction
                                          ?.structuredFormatting?.mainText ??
                                      '';
                                  debugPrint("postalCode=======> $postalCode");

                                  addressController.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset: prediction.description != null
                                              ? prediction.description!.length
                                              : 0));
                                },
                                isCrossBtnShown: false,
                              ),
                          )
                          :*//*


                      CommonTextField(
                        size: size,
                        maxLines: 3,
                        textInputFormatters: null,
                        borderColor: colorTextFieldBorder,
                        controller: addressController,
                        hintText:
                            "${enterText.toTitleCase()} ${addressText.toLowerCase()}",
                        prefixIcon: const ImageIcon(
                          AssetImage(
                            "${iconsPath}ic_location.png",
                          ),
                        ),
                        prefixIconHeight: size.width * numD045,
                        suffixIconIconHeight: size.width * numD045,
                        suffixIcon: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            addressController.clear();
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.black,
                          ),
                        ),
                        hidePassword: false,
                        keyboardType: TextInputType.text,
                        validator: checkRequiredValidator,
                        enableValidations: true,
                        filled: true,
                        filledColor: colorLightGrey,
                        autofocus: false,
                        onChanged: (value) {
                          if (value!.isNotEmpty) {
                            getSuggestion(value);
                          } else {
                            showList = false;
                          }
                        },
                        readOnly: widget.editProfileScreen ? false : true,
                      ),
                      showList ? _addressList() : Container()
                    ],
                  ),

                  showPostalCodeError &&
                          postCodeController.text.trim().isEmpty &&
                          addressController.text.isNotEmpty
                      ? Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * numD04,
                              vertical: size.width * numD01),
                          child: Text(
                            requiredText,
                            style: commonTextStyle(
                                size: size,
                                fontSize: size.width * numD03,
                                color: Colors.red.shade700,
                                fontWeight: FontWeight.normal),
                          ),
                        )
                      : Container(),

                  SizedBox(height: size.width * numD06),

                  /// City
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cityText,
                          style: commonTextStyle(
                              size: size,
                              fontSize: size.width * numD032,
                              color: Colors.black,
                              fontWeight: FontWeight.normal)),
                      SizedBox(
                        height: size.width * numD02,
                      ),
                      CommonTextField(
                        size: size,
                        maxLines: 1,
                        textInputFormatters: null,
                        borderColor: colorTextFieldBorder,
                        controller: cityNameController,
                        hintText: cityText,
                        prefixIcon: const ImageIcon(
                          AssetImage(
                            "${iconsPath}ic_location.png",
                          ),
                        ),
                        prefixIconHeight: size.width * numD045,
                        suffixIconIconHeight: 0,
                        suffixIcon: null,
                        hidePassword: false,
                        keyboardType: TextInputType.text,
                        validator: checkRequiredValidator,
                        enableValidations: true,
                        filled: true,
                        filledColor: colorLightGrey,
                        autofocus: false,
                        readOnly: widget.editProfileScreen ? false : true,
                      ),
                    ],
                  ),

                  SizedBox(height: size.width * numD06),

                  /// Country
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(countryText,
                          style: commonTextStyle(
                              size: size,
                              fontSize: size.width * numD032,
                              color: Colors.black,
                              fontWeight: FontWeight.normal)),
                      SizedBox(
                        height: size.width * numD02,
                      ),
                      CommonTextField(
                        size: size,
                        maxLines: 1,
                        textInputFormatters: null,
                        borderColor: colorTextFieldBorder,
                        controller: countryNameController,
                        hintText: countryText,
                        prefixIcon: const ImageIcon(
                          AssetImage(
                            "${iconsPath}ic_location.png",
                          ),
                        ),
                        prefixIconHeight: size.width * numD045,
                        suffixIconIconHeight: 0,
                        suffixIcon: null,
                        hidePassword: false,
                        keyboardType: TextInputType.text,
                        validator: checkRequiredValidator,
                        enableValidations: true,
                        filled: true,
                        filledColor: colorLightGrey,
                        autofocus: false,
                        readOnly: widget.editProfileScreen ? false : true,
                      ),
                    ],
                  ),

                  SizedBox(
                    height: size.width * numD25,
                  ),
                  Container(
                    width: size.width,
                    height: size.width * numD14,
                    padding:
                        EdgeInsets.symmetric(horizontal: size.width * numD08),
                    child: commonElevatedButton(
                        widget.editProfileScreen
                            ? saveText.toTitleCase()
                            : editProfileText.toTitleCase(),
                        size,
                        commonTextStyle(
                            size: size,
                            fontSize: size.width * numD035,
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                        commonButtonStyle(size, colorThemePink), () {
                      if (!widget.editProfileScreen) {
                        widget.editProfileScreen = !widget.editProfileScreen;
                        scrollController.animateTo(
                            scrollController.position.minScrollExtent,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut);
                        userNameAutoFocus = true;
                      } else {
                        scrollController.animateTo(
                            scrollController.position.minScrollExtent,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut);

                        showAddressError = addressController.text.trim().isEmpty
                            ? true
                            : false;

                        showApartmentNumberError =
                            apartmentAndHouseNameController.text.trim().isEmpty
                                ? true
                                : false;

                        showPostalCodeError =
                            postCodeController.text.trim().isEmpty
                                ? true
                                : false;

                        if (formKey.currentState!.validate()) {
                          editProfileApi();
                        }
                      }
                      setState(() {});
                    }),
                  ),
                  SizedBox(
                    height: size.width * numD04,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    // );
  }

  void getSuggestion(String input) async {
    ///Url to hit google location -->
    String requestApi =
        '$googleMapURL?input=$input&key=AIzaSyAzccAqyrfD-V43gI9eBXqLf0qpqlm0Gu0& sessionToken=$sessionToken';

    var response = await http.get(Uri.parse(requestApi));
    debugPrint("searchMap-Res->${response.body}");

    if (response.statusCode == 200) {
      setState(() {
        if (input.isNotEmpty) {
          placeList = json.decode(response.body)['predictions'];
          showList = true;
        }
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  Widget _addressList() {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.width * numD45,
      decoration: BoxDecoration(
          color: colorLightGrey,
          border: Border.all(color: colorLightGrey),
          borderRadius: BorderRadius.circular(size.width * numD015)),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: placeList.length,
        itemBuilder: (context, index) {
          return InkWell(
              onTap: () {
                setState(() {
                  FocusScope.of(context).requestFocus(FocusNode());
                  String location = placeList[index]["description"];
                  addressController.text = location;
                  showList = false;
                  getLatLong(location);
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: size.width * numD02,
                    horizontal: size.width * numD02),
                alignment: Alignment.centerLeft,
                child: Text(
                  placeList[index]["description"],
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: size.width * numD035,
                      fontFamily: 'AirbnbCereal_W_Md'),
                ),
              ));
        },
      ),
    );
  }

  void getLatLong(String address) async {
    List<Location> locations = await locationFromAddress(address);


    if (locations.isNotEmpty) {
      latitude = locations[0].latitude.toString();
      longitude = locations[0].longitude.toString();
      placeMark = await getAddressFromLatLng(double.parse(latitude),double.parse(longitude));
      postCodeController.text = placeMark!.postalCode.toString();
      debugPrint("postCodeController:${postCodeController.text}");
      debugPrint("latitude:$latitude");
      debugPrint("latitude:$longitude");
    } else {
      showSnackBar("Location", "Location not Match !", Colors.red);
    }
  }
  Future<Placemark?> getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placeMarks = await placemarkFromCoordinates(lat, lng);
      var placeMark = placeMarks[0];
      return placeMark;
    } on PlatformException catch (e) {
      debugPrint("Get Address Error=======>$e");
      return null;
    }
  }

  Widget topProfileWidget() {
    return Container(
      height: size.width * numD35,
      decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(size.width * numD04)),
      child: Row(
        children: [
          Stack(
            fit: StackFit.loose,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(size.width * numD04),
                      bottomLeft: Radius.circular(size.width * numD04)),
                  child: Image.network(
                    myProfileData != null
                        ? "$avatarImageUrl${myProfileData!.avatarImage}"
                        : "",
                    errorBuilder: (context, exception, stacktrace) {
                      return Padding(
                        padding: EdgeInsets.all(size.width * numD04),
                        child: Image.asset(
                          "${commonImagePath}rabbitLogo.png",
                          fit: BoxFit.contain,
                          width: size.width * numD35,
                          height: size.width * numD35,
                        ),
                      );
                    },
                    fit: BoxFit.cover,
                    width: size.width * numD37,
                    height: size.width * numD35,
                  )),
              widget.editProfileScreen
                  ? Positioned(
                      bottom: size.width * numD01,
                      right: size.width * numD01,
                      child: InkWell(
                        onTap: () {
                          avatarBottomSheet(size);
                        },
                        child: Container(
                          padding: EdgeInsets.all(size.width * 0.005),
                          decoration: const BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: Container(
                              padding: EdgeInsets.all(size.width * 0.005),
                              decoration: const BoxDecoration(
                                  color: colorThemePink,
                                  shape: BoxShape.circle),
                              child: Icon(
                                Icons.edit_outlined,
                                color: Colors.white,
                                size: size.width * numD04,
                              )),
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
          SizedBox(
            width: size.width * numD04,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  myProfileData != null
                      ? myProfileData!.userName.toCapitalized()
                      : "",
                  style: commonTextStyle(
                      size: size,
                      fontSize: size.width * numD04,
                      color: colorThemePink,
                      fontWeight: FontWeight.w500)),
              SizedBox(
                height: size.width * numD01,
              ),
              Text(
                  "$joinedText - ${myProfileData != null ? myProfileData!.joinedDate : ""}",
                  style: commonTextStyle(
                      size: size,
                      fontSize: size.width * numD035,
                      color: Colors.white,
                      fontWeight: FontWeight.normal)),
              SizedBox(
                height: size.width * numD005,
              ),
              Text("$earningsText - ${euroUniqueCode}0",
                  style: commonTextStyle(
                      size: size,
                      fontSize: size.width * numD035,
                      color: Colors.white,
                      fontWeight: FontWeight.normal)),
              SizedBox(
                height: size.width * numD005,
              ),
              Text(myProfileData != null ? myProfileData!.address : "",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: commonTextStyle(
                      size: size,
                      fontSize: size.width * numD035,
                      color: Colors.white,
                      fontWeight: FontWeight.normal))
            ],
          ))
        ],
      ),
    );
  }

  void setProfileData() {
    if (myProfileData != null) {
      firstNameController.text = myProfileData!.firstName;
      lastNameController.text = myProfileData!.lastName;
      userNameController.text = myProfileData!.userName;
      selectedCountryCode = myProfileData!.countryCode;
      addressController.text = myProfileData!.address;
      phoneNumberController.text = myProfileData!.phoneNumber;
      emailAddressController.text = myProfileData!.email;
      postCodeController.text = myProfileData!.postCode;
      apartmentAndHouseNameController.text = myProfileData!.apartment;
      cityNameController.text = myProfileData!.cityName;
      countryNameController.text = myProfileData!.countryName;
    }
  }

  String? userNameValidator(String? value) {
    //<-- add String? as a return type
    if (value!.isEmpty) {
      return requiredText;
    } else if (firstNameController.text.trim().isEmpty) {
      return "First name must be filled.";
    } else if (lastNameController.text.trim().isEmpty) {
      return "Last name must be filled.";
    }
    if (value.toLowerCase().contains(firstNameController.text.toLowerCase()) ||
        value.toLowerCase().contains(lastNameController.text.toLowerCase())) {
      return "First name or Last name are not allowed in user name.";
    } else if (value.length < 4) {
      return "Your user name must be at least 4 characters in length";
    } else if (userNameAlreadyExists) {
      return "This user name already occupied. Please try another one";
    }
    return null;
  }

  void setUserNameListener() {
    userNameController.addListener(() {
      if (widget.editProfileScreen) {
        debugPrint("UserName:${userNameController.text}");
        if (userNameController.text.trim().isNotEmpty &&
            firstNameController.text.trim().isNotEmpty &&
            lastNameController.text.trim().isNotEmpty &&
            userNameController.text.trim().length >= 4 &&
            !userNameController.text
                .trim()
                .toLowerCase()
                .contains(firstNameController.text.trim().toLowerCase()) &&
            !userNameController.text
                .trim()
                .toLowerCase()
                .contains(lastNameController.text.trim().toLowerCase())) {
          debugPrint("notsuccess");
          checkUserNameApi();
        } else {
          userNameAlreadyExists = false;
        }
        setState(() {});
      }
    });
  }

  void setEmailListener() {
    emailAddressController.addListener(() {
      if (widget.editProfileScreen) {
        debugPrint("Emil:${emailAddressController.text}");
        if (emailAddressController.text.trim().isNotEmpty) {
          debugPrint("notsuccess");
          checkEmailApi();
        } else {
          emailAlreadyExists = false;
        }

        setState(() {});
      }
    });
  }

  void setPhoneListener() {
    phoneNumberController.addListener(() {
      if (widget.editProfileScreen) {
        debugPrint("Phone:${phoneNumberController.text}");
        if (phoneNumberController.text.trim().isNotEmpty &&
            phoneNumberController.text.trim().length > 9) {
          debugPrint("notsuccess");
          checkPhoneApi();
        } else {
          phoneAlreadyExists = false;
        }

        setState(() {});
      }
    });
  }

  /// Avatar Images
  void avatarBottomSheet(Size size) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, avatarState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: size.width * numD04),
                  child: Row(
                    children: [
                      Text(
                        chooseAvatarText,
                        style: commonTextStyle(
                            size: size,
                            fontSize: size.width * numD04,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.close,
                            color: Colors.black,
                            size: size.width * numD06,
                          ))
                    ],
                  ),
                ),
                Flexible(
                    child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: StaggeredGridView.count(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    crossAxisCount: 6,
                    padding: const EdgeInsets.all(2.0),
                    staggeredTiles: avatarList
                        .map<StaggeredTile>((_) => const StaggeredTile.fit(2))
                        .toList(),
                    mainAxisSpacing: 3.0,
                    crossAxisSpacing: 4.0,
                    children: avatarList.map<Widget>((item) {
                      return InkWell(
                        onTap: () {
                          int pos = avatarList
                              .indexWhere((element) => element.selected);

                          if (pos >= 0) {
                            avatarList[pos].selected = false;
                          }

                          myProfileData!.avatarImage = item.avatar;
                          myProfileData!.avatarId = item.id;
                          item.selected = true;
                          avatarState(() {});
                          setState(() {});
                          Navigator.pop(context);
                        },
                        child: Stack(
                          children: [
                            Image.network("$avatarImageUrl${item.avatar}"),
                            item.selected
                                ? Align(
                                    alignment: Alignment.topRight,
                                    child: Icon(
                                      Icons.check,
                                      color: Colors.black,
                                      size: size.width * numD06,
                                    ))
                                : Container()
                          ],
                        ),
                      );
                    }).toList(), // add some space
                  ),
                ))
              ],
            );
          });
        });
  }

  /// Get current Location
*/
/*
  Future<String?> getCurrentLocationFxn(String latitude, longitude) async {
    try {
      double lat = double.parse(latitude);
      double long = double.parse(longitude);
      List<Placemark> placeMarkList = await placemarkFromCoordinates(lat, long);
      debugPrint("PlaceHolder: ${placeMarkList.first}");
      return placeMarkList.first.postalCode!;
    } on Exception catch (e) {
      debugPrint("PEx: $e");
      showSnackBar("Exception", e.toString(), Colors.red);
    }
    return null;
  }
*//*


  Future<List<Placemark>> getCurrentLocationFxn(
      String latitude, longitude) async {
    try {
      double lat = double.parse(latitude);
      double long = double.parse(longitude);
      List<Placemark> placeMarkList = await placemarkFromCoordinates(lat, long);
      debugPrint("PlaceHolder: ${placeMarkList.first}");
      return placeMarkList;
    } on Exception catch (e) {
      debugPrint("PEx: $e");
      showSnackBar("Exception", e.toString(), Colors.red);
    }
    return [];
  }

  void openCountryCodePicker() {
    showCountryPicker(
      context: context,
      showPhoneCode: true,
      onSelect: (Country country) {
        debugPrint('Select country: ${country.displayName}');
        debugPrint('Select country: ${country.countryCode}');
        debugPrint('Select country: ${country.hashCode}');
        debugPrint('Select country: ${country.displayNameNoCountryCode}');
        debugPrint('Select country: ${country.phoneCode}');

        myProfileData!.countryCode = country.phoneCode;
        setState(() {});
      },
    );
  }

  String? checkSignupPhoneValidator(String? value) {
    //<-- add String? as a return type
    if (value!.isEmpty) {
      return requiredText;
    } else if (value.length < 10) {
      return phoneErrorText;
    } else if (phoneAlreadyExists) {
      return phoneExistsErrorText;
    }
    return null;
  }

  String? checkSignupEmailValidator(String? value) {
    //<-- add String? as a return type
    if (value!.isEmpty) {
      return requiredText;
    } else if (!emailExpression.hasMatch(value)) {
      return emailErrorText;
    } else if (emailAlreadyExists) {
      return emailExistsErrorText;
    }
    return null;
  }

  ///ApisSection------------
  void checkUserNameApi() {
    try {
      NetworkClass(
              "$checkUserNameUrl${userNameController.text.trim().toLowerCase()}",
              this,
              checkUserNameUrlRequest)
          .callRequestServiceHeader(false, "get", null);
    } on Exception catch (e) {
      debugPrint("$e");
    }
  }

  void checkEmailApi() {
    try {
      NetworkClass("$checkEmailUrl${emailAddressController.text.trim()}", this,
              checkEmailUrlRequest)
          .callRequestServiceHeader(false, "get", null);
    } on Exception catch (e) {
      debugPrint("$e");
    }
  }

  void checkPhoneApi() {
    try {
      NetworkClass("$checkPhoneUrl${phoneNumberController.text.trim()}", this,
              checkPhoneUrlRequest)
          .callRequestServiceHeader(false, "get", null);
    } on Exception catch (e) {
      debugPrint("$e");
    }
  }

  void getAvatarsApi() {
    try {
      NetworkClass(getAvatarsUrl, this, getAvatarsUrlRequest)
          .callRequestServiceHeader(true, "get", null);
    } on Exception catch (e) {
      debugPrint("$e");
    }
  }

  void myProfileApi() {
    NetworkClass(myProfileUrl, this, myProfileUrlRequest)
        .callRequestServiceHeader(true, "get", null);
  }

  void editProfileApi() {
    try {
      Map<String, String> params = {
        firstNameKey: firstNameController.text.trim(),
        lastNameKey: lastNameController.text.trim(),
        userNameKey: userNameController.text.trim().toLowerCase(),
        emailKey: emailAddressController.text.trim(),
        countryCodeKey: myProfileData!.countryCode,
        phoneKey: phoneNumberController.text.trim(),
        addressKey: addressController.text.trim(),
        latitudeKey: myProfileData!.latitude,
        longitudeKey: myProfileData!.longitude,
        avatarIdKey: myProfileData!.avatarId,
        postCodeKey: postCodeController.text,
        cityKey: cityNameController.text.trim(),
        countryKey: countryNameController.text.trim(),
        apartmentKey: apartmentAndHouseNameController.text.trim(),
        roleKey: "Hopper",
      };
      NetworkClass.fromNetworkClass(
              editProfileUrl, this, editProfileUrlRequest, params)
          .callRequestServiceHeader(true, "patch", null);
    } on Exception catch (e) {
      debugPrint("$e");
    }
  }

  @override
  void onError({required int requestCode, required String response}) {
    try {
      switch (requestCode) {
        case myProfileUrlRequest:
          var map = jsonDecode(response);
          debugPrint("MyProfileError:$map");
          break;

        case editProfileUrlRequest:
          var map = jsonDecode(response);
          debugPrint("EditProfileError:$map");
          break;
      }
    } on Exception catch (e) {
      debugPrint("$e");
    }
  }

  @override
  void onResponse({required int requestCode, required String response}) {
    try {
      switch (requestCode) {
        case myProfileUrlRequest:
          var map = jsonDecode(response);
          debugPrint("MyProfileSuccess:$map");

          if (map["code"] == 200) {
            myProfileData = MyProfileData.fromJson(map["userData"]);
            setProfileData();
            setState(() {});
          }
          break;

        case checkUserNameUrlRequest:
          var map = jsonDecode(response);
          debugPrint("CheckUserNameResponse:$map");
          userNameAlreadyExists = map["userNameExist"];
          setState(() {});
          break;

        case checkPhoneUrlRequest:
          var map = jsonDecode(response);
          debugPrint("CheckPhoneResponse:$map");
          phoneAlreadyExists = map["phoneExist"];
          setState(() {});
          break;

        case checkEmailUrlRequest:
          var map = jsonDecode(response);
          debugPrint("CheckEmailResponse:$map");
          emailAlreadyExists = map["emailExist"];
          setState(() {});
          break;
        case getAvatarsUrlRequest:
          var map = jsonDecode(response);

          var list = map["response"] as List;
          avatarList = list.map((e) => AvatarsData.fromJson(e)).toList();
          debugPrint("AvatarList: ${avatarList.length}");
          setState(() {});
          break;
        case editProfileUrlRequest:
          var map = jsonDecode(response);
          if (map["code"] == 200) {
            widget.editProfileScreen = false;
            */
/* showSnackBar("Profile Updated!",
                "Your profile has been updated successfully", colorOnlineGreen);*//*

            debugPrint("heloooo::::${myProfileData!.avatarId}");

            myProfileApi();
            sharedPreferences!.setString(avatarKey, myProfileData!.avatarImage);
          }
          setState(() {});
          break;
      }
    } on Exception catch (e) {
      debugPrint("$e");
    }
  }
}

class MyProfileData {
  String firstName = "";
  String lastName = "";
  String userName = "";
  String countryCode = "";
  String phoneNumber = "";
  String email = "";
  String address = "";
  String postCode = "";
  String latitude = "";
  String longitude = "";
  String avatarImage = "";
  String avatarId = "";
  String joinedDate = "";
  String earnings = "0";
  String validDegree = "";
  String validMemberShip = "";
  String apartment = "";
  String cityName = "";
  String countryName = "";
  String validBritishPassport = "";

  MyProfileData.fromJson(json) {
    firstName = json[firstNameKey];
    lastName = json[lastNameKey];
    userName = json[userNameKey];
    countryCode = json[countryCodeKey];
    phoneNumber = json[phoneKey].toString();
    debugPrint("MyPhone: $phoneNumber");

    cityName = json[cityKey] ?? '';
    countryName = json[countryKey] ?? '';
    apartment = json[apartmentKey] ?? '';
    email = json[emailKey];
    address = json[addressKey];
    postCode = json[postCodeKey] ?? "";
    latitude = json[latitudeKey].toString();
    longitude = json[longitudeKey].toString();
    avatarImage =
        json["avatarData"] != null ? json["avatarData"]["avatar"] : "";
    avatarId = json["avatarData"] != null ? json["avatarData"]["_id"] : "";
    joinedDate = changeDateFormat(
        "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", json["createdAt"], "dd MMMM, yyyy");
    validDegree = json["doc_to_become_pro"] != null
        ? json["doc_to_become_pro"]["govt_id_mediatype"].toString()
        : "";
    validMemberShip = json["doc_to_become_pro"] != null
        ? json["doc_to_become_pro"]["photography_mediatype"].toString()
        : "";
    validBritishPassport = json["doc_to_become_pro"] != null
        ? json["doc_to_become_pro"]["comp_incorporation_cert_mediatype"]
            .toString()
        : "";
  }
}
*/
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as PH;
import 'package:permission_handler/permission_handler.dart';
import 'package:presshop/utils/Common.dart';
import 'package:presshop/utils/CommonExtensions.dart';
import 'package:presshop/utils/CommonSharedPrefrence.dart';
import 'package:presshop/utils/CommonWigdets.dart';
import 'package:presshop/utils/LocalNotificationService.dart';
import 'package:presshop/utils/networkOperations/NetworkResponse.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../main.dart';
import '../../utils/CommonModel.dart';
import '../../utils/PermissionHandler.dart';
import '../../utils/countdownTimerScreen.dart';
import '../../utils/networkOperations/NetworkClass.dart';
import 'package:http/http.dart' as http;

import 'dashboard/Dashboard.dart';

class BroadCastScreen1 extends StatefulWidget {
  String taskId = "";
  String mediaHouseId = "";

  BroadCastScreen1(
      {super.key, required this.taskId, required this.mediaHouseId});

  @override
  State<BroadCastScreen1> createState() => _BroadCastScreen1State();
}

class _BroadCastScreen1State extends State<BroadCastScreen1>
    implements NetworkResponse {
  late Size size;

  LatLng? _latLng;

  String _hopperAcceptedCount = "";
  String _distance = "";
  String _drivingEstTime = "";
  String _walkingEstTime = "";
  String googleUrl =
      'https://www.google.com/maps/dir/?api=1&origin=30.9010,75.8573&destination=31.3260,75.5762&travelmode=driving&dir_action=navigate';
  String appleUrl =
      'http://maps.apple.com/maps?saddr=30.9010,75.8573&daddr=31.3260,75.5762';

  bool _showMap = false;
  bool _isAccepted = false;
  bool isDirection = false;
  bool isMultipleContact = false;

  BitmapDescriptor? mapIcon;
  BroadcastedData? broadCastedData;

  List<Marker> marker = [];
  Timer? _hopperCountTimer;
  TaskDetailModel? taskDetail;

  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

/*
  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
*/

  TextEditingController contactSearchController = TextEditingController();
  List<ContactListModel> contactsDataList = [];
  List<ContactListModel> contactSearch = [];

  @override
  void initState() {
    getAllIcons();
    debugPrint("Class Name : $runtimeType");
    widget.taskId = "65f0006a63178dfaaf72ac56";
    getCurrentLocation();
    requestContactsPermission();
    super.initState();
  }

  @override
  void dispose() {
    _hopperCountTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: null,
      body: broadCastedData != null && _showMap
          ? Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: size.height/2 ,
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                              bottomLeft:
                              Radius.circular(size.width * numD06),
                              bottomRight:
                              Radius.circular(size.width * numD06)),
                          child: GoogleMap(
                            zoomGesturesEnabled: false,
                            mapToolbarEnabled:true,
                            myLocationButtonEnabled:false,
                            mapType: MapType.normal,
                            initialCameraPosition: _kGooglePlex,
                            onTap: (latLng){
                              //_updateGoogleMap(latLng);
                              // if (mounted) {
                              //   setState(() {});
                              //  }
                            },
                            markers: marker.map((e) => e).toSet(),
                            onMapCreated:
                                (GoogleMapController controller) {
                              _controller.complete(controller);
                            },
                            zoomControlsEnabled: true,
                            scrollGesturesEnabled:true,

                          ),

                          /*Stack(
                                  children: [
                                    GoogleMap(

                                      mapType: MapType.normal,
                                      initialCameraPosition: _kGooglePlex,
                                      markers: marker.map((e) => e).toSet(),
                                      onMapCreated:
                                          (GoogleMapController controller) {
                                        _controller.complete(controller);
                                      },
                                      zoomControlsEnabled: true,
                                      */
                          /*
                                      zoomGesturesEnabled: true,
                                      rotateGesturesEnabled: true,
                                      scrollGesturesEnabled: true,*/
                          /*
                                    ),
                                    Positioned.fill(child: InkWell(
                                      onTap: () {
                                        isDirection = false;
                                        setState(() {});
                                        openUrl();
                                      },
                                    ))
                                  ],
                                ),*/
                        ),
                        Positioned(
                          bottom: size.width * numD01,
                          left: size.width * numD04,
                          right: size.width * numD04,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: size.width * numD02,
                                    vertical: size.width * numD02),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                      size.width * numD04),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.my_location,
                                      size: size.width * numD05,
                                    ),
                                    SizedBox(
                                      width: size.width * numD01,
                                    ),
                                    Text(
                                      "$_hopperAcceptedCount Hoppers",
                                      style: commonTextStyle(
                                          size: size,
                                          fontSize: size.width * numD035,
                                          color: Colors.black,
                                          fontWeight: FontWeight.normal),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: size.width * numD02,
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width * numD05,
                                      vertical: size.width * numD02),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                        size.width * numD04),
                                  ),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        "${iconsPath}ic_marker.png",
                                        width: size.width * numD04,
                                      ),
                                      SizedBox(
                                        width: size.width * numD01,
                                      ),
                                      Text(
                                        _distance,
                                        style: commonTextStyle(
                                            size: size,
                                            fontSize:
                                            size.width * numD035,
                                            color: Colors.black,
                                            fontWeight:
                                            FontWeight.normal),
                                      ),
                                      const Spacer(),
                                      Container(
                                        width: 1,
                                        height: size.width * numD04,
                                        color: Colors.grey,
                                      ),
                                      const Spacer(),
                                      Image.asset(
                                        "${iconsPath}ic_man_walking.png",
                                        height: size.width * numD05,
                                      ),
                                      SizedBox(
                                        width: size.width * numD01,
                                      ),
                                      Text(
                                        _walkingEstTime,
                                        style: commonTextStyle(
                                            size: size,
                                            fontSize:
                                            size.width * numD035,
                                            color: Colors.black,
                                            fontWeight:
                                            FontWeight.normal),
                                      ),
                                      const Spacer(),
                                      Container(
                                        width: 1,
                                        height: size.width * numD04,
                                        color: Colors.grey,
                                      ),
                                      const Spacer(),
                                      Image.asset(
                                        "${iconsPath}ic_car.png",
                                        width: size.width * numD05,
                                      ),
                                      SizedBox(
                                        width: size.width * numD01,
                                      ),
                                      Text(
                                        _drivingEstTime,
                                        style: commonTextStyle(
                                            size: size,
                                            fontSize:
                                            size.width * numD035,
                                            color: Colors.black,
                                            fontWeight:
                                            FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: EdgeInsets.only(
                          top: size.width * numD08,
                          right: size.width * numD04),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                          BorderRadius.circular(size.width * numD04),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade300,
                                spreadRadius: 2,
                                blurRadius: 2)
                          ]),
                      child: ClipRRect(
                          borderRadius:
                          BorderRadius.circular(size.width * numD04),
                          child: Image.network(
                            taskDetail!.mediaHouseImage,
                            height: size.width * numD14,
                            width: size.width * numD14,
                            fit: BoxFit.cover,
                            errorBuilder: (context, object, stacktrace) {
                              return Padding(
                                padding:
                                EdgeInsets.all(size.width * numD02),
                                child: Image.asset(
                                  "${commonImagePath}rabbitLogo.png",
                                  height: size.width * numD14,
                                  width: size.width * numD14,
                                ),
                              );
                            },
                          )),
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(
                  horizontal: size.width * numD07,
                  vertical: size.width * numD01,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: size.width * numD03,
                    ),

                    /// News Company Name
                    Text(
                      broadCastedData!.mediaHouseName,
                      style: commonTextStyle(
                          size: size,
                          fontSize: size.width * numD04,
                          color: Colors.black,
                          fontWeight: FontWeight.w300),
                    ),

                    SizedBox(
                      height: size.width * numD05,
                    ),

                    /// News Headline
                    Text(
                      broadCastedData!.headline,
                      style: commonTextStyle(
                          size: size,
                          fontSize: size.width * numD04,
                          color: Colors.black,
                          lineHeight: 1.5,
                          fontWeight: FontWeight.w600),
                    ),

                    SizedBox(
                      height: size.width * numD02,
                    ),

                    /// News Description
                    Text(
                      "${broadCastedData!.taskDescription}\n\n${broadCastedData!.specialRequirements}",
                      style: commonTextStyle(
                        size: size,
                        fontSize: size.width * numD03,
                        color: Colors.black,
                        lineHeight: 1.8,
                        fontWeight: FontWeight.normal,
                      ),
                      textAlign: TextAlign.justify,
                    ),

                    /// Divider
                    const Divider(
                      thickness: 1,
                      color: colorLightGrey,
                    ),

                    Container(
                      margin: EdgeInsets.only(
                        top: size.width * numD04,
                        bottom: size.width * numD05,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: size.width * numD20,
                              padding: EdgeInsets.symmetric(
                                  vertical: size.width * numD03,
                                  horizontal: size.width * numD02),
                              decoration: BoxDecoration(
                                  color: colorLightGrey,
                                  borderRadius: BorderRadius.circular(
                                      size.width * numD03)),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.access_time,
                                        color: Colors.black,
                                        size: size.width * numD04,
                                      ),
                                      SizedBox(
                                        width: size.width * numD01,
                                      ),
                                      Text(
                                        deadlineText,
                                        style: commonTextStyle(
                                            size: size,
                                            fontSize: size.width * numD03,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: size.width * numD01,
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: size.width * numD01,
                                          top: size.width * numD01),
                                      child: TimerCountdown(
                                        endTime:
                                        broadCastedData!.deadLine,
                                        spacerWidth: 3,
                                        enableDescriptions: false,
                                        countDownFormatter:
                                            (day, hour, min, sec) {
                                          if (broadCastedData!.deadLine
                                              .difference(
                                              DateTime.now())
                                              .inDays >
                                              0) {
                                            return "${day}d:${hour}h:${min}m:${sec}s";
                                          } else {
                                            return "${hour}h:${min}m:${sec}s";
                                          }
                                        },
                                        format: CountDownTimerFormat
                                            .customFormats,
                                        timeTextStyle: commonTextStyle(
                                            size: size,
                                            fontSize: size.width * numD03,
                                            color: Colors.black,
                                            fontWeight:
                                            FontWeight.normal),
                                      ) /*Text(
                                            "1h: 21m: 11s",
                                            style: commonTextStyle(
                                                size: size,
                                                fontSize: size.width * numD03,
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal),
                                          ),*/
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: size.width * numD05,
                          ),
                          Expanded(
                            child: Container(
                              height: size.width * numD20,
                              padding: EdgeInsets.symmetric(
                                  vertical: size.width * numD03,
                                  horizontal: size.width * numD02),
                              decoration: BoxDecoration(
                                  color: colorLightGrey,
                                  borderRadius: BorderRadius.circular(
                                      size.width * numD03)),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        "${iconsPath}ic_location.png",
                                        width: size.width * numD03,
                                      ),
                                      SizedBox(
                                        width: size.width * numD01,
                                      ),
                                      Text(
                                        locationText.toUpperCase(),
                                        style: commonTextStyle(
                                            size: size,
                                            fontSize: size.width * numD03,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      left: size.width * numD01,
                                      top: size.width * numD01,
                                    ),
                                    child: Text(
                                      broadCastedData!.location,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: commonTextStyle(
                                          size: size,
                                          fontSize: size.width * numD03,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    priceOfferWidget(),

                    SizedBox(
                      height: size.width * numD1,
                    ),

                    /// Button
                    Row(
                      children: [
                        Expanded(
                            child: SizedBox(
                              height: size.width * numD15,
                              child: commonElevatedButton(
                                  declineText.toTitleCase(),
                                  size,
                                  commonTextStyle(
                                      size: size,
                                      fontSize: size.width * numD04,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                  commonButtonStyle(size, Colors.black), () {
                                _isAccepted = false;
                                callAcceptRejectApi();
                                debugPrint("rejected====>");
                                setState(() {});
                              }),
                            )),
                        SizedBox(
                          width: size.width * numD03,
                        ),
                        Expanded(
                            child: SizedBox(
                              height: size.width * numD15,
                              child: commonElevatedButton(
                                  acceptText,
                                  size,
                                  commonTextStyle(
                                      size: size,
                                      fontSize: size.width * numD04,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                  commonButtonStyle(size, colorThemePink),
                                      () {
                                    _isAccepted = true;
                                    //isDirection = true;
                                    callAcceptRejectApi();

                                    debugPrint("accepted====>");
                                    setState(() {});
                                  }),
                            ))
                      ],
                    ),

                    SizedBox(
                      height: size.width * numD05,
                    ),
                  ],
                ),
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.only(
                      top: size.width * numD08,
                      left: size.width * numD04),
                  padding: EdgeInsets.all(size.width * numD02),
                  decoration: const BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: Image.asset(
                    "${iconsPath}ic_arrow_left.png",
                    height: size.width * numD06,
                    width: size.width * numD06,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  requestContactsPermission();
                  showShareBottomSheet();
                },
                child: Container(
                  margin: EdgeInsets.only(
                      top: size.width * numD08,
                      left: size.width * numD04),
                  padding: EdgeInsets.all(size.width * numD02),
                  decoration: const BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: Image.asset(
                    "${iconsPath}ic_share_now.png",
                    height: size.width * numD06,
                    width: size.width * numD06,
                  ),
                ),
              ),
            ],
          )
        ],
      )
          : showLoader(),
    );
  }



  /// Price Offer widget
  Widget priceOfferWidget() {
    return Column(
      children: [
        const Divider(),

        SizedBox(
          height: size.width * numD05,
        ),

        /*/// Price Offer
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    taskDetail!.isNeedPhoto
                        ? "$euroUniqueCode${taskDetail!.photoPrice}"
                        : "- -",
                    style: commonTextStyle(
                        size: size,
                        fontSize: size.width * numD065,
                        color: colorThemePink,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    offeredText,
                    style: commonTextStyle(
                        size: size,
                        fontSize: size.width * numD04,
                        color: colorHint,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: size.width * numD04,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * numD04,
                        vertical: size.width * numD02),
                    decoration: BoxDecoration(
                        color: colorLightGrey,
                        borderRadius:
                            BorderRadius.circular(size.width * numD02)),
                    child: Text(
                      pictureText,
                      style: commonTextStyle(
                          size: size,
                          fontSize: size.width * numD04,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    taskDetail!.isNeedInterview
                        ? "$euroUniqueCode${taskDetail!.interviewPrice}"
                        : "- -",
                    style: commonTextStyle(
                        size: size,
                        fontSize: size.width * numD065,
                        color: colorThemePink,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    offeredText,
                    style: commonTextStyle(
                        size: size,
                        fontSize: size.width * numD04,
                        color: colorHint,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: size.width * numD04,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * numD04,
                        vertical: size.width * numD02),
                    decoration: BoxDecoration(
                        color: colorLightGrey,
                        borderRadius:
                            BorderRadius.circular(size.width * numD02)),
                    child: Text(
                      interviewText,
                      style: commonTextStyle(
                          size: size,
                          fontSize: size.width * numD04,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    taskDetail!.isNeedVideo
                        ? "$euroUniqueCode${taskDetail!.videoPrice}"
                        : "- -",
                    style: commonTextStyle(
                        size: size,
                        fontSize: size.width * numD065,
                        color: colorThemePink,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    offeredText,
                    style: commonTextStyle(
                        size: size,
                        fontSize: size.width * numD04,
                        color: colorHint,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: size.width * numD04,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * numD04,
                        vertical: size.width * numD02),
                    decoration: BoxDecoration(
                        color: colorLightGrey,
                        borderRadius:
                            BorderRadius.circular(size.width * numD02)),
                    child: Text(
                      videoText,
                      style: commonTextStyle(
                          size: size,
                          fontSize: size.width * numD04,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),*/

        /// Price Offer
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Column(
                children: [
                  Text(
                    taskDetail!.isNeedPhoto
                        ? "$euroUniqueCode${taskDetail!.photoPrice}"
                        : "-",
                    style: commonTextStyle(
                        size: size,
                        fontSize: size.width * numD06,
                        color: colorThemePink,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    offeredText,
                    style: commonTextStyle(
                        size: size,
                        fontSize: size.width * numD035,
                        color: colorHint,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: size.width * numD04,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * numD04,
                        vertical: size.width * numD02),
                    decoration: BoxDecoration(
                        color: colorLightGrey,
                        borderRadius:
                        BorderRadius.circular(size.width * numD02)),
                    child: Text(
                      photoText,
                      style: commonTextStyle(
                          size: size,
                          fontSize: size.width * numD035,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    taskDetail!.isNeedInterview
                        ? "$euroUniqueCode${taskDetail!.interviewPrice}"
                        : "-",
                    style: commonTextStyle(
                        size: size,
                        fontSize: size.width * numD06,
                        color: colorThemePink,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    offeredText,
                    style: commonTextStyle(
                        size: size,
                        fontSize: size.width * numD035,
                        color: colorHint,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: size.width * numD04,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * numD04,
                        vertical: size.width * numD02),
                    decoration: BoxDecoration(
                        color: colorLightGrey,
                        borderRadius:
                        BorderRadius.circular(size.width * numD02)),
                    child: Text(
                      interviewText,
                      style: commonTextStyle(
                          size: size,
                          fontSize: size.width * numD035,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    taskDetail!.isNeedVideo
                        ? "$euroUniqueCode${taskDetail!.videoPrice}"
                        : "-",
                    style: commonTextStyle(
                        size: size,
                        fontSize: size.width * numD06,
                        color: colorThemePink,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    offeredText,
                    style: commonTextStyle(
                        size: size,
                        fontSize: size.width * numD035,
                        color: colorHint,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: size.width * numD04,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * numD04,
                        vertical: size.width * numD02),
                    decoration: BoxDecoration(
                        color: colorLightGrey,
                        borderRadius:
                        BorderRadius.circular(size.width * numD02)),
                    child: Text(
                      videoText,
                      style: commonTextStyle(
                          size: size,
                          fontSize: size.width * numD035,
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),

        SizedBox(
          height: size.width * numD05,
        ),

        const Divider(),
      ],
    );
  }

  Future<void> showShareBottomSheet() async {
    showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        useSafeArea: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(size.width * numD085),
              topRight: Radius.circular(size.width * numD085),
            )),
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter stateSetter) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Heading
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * numD05,
                  ).copyWith(
                    top: size.width * numD05,
                    bottom: size.width * numD02,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        splashRadius: size.width * numD05,
                        icon: Icon(
                          Icons.close,
                          color: Colors.black,
                          size: size.width * numD06,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            "Share the task",
                            style: commonTextStyle(
                                size: size,
                                fontSize: size.width * numD045,
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),

                      /*    /// Share Button
                      isMultipleContact
                          ? commonElevatedButton(
                              shareText,
                              size,
                              commonTextStyle(
                                  size: size,
                                  fontSize: size.width * numD035,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                              commonButtonStyle(size, colorThemePink),
                              () {})
                          : Container(),*/
                    ],
                  ),
                ),

                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * numD04,
                      vertical: size.width * numD04,
                    ),
                    children: [
                      /// Share Sub Text
                      Text(
                        boardCastShareSubText,
                        textAlign: TextAlign.center,
                        style: commonTextStyle(
                            size: size,
                            fontSize: size.width * numD035,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: size.width * numD03,
                      ),

                      /// Search
                      TextFormField(
                        controller: contactSearchController,
                        cursorColor: colorTextFieldIcon,
                        onChanged: (value) {
                          contactSearch = contactsDataList
                              .where((element) => element.displayName!
                              .trim()
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                              .toList();

                          debugPrint("searchResult :: ${contactSearch.length}");
                          setState(() {});
                          stateSetter(() {});
                        },
                        decoration: InputDecoration(
                          fillColor: colorLightGrey,
                          isDense: true,
                          filled: true,
                          hintText: searchHintText,
                          hintStyle: TextStyle(
                              color: colorHint, fontSize: size.width * numD04),
                          disabledBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(size.width * 0.03),
                              borderSide: const BorderSide(
                                  width: 0, color: colorLightGrey)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(size.width * 0.03),
                              borderSide: const BorderSide(
                                  width: 0, color: colorLightGrey)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(size.width * 0.03),
                              borderSide: const BorderSide(
                                  width: 0, color: colorLightGrey)),
                          errorBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(size.width * 0.03),
                              borderSide: const BorderSide(
                                  width: 0, color: colorLightGrey)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(size.width * 0.03),
                              borderSide: const BorderSide(
                                  width: 0, color: colorLightGrey)),
                          suffixIcon: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * numD02),
                            child: Image.asset(
                              "${iconsPath}ic_search.png",
                              color: Colors.black,
                            ),
                          ),
                          suffixIconConstraints:
                          BoxConstraints(maxHeight: size.width * numD06),
                        ),
                        textAlignVertical: TextAlignVertical.center,
                      ),

                      /// User List
                      contactsDataList.isNotEmpty
                          ? ListView.separated(
                          padding: EdgeInsets.symmetric(
                              vertical: size.width * numD06),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            var item =
                            contactSearchController.text.isNotEmpty
                                ? contactSearch[index]
                                : contactsDataList[index];
                            return InkWell(
                              onTap: () {
                                /* contactsDataList[index].isContactSelected = !contactsDataList[index].isContactSelected;
                                if( contactsDataList[index].isContactSelected){
                                  isMultipleContact = true;
                                }*/
                                /*stateSetter(() {});
                                    setState(() {});*/
                              },
                              child: Container(
                                padding:
                                EdgeInsets.all(size.width * numD02),
                                color: item.isContactSelected
                                    ? colorLightGrey
                                    : Colors.transparent,
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: size.width * numD15,
                                          width: size.width * numD15,
                                          padding: EdgeInsets.all(
                                              size.width * numD01),
                                          decoration: const BoxDecoration(
                                              color: colorThemePink,
                                              shape: BoxShape.circle),
                                          child: ClipOval(
                                            child: item.avatar != null
                                                ? Image.memory(
                                              item.avatar!,
                                              height:
                                              size.width * numD09,
                                              width:
                                              size.width * numD09,
                                              fit: BoxFit.contain,
                                              errorBuilder:
                                                  (context, dd, v) {
                                                return Center(
                                                    child: Text(
                                                      item.displayName![0]
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize:
                                                          size.width *
                                                              numD05,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
                                                          color: Colors
                                                              .white),
                                                    ));
                                              },
                                            )
                                                : Center(
                                                child: Text(
                                                  item.displayName![0]
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize:
                                                      size.width *
                                                          numD05,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color:
                                                      Colors.white),
                                                )),
                                          ),
                                        ),
                                        SizedBox(
                                          width: size.width * numD025,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: size.width * numD30,
                                              child: Text(
                                                item.displayName.toString(),
                                                maxLines: 1,
                                                overflow:
                                                TextOverflow.ellipsis,
                                                style: commonTextStyle(
                                                    size: size,
                                                    fontSize: size.width *
                                                        numD037,
                                                    color: Colors.black,
                                                    fontWeight:
                                                    FontWeight.w600),
                                              ),
                                            ),
                                            Text(
                                              item.phones!.isNotEmpty
                                                  ? item.phones!.first.value
                                                  .toString()
                                                  : '',
                                              style: commonTextStyle(
                                                  size: size,
                                                  fontSize:
                                                  size.width * numD035,
                                                  color: Colors.black,
                                                  fontWeight:
                                                  FontWeight.w400),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () async {
                                              String phoneNumber = item
                                                  .phones!.first.value
                                                  .toString()
                                                  .trim();
                                              final Uri uri = Uri(
                                                  scheme: 'sms',
                                                  path: phoneNumber,
                                                  queryParameters: {
                                                    'body':
                                                    '${broadCastedData!.headline}\n${broadCastedData!.taskDescription}\nHi ${item.displayName}, ${sharedPreferences!.getString(firstNameKey).toString()} ${sharedPreferences!.getString(lastNameKey).toString()} has shared a task priced from £${broadCastedData!.minimumPriceRange} to £${broadCastedData!.maximumPriceRange} with you. Please click this ${Uri.parse(baseShareUrl)} to download Presshop and review the task.Cheers'
                                                  });
                                              if (await canLaunchUrl(uri)) {
                                                await launchUrl(uri);
                                              } else {
                                                showSnackBar(
                                                    'PRESSHOP',
                                                    errorOpenSMS,
                                                    Colors.black);
                                                // Handle the case when the URL can't be launched.
                                                throw ('Error launching Sms');
                                              }
                                            },
                                            splashRadius:
                                            size.width * numD05,
                                            icon: Image.asset(
                                              "${iconsPath}message_icon.png",
                                              height: size.width * numD06,
                                            )),
                                        IconButton(
                                            splashRadius:
                                            size.width * numD05,
                                            onPressed: () async {
                                              String phoneNumber = item
                                                  .phones!.first.value
                                                  .toString()
                                                  .trim();
                                              /*Uri whatsappUrl = Uri.parse(
                                                      "whatsapp://send?phone=$phoneNumber&text=${Uri.encodeComponent("${broadCastedData!.headline}\n\n ${broadCastedData!.taskDescription}"
                                                          "\n\n ${Uri.parse(baseShareUrl)}")}"); */
                                              Uri whatsappUrl = Uri.parse(
                                                  "whatsapp://send?phone=$phoneNumber&text=${Uri.encodeComponent("${broadCastedData!.headline}\n ${broadCastedData!.taskDescription}"
                                                      "\n\n Hi ${item.displayName}, ${sharedPreferences!.getString(firstNameKey).toString()} ${sharedPreferences!.getString(lastNameKey).toString()} has shared a task priced from £${broadCastedData!.minimumPriceRange} to £${broadCastedData!.maximumPriceRange} with you. Please click this ${Uri.parse(baseShareUrl)} to download Presshop and review the task. Cheers")}");

                                              debugPrint(
                                                  "whatsapp==> $whatsappUrl");
                                              if (await canLaunchUrl(
                                                  whatsappUrl)) {
                                                await launchUrl(
                                                    whatsappUrl);
                                              } else {
                                                showSnackBar(
                                                    'PRESSHOP',
                                                    errorOpenWhatsapp,
                                                    Colors.black);
                                                // Handle the case when the URL can't be launched.
                                                throw ('Error launching Whatsapp');
                                              }
                                            },
                                            icon: Padding(
                                              padding: EdgeInsets.only(
                                                  bottom:
                                                  size.width * numD006),
                                              child: Image.asset(
                                                "${iconsPath}whatsapp_icon.png",
                                                height:
                                                size.width * numD058,
                                              ),
                                            ))
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: size.width * numD04,
                            );
                          },
                          itemCount: contactSearchController.text.isNotEmpty
                              ? contactSearch.length
                              : contactsDataList.length)
                          : Center(
                        child: Padding(
                          padding: EdgeInsets.all(size.width * numD05),
                          child: const Text("Not Contact Available"),
                        ),
                      ),

                      /* /// Share Button
                      contactsDataList != null
                          ? Container(
                        width: size.width,
                        height: size.width * numD14,
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * numD08,
                        ),
                        margin: EdgeInsets.only(
                          top: size.width * numD06,
                          bottom: size.width * numD08,
                        ),
                        child: commonElevatedButton(
                            shareText,
                            size,
                            commonTextStyle(
                                size: size,
                                fontSize: size.width * numD035,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                            commonButtonStyle(size, colorThemePink),
                                () {}),
                      )
                          : Container(),*/
                    ],
                  ),
                ),
              ],
            );
          });
        });
  }

  /// Update Map Location
  Future<void> _updateGoogleMap(LatLng latLng) async {
    final GoogleMapController controller = await _controller.future;
    marker.add(Marker(
      markerId: const MarkerId("1"),
      position: latLng,
      icon: mapIcon!,
    ));
    controller.animateCamera(CameraUpdate.newLatLngZoom(
        LatLng(latLng.latitude, latLng.longitude), 12));
    setState(() {});

/*
    setState(() {
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: latLng,
        zoom: 14.4746,
      )));
    });*/
  }

  /// Current Lat Lng
  void getCurrentLocation() async {
    bool serviceEnable = await checkGps();
    bool locationEnable = await locationPermission();
    if (serviceEnable && locationEnable) {
      LocationData loc = await Location.instance.getLocation();
      setState(() {
        _latLng = LatLng(loc.latitude!, loc.longitude!);
        _showMap = true;
        debugPrint("_longitude: $_latLng");
      });
      taskDetailApi();
    } else {
      showSnackBar(
          "Permission Denied", "Please Allow Loction permission", Colors.red);
    }
  }

  /// Initialize Map icon
  void getAllIcons() async {
    mapIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(5.0, 5.0)),
        "${commonImagePath}ic_cover_radius.png");
  }

  openUrl() async {
    String googleUrl = isDirection
        ? 'https://www.google.com/maps/dir/?api=1&origin=${_latLng!.latitude},'
        '${_latLng!.longitude}&destination=${broadCastedData!.latitude},'
        '${broadCastedData!.longitude}&travelmode=driving&dir_action=navigate'
        : 'https://www.google.com/maps/search/?api=1&query=${broadCastedData!.latitude},${broadCastedData!.longitude}';

    String appleUrl = isDirection
        ? 'http://maps.apple.com/maps?saddr=${_latLng!.latitude},'
        '${_latLng!.longitude}&daddr=${broadCastedData!.latitude},'
        '${broadCastedData!.longitude}'
        : 'http://maps.apple.com/?q=${broadCastedData!.latitude},'
        '${broadCastedData!.longitude}';
    if (await canLaunchUrl(Uri.parse(googleUrl))) {
      debugPrint('launching com googleUrl');
      await launchUrl(Uri.parse(googleUrl),
          mode: LaunchMode.externalApplication);
    } else if (await canLaunchUrl(Uri.parse(appleUrl))) {
      debugPrint('launching apple url');
      await launchUrl(Uri.parse(appleUrl),
          mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch url';
    }
  }

  /// Contact Permission
  Future<void> requestContactsPermission() async {
    PH.PermissionStatus permissionStatus = await Permission.contacts.request();
    if (permissionStatus.isGranted) {
      // Permission granted, proceed with retrieving contacts
      getContacts();
    } else {
      // Permission denied, handle accordingly (e.g., show error message)
    }
  }

  /// Contact List
  Future<void> getContacts() async {
    Iterable<Contact> contacts = await ContactsService.getContacts();
    for (var contact in contacts) {
      contactsDataList.add(ContactListModel(
        displayName: contact.displayName,
        givenName: contact.givenName,
        middleName: contact.middleName,
        phones: contact.phones,
        avatar: contact.avatar,
        isContactSelected: false,
      ));
    }
  }

  ///--------Apis Section------------

  void taskDetailApi() {
    NetworkClass("$taskDetailUrl${widget.taskId}", this, taskDetailUrlRequest)
        .callRequestServiceHeader(false, "get", null);
  }

  void getEstimateTime() {
    debugPrint("::: Inside estimate Time Fuc ::::");
    dynamic mapKey;
    if( Platform.isIOS){
      mapKey = appleMapAPiKey;
    }else{
      mapKey = googleMapAPiKey;
    }

    String drivingMode =
        "https://maps.googleapis.com/maps/api/distancematrix/json?origins="
        "${_latLng!.latitude},${_latLng!.longitude}&&destinations="
        "${broadCastedData!.latitude},${broadCastedData!.longitude}"
        "&mode=driving&key=$mapKey";

    String walkingMode =
        "https://maps.googleapis.com/maps/api/distancematrix/json?origins="
        "${_latLng!.latitude},${_latLng!.longitude}&destinations="
        "${broadCastedData!.latitude},${broadCastedData!.longitude}&mode=walking&key=$mapKey";

    debugPrint("drivingMode : $drivingMode");
    debugPrint("walkingMode : $walkingMode");

    var res = http.get(Uri.parse(drivingMode)).then((value) {
      debugPrint("Status Code : ${value.statusCode}");
      debugPrint("Body : ${value.body}");
      if (value.statusCode <= 201) {
        var data = jsonDecode(value.body);
        var dataModel = data["rows"] as List;
        if (dataModel.isNotEmpty) {
          var dataModel2 = dataModel.first["elements"] as List;
          if (dataModel2.isNotEmpty) {
            _drivingEstTime = dataModel2.first["duration"]["text"] ?? "";
            _distance = dataModel2.first["distance"]["text"] ?? "";
          }
        }
      }
      setState(() {});
    });

    var res1 = http.get(Uri.parse(walkingMode)).then((value) {
      debugPrint("Status Code : ${value.statusCode}");
      debugPrint("Body : ${value.body}");
      debugPrint("");
      if (value.statusCode <= 201) {
        var data = jsonDecode(value.body);
        var dataModel = data["rows"] as List;
        if (dataModel.isNotEmpty) {
          var dataModel2 = dataModel.first["elements"] as List;
          if (dataModel2.isNotEmpty) {
            _walkingEstTime = dataModel2.first["duration"]["text"] ?? "";
            _distance = dataModel2.first["distance"]["text"] ?? "";
          }
          setState(() {});
        }
      }
    });
  }

  /// Accept Reject Api
  void callAcceptRejectApi() {
    Map<String, String> map = {
      "task_id": widget.taskId,
      "mediahouse_id": widget.mediaHouseId,
      "task_status": _isAccepted ? "accepted" : "rejected"
    };

    debugPrint("map accepted value===>: $map");
    NetworkClass.fromNetworkClass(
        taskAcceptRejectRequestUrl, this, taskAcceptRejectRequestReq, map)
        .callRequestServiceHeader(true, "post", null);
  }

  /// Get Room Id
  void callGetRoomIdApi() {
    Map<String, String> map = {
      "receiver_id": broadCastedData!.mediaHouseId,
      "room_type": "HoppertoAdmin",
      "type": "external_task",
      "task_id": widget.taskId,
    };

    debugPrint("Map : $map");

    NetworkClass.fromNetworkClass(getRoomIdUrl, this, getRoomIdReq, map)
        .callRequestServiceHeader(true, "post", null);
  }

  /// Get Hopper Accepted List
  void callGetHopperAcceptedCount() {
    NetworkClass(
      "$getHopperAcceptedCountUrl?task_id=${broadCastedData!.broadcastedId}",
      this,
      getHopperAcceptedCountReq,
    ).callRequestServiceHeader(false, "get", null);
  }

  @override
  void onError({required int requestCode, required String response}) {
    try {
      switch (requestCode) {
      /// Get Hopper Accepted List
        case getHopperAcceptedCountReq:
          {
            var data = jsonDecode(response);
            debugPrint("getHopperAcceptedCountReq Error : $data");
            showSnackBar("Error", data.toString(), Colors.red);
            break;
          }

      /// Get Room Id
        case getRoomIdReq:
          {
            var data = jsonDecode(response);
            debugPrint("getRoomIdReq Error : $data");
            showSnackBar("Error", data.toString(), Colors.red);
            break;
          }

        case taskDetailUrlRequest:
          debugPrint("BroadcastedData::::Error");
          break;

      /// Task Accept Reject
        case taskAcceptRejectRequestReq:
          {
            var data = jsonDecode(response);
            debugPrint("taskAcceptRejectRequestReq Success : $data");
            if (data != null && data['errors'] != null) {
              showSnackBar(
                  "Error", data['errors']['msg'].toString(), Colors.red);
            } else {
              showSnackBar("Error", data.toString(), Colors.red);
            }
            break;
          }
      }
    } on Exception catch (e) {
      debugPrint("$e");
    }
  }

  @override
  void onResponse({required int requestCode, required String response}) {
    try {
      switch (requestCode) {
      /// Get Hopper Accepted List
        case getHopperAcceptedCountReq:
          var data = jsonDecode(response);
          debugPrint("getHopperAcceptedCountReq Success : $data");
          _hopperAcceptedCount = (data["count"] ?? "0").toString();
          /*  _hopperCountTimer = Timer(
              const Duration(seconds: 10), () => callGetHopperAcceptedCount());*/
          break;

      /// Get Room Id
        case getRoomIdReq:
          var data = jsonDecode(response);
          debugPrint("getRoomIdReq Success : $data");
          //  openUrl();
          Navigator.pushAndRemoveUntil(
              navigatorKey.currentState!.context,
              MaterialPageRoute(
                  builder: (context) =>
                      Dashboard(initialPosition: 1, taskStatus: "accepted")),
                  (route) => false);
          break;

      /// Task Accept Reject
        case taskAcceptRejectRequestReq:
          var data = jsonDecode(response);
          debugPrint("taskAcceptRejectRequestReq Success : $data");
          debugPrint("taskStatus ========> $_isAccepted");
          if (_isAccepted) {
            debugPrint("taskStatus true ========> $_isAccepted");
            callGetRoomIdApi();
            showSnackBar("Accepted", "Accepted", Colors.green);
          } else {
            var taskStatusValue = data['data']['task_status'].toString();
            debugPrint("taskStatus false========> $_isAccepted");

            Navigator.pushAndRemoveUntil(
                navigatorKey.currentState!.context,
                MaterialPageRoute(
                    builder: (context) => Dashboard(
                        initialPosition: 1, taskStatus: taskStatusValue)),
                    (route) => false);
          }
          break;

        case taskDetailUrlRequest:
          debugPrint("BroadcastedData::::Success:  $response");

          var map = jsonDecode(response);
          if (map["code"] == 200 && map["task"] != null) {
            broadCastedData = BroadcastedData.fromJson(map["task"]);
            taskDetail = TaskDetailModel.fromJson(map["task"] ?? {});
            callGetHopperAcceptedCount();
            getEstimateTime();
            _updateGoogleMap(
                LatLng(broadCastedData!.latitude, broadCastedData!.longitude));
            // Future.delayed(const Duration(seconds: 5),()=>_updateGoogleMap(LatLng(broadcastedData!.latitude, broadcastedData!.longitude)));
          }
          setState(() {});

          break;
      }
    } on Exception catch (e) {
      debugPrint("$e");
    }
  }
}

class ContactListModel {
  String? identifier, displayName, givenName, middleName;
  List<Item>? phones = [];
  Uint8List? avatar;
  bool isContactSelected = false;

  ContactListModel(
      {required this.displayName,
        required this.givenName,
        required this.middleName,
        required this.phones,
        required this.avatar,
        required this.isContactSelected});
}

class BroadcastedData {
  String broadcastedId = "";
  String headline = "";
  String taskDescription = "";
  String specialRequirements = "";
  String photoPrice = "";
  String videoPrice = "";
  String interviewPrice = "";
  String location = "";
  String deadLineDate = "";
  DateTime deadLine = DateTime.now();
  String mediaHouseName = "";
  String mediaHouseImage = "";
  String mediaHouseId = "";
  double latitude = 0;
  double longitude = 0;
  bool showPhotoPrice = false;
  bool showVideoPrice = false;
  bool showInterviewPrice = false;
  String minimumPriceRange = "";
  String maximumPriceRange = "";

  BroadcastedData.fromJson(json) {
    broadcastedId = json["_id"];
    headline = json["heading"] ?? "";
    taskDescription = json["task_description"];
    specialRequirements = json["any_spcl_req"];
    location = json["location"];
    deadLineDate = json["deadline_date"];
    deadLine = DateTime.parse(dateTimeFormatter(
        dateTime: (json["deadline_date"] ?? "").toString(),
        format: "yyyy-MM-dd HH:mm:ss",
        time: true));
    photoPrice = json["photo_price"].toString();
    videoPrice = json["videos_price"].toString();
    interviewPrice = json["interview_price"].toString();
    if (json["mediahouse_id"] != null &&
        json["mediahouse_id"]["admin_detail"] != null) {
      mediaHouseName = json["mediahouse_id"]["admin_detail"]["full_name"];
      mediaHouseImage = json["mediahouse_id"]["admin_detail"]["admin_profile"];
      mediaHouseId = json["mediahouse_id"]["_id"].toString();

    }
    if(json['mediahouse_id'] != null  && json['mediahouse_id']['admin_rignts'] !=null){
      if(json['mediahouse_id']['admin_rignts']['price_range'] != null ){
        maximumPriceRange = json['mediahouse_id']['admin_rignts']['price_range']['maximum_price'].toString() ;
        minimumPriceRange = json['mediahouse_id']['admin_rignts']['price_range']['minimum_price'].toString();
      }
    }
    if (json["address_location"] != null &&
        json["address_location"]["coordinates"] != null) {
      var coordinatesList = json["address_location"]["coordinates"] as List;

      if (coordinatesList.isNotEmpty) {
        latitude = coordinatesList.first;
        longitude = coordinatesList[1];
      }
    }

    showPhotoPrice = json["need_photos"];
    showVideoPrice = json["need_videos"];
    showInterviewPrice = json["need_interview"];
  }
}
