import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:mime/mime.dart';
import 'package:presshop/utils/networkOperations/NetworkResponse.dart';
import 'package:presshop/view/cameraScreen/AudioWaveFormWidgetScreen.dart';

import '../../main.dart';
import '../../utils/Common.dart';
import '../../utils/CommonAppBar.dart';
import '../../utils/CommonModel.dart';
import '../../utils/CommonSharedPrefrence.dart';
import '../../utils/CommonWigdets.dart';
import '../../utils/VideoWidget.dart';
import '../../utils/commonEnums.dart';
import '../../utils/networkOperations/NetworkClass.dart';
import '../authentication/TermCheckScreen.dart';
import '../cameraScreen/CameraScreen.dart';
import '../chatScreens/FullVideoView.dart';
import '../dashboard/Dashboard.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../menuScreen/ContactUsScreen.dart';
import '../myEarning/MyEarningScreen.dart';
import '../myEarning/TransactionDetailScreen.dart';
import '../myEarning/earningDataModel.dart';

class BroadCastChatTaskScreen extends StatefulWidget {
  final TaskDetailModel? taskDetail;
  final String roomId;

  const BroadCastChatTaskScreen(
      {super.key, required this.taskDetail, required this.roomId});

  @override
  State<BroadCastChatTaskScreen> createState() =>
      _BroadCastChatTaskScreenState();
}

class _BroadCastChatTaskScreenState extends State<BroadCastChatTaskScreen>
    implements NetworkResponse {
  List<ManageTaskChatModel> chatList = [];
  late IO.Socket socket;
  final String _senderId = sharedPreferences!.getString(hopperIdKey) ?? "";
  TextEditingController ratingReviewController1 = TextEditingController();
  List<String> intList = [
    "User experience",
    "Safe",
    "Easy to use",
    "Instant money",
    "Anonymity",
    "Secure Payment",
    "Hopper Support"
  ];
  List<int> indexList = [];
  List<String> dataList = [];
  List<MediaModel> selectMultipleMediaList = [];
  List<EarningTransactionDetail> earningTransactionDataList = [];
  double ratings = 0.0;
  int currentPage = 0;
  bool isRequiredVisible = false;
  bool isRatingGiven = false;
  bool showCelebration = false;
  bool isLoading = false;
  String imageId = "", chatId = "", contentView = "", contentPurchased = "";

  @override
  void initState() {
    debugPrint("class name :::$runtimeType");
    super.initState();
    socketConnectionFunc();
   // callGetManageTaskListingApi();
  }

  void onTextChanged() {
    setState(() {
      isRequiredVisible = ratingReviewController1.text.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: CommonAppBar(
        elevation: 0,
        hideLeading: false,
        title: Text(
          manageTaskText,
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
              "${commonImagePath}ic_black_rabbit.png",
              height: size.width * numD07,
              width: size.width * numD07,
            ),
          ),
          SizedBox(
            width: size.width * numD04,
          )
        ],
      ),
      bottomNavigationBar: !isLoading
          ? showLoader()
          : Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * numD04,
                        vertical: size.width * numD02),
                    height: size.width * numD18,
                    child: commonElevatedButton(
                        galleryText,
                        size,
                        commonButtonTextStyle(size),
                        commonButtonStyle(size, Colors.black), () {
                      getMultipleImages();
                    }),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: size.width * numD04,
                        vertical: size.width * numD02),
                    height: size.width * numD18,
                    child: commonElevatedButton(
                        cameraText,
                        size,
                        commonButtonTextStyle(size),
                        commonButtonStyle(size, colorThemePink), () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CameraScreen(
                                    picAgain: true,
                                    previousScreen:
                                        ScreenNameEnum.manageTaskScreen,
                                  ))).then((value) {
                        if (value != null) {
                          debugPrint(
                              "value:::::$value::::::::${value.first.path}");
                          List<CameraData> temData = value;
                          temData.forEach((element) {
                            selectMultipleMediaList.add(
                              MediaModel(
                                mediaFile: XFile(element.path),
                                mimetype: element.mimeType,
                              ),
                            );
                          });
                          previewBottomSheet();
                        }
                      });
                    }),
                  ),
                ),
              ],
            ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(size.width * numD04),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: size.width * numD055),
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * numD03,
                      vertical: size.width * numD02),
                  width: size.width,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(size.width * numD04),
                          bottomLeft: Radius.circular(size.width * numD04),
                          bottomRight: Radius.circular(size.width * numD04))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: size.width * numD025,
                      ),
                      Row(
                        children: [
                          Text(
                            // "$taskText ${widget.taskDetail?.status}",
                            "TASK ACCEPTED",
                            style: commonTextStyle(
                                size: size,
                                fontSize: size.width * numD035,
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          const Spacer(),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade300,
                                      spreadRadius: 2)
                                ]),
                            child: ClipOval(
                              child: Image.network(
                                widget.taskDetail!.mediaHouseImage.toString(),
                                height: size.width * numD10,
                                width: size.width * numD10,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.width * numD03,
                      ),
                      Text(
                        "${widget.taskDetail?.title}",
                        style: TextStyle(
                          fontSize: size.width * numD035,
                          color: Colors.black,
                          fontFamily: "AirbnbCereal",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        height: size.width * numD04,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  widget.taskDetail!.isNeedPhoto
                                      ? "$euroUniqueCode${formatDouble(double.parse(widget.taskDetail!.photoPrice))}"
                                      : "-",
                                  style: commonTextStyle(
                                      size: size,
                                      fontSize: size.width * numD055,
                                      color: colorThemePink,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  offeredText,
                                  style: commonTextStyle(
                                      size: size,
                                      fontSize: size.width * numD035,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: size.width * numD03,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width * numD045,
                                      vertical: size.width * numD02),
                                  decoration: BoxDecoration(
                                      color: colorThemePink,
                                      borderRadius: BorderRadius.circular(
                                          size.width * numD02)),
                                  child: Text(
                                    photoText,
                                    style: commonTextStyle(
                                        size: size,
                                        fontSize: size.width * numD033,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  widget.taskDetail!.isNeedInterview
                                      ? "$euroUniqueCode${formatDouble(double.parse(widget.taskDetail!.interviewPrice))}"
                                      : "-",
                                  style: commonTextStyle(
                                      size: size,
                                      fontSize: size.width * numD055,
                                      color: colorThemePink,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  offeredText,
                                  style: commonTextStyle(
                                      size: size,
                                      fontSize: size.width * numD035,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: size.width * numD03,
                                ),
                                Container(
                                  // alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width * numD018,
                                      vertical: size.width * numD02),
                                  decoration: BoxDecoration(
                                      color: colorThemePink,
                                      borderRadius: BorderRadius.circular(
                                          size.width * numD02)),
                                  child: Text(
                                    interviewText,
                                    style: commonTextStyle(
                                        size: size,
                                        fontSize: size.width * numD033,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  widget.taskDetail!.isNeedVideo
                                      ? "$euroUniqueCode${formatDouble(double.parse(widget.taskDetail!.videoPrice))}"
                                      : "-",
                                  style: commonTextStyle(
                                      size: size,
                                      fontSize: size.width * numD055,
                                      color: colorThemePink,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  offeredText,
                                  style: commonTextStyle(
                                      size: size,
                                      fontSize: size.width * numD035,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: size.width * numD03,
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width * numD045,
                                      vertical: size.width * numD02),
                                  decoration: BoxDecoration(
                                      color: colorThemePink,
                                      borderRadius: BorderRadius.circular(
                                          size.width * numD02)),
                                  child: Text(
                                    videoText,
                                    style: commonTextStyle(
                                        size: size,
                                        fontSize: size.width * numD033,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: size.width * numD03,
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: EdgeInsets.all(size.width * numD025),
                    decoration: const BoxDecoration(
                        color: Colors.black, shape: BoxShape.circle),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                      size: size.width * numD07,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: size.width * numD04,
            ),
            uploadMediaInfoWidget('', size),
            SizedBox(
              height: size.width * numD033,
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var item = chatList[index];
                    if (item.messageType == "media") {
                      return Column(
                        children: [
                          rightImageChatWidget(item.media!.imageVideoUrl,
                              item.createdAtTime, size),
                          SizedBox(
                            height: size.width * numD03,
                          ),
                          thanksToUploadMediaWidget("", size, chatList.length),
                          SizedBox(
                            height: item.messageType == "request_more_content"
                                ? size.width * numD03
                                : 0,
                          ),
                          item.messageType == "request_more_content"
                              ? moreContentReqWidget(item, size)
                              : Container()
                        ],
                      );
                    }
                  },
                  /* {
                      var item = chatList[index];
                      if (item.messageType == "media") {
                        if (item.media!.type == "video")
                        {
                          return Column(
                            children: [
                              rightVideoChatWidget(item.media!.thumbnail, item.media!.imageVideoUrl, size),
                              SizedBox(
                                height: size.width * numD03,
                              ),
                              thanksToUploadMediaWidget("video", size,chatList.length),
                              SizedBox(
                                height: size.width * numD03,
                              ),
                            ],
                          );
                        } else if (item.media!.type == "audio") {
                          return Column(
                            children: [
                              rightAudioChatWidget(item.media!.imageVideoUrl, size),
                              SizedBox(
                                height: size.width * numD03,
                              ),
                              thanksToUploadMediaWidget("video", size,chatList.length),
                              SizedBox(
                                height: size.width * numD03,
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              rightImageChatWidget(
                                  item.media!.type == "video"
                                      ? item.media!.thumbnail
                                      : item.media!.imageVideoUrl,
                                  item.createdAtTime,
                                  size),
                              SizedBox(
                                height: size.width * numD03,
                              ),
                              thanksToUploadMediaWidget("video", size,chatList.length),
                              SizedBox(
                                height: size.width * numD03,
                              ),
                            ],
                          );
                        }
                      } else if (item.messageType == "buy") {
                        return paymentReceivedWidget(item.amount, size);
                      } else if (item.messageType == "request_more_content") {
                        return moreContentReqWidget(item, size);
                      } else if (item.messageType == "contentupload") {
                        // return moreContentUploadWidget(item);
                        return Column(
                          children: [
                            uploadMediaInfoWidget("request_more_content", size),
                            SizedBox(
                              height: size.width * numD03,
                            ),
                          ],
                        );
                      } else if (item.messageType == "NocontentUpload") {
                        return uploadNoContentWidget(size);
                      } else if (item.messageType == "PaymentIntentApp" &&
                          item.paidStatus) {
                        return mediaHouseOfferWidget(item,
                            item.messageType == "Mediahouse_initial_offer", size);
                      } else if (item.messageType == "rating_hopper") {
                        return ratingReview(size, item);
                      } else {
                        return Container();
                      }
                    },*/
                  itemCount: chatList.length),
              SizedBox(
                height: size.width * numD035,
              ),
              widget.taskDetail!.paidStatus != "paid"
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: size.width * numD013),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade300,
                                    spreadRadius: 2)
                              ]),
                          child: ClipOval(
                            child: Padding(
                              padding: EdgeInsets.all(size.width * numD01),
                              child: Image.asset(
                                "${commonImagePath}ic_black_rabbit.png",
                                width: size.width * numD075,
                                height: size.width * numD075,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.width * numD04,
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * numD05,
                                vertical: size.width * numD02),
                            width: size.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.only(
                                  topRight:
                                      Radius.circular(size.width * numD04),
                                  bottomLeft:
                                      Radius.circular(size.width * numD04),
                                  bottomRight:
                                      Radius.circular(size.width * numD04),
                                )),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: size.width * numD01,
                                ),
                                RichText(
                                    text: TextSpan(
                                        style: const TextStyle(
                                          fontFamily: "AirbnbCereal",
                                          fontWeight: FontWeight.bold,
                                        ),
                                        children: [
                                      TextSpan(
                                        text: "Congratulations, ",
                                        style: commonTextStyle(
                                            size: size,
                                            fontSize: size.width * numD036,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      TextSpan(
                                        text: widget.taskDetail!.mediaHouseName,
                                        style: commonTextStyle(
                                            size: size,
                                            fontSize: size.width * numD036,
                                            color: colorThemePink,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      TextSpan(
                                        text:
                                            " has purchased your content for ",
                                        style: commonTextStyle(
                                            size: size,
                                            fontSize: size.width * numD036,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      TextSpan(
                                        text:
    widget.taskDetail!.interviewPrice.isNotEmpty?
                                            "$euroUniqueCode${formatDouble(double.parse(widget.taskDetail!.interviewPrice))}":"-",
                                        style: commonTextStyle(
                                            size: size,
                                            fontSize: size.width * numD036,
                                            color: colorThemePink,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ])),
                                SizedBox(
                                  height: size.width * numD03,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: size.width * numD13,
                                      width: size.width,
                                      child: commonElevatedButton(
                                          "View Transaction Details",
                                          size,
                                          commonButtonTextStyle(size),
                                          commonButtonStyle(
                                              size, colorThemePink), () {
                                        callDetailApi(
                                            widget.taskDetail!.mediaHouseId);
                                      }),
                                    ),
                                    SizedBox(
                                      height: size.width * numD01,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(),
              SizedBox(
                height: widget.taskDetail!.paidStatus != "paid"
                    ? size.width * numD035
                    : 0,
              ),
              widget.taskDetail!.paidStatus == "paid"
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: size.width * numD013),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade300,
                                    spreadRadius: 2)
                              ]),
                          child: ClipOval(
                            child: Padding(
                              padding: EdgeInsets.all(size.width * numD01),
                              child: Image.asset(
                                "${commonImagePath}ic_black_rabbit.png",
                                width: size.width * numD075,
                                height: size.width * numD075,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.width * numD04,
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * numD05,
                                vertical: size.width * numD02),
                            width: size.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(color: colorGoogleButtonBorder),
                                borderRadius: BorderRadius.only(
                                  topRight:
                                      Radius.circular(size.width * numD04),
                                  bottomLeft:
                                      Radius.circular(size.width * numD04),
                                  bottomRight:
                                      Radius.circular(size.width * numD04),
                                )),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: size.width * numD01,
                                ),
                                RichText(
                                    text: TextSpan(
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: size.width * numD037,
                                          fontFamily: "AirbnbCereal",
                                          fontWeight: FontWeight.bold,
                                        ),
                                        children: [
                                      TextSpan(
                                        text: "Woohoo! We have paid ",
                                        style: commonTextStyle(
                                            size: size,
                                            fontSize: size.width * numD036,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      TextSpan(
                                        text:
                                            "$euroUniqueCode${formatDouble(double.parse(widget.taskDetail!.interviewPrice))}",
                                        style: commonTextStyle(
                                            size: size,
                                            fontSize: size.width * numD036,
                                            color: colorThemePink,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      TextSpan(
                                        text:
                                            " into your bank account. Please visit ",
                                        style: commonTextStyle(
                                            size: size,
                                            fontSize: size.width * numD036,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      TextSpan(
                                        text: "My Earnings",
                                        style: commonTextStyle(
                                            size: size,
                                            fontSize: size.width * numD036,
                                            color: colorThemePink,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      TextSpan(
                                        text: " to view your transaction ",
                                        style: commonTextStyle(
                                            size: size,
                                            fontSize: size.width * numD036,
                                            color: Colors.black,
                                            fontWeight: FontWeight.normal),
                                      )
                                    ])),
                                SizedBox(
                                  height: size.width * numD025,
                                ),
                                /*Row(
                            children: [
                              Expanded(
                                    child: SizedBox(
                                      height: size.width * numD13,
                                      width: size.width,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (item.requestStatus.isEmpty &&
                                              !item.isMakeCounterOffer) {
                                            var map1 = {
                                              "chat_id": item.id,
                                              "status": false,
                                            };

                                            socketEmitFunc(
                                                socketEvent: "reqstatus",
                                                messageType: "",
                                                dataMap: map1);

                                            socketEmitFunc(
                                              socketEvent: "chat message",
                                              messageType: "reject_mediaHouse_offer",
                                            );

                                            socketEmitFunc(
                                              socketEvent: "chat message",
                                              messageType: "rating_hopper",
                                            );

                                            socketEmitFunc(
                                              socketEvent: "chat message",
                                              messageType: "rating_mediaHouse",
                                            );
                                            showRejectBtn = true;
                                          }
                                          setState(() {});
                                        },
                                        style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            backgroundColor: item.requestStatus.isEmpty &&
                                                !item.isMakeCounterOffer
                                                ? Colors.black
                                                : item.requestStatus == "false"
                                                ? Colors.grey
                                                : Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(size.width * numD04),
                                                side: (item.requestStatus == "false" ||
                                                    item.requestStatus.isEmpty) &&
                                                    !item.isMakeCounterOffer
                                                    ? BorderSide.none
                                                    : const BorderSide(
                                                    color: Colors.black, width: 1))),
                                        child: Text(
                                          rejectText,
                                          style: commonTextStyle(
                                              size: size,
                                              fontSize: size.width * numD037,
                                              color: (item.requestStatus == "false" ||
                                                  item.requestStatus.isEmpty) &&
                                                  !item.isMakeCounterOffer
                                                  ? Colors.white
                                                  : colorLightGreen,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    )),
                              SizedBox(
                                width: size.width * numD04,
                              ),
                              Expanded(
                                    child: SizedBox(
                                      height: size.width * numD13,
                                      width: size.width,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          //aditya accept btn
                                          if (item.requestStatus.isEmpty &&
                                              !item.isMakeCounterOffer) {
                                            debugPrint("tapppppp:::::$showAcceptBtn");
                                            showAcceptBtn = true;
                                            var map1 = {
                                              "chat_id": item.id,
                                              "status": true,
                                            };

                                            socketEmitFunc(
                                                socketEvent: "reqstatus",
                                                messageType: "",
                                                dataMap: map1);

                                            socketEmitFunc(
                                                socketEvent: "chat message",
                                                messageType: "accept_mediaHouse_offer",
                                                dataMap: {
                                                  "amount": isMakeCounter
                                                      ? item.initialOfferAmount
                                                      : item.finalCounterAmount,
                                                  "image_id": widget.contentId!,
                                                });
                                          }
                                          setState(() {});
                                        },
                                        style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            backgroundColor: item.requestStatus.isEmpty &&
                                                !item.isMakeCounterOffer
                                                ? colorThemePink
                                                : item.requestStatus == "true"
                                                ? Colors.grey
                                                : Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(size.width * numD04),
                                                side: (item.requestStatus == "true" ||
                                                    item.requestStatus.isEmpty) &&
                                                    !item.isMakeCounterOffer
                                                    ? BorderSide.none
                                                    : const BorderSide(
                                                    color: Colors.black, width: 1))),
                                        child: Text(
                                          acceptText,
                                          style: commonTextStyle(
                                              size: size,
                                              fontSize: size.width * numD037,
                                              color: (item.requestStatus == "true" ||
                                                  item.requestStatus.isEmpty) &&
                                                  !item.isMakeCounterOffer
                                                  ? Colors.white
                                                  : colorLightGreen,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    )),

                              */
                                /* Expanded(
                                    child: SizedBox(
                                      height: size.width * numD13,
                                      width: size.width,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if(item.requestStatus.isEmpty){

                                            var map1 = {
                                              "chat_id" : item.id,
                                              "status" : true,
                                            };

                                            socketEmitFunc(
                                                socketEvent: "reqstatus",
                                                messageType: "",
                                                dataMap: map1
                                            );

                                            socketEmitFunc(
                                                socketEvent: "chat message",
                                                messageType: "contentupload",
                                            );
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                            item.requestStatus.isEmpty
                                                ? colorThemePink
                                                :item.requestStatus == "true"
                                                ?  Colors.grey
                                                :  Colors.transparent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  size.width * numD04),
                                                side: item.requestStatus == "true" || item.requestStatus.isEmpty ? BorderSide.none : const BorderSide(
                                                    color: colorGrey1, width: 2)
                                            )),
                                        child: Text(
                                          yesText,
                                          style: commonTextStyle(
                                              size: size,
                                              fontSize: size.width * numD04,
                                              color: item.requestStatus == "true" || item.requestStatus.isEmpty ? Colors.white : colorLightGreen,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    )),*/ /*
                            ],
                          ),*/
                                SizedBox(
                                  height: size.width * numD03,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: size.width * numD13,
                                      width: size.width,
                                      child: commonElevatedButton(
                                          "View My Earnings",
                                          size,
                                          commonButtonTextStyle(size),
                                          commonButtonStyle(
                                              size, colorThemePink), () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MyEarningScreen(
                                                      openDashboard: false,
                                                    )));
                                      }),
                                    ),
                                    SizedBox(
                                      height: size.width * numD01,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    )
                  : Container(),
            ]),
          ],
        ),
      ),
    );
  }

  Widget uploadMediaInfoWidget(String uploadTextType, var size) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
              top: uploadTextType == "request_more_content"
                  ? size.width * numD04
                  : 0),
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.grey.shade300, spreadRadius: 2)
              ]),
          child: ClipOval(
            child: Padding(
              padding: EdgeInsets.all(size.width * numD01),
              child: Image.asset(
                "${commonImagePath}ic_black_rabbit.png",
                width: size.width * numD075,
                height: size.width * numD075,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        SizedBox(
          width: size.width * numD04,
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(
                top: uploadTextType == "request_more_content"
                    ? size.width * numD05
                    : 0),
            padding: EdgeInsets.symmetric(
                horizontal: size.width * numD03, vertical: size.width * numD02),
            width: size.width,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(size.width * numD04),
                    bottomLeft: Radius.circular(size.width * numD04),
                    bottomRight: Radius.circular(size.width * numD04))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                    text: TextSpan(
                        style: TextStyle(
                            fontSize: size.width * numD035,
                            color: Colors.black,
                            fontFamily: "AirbnbCereal",
                            height: 1.5),
                        children: [
                      TextSpan(
                        text: uploadTextType == "request_more_content"
                            ? "Please upload more content by clicking the"
                            : "Please upload content by clicking the",
                      ),
                      TextSpan(
                        text: " Gallery or Camera",
                        style: TextStyle(
                          fontSize: size.width * numD035,
                          color: colorThemePink,
                          fontFamily: "AirbnbCereal",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(
                        text: " buttons below",
                      ),
                    ])),
                SizedBox(
                  height: size.width * numD008,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget rightVideoChatWidget(String thumbnail, String videoUrl, var size) {
    debugPrint("----------------$videoUrl");
    debugPrint("-thumbnail---------------$thumbnail");
    return Container(
      margin: EdgeInsets.only(top: size.width * numD04),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MediaViewScreen(
                              mediaFile: videoUrl,
                              type: MediaTypeEnum.video,
                            )));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(size.width * numD04),
                    child: Image.network(
                      thumbnail,
                      height: size.height / 3,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                    top: size.width * numD02,
                    left: size.width * numD02,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * numD006,
                          vertical: size.width * numD002),
                      decoration: BoxDecoration(
                          color: colorLightGreen.withOpacity(0.8),
                          borderRadius:
                              BorderRadius.circular(size.width * numD01)),
                      child: const Icon(
                        Icons.videocam_outlined,
                        color: Colors.white,
                      ),
                    )),
                InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MediaViewScreen(
                              mediaFile: videoUrl,
                              type: MediaTypeEnum.video,
                            )));
                  },
                  child: Icon(
                    Icons.play_circle,
                    color: Colors.white,
                    size: size.width * numD09,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: size.width * numD02,
          ),
          (avatarImageUrl + (sharedPreferences!.getString(avatarKey) ?? ""))
                  .isNotEmpty
              ? Container(
                  padding: EdgeInsets.all(
                    size.width * numD01,
                  ),
                  decoration: const BoxDecoration(
                      color: colorLightGrey, shape: BoxShape.circle),
                  child: ClipOval(
                      clipBehavior: Clip.antiAlias,
                      child: Image.network(
                        avatarImageUrl +
                            (sharedPreferences!.getString(avatarKey) ?? ""),
                        fit: BoxFit.cover,
                        height: size.width * numD09,
                        width: size.width * numD09,
                      )))
              : Container(
                  padding: EdgeInsets.all(
                    size.width * numD01,
                  ),
                  height: size.width * numD09,
                  width: size.width * numD09,
                  decoration: const BoxDecoration(
                      color: colorSwitchBack, shape: BoxShape.circle),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Image.asset("${commonImagePath}rabbitLogo.png",
                        fit: BoxFit.contain),
                  ),
                ),
        ],
      ),
    );
  }

  Widget rightAudioChatWidget(String audioUrl, var size) {
    debugPrint("----------------$audioUrl");
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MediaViewScreen(
                  mediaFile: audioUrl,
                  type: MediaTypeEnum.audio,
                )));
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(size.width * numD04),
                  child: Container(
                    color: colorGrey2.withOpacity(.9),
                    height: size.width * numD80,
                    width: double.infinity,
                    child: Icon(
                      Icons.play_circle,
                      color: colorThemePink,
                      size: size.width * numD18,
                    ),
                  ),
                ),
                Positioned(
                    top: size.width * numD02,
                    left: size.width * numD02,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * numD008,
                          vertical: size.width * numD005),
                      decoration: BoxDecoration(
                          color: colorLightGreen.withOpacity(0.8),
                          borderRadius:
                              BorderRadius.circular(size.width * numD01)),
                      child: Image.asset(
                        "${iconsPath}ic_mic1.png",
                        fit: BoxFit.cover,
                        height: size.width * numD05,
                        width: size.width * numD05,
                      ),
                    )),
                ClipRRect(
                    borderRadius: BorderRadius.circular(size.width * numD04),
                    child: Image.asset(
                      "${commonImagePath}watermark1.png",
                      height: size.height / 3,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )),
              ],
            ),
          ),
          SizedBox(
            width: size.width * numD02,
          ),
          (avatarImageUrl + (sharedPreferences!.getString(avatarKey) ?? ""))
                  .isNotEmpty
              ? Container(
                  padding: EdgeInsets.all(
                    size.width * numD01,
                  ),
                  decoration: const BoxDecoration(
                      color: colorLightGrey, shape: BoxShape.circle),
                  child: ClipOval(
                      clipBehavior: Clip.antiAlias,
                      child: Image.network(
                        avatarImageUrl +
                            (sharedPreferences!.getString(avatarKey) ?? ""),
                        fit: BoxFit.cover,
                        height: size.width * numD09,
                        width: size.width * numD09,
                      )))
              : Container(
                  padding: EdgeInsets.all(
                    size.width * numD01,
                  ),
                  height: size.width * numD09,
                  width: size.width * numD09,
                  decoration: const BoxDecoration(
                      color: colorSwitchBack, shape: BoxShape.circle),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Image.asset("${commonImagePath}rabbitLogo.png",
                        fit: BoxFit.contain),
                  ),
                ),
        ],
      ),
    );
  }

  Widget rightImageChatWidget(String imageUrl, String time, var size) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        debugPrint("imageTap:::::::${sharedPreferences!.getString(avatarKey)}");
        Navigator.of(navigatorKey.currentState!.context).push(MaterialPageRoute(
            builder: (context) => MediaViewScreen(
                  mediaFile: imageUrl,
                  type: MediaTypeEnum.image,
                )));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: colorGreyChat,
                          borderRadius:
                              BorderRadius.circular(size.width * numD04),
                          border: Border.all(
                              color: Colors.grey.shade300, width: 1)),
                      child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(size.width * numD04),
                          child: Image.network(
                            imageUrl,
                            height: size.height / 3,
                            fit: BoxFit.cover,
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return Center(
                                child: Image.asset(
                                  "${commonImagePath}rabbitLogo.png",
                                  height: size.height / 3,
                                  width: size.width / 1.7,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          )),
                    ),
                    Positioned(
                        top: size.width * numD02,
                        left: size.width * numD02,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * numD006,
                              vertical: size.width * numD002),
                          decoration: BoxDecoration(
                              color: colorLightGreen.withOpacity(0.8),
                              borderRadius:
                                  BorderRadius.circular(size.width * numD01)),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.white,
                          ),
                        )),
                    ClipRRect(
                        borderRadius:
                            BorderRadius.circular(size.width * numD04),
                        child: Image.asset(
                          "${commonImagePath}watermark1.png",
                          height: size.height / 3,
                          width: size.width / 1.7,
                          fit: BoxFit.cover,
                        )),
                  ],
                ),
              ),
              SizedBox(
                width: size.width * numD02,
              ),
              sharedPreferences!.getString(avatarKey).toString().isNotEmpty
                  ? Container(
                      padding: EdgeInsets.all(
                        size.width * numD01,
                      ),
                      decoration: const BoxDecoration(
                          color: colorLightGrey, shape: BoxShape.circle),
                      child: ClipOval(
                          clipBehavior: Clip.antiAlias,
                          child: Image.network(
                              avatarImageUrl +
                                  sharedPreferences!
                                      .getString(avatarKey)
                                      .toString(),
                              height: size.width * numD09,
                              width: size.width * numD09,
                              fit: BoxFit.cover, errorBuilder:
                                  (BuildContext context, Object exception,
                                      StackTrace? stackTrace) {
                            return Center(
                              child: Image.asset(
                                "${commonImagePath}rabbitLogo.png",
                                height: size.width * numD09,
                                width: size.width * numD09,
                                fit: BoxFit.contain,
                              ),
                            );
                          })))
                  : Container(
                      padding: EdgeInsets.all(
                        size.width * numD01,
                      ),
                      height: size.width * numD09,
                      width: size.width * numD09,
                      decoration: const BoxDecoration(
                          color: colorSwitchBack, shape: BoxShape.circle),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Image.asset(
                          "${commonImagePath}rabbitLogo.png",
                          height: size.width * numD09,
                          width: size.width * numD09,
                        ),
                      ),
                    ),
            ],
          ),
          SizedBox(
            height: size.width * numD018,
          ),
          Row(
            children: [
              Image.asset(
                "${iconsPath}ic_clock.png",
                height: size.width * numD038,
                color: Colors.black,
              ),
              SizedBox(
                width: size.width * numD012,
              ),
              Text(
                dateTimeFormatter(dateTime: time, format: 'hh:mm a'),
                style: commonTextStyle(
                    size: size,
                    fontSize: size.width * numD028,
                    color: colorHint,
                    fontWeight: FontWeight.normal),
              ),
              SizedBox(
                width: size.width * numD018,
              ),
              Image.asset(
                "${iconsPath}ic_yearly_calendar.png",
                height: size.width * numD035,
                color: Colors.black,
              ),
              SizedBox(
                width: size.width * numD01,
              ),
              Text(
                dateTimeFormatter(dateTime: time, format: 'dd MMM yyyy'),
                style: commonTextStyle(
                    size: size,
                    fontSize: size.width * numD028,
                    color: colorHint,
                    fontWeight: FontWeight.normal),
              ),
            ],
          ),
          SizedBox(
            height: size.width * numD018,
          ),
        ],
      ),
    );
  }

  Widget thanksToUploadMediaWidget(String type, var size, int mediaLength) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.grey.shade300, spreadRadius: 2)
              ]),
          child: ClipOval(
            child: Padding(
              padding: EdgeInsets.all(size.width * numD01),
              child: Image.asset(
                "${commonImagePath}ic_black_rabbit.png",
                width: size.width * numD075,
                height: size.width * numD075,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        SizedBox(
          width: size.width * numD04,
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * numD03, vertical: size.width * numD03),
            width: size.width,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(size.width * numD04),
                    bottomLeft: Radius.circular(size.width * numD04),
                    bottomRight: Radius.circular(size.width * numD04))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.width * numD008,
                ),
                Row(
                  children: [
                    Text("Thanks. you've uploaded",
                        style: commonTextStyle(
                            size: size,
                            fontSize: size.width * numD035,
                            color: Colors.black,
                            fontWeight: FontWeight.normal)),
                    Text(" $mediaLength $type",
                        style: commonTextStyle(
                            size: size,
                            fontSize: size.width * numD035,
                            color: colorThemePink,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(
                  height: size.width * numD008,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget paymentReceivedWidget(String amount, var size) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /*profilePicWidget(),*/
        Container(
          margin: EdgeInsets.only(top: size.width * numD04),
          padding: EdgeInsets.all(size.width * numD03),
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.grey.shade300, spreadRadius: 2)
              ]),
          child: Image.asset(
            "${commonImagePath}rabbitLogo.png",
            width: size.width * numD07,
          ),
        ),
        SizedBox(
          width: size.width * numD04,
        ),
        Expanded(
            child: Container(
          margin: EdgeInsets.only(top: size.width * numD06),
          padding: EdgeInsets.symmetric(
              horizontal: size.width * numD05, vertical: size.width * numD02),
          width: size.width,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(size.width * numD04),
                  bottomLeft: Radius.circular(size.width * numD04),
                  bottomRight: Radius.circular(size.width * numD04))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: size.width * numD04,
              ),
              Text(
                "Congrats, you’ve received £$amount from Reuters Media ",
                style: commonTextStyle(
                    size: size,
                    fontSize: size.width * numD035,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: size.width * numD04,
              ),
              SizedBox(
                height: size.width * numD13,
                width: size.width,
                child: commonElevatedButton(
                    "View Transaction Details",
                    size,
                    commonButtonTextStyle(size),
                    commonButtonStyle(size, colorThemePink),
                    () {}),
              )
            ],
          ),
        ))
      ],
    );
  }

  Widget profilePicWidget(var size) {
    return Container(
        //margin: EdgeInsets.only(top: size.width * numD03),
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade400)),
        child: ClipOval(
          clipBehavior: Clip.antiAlias,
          child: Image.network(
            widget.taskDetail?.mediaHouseImage ?? "",
            width: size.width * numD09,
            height: size.width * numD09,
            fit: BoxFit.contain,
            errorBuilder: (ctx, obj, stace) {
              return Image.asset(
                "${dummyImagePath}news.png",
                width: size.width * numD09,
                height: size.width * numD09,
              );
            },
          ),
        ));
  }

  Widget moreContentReqWidget(ManageTaskChatModel item, var size) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        profilePicWidget(size),
        SizedBox(
          width: size.width * numD04,
        ),
        Expanded(
            child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * numD05, vertical: size.width * numD02),
          width: size.width,
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(size.width * numD04),
                  bottomLeft: Radius.circular(size.width * numD04),
                  bottomRight: Radius.circular(size.width * numD04))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: size.width * numD023,
              ),
              Text(
                "Do you have additional pictures related to the task?",
                style: commonTextStyle(
                    size: size,
                    fontSize: size.width * numD035,
                    color: Colors.black,
                    fontWeight: FontWeight.normal),
              ),
              SizedBox(
                height: size.width * numD04,
              ),
              Row(
                children: [
                  Expanded(
                      child: SizedBox(
                    height: size.width * numD13,
                    width: size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        if (item.requestStatus.isEmpty) {
                          var map1 = {
                            "chat_id": item.id,
                            "status": true,
                          };

                          socketEmitFunc(
                              socketEvent: "reqstatus",
                              messageType: "",
                              dataMap: map1);

                          socketEmitFunc(
                            socketEvent: "chat message",
                            messageType: "contentupload",
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: item.requestStatus.isEmpty
                              ? colorThemePink
                              : item.requestStatus == "true"
                                  ? Colors.grey
                                  : Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(size.width * numD04),
                              side: item.requestStatus == "true" ||
                                      item.requestStatus.isEmpty
                                  ? BorderSide.none
                                  : const BorderSide(
                                      color: Colors.black, width: 1))),
                      child: Text(
                        yesText,
                        style: commonTextStyle(
                            size: size,
                            fontSize: size.width * numD04,
                            color: item.requestStatus == "true" ||
                                    item.requestStatus.isEmpty
                                ? Colors.white
                                : colorLightGreen,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  )),
                  SizedBox(
                    width: size.width * numD04,
                  ),
                  Expanded(
                      child: SizedBox(
                    height: size.width * numD13,
                    width: size.width,
                    child: ElevatedButton(
                      onPressed: () {
                        if (item.requestStatus.isEmpty) {
                          var map1 = {
                            "chat_id": item.id,
                            "status": false,
                          };

                          socketEmitFunc(
                              socketEvent: "reqstatus",
                              messageType: "",
                              dataMap: map1);

                          socketEmitFunc(
                            socketEvent: "chat message",
                            messageType: "NocontentUpload",
                          );

                          socketEmitFunc(
                            socketEvent: "chat message",
                            messageType: "rating_hopper",
                          );

                          socketEmitFunc(
                            socketEvent: "chat message",
                            messageType: "rating_mediaHouse",
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: item.requestStatus.isEmpty
                              ? Colors.black
                              : item.requestStatus == "false"
                                  ? Colors.grey
                                  : Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(size.width * numD04),
                              side: item.requestStatus == "false" ||
                                      item.requestStatus.isEmpty
                                  ? BorderSide.none
                                  : const BorderSide(
                                      color: Colors.black, width: 1))),
                      child: Text(
                        noText,
                        style: commonTextStyle(
                            size: size,
                            fontSize: size.width * numD04,
                            color: item.requestStatus == "false" ||
                                    item.requestStatus.isEmpty
                                ? Colors.white
                                : colorLightGreen,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  )),
                ],
              ),
              SizedBox(
                height: size.width * numD023,
              ),
            ],
          ),
        ))
      ],
    );
  }

  Widget uploadNoContentWidget(var size) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: size.width * numD03),
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.grey.shade300, spreadRadius: 2)
              ]),
          child: ClipOval(
            child: Padding(
              padding: EdgeInsets.all(size.width * numD01),
              child: Image.asset(
                "${commonImagePath}ic_black_rabbit.png",
                width: size.width * numD075,
                height: size.width * numD075,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        SizedBox(
          width: size.width * numD04,
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(top: size.width * numD03),
            padding: EdgeInsets.symmetric(
                horizontal: size.width * numD03, vertical: size.width * numD03),
            width: size.width,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(size.width * numD04),
                    bottomLeft: Radius.circular(size.width * numD04),
                    bottomRight: Radius.circular(size.width * numD04))),
            child: Text(
              "Thank you ever so much for a splendid job well done!",
              style: commonTextStyle(
                  size: size,
                  fontSize: size.width * numD035,
                  color: Colors.black,
                  fontWeight: FontWeight.normal),
            ),
          ),
        ),
      ],
    );
  }

  Widget mediaHouseOfferWidget(
      ManageTaskChatModel item, bool isMakeCounter, var size) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: size.width * numD026,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.grey.shade300, spreadRadius: 2)
                      ]),
                  child: ClipOval(
                    clipBehavior: Clip.antiAlias,
                    child: Padding(
                      padding: EdgeInsets.all(size.width * numD01),
                      child: Image.asset(
                        "${commonImagePath}ic_black_rabbit.png",
                        color: Colors.white,
                        width: size.width * numD07,
                        height: size.width * numD07,
                      ),
                    ),
                  )),
              SizedBox(
                width: size.width * numD025,
              ),
              Expanded(
                  child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * numD05,
                    vertical: size.width * numD02),
                width: size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: colorGoogleButtonBorder),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(size.width * numD04),
                      bottomLeft: Radius.circular(size.width * numD04),
                      bottomRight: Radius.circular(size.width * numD04),
                    )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: size.width * numD009,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: size.width * 0.55,
                          child: RichText(
                              text: TextSpan(
                                  style: const TextStyle(
                                    fontFamily: "AirbnbCereal",
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: [
                                TextSpan(
                                  text:
                                      "Well done! You've received\nan offer from",
                                  style: commonTextStyle(
                                      size: size,
                                      fontSize: size.width * numD036,
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                ),
                                TextSpan(
                                  text: " ${item.mediaHouseName}",
                                  style: commonTextStyle(
                                      size: size,
                                      fontSize: size.width * numD036,
                                      color: colorThemePink,
                                      fontWeight: FontWeight.w600),
                                ),
                              ])),
                        ),
                        Container(
                            margin: EdgeInsets.only(left: size.width * numD01),
                            width: size.width * numD13,
                            height: size.width * numD13,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(size.width * numD03),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey.shade200,
                                      spreadRadius: 1)
                                ]),
                            child: ClipOval(
                              clipBehavior: Clip.antiAlias,
                              child: Image.network(
                                item.mediaHouseImage,
                                fit: BoxFit.contain,
                                height: size.width * numD20,
                                width: size.width * numD20,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  return Image.asset(
                                    "${dummyImagePath}news.png",
                                    fit: BoxFit.contain,
                                    width: size.width * numD20,
                                    height: size.width * numD20,
                                  );
                                },
                              ),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: size.width * numD03,
                    ),
                    Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(size.width * numD012),
                      decoration: BoxDecoration(
                          color: colorLightGrey,
                          borderRadius:
                              BorderRadius.circular(size.width * numD03),
                          border: Border.all(
                              color: const Color(0xFFd4dedd), width: 2)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Offered Price",
                            style: TextStyle(
                                fontSize: size.width * numD035,
                                color: colorLightGreen,
                                fontFamily: 'AirbnbCereal'),
                          ),
                          Text(
                            item.hopperPrice.isEmpty
                                ? ""
                                : "$euroUniqueCode${formatDouble(double.parse(item.hopperPrice))}",
                            style: TextStyle(
                                fontSize: size.width * numD045,
                                color: colorLightGreen,
                                fontWeight: FontWeight.w900,
                                fontFamily: 'AirbnbCereal'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: size.width * numD01,
                    )
                  ],
                ),
              )),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.only(top: size.width * numD06),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.grey.shade300, spreadRadius: 2)
                      ]),
                  child: ClipOval(
                    clipBehavior: Clip.antiAlias,
                    child: Padding(
                      padding: EdgeInsets.all(size.width * numD01),
                      child: Image.asset(
                        "${commonImagePath}ic_black_rabbit.png",
                        color: Colors.white,
                        width: size.width * numD07,
                        height: size.width * numD07,
                      ),
                    ),
                  )),
              SizedBox(
                width: size.width * numD025,
              ),
              Expanded(
                  child: Container(
                margin: EdgeInsets.only(top: size.width * numD06),
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * numD05,
                    vertical: size.width * numD02),
                width: size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: colorGoogleButtonBorder),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(size.width * numD04),
                      bottomLeft: Radius.circular(size.width * numD04),
                      bottomRight: Radius.circular(size.width * numD04),
                    )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: size.width * numD01,
                    ),
                    RichText(
                        text: TextSpan(
                            style: const TextStyle(
                              fontFamily: "AirbnbCereal",
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                          TextSpan(
                            text: "Congratulations, ",
                            style: commonTextStyle(
                                size: size,
                                fontSize: size.width * numD036,
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                          ),
                          TextSpan(
                            text: item.mediaHouseName,
                            style: commonTextStyle(
                                size: size,
                                fontSize: size.width * numD036,
                                color: colorThemePink,
                                fontWeight: FontWeight.w600),
                          ),
                          TextSpan(
                            text: " has purchased your content for ",
                            style: commonTextStyle(
                                size: size,
                                fontSize: size.width * numD036,
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                          ),
                          TextSpan(
                            text: item.hopperPrice.isEmpty
                                ? ""
                                : "$euroUniqueCode${formatDouble(double.parse(item.hopperPrice))}",
                            style: commonTextStyle(
                                size: size,
                                fontSize: size.width * numD036,
                                color: colorThemePink,
                                fontWeight: FontWeight.w600),
                          ),
                        ])),
                    SizedBox(
                      height: size.width * numD03,
                    ),
                    SizedBox(
                      height: size.width * numD03,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: size.width * numD13,
                          width: size.width,
                          child: commonElevatedButton(
                              "View Transaction Details ",
                              size,
                              commonButtonTextStyle(size),
                              commonButtonStyle(size, colorThemePink), () {
                            callDetailApi(item.mediaHouseId);
                          }),
                        ),
                        SizedBox(
                          height: size.width * numD01,
                        ),
                      ],
                    )
                  ],
                ),
              )),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.only(top: size.width * numD06),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.grey.shade300, spreadRadius: 2)
                      ]),
                  child: ClipOval(
                    clipBehavior: Clip.antiAlias,
                    child: Padding(
                      padding: EdgeInsets.all(size.width * numD01),
                      child: Image.asset(
                        "${commonImagePath}ic_black_rabbit.png",
                        color: Colors.white,
                        width: size.width * numD07,
                        height: size.width * numD07,
                      ),
                    ),
                  )),
              SizedBox(
                width: size.width * numD025,
              ),
              Expanded(
                  child: Container(
                margin: EdgeInsets.only(top: size.width * numD06),
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * numD05,
                    vertical: size.width * numD02),
                width: size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: colorGoogleButtonBorder),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(size.width * numD04),
                      bottomLeft: Radius.circular(size.width * numD04),
                      bottomRight: Radius.circular(size.width * numD04),
                    )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: size.width * numD01,
                    ),
                    RichText(
                        text: TextSpan(
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size.width * numD037,
                              fontFamily: "AirbnbCereal",
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
                          TextSpan(
                            text: "Woohoo! We have paid ",
                            style: commonTextStyle(
                                size: size,
                                fontSize: size.width * numD036,
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                          ),
                          TextSpan(
                            text: item.payableHopperPrice.isEmpty
                                ? ""
                                : "$euroUniqueCode${formatDouble(double.parse(item.payableHopperPrice))}",
                            style: commonTextStyle(
                                size: size,
                                fontSize: size.width * numD036,
                                color: colorThemePink,
                                fontWeight: FontWeight.w600),
                          ),
                          TextSpan(
                            text: " into your bank account. Please visit ",
                            style: commonTextStyle(
                                size: size,
                                fontSize: size.width * numD036,
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                          ),
                          TextSpan(
                            text: "My Earnings",
                            style: commonTextStyle(
                                size: size,
                                fontSize: size.width * numD036,
                                color: colorThemePink,
                                fontWeight: FontWeight.w600),
                          ),
                          TextSpan(
                            text: " to view your transaction ",
                            style: commonTextStyle(
                                size: size,
                                fontSize: size.width * numD036,
                                color: Colors.black,
                                fontWeight: FontWeight.normal),
                          )
                        ])),
                    SizedBox(
                      height: size.width * numD025,
                    ),
                    /*Row(
                          children: [
                            Expanded(
                                child: SizedBox(
                                  height: size.width * numD13,
                                  width: size.width,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (item.requestStatus.isEmpty &&
                                          !item.isMakeCounterOffer) {
                                        var map1 = {
                                          "chat_id": item.id,
                                          "status": false,
                                        };

                                        socketEmitFunc(
                                            socketEvent: "reqstatus",
                                            messageType: "",
                                            dataMap: map1);

                                        socketEmitFunc(
                                          socketEvent: "chat message",
                                          messageType: "reject_mediaHouse_offer",
                                        );

                                        socketEmitFunc(
                                          socketEvent: "chat message",
                                          messageType: "rating_hopper",
                                        );

                                        socketEmitFunc(
                                          socketEvent: "chat message",
                                          messageType: "rating_mediaHouse",
                                        );
                                        showRejectBtn = true;
                                      }
                                      setState(() {});
                                    },
                                    style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor: item.requestStatus.isEmpty &&
                                            !item.isMakeCounterOffer
                                            ? Colors.black
                                            : item.requestStatus == "false"
                                            ? Colors.grey
                                            : Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(size.width * numD04),
                                            side: (item.requestStatus == "false" ||
                                                item.requestStatus.isEmpty) &&
                                                !item.isMakeCounterOffer
                                                ? BorderSide.none
                                                : const BorderSide(
                                                color: Colors.black, width: 1))),
                                    child: Text(
                                      rejectText,
                                      style: commonTextStyle(
                                          size: size,
                                          fontSize: size.width * numD037,
                                          color: (item.requestStatus == "false" ||
                                              item.requestStatus.isEmpty) &&
                                              !item.isMakeCounterOffer
                                              ? Colors.white
                                              : colorLightGreen,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                )),
                            SizedBox(
                              width: size.width * numD04,
                            ),
                            Expanded(
                                child: SizedBox(
                                  height: size.width * numD13,
                                  width: size.width,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      //aditya accept btn
                                      if (item.requestStatus.isEmpty &&
                                          !item.isMakeCounterOffer) {
                                        debugPrint("tapppppp:::::$showAcceptBtn");
                                        showAcceptBtn = true;
                                        var map1 = {
                                          "chat_id": item.id,
                                          "status": true,
                                        };

                                        socketEmitFunc(
                                            socketEvent: "reqstatus",
                                            messageType: "",
                                            dataMap: map1);

                                        socketEmitFunc(
                                            socketEvent: "chat message",
                                            messageType: "accept_mediaHouse_offer",
                                            dataMap: {
                                              "amount": isMakeCounter
                                                  ? item.initialOfferAmount
                                                  : item.finalCounterAmount,
                                              "image_id": widget.contentId!,
                                            });
                                      }
                                      setState(() {});
                                    },
                                    style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor: item.requestStatus.isEmpty &&
                                            !item.isMakeCounterOffer
                                            ? colorThemePink
                                            : item.requestStatus == "true"
                                            ? Colors.grey
                                            : Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(size.width * numD04),
                                            side: (item.requestStatus == "true" ||
                                                item.requestStatus.isEmpty) &&
                                                !item.isMakeCounterOffer
                                                ? BorderSide.none
                                                : const BorderSide(
                                                color: Colors.black, width: 1))),
                                    child: Text(
                                      acceptText,
                                      style: commonTextStyle(
                                          size: size,
                                          fontSize: size.width * numD037,
                                          color: (item.requestStatus == "true" ||
                                              item.requestStatus.isEmpty) &&
                                              !item.isMakeCounterOffer
                                              ? Colors.white
                                              : colorLightGreen,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                )),

                            */
                    /* Expanded(
                                child: SizedBox(
                                  height: size.width * numD13,
                                  width: size.width,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if(item.requestStatus.isEmpty){

                                        var map1 = {
                                          "chat_id" : item.id,
                                          "status" : true,
                                        };

                                        socketEmitFunc(
                                            socketEvent: "reqstatus",
                                            messageType: "",
                                            dataMap: map1
                                        );

                                        socketEmitFunc(
                                            socketEvent: "chat message",
                                            messageType: "contentupload",
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                        item.requestStatus.isEmpty
                                            ? colorThemePink
                                            :item.requestStatus == "true"
                                            ?  Colors.grey
                                            :  Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                              size.width * numD04),
                                            side: item.requestStatus == "true" || item.requestStatus.isEmpty ? BorderSide.none : const BorderSide(
                                                color: colorGrey1, width: 2)
                                        )),
                                    child: Text(
                                      yesText,
                                      style: commonTextStyle(
                                          size: size,
                                          fontSize: size.width * numD04,
                                          color: item.requestStatus == "true" || item.requestStatus.isEmpty ? Colors.white : colorLightGreen,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                )),*/ /*
                          ],
                        ),*/
                    SizedBox(
                      height: size.width * numD03,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: size.width * numD13,
                          width: size.width,
                          child: commonElevatedButton(
                              "View My Earnings",
                              size,
                              commonButtonTextStyle(size),
                              commonButtonStyle(size, colorThemePink), () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => MyEarningScreen(
                                      openDashboard: false,
                                    )));
                          }),
                        ),
                        SizedBox(
                          height: size.width * numD01,
                        ),
                      ],
                    )
                  ],
                ),
              )),
            ],
          ),

          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     profilePicWidget(),
          //     SizedBox(
          //       width: size.width * numD04,
          //     ),
          //     Expanded(
          //         child: Container(
          //       margin: EdgeInsets.only(top: size.width * numD06),
          //       padding: EdgeInsets.symmetric(
          //           horizontal: size.width * numD05,
          //           vertical: size.width * numD02),
          //       width: size.width,
          //       decoration: BoxDecoration(
          //           color: Colors.white,
          //           border: Border.all(color: colorGoogleButtonBorder),
          //           borderRadius: BorderRadius.only(
          //             topRight: Radius.circular(size.width * numD04),
          //             bottomLeft: Radius.circular(size.width * numD04),
          //             bottomRight: Radius.circular(size.width * numD04),
          //           )),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           SizedBox(
          //             height: size.width * numD04,
          //           ),
          //           RichText(
          //               text: TextSpan(children: [
          //             TextSpan(
          //               text: "We're giving your content a little ",
          //               style: commonTextStyle(
          //                   size: size,
          //                   fontSize: size.width * numD036,
          //                   color: Colors.black,
          //                   fontWeight: FontWeight.w600),
          //             ),
          //             TextSpan(
          //               text: "makeover!",
          //               style: commonTextStyle(
          //                   size: size,
          //                   fontSize: size.width * numD036,
          //                   color: colorThemePink,
          //                   fontWeight: FontWeight.w600),
          //             ),
          //             TextSpan(
          //               text:
          //                   " To boost its appeal and help it to fly off the virtual shelves, we've adjusted the price to ",
          //               style: commonTextStyle(
          //                   size: size,
          //                   fontSize: size.width * numD036,
          //                   color: Colors.black,
          //                   fontWeight: FontWeight.w600),
          //             ),
          //             TextSpan(
          //               text: "${euroUniqueCode}30",
          //               style: commonTextStyle(
          //                   size: size,
          //                   fontSize: size.width * numD036,
          //                   color: colorThemePink,
          //                   fontWeight: FontWeight.w600),
          //             ),
          //           ])),
          //           SizedBox(
          //             height: size.width * numD04,
          //           ),
          //           /*Row(
          //                 children: [
          //                   Expanded(
          //                       child: SizedBox(
          //                         height: size.width * numD13,
          //                         width: size.width,
          //                         child: ElevatedButton(
          //                           onPressed: () {
          //                             if (item.requestStatus.isEmpty &&
          //                                 !item.isMakeCounterOffer) {
          //                               var map1 = {
          //                                 "chat_id": item.id,
          //                                 "status": false,
          //                               };
          //
          //                               socketEmitFunc(
          //                                   socketEvent: "reqstatus",
          //                                   messageType: "",
          //                                   dataMap: map1);
          //
          //                               socketEmitFunc(
          //                                 socketEvent: "chat message",
          //                                 messageType: "reject_mediaHouse_offer",
          //                               );
          //
          //                               socketEmitFunc(
          //                                 socketEvent: "chat message",
          //                                 messageType: "rating_hopper",
          //                               );
          //
          //                               socketEmitFunc(
          //                                 socketEvent: "chat message",
          //                                 messageType: "rating_mediaHouse",
          //                               );
          //                               showRejectBtn = true;
          //                             }
          //                             setState(() {});
          //                           },
          //                           style: ElevatedButton.styleFrom(
          //                               elevation: 0,
          //                               backgroundColor: item.requestStatus.isEmpty &&
          //                                   !item.isMakeCounterOffer
          //                                   ? Colors.black
          //                                   : item.requestStatus == "false"
          //                                   ? Colors.grey
          //                                   : Colors.transparent,
          //                               shape: RoundedRectangleBorder(
          //                                   borderRadius:
          //                                   BorderRadius.circular(size.width * numD04),
          //                                   side: (item.requestStatus == "false" ||
          //                                       item.requestStatus.isEmpty) &&
          //                                       !item.isMakeCounterOffer
          //                                       ? BorderSide.none
          //                                       : const BorderSide(
          //                                       color: Colors.black, width: 1))),
          //                           child: Text(
          //                             rejectText,
          //                             style: commonTextStyle(
          //                                 size: size,
          //                                 fontSize: size.width * numD037,
          //                                 color: (item.requestStatus == "false" ||
          //                                     item.requestStatus.isEmpty) &&
          //                                     !item.isMakeCounterOffer
          //                                     ? Colors.white
          //                                     : colorLightGreen,
          //                                 fontWeight: FontWeight.w500),
          //                           ),
          //                         ),
          //                       )),
          //                   SizedBox(
          //                     width: size.width * numD04,
          //                   ),
          //                   Expanded(
          //                       child: SizedBox(
          //                         height: size.width * numD13,
          //                         width: size.width,
          //                         child: ElevatedButton(
          //                           onPressed: () {
          //                             //aditya accept btn
          //                             if (item.requestStatus.isEmpty &&
          //                                 !item.isMakeCounterOffer) {
          //                               debugPrint("tapppppp:::::$showAcceptBtn");
          //                               showAcceptBtn = true;
          //                               var map1 = {
          //                                 "chat_id": item.id,
          //                                 "status": true,
          //                               };
          //
          //                               socketEmitFunc(
          //                                   socketEvent: "reqstatus",
          //                                   messageType: "",
          //                                   dataMap: map1);
          //
          //                               socketEmitFunc(
          //                                   socketEvent: "chat message",
          //                                   messageType: "accept_mediaHouse_offer",
          //                                   dataMap: {
          //                                     "amount": isMakeCounter
          //                                         ? item.initialOfferAmount
          //                                         : item.finalCounterAmount,
          //                                     "image_id": widget.contentId!,
          //                                   });
          //                             }
          //                             setState(() {});
          //                           },
          //                           style: ElevatedButton.styleFrom(
          //                               elevation: 0,
          //                               backgroundColor: item.requestStatus.isEmpty &&
          //                                   !item.isMakeCounterOffer
          //                                   ? colorThemePink
          //                                   : item.requestStatus == "true"
          //                                   ? Colors.grey
          //                                   : Colors.transparent,
          //                               shape: RoundedRectangleBorder(
          //                                   borderRadius:
          //                                   BorderRadius.circular(size.width * numD04),
          //                                   side: (item.requestStatus == "true" ||
          //                                       item.requestStatus.isEmpty) &&
          //                                       !item.isMakeCounterOffer
          //                                       ? BorderSide.none
          //                                       : const BorderSide(
          //                                       color: Colors.black, width: 1))),
          //                           child: Text(
          //                             acceptText,
          //                             style: commonTextStyle(
          //                                 size: size,
          //                                 fontSize: size.width * numD037,
          //                                 color: (item.requestStatus == "true" ||
          //                                     item.requestStatus.isEmpty) &&
          //                                     !item.isMakeCounterOffer
          //                                     ? Colors.white
          //                                     : colorLightGreen,
          //                                 fontWeight: FontWeight.w500),
          //                           ),
          //                         ),
          //                       )),
          //
          //                   */ /* Expanded(
          //                       child: SizedBox(
          //                         height: size.width * numD13,
          //                         width: size.width,
          //                         child: ElevatedButton(
          //                           onPressed: () {
          //                             if(item.requestStatus.isEmpty){
          //
          //                               var map1 = {
          //                                 "chat_id" : item.id,
          //                                 "status" : true,
          //                               };
          //
          //                               socketEmitFunc(
          //                                   socketEvent: "reqstatus",
          //                                   messageType: "",
          //                                   dataMap: map1
          //                               );
          //
          //                               socketEmitFunc(
          //                                   socketEvent: "chat message",
          //                                   messageType: "contentupload",
          //                               );
          //                             }
          //                           },
          //                           style: ElevatedButton.styleFrom(
          //                               backgroundColor:
          //                               item.requestStatus.isEmpty
          //                                   ? colorThemePink
          //                                   :item.requestStatus == "true"
          //                                   ?  Colors.grey
          //                                   :  Colors.transparent,
          //                               shape: RoundedRectangleBorder(
          //                                 borderRadius: BorderRadius.circular(
          //                                     size.width * numD04),
          //                                   side: item.requestStatus == "true" || item.requestStatus.isEmpty ? BorderSide.none : const BorderSide(
          //                                       color: colorGrey1, width: 2)
          //                               )),
          //                           child: Text(
          //                             yesText,
          //                             style: commonTextStyle(
          //                                 size: size,
          //                                 fontSize: size.width * numD04,
          //                                 color: item.requestStatus == "true" || item.requestStatus.isEmpty ? Colors.white : colorLightGreen,
          //                                 fontWeight: FontWeight.w500),
          //                           ),
          //                         ),
          //                       )),*/ /*
          //                 ],
          //               ),*/
          //           SizedBox(
          //             height: size.width * numD01,
          //           ),
          //         ],
          //       ),
          //     )),
          //   ],
          // ),
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     profilePicWidget(),
          //     SizedBox(
          //       width: size.width * numD04,
          //     ),
          //     Expanded(
          //         child: Container(
          //       margin: EdgeInsets.only(top: size.width * numD06),
          //       padding: EdgeInsets.symmetric(
          //           horizontal: size.width * numD05,
          //           vertical: size.width * numD02),
          //       width: size.width,
          //       decoration: BoxDecoration(
          //           color: Colors.white,
          //           border: Border.all(color: colorGoogleButtonBorder),
          //           borderRadius: BorderRadius.only(
          //             topRight: Radius.circular(size.width * numD04),
          //             bottomLeft: Radius.circular(size.width * numD04),
          //             bottomRight: Radius.circular(size.width * numD04),
          //           )),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           SizedBox(
          //             height: size.width * numD04,
          //           ),
          //           RichText(
          //               text: TextSpan(children: [
          //             TextSpan(
          //               text: "Keep your fingers crossed —",
          //               style: commonTextStyle(
          //                   size: size,
          //                   fontSize: size.width * numD036,
          //                   color: Colors.black,
          //                   fontWeight: FontWeight.w600),
          //             ),
          //             TextSpan(
          //               text: "exciting news might be just around the corner. ",
          //               style: commonTextStyle(
          //                   size: size,
          //                   fontSize: size.width * numD036,
          //                   color: colorThemePink,
          //                   fontWeight: FontWeight.w600),
          //             ),
          //             TextSpan(
          //               text: "Stay tuned for updates! ",
          //               style: commonTextStyle(
          //                   size: size,
          //                   fontSize: size.width * numD036,
          //                   color: Colors.black,
          //                   fontWeight: FontWeight.w600),
          //             ),
          //           ])),
          //           SizedBox(
          //             height: size.width * numD04,
          //           ),
          //           /*Row(
          //                 children: [
          //                   Expanded(
          //                       child: SizedBox(
          //                         height: size.width * numD13,
          //                         width: size.width,
          //                         child: ElevatedButton(
          //                           onPressed: () {
          //                             if (item.requestStatus.isEmpty &&
          //                                 !item.isMakeCounterOffer) {
          //                               var map1 = {
          //                                 "chat_id": item.id,
          //                                 "status": false,
          //                               };
          //
          //                               socketEmitFunc(
          //                                   socketEvent: "reqstatus",
          //                                   messageType: "",
          //                                   dataMap: map1);
          //
          //                               socketEmitFunc(
          //                                 socketEvent: "chat message",
          //                                 messageType: "reject_mediaHouse_offer",
          //                               );
          //
          //                               socketEmitFunc(
          //                                 socketEvent: "chat message",
          //                                 messageType: "rating_hopper",
          //                               );
          //
          //                               socketEmitFunc(
          //                                 socketEvent: "chat message",
          //                                 messageType: "rating_mediaHouse",
          //                               );
          //                               showRejectBtn = true;
          //                             }
          //                             setState(() {});
          //                           },
          //                           style: ElevatedButton.styleFrom(
          //                               elevation: 0,
          //                               backgroundColor: item.requestStatus.isEmpty &&
          //                                   !item.isMakeCounterOffer
          //                                   ? Colors.black
          //                                   : item.requestStatus == "false"
          //                                   ? Colors.grey
          //                                   : Colors.transparent,
          //                               shape: RoundedRectangleBorder(
          //                                   borderRadius:
          //                                   BorderRadius.circular(size.width * numD04),
          //                                   side: (item.requestStatus == "false" ||
          //                                       item.requestStatus.isEmpty) &&
          //                                       !item.isMakeCounterOffer
          //                                       ? BorderSide.none
          //                                       : const BorderSide(
          //                                       color: Colors.black, width: 1))),
          //                           child: Text(
          //                             rejectText,
          //                             style: commonTextStyle(
          //                                 size: size,
          //                                 fontSize: size.width * numD037,
          //                                 color: (item.requestStatus == "false" ||
          //                                     item.requestStatus.isEmpty) &&
          //                                     !item.isMakeCounterOffer
          //                                     ? Colors.white
          //                                     : colorLightGreen,
          //                                 fontWeight: FontWeight.w500),
          //                           ),
          //                         ),
          //                       )),
          //                   SizedBox(
          //                     width: size.width * numD04,
          //                   ),
          //                   Expanded(
          //                       child: SizedBox(
          //                         height: size.width * numD13,
          //                         width: size.width,
          //                         child: ElevatedButton(
          //                           onPressed: () {
          //                             //aditya accept btn
          //                             if (item.requestStatus.isEmpty &&
          //                                 !item.isMakeCounterOffer) {
          //                               debugPrint("tapppppp:::::$showAcceptBtn");
          //                               showAcceptBtn = true;
          //                               var map1 = {
          //                                 "chat_id": item.id,
          //                                 "status": true,
          //                               };
          //
          //                               socketEmitFunc(
          //                                   socketEvent: "reqstatus",
          //                                   messageType: "",
          //                                   dataMap: map1);
          //
          //                               socketEmitFunc(
          //                                   socketEvent: "chat message",
          //                                   messageType: "accept_mediaHouse_offer",
          //                                   dataMap: {
          //                                     "amount": isMakeCounter
          //                                         ? item.initialOfferAmount
          //                                         : item.finalCounterAmount,
          //                                     "image_id": widget.contentId!,
          //                                   });
          //                             }
          //                             setState(() {});
          //                           },
          //                           style: ElevatedButton.styleFrom(
          //                               elevation: 0,
          //                               backgroundColor: item.requestStatus.isEmpty &&
          //                                   !item.isMakeCounterOffer
          //                                   ? colorThemePink
          //                                   : item.requestStatus == "true"
          //                                   ? Colors.grey
          //                                   : Colors.transparent,
          //                               shape: RoundedRectangleBorder(
          //                                   borderRadius:
          //                                   BorderRadius.circular(size.width * numD04),
          //                                   side: (item.requestStatus == "true" ||
          //                                       item.requestStatus.isEmpty) &&
          //                                       !item.isMakeCounterOffer
          //                                       ? BorderSide.none
          //                                       : const BorderSide(
          //                                       color: Colors.black, width: 1))),
          //                           child: Text(
          //                             acceptText,
          //                             style: commonTextStyle(
          //                                 size: size,
          //                                 fontSize: size.width * numD037,
          //                                 color: (item.requestStatus == "true" ||
          //                                     item.requestStatus.isEmpty) &&
          //                                     !item.isMakeCounterOffer
          //                                     ? Colors.white
          //                                     : colorLightGreen,
          //                                 fontWeight: FontWeight.w500),
          //                           ),
          //                         ),
          //                       )),
          //
          //                   */ /* Expanded(
          //                       child: SizedBox(
          //                         height: size.width * numD13,
          //                         width: size.width,
          //                         child: ElevatedButton(
          //                           onPressed: () {
          //                             if(item.requestStatus.isEmpty){
          //
          //                               var map1 = {
          //                                 "chat_id" : item.id,
          //                                 "status" : true,
          //                               };
          //
          //                               socketEmitFunc(
          //                                   socketEvent: "reqstatus",
          //                                   messageType: "",
          //                                   dataMap: map1
          //                               );
          //
          //                               socketEmitFunc(
          //                                   socketEvent: "chat message",
          //                                   messageType: "contentupload",
          //                               );
          //                             }
          //                           },
          //                           style: ElevatedButton.styleFrom(
          //                               backgroundColor:
          //                               item.requestStatus.isEmpty
          //                                   ? colorThemePink
          //                                   :item.requestStatus == "true"
          //                                   ?  Colors.grey
          //                                   :  Colors.transparent,
          //                               shape: RoundedRectangleBorder(
          //                                 borderRadius: BorderRadius.circular(
          //                                     size.width * numD04),
          //                                   side: item.requestStatus == "true" || item.requestStatus.isEmpty ? BorderSide.none : const BorderSide(
          //                                       color: colorGrey1, width: 2)
          //                               )),
          //                           child: Text(
          //                             yesText,
          //                             style: commonTextStyle(
          //                                 size: size,
          //                                 fontSize: size.width * numD04,
          //                                 color: item.requestStatus == "true" || item.requestStatus.isEmpty ? Colors.white : colorLightGreen,
          //                                 fontWeight: FontWeight.w500),
          //                           ),
          //                         ),
          //                       )),*/ /*
          //                 ],
          //               ),*/
          //           SizedBox(
          //             height: size.width * numD01,
          //           ),
          //         ],
          //       ),
          //     )),
          //   ],
          // ),
          // Row(
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: [
          //     profilePicWidget(),
          //     SizedBox(
          //       width: size.width * numD04,
          //     ),
          //     Expanded(
          //         child: Container(
          //       margin: EdgeInsets.only(top: size.width * numD06),
          //       padding: EdgeInsets.symmetric(
          //           horizontal: size.width * numD05,
          //           vertical: size.width * numD02),
          //       width: size.width,
          //       decoration: BoxDecoration(
          //           color: Colors.white,
          //           border: Border.all(color: colorGoogleButtonBorder),
          //           borderRadius: BorderRadius.only(
          //             topRight: Radius.circular(size.width * numD04),
          //             bottomLeft: Radius.circular(size.width * numD04),
          //             bottomRight: Radius.circular(size.width * numD04),
          //           )),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           SizedBox(
          //             height: size.width * numD04,
          //           ),
          //           RichText(
          //               text: TextSpan(children: [
          //             TextSpan(
          //               text: "Rate your experience with Presshop",
          //               style: commonTextStyle(
          //                   size: size,
          //                   fontSize: size.width * numD036,
          //                   color: Colors.black,
          //                   fontWeight: FontWeight.w600),
          //             ),
          //           ])),
          //           SizedBox(
          //             height: size.width * numD04,
          //           ),
          //           RatingBar(
          //             ratingWidget: RatingWidget(
          //               empty: Image.asset("${iconsPath}emptystar.png"),
          //               full: Image.asset("${iconsPath}star.png"),
          //               half: Image.asset("${iconsPath}ic_half_star.png"),
          //             ),
          //             onRatingUpdate: (value) {},
          //             itemSize: size.width * numD09,
          //             itemCount: 5,
          //             initialRating: 0,
          //             allowHalfRating: true,
          //             itemPadding: EdgeInsets.only(left: size.width * numD03),
          //           ),
          //           SizedBox(
          //             height: size.width * 0.04,
          //           ),
          //           Text(
          //             "Tell us what you liked about the App",
          //             style: TextStyle(
          //                 fontSize: 14,
          //                 color: Colors.black,
          //                 fontWeight: FontWeight.w700),
          //           ),
          //           Wrap(
          //               children: List<Widget>.generate(8, (int index) {
          //             return Container(
          //               margin: EdgeInsets.all(size.width * 0.02),
          //               child: ChoiceChip(
          //                 label: Text('Choice $index'),
          //                 onSelected: (bool selected) {
          //                   setState(() {});
          //                 },
          //                 selected: true,
          //               ),
          //             );
          //           })),
          //           Container(
          //               padding: EdgeInsets.all(size.width * 0.02),
          //               decoration: BoxDecoration(
          //                   borderRadius:
          //                       BorderRadius.circular(size.width * 0.02),
          //                   border: Border.all(color: Colors.black)),
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.start,
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   Image.asset("${iconsPath}docs.png",
          //                       width: size.width * 0.07,
          //                       height: size.width * 0.09),
          //                   SizedBox(
          //                     width: size.width * 0.02,
          //                   ),
          //                   Expanded(
          //                     child: Text(
          //                       textData,
          //                       style: TextStyle(
          //                         color: colorGrey2,
          //                         fontSize: size.width * 0.04,
          //                       ),
          //                       textAlign: TextAlign.justify,
          //                     ),
          //                   )
          //                 ],
          //               )),
          //           SizedBox(height: size.width * 0.06),
          //           SizedBox(
          //             height: size.width * numD13,
          //             width: size.width,
          //             child: commonElevatedButton(
          //                 submitText,
          //                 size,
          //                 commonButtonTextStyle(size),
          //                 commonButtonStyle(
          //                     size,
          //                     item.requestStatus.isEmpty &&
          //                             !item.isMakeCounterOffer
          //                         ? colorThemePink
          //                         : Colors.grey), () {
          //               Timer(
          //                   const Duration(milliseconds: 50),
          //                   () => scrollController.jumpTo(
          //                       scrollController.position.maxScrollExtent));
          //               if (item.requestStatus.isEmpty &&
          //                   !item.isMakeCounterOffer) {
          //                 socketEmitFunc(
          //                     socketEvent: "updatehide",
          //                     messageType: "",
          //                     dataMap: {
          //                       "chat_id": item.id,
          //                     });
          //
          //                 socketEmitFunc(
          //                   socketEvent: "chat message",
          //                   messageType: "hopper_counter_offer",
          //                 );
          //               }
          //             }),
          //           ),
          //           SizedBox(height: size.width * 0.04),
          //           RichText(
          //               text: TextSpan(children: [
          //             TextSpan(
          //               text: "Please refer to our ",
          //               style: commonTextStyle(
          //                   size: size,
          //                   fontSize: size.width * numD036,
          //                   color: Colors.black,
          //                   fontWeight: FontWeight.w400),
          //             ),
          //             TextSpan(
          //               text: "Terms & Conditions. ",
          //               style: commonTextStyle(
          //                   size: size,
          //                   fontSize: size.width * numD036,
          //                   color: colorThemePink,
          //                   fontWeight: FontWeight.w600),
          //             ),
          //             TextSpan(
          //               text: "If you have any questions, please ",
          //               style: commonTextStyle(
          //                   size: size,
          //                   fontSize: size.width * numD036,
          //                   color: Colors.black,
          //                   fontWeight: FontWeight.w400),
          //             ),
          //             TextSpan(
          //               text: "contact ",
          //               style: commonTextStyle(
          //                   size: size,
          //                   fontSize: size.width * numD036,
          //                   color: colorThemePink,
          //                   fontWeight: FontWeight.w600),
          //             ),
          //             TextSpan(
          //               text:
          //                   "our helpful teams who are available 24x7 to assist you. Thank you",
          //               style: commonTextStyle(
          //                   size: size,
          //                   fontSize: size.width * numD036,
          //                   color: Colors.black,
          //                   fontWeight: FontWeight.w400),
          //             ),
          //           ])),
          //           SizedBox(
          //             height: size.width * 0.01,
          //           ),
          //
          //           /*Row(
          //                 children: [
          //                   Expanded(
          //                       child: SizedBox(
          //                         height: size.width * numD13,
          //                         width: size.width,
          //                         child: ElevatedButton(
          //                           onPressed: () {
          //                             if (item.requestStatus.isEmpty &&
          //                                 !item.isMakeCounterOffer) {
          //                               var map1 = {
          //                                 "chat_id": item.id,
          //                                 "status": false,
          //                               };
          //
          //                               socketEmitFunc(
          //                                   socketEvent: "reqstatus",
          //                                   messageType: "",
          //                                   dataMap: map1);
          //
          //                               socketEmitFunc(
          //                                 socketEvent: "chat message",
          //                                 messageType: "reject_mediaHouse_offer",
          //                               );
          //
          //                               socketEmitFunc(
          //                                 socketEvent: "chat message",
          //                                 messageType: "rating_hopper",
          //                               );
          //
          //                               socketEmitFunc(
          //                                 socketEvent: "chat message",
          //                                 messageType: "rating_mediaHouse",
          //                               );
          //                               showRejectBtn = true;
          //                             }
          //                             setState(() {});
          //                           },
          //                           style: ElevatedButton.styleFrom(
          //                               elevation: 0,
          //                               backgroundColor: item.requestStatus.isEmpty &&
          //                                   !item.isMakeCounterOffer
          //                                   ? Colors.black
          //                                   : item.requestStatus == "false"
          //                                   ? Colors.grey
          //                                   : Colors.transparent,
          //                               shape: RoundedRectangleBorder(
          //                                   borderRadius:
          //                                   BorderRadius.circular(size.width * numD04),
          //                                   side: (item.requestStatus == "false" ||
          //                                       item.requestStatus.isEmpty) &&
          //                                       !item.isMakeCounterOffer
          //                                       ? BorderSide.none
          //                                       : const BorderSide(
          //                                       color: Colors.black, width: 1))),
          //                           child: Text(
          //                             rejectText,
          //                             style: commonTextStyle(
          //                                 size: size,
          //                                 fontSize: size.width * numD037,
          //                                 color: (item.requestStatus == "false" ||
          //                                     item.requestStatus.isEmpty) &&
          //                                     !item.isMakeCounterOffer
          //                                     ? Colors.white
          //                                     : colorLightGreen,
          //                                 fontWeight: FontWeight.w500),
          //                           ),
          //                         ),
          //                       )),
          //                   SizedBox(
          //                     width: size.width * numD04,
          //                   ),
          //                   Expanded(
          //                       child: SizedBox(
          //                         height: size.width * numD13,
          //                         width: size.width,
          //                         child: ElevatedButton(
          //                           onPressed: () {
          //                             //aditya accept btn
          //                             if (item.requestStatus.isEmpty &&
          //                                 !item.isMakeCounterOffer) {
          //                               debugPrint("tapppppp:::::$showAcceptBtn");
          //                               showAcceptBtn = true;
          //                               var map1 = {
          //                                 "chat_id": item.id,
          //                                 "status": true,
          //                               };
          //
          //                               socketEmitFunc(
          //                                   socketEvent: "reqstatus",
          //                                   messageType: "",
          //                                   dataMap: map1);
          //
          //                               socketEmitFunc(
          //                                   socketEvent: "chat message",
          //                                   messageType: "accept_mediaHouse_offer",
          //                                   dataMap: {
          //                                     "amount": isMakeCounter
          //                                         ? item.initialOfferAmount
          //                                         : item.finalCounterAmount,
          //                                     "image_id": widget.contentId!,
          //                                   });
          //                             }
          //                             setState(() {});
          //                           },
          //                           style: ElevatedButton.styleFrom(
          //                               elevation: 0,
          //                               backgroundColor: item.requestStatus.isEmpty &&
          //                                   !item.isMakeCounterOffer
          //                                   ? colorThemePink
          //                                   : item.requestStatus == "true"
          //                                   ? Colors.grey
          //                                   : Colors.transparent,
          //                               shape: RoundedRectangleBorder(
          //                                   borderRadius:
          //                                   BorderRadius.circular(size.width * numD04),
          //                                   side: (item.requestStatus == "true" ||
          //                                       item.requestStatus.isEmpty) &&
          //                                       !item.isMakeCounterOffer
          //                                       ? BorderSide.none
          //                                       : const BorderSide(
          //                                       color: Colors.black, width: 1))),
          //                           child: Text(
          //                             acceptText,
          //                             style: commonTextStyle(
          //                                 size: size,
          //                                 fontSize: size.width * numD037,
          //                                 color: (item.requestStatus == "true" ||
          //                                     item.requestStatus.isEmpty) &&
          //                                     !item.isMakeCounterOffer
          //                                     ? Colors.white
          //                                     : colorLightGreen,
          //                                 fontWeight: FontWeight.w500),
          //                           ),
          //                         ),
          //                       )),
          //
          //                   */ /* Expanded(
          //                       child: SizedBox(
          //                         height: size.width * numD13,
          //                         width: size.width,
          //                         child: ElevatedButton(
          //                           onPressed: () {
          //                             if(item.requestStatus.isEmpty){
          //
          //                               var map1 = {
          //                                 "chat_id" : item.id,
          //                                 "status" : true,
          //                               };
          //
          //                               socketEmitFunc(
          //                                   socketEvent: "reqstatus",
          //                                   messageType: "",
          //                                   dataMap: map1
          //                               );
          //
          //                               socketEmitFunc(
          //                                   socketEvent: "chat message",
          //                                   messageType: "contentupload",
          //                               );
          //                             }
          //                           },
          //                           style: ElevatedButton.styleFrom(
          //                               backgroundColor:
          //                               item.requestStatus.isEmpty
          //                                   ? colorThemePink
          //                                   :item.requestStatus == "true"
          //                                   ?  Colors.grey
          //                                   :  Colors.transparent,
          //                               shape: RoundedRectangleBorder(
          //                                 borderRadius: BorderRadius.circular(
          //                                     size.width * numD04),
          //                                   side: item.requestStatus == "true" || item.requestStatus.isEmpty ? BorderSide.none : const BorderSide(
          //                                       color: colorGrey1, width: 2)
          //                               )),
          //                           child: Text(
          //                             yesText,
          //                             style: commonTextStyle(
          //                                 size: size,
          //                                 fontSize: size.width * numD04,
          //                                 color: item.requestStatus == "true" || item.requestStatus.isEmpty ? Colors.white : colorLightGreen,
          //                                 fontWeight: FontWeight.w500),
          //                           ),
          //                         ),
          //                       )),*/ /*
          //                 ],
          //               ),*/
          //         ],
          //       ),
          //     )),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget ratingReview(var size, ManageTaskChatModel item) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: EdgeInsets.only(
                    top: size.width * numD04, left: size.width * numD04),
                decoration: BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.grey.shade300, spreadRadius: 2)
                    ]),
                child: ClipOval(
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: EdgeInsets.all(size.width * numD01),
                    child: Image.asset(
                      "${commonImagePath}ic_black_rabbit.png",
                      color: Colors.white,
                      width: size.width * numD07,
                      height: size.width * numD07,
                    ),
                  ),
                )),
            SizedBox(
              width: size.width * numD025,
            ),
            Expanded(
                child: Container(
              margin: EdgeInsets.only(
                  top: size.width * numD04,
                  right: size.width * numD04,
                  bottom: size.width * numD06),
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * numD05,
                  vertical: size.width * numD02),
              width: size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: colorGoogleButtonBorder),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(size.width * numD04),
                    bottomLeft: Radius.circular(size.width * numD04),
                    bottomRight: Radius.circular(size.width * numD04),
                  )),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: size.width * numD04,
                  ),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                      text: "Rate your experience with Presshop",
                      style: commonTextStyle(
                          size: size,
                          fontSize: size.width * numD036,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                  ])),
                  SizedBox(
                    height: size.width * numD04,
                  ),
                  RatingBar(
                    glowRadius: 0,
                    ratingWidget: RatingWidget(
                      empty: Image.asset("${iconsPath}emptystar.png"),
                      full: Image.asset("${iconsPath}star.png"),
                      half: Image.asset("${iconsPath}ic_half_star.png"),
                    ),
                    onRatingUpdate: (value) {
                      ratings = value;
                      setState(() {});
                    },
                    itemSize: size.width * numD09,
                    itemCount: 5,
                    initialRating: ratings,
                    allowHalfRating: true,
                    itemPadding: EdgeInsets.only(left: size.width * numD03),
                  ),
                  SizedBox(
                    height: size.width * 0.04,
                  ),
                  const Text(
                    "Tell us what you liked about the App",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: size.width * numD018,
                  ),
                  Wrap(
                      children:
                          List<Widget>.generate(intList.length, (int index) {
                    return Container(
                      margin: EdgeInsets.only(
                          left: size.width * 0.02, right: size.width * 0.02),
                      child: ChoiceChip(
                        label: Text(intList[index]),
                        labelStyle: TextStyle(
                            color: dataList.contains(intList[index])
                                ? Colors.white
                                : colorGrey6),
                        onSelected: (bool selected) {
                          if (selected) {
                            for (int i = 0; i < intList.length; i++) {
                              if (intList[i] == intList[index] &&
                                  !dataList.contains(intList[i])) {
                                dataList.add(intList[i]);
                                indexList.add(i);
                              }
                            }
                          } else {
                            for (int i = 0; i < intList.length; i++) {
                              if (intList[i] == intList[index] &&
                                  dataList.contains(intList[i])) {
                                dataList.remove(intList[i]);
                                indexList.remove(i);
                              }
                            }
                          }
                          setState(() {});
                        },
                        selectedColor: colorThemePink,
                        disabledColor: colorGreyChat.withOpacity(.3),
                        selected:
                            dataList.contains(intList[index]) ? true : false,
                      ),
                    );
                  })),
                  SizedBox(
                    height: size.width * numD02,
                  ),
                  Stack(
                    children: [
                      TextFormField(
                        controller: ratingReviewController1,
                        cursorColor: colorTextFieldIcon,
                        keyboardType: TextInputType.multiline,
                        maxLines: 6,
                        readOnly: false,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: size.width * numD035,
                        ),
                        onChanged: (v) {
                          onTextChanged();
                        },
                        decoration: InputDecoration(
                          hintText: textData,
                          contentPadding: EdgeInsets.only(
                              left: size.width * numD08,
                              right: size.width * numD02,
                              top: size.width * numD075),
                          hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              wordSpacing: 2,
                              fontSize: size.width * numD035),
                          disabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(size.width * 0.03),
                              borderSide: BorderSide(
                                  width: 1, color: Colors.grey.shade300)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(size.width * 0.03),
                              borderSide: BorderSide(
                                  width: 1, color: Colors.grey.shade300)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(size.width * 0.03),
                              borderSide: const BorderSide(
                                  width: 1, color: Colors.black)),
                          errorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(size.width * 0.03),
                              borderSide: BorderSide(
                                  width: 1, color: Colors.grey.shade300)),
                          focusedErrorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(size.width * 0.03),
                              borderSide: const BorderSide(
                                  width: 1, color: Colors.grey)),
                          alignLabelWithHint: false,
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: size.width * numD038,
                            left: size.width * numD014),
                        child: Image.asset(
                          "${iconsPath}docs.png",
                          width: size.width * 0.06,
                          height: size.width * 0.07,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.width * numD017),
                  ratingReviewController1.text.isEmpty
                      ? const Text(
                          "Required",
                          style: TextStyle(
                              fontSize: 11,
                              color: colorThemePink,
                              fontWeight: FontWeight.w400),
                        )
                      : Container(),
                  SizedBox(height: size.width * numD04),
                  SizedBox(
                    height: size.width * numD13,
                    width: size.width,
                    child: commonElevatedButton(
                        isRatingGiven ? "Thanks a Ton" : submitText,
                        size,
                        isRatingGiven
                            ? TextStyle(
                                color: Colors.black,
                                fontSize: size.width * numD037,
                                fontFamily: "AirbnbCereal",
                                fontWeight: FontWeight.bold)
                            : commonButtonTextStyle(size),
                        commonButtonStyle(
                            size, isRatingGiven ? Colors.grey : colorThemePink),
                        !isRatingGiven
                            ? () {
                                if (ratingReviewController1.text.isNotEmpty) {
                                  var map = {
                                    // "chat_id": item.id,
                                    "rating": ratings,
                                    "review": ratingReviewController1.text,
                                    "features": dataList,
                                    "image_id": imageId,
                                    "type": "content",
                                    "sender_type": "hopper"
                                  };
                                  debugPrint("map function $map");
                                  socketEmitFunc(
                                      socketEvent: "rating",
                                      messageType: "rating_for_hopper",
                                      dataMap: map);
                                  showSnackBar(
                                      "Rating & Review",
                                      "Thanks for the love! Your feedback makes all the difference ❤️",
                                      Colors.green);
                                  showCelebration = true;
                                  Future.delayed(const Duration(seconds: 3),
                                      () {
                                    showCelebration = false;
                                  });
                                  setState(() {});
                                } else {
                                  showSnackBar(
                                      "Required *",
                                      "Please Enter some review for mediahouse",
                                      Colors.red);
                                }
                              }
                            : () {
                                debugPrint("already rated:::;");
                              }),
                  ),
                  SizedBox(height: size.width * 0.01),
                  RichText(
                      text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black,
                            fontFamily: "AirbnbCereal",
                          ),
                          children: [
                        TextSpan(
                          text: "Please refer to our ",
                          style: commonTextStyle(
                              size: size,
                              fontSize: size.width * numD035,
                              color: Colors.black,
                              lineHeight: 1.2,
                              fontWeight: FontWeight.w400),
                        ),
                        TextSpan(
                            text: "Terms & Conditions. ",
                            style: commonTextStyle(
                                size: size,
                                fontSize: size.width * numD035,
                                color: colorThemePink,
                                lineHeight: 2,
                                fontWeight: FontWeight.w600),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => TermCheckScreen(
                                          type: 'legal',
                                        )));
                              }),
                        TextSpan(
                          text: "If you have any questions, please ",
                          style: commonTextStyle(
                              size: size,
                              fontSize: size.width * numD035,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        ),
                        TextSpan(
                            text: "contact ",
                            style: commonTextStyle(
                                size: size,
                                fontSize: size.width * numD035,
                                color: colorThemePink,
                                fontWeight: FontWeight.w600),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        const ContactUsScreen()));
                              }),
                        TextSpan(
                          text:
                              "our helpful teams who are available 24x7 to assist you. Thank you",
                          style: commonTextStyle(
                              size: size,
                              fontSize: size.width * numD035,
                              color: Colors.black,
                              lineHeight: 1.4,
                              fontWeight: FontWeight.w400),
                        ),
                      ])),
                  SizedBox(
                    height: size.width * 0.01,
                  ),
                ],
              ),
            )),
          ],
        ),
        showCelebration
            ? Lottie.asset(
                "assets/lottieFiles/celebrate.json",
              )
            : Container(),
      ],
    );
  }

  Widget videoWidget() {
    return Container();
  }

  void socketEmitFunc({
    required String socketEvent,
    required String messageType,
    Map<String, dynamic>? dataMap,
    String mediaType = "",
  }) {
    debugPrint(":::: Inside Socket Emit :::::");

    Map<String, dynamic> map = {
      "message_type": messageType,
      "receiver_id": widget.taskDetail?.mediaHouseId ?? "5",
      "sender_id": _senderId,
      "message": "",
      "primary_room_id": "",
      "room_id": widget.roomId,
      "media_type": mediaType,
      "sender_type": "hopper",
    };

    if (dataMap != null) {
      map.addAll(dataMap);
    }

    debugPrint("Emit Socket : $map");
    debugPrint(" Socket=====>  : $socketEvent");
    socket.emit(socketEvent, map);
    callGetManageTaskListingApi();
  }

  void socketConnectionFunc() {
    debugPrint(":::: Inside Socket Func :::::");
    debugPrint("socketUrl:::::$socketUrl");
    socket =
        IO.io(socketUrl, OptionBuilder().setTransports(['websocket']).build());

    debugPrint("Socket Disconnect : ${socket.disconnected}");
    debugPrint("Socket Disconnect : ${widget.taskDetail?.mediaHouseId}");

    socket.connect();

    socket.onConnect((_) {
      socket.emit('room join', {"room_id": widget.roomId});
    });

    socket.on("chat message", (data) => callGetManageTaskListingApi());
    socket.on("getallchat", (data) => callGetManageTaskListingApi());
    socket.on("updatehide", (data) => callGetManageTaskListingApi());
    socket.on("media message", (data) => callGetManageTaskListingApi());
    socket.on("offer message", (data) => callGetManageTaskListingApi());
    socket.on("rating", (data) => callGetManageTaskListingApi());
    socket.on("room join", (data) => callGetManageTaskListingApi());
    socket.on("initialoffer", (data) => callGetManageTaskListingApi());
    socket.on("updateOffer", (data) => callGetManageTaskListingApi());
    socket.on("leave room", (data) => callGetManageTaskListingApi());

    socket.onError((data) => debugPrint("Error Socket ::: $data"));
  }

  Future<void> getMultipleImages1() async {
    final ImagePicker picker = ImagePicker();
    const int maxImages = 10;

    try {
      final List<XFile> pickedFiles = await picker.pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        for (XFile file in pickedFiles) {
          debugPrint("Picked File: ${file.path}");
          selectMultipleMediaList
              .add(MediaModel(mediaFile: file, mimetype: ""));
        }

        previewBottomSheet();
        setState(() {});
      } else {
        debugPrint("No images selected.");
      }
    } catch (e) {
      debugPrint("Error picking images: $e");
    }
  }

  Future<void> getMultipleImages() async {
    final ImagePicker picker = ImagePicker();
    const int maxImages = 10;

    try {
      final List<XFile> pickedFiles = await picker.pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        for (XFile file in pickedFiles) {
          final String? mimeType = lookupMimeType(file.path);
          debugPrint("Picked File: ${file.path}");
          debugPrint("MIME Type: $mimeType");
          selectMultipleMediaList.add(
            MediaModel(
              mediaFile: file,
              mimetype: mimeType!,
            ),
          );
        }

        previewBottomSheet();
        setState(() {});
      } else {
        debugPrint("No images selected.");
      }
    } catch (e) {
      debugPrint("Error picking images: $e");
    }
  }

  void previewBottomSheet() {
    var size = MediaQuery.of(context).size;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        builder: (context) {
          return StatefulBuilder(builder: (context, avatarState) {
            return Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    onPageChanged: (value) {
                      currentPage = value;
                      setState(() {});
                    },
                    itemBuilder: (context, index) {
                      var item = selectMultipleMediaList[index];
                      debugPrint("type:::${item.mimetype}");
                      debugPrint("file:::${item.mediaFile!.path}");
                      if (item.mimetype.startsWith('image')) {
                        return Image.file(
                          File(item.mediaFile!.path),
                          fit: BoxFit.cover,
                          gaplessPlayback: true,
                        );
                      } else if (item.mimetype.startsWith('video')) {
                        return Container();
                      } else if (item.mimetype.startsWith('audio')) {
                        return AudioWaveFormWidgetScreen(
                            mediaPath: item.mediaFile!.path);
                      }
                    },
                    itemCount: selectMultipleMediaList.length,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.width * numD04,
                            vertical: size.width * numD02),
                        height: size.width * numD18,
                        child: commonElevatedButton(
                            "Add more",
                            size,
                            commonButtonTextStyle(size),
                            commonButtonStyle(size, Colors.black), () {
                          Navigator.pop(context);
                          getMultipleImages();
                        }),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.width * numD04,
                            vertical: size.width * numD02),
                        height: size.width * numD18,
                        child: commonElevatedButton(
                            "Next",
                            size,
                            commonButtonTextStyle(size),
                            commonButtonStyle(size, colorThemePink), () {
                          Navigator.pop(context);
                          callUploadMediaApi({}, "");
                        }),
                      ),
                    ),
                  ],
                ),
              ],
            );
          });
        });
  }

  void callDetailApi(String id) {
    Map<String, dynamic> map = {
      "content_id": widget.roomId,
      "media_house_id": id
    };

    NetworkClass(GetDetailsById, this, reqGetDetailsById)
        .callRequestServiceHeader(true, 'get', map);
  }

  /// Upload media
  void callUploadMediaApi(Map<String, String> mediaMap, String type) {
    List<String> mediaList = [];
    List<File> filesPath = [];
    for (var element in selectMultipleMediaList) {
      mediaList.add(element.mediaFile!.path);
    }

    filesPath.addAll(mediaList.map((path) => File(path)).toList());
    debugPrint("mediaList :::::$mediaList");

    Map<String, String> map = {
     // "type": type,
      'task_id': widget.taskDetail!.id,
    };

    debugPrint('map:::::::$map');
    /*NetworkClass.fromNetworkClass(
            uploadTaskMediaUrl, this, uploadTaskMediaReq, map)
        .callMultipartServiceNew(true, "post", mediaMap);*/

   NetworkClass.multipartNetworkClassFiles(
       uploadTaskMediaUrl, this, uploadTaskMediaReq, map, filesPath)
        .callMultipartServiceSameParamMultiImage(true, "post", "mediaFiles");
  }

  /// Get Listing
  void callGetManageTaskListingApi() {
    Map<String, String> map = {
      "room_id": widget.roomId,
      "type": "task_content"
    };

    NetworkClass.fromNetworkClass(
            getMediaTaskChatListUrl, this, getMediaTaskChatListReq, map)
        .callRequestServiceHeader(false, "post", null);
  }

  @override
  void onError({required int requestCode, required String response}) {
    switch (requestCode) {
      /// Upload Media
      case uploadTaskMediaReq:
        var data = jsonDecode(response);
        debugPrint("uploadTaskMediaReq Error : $data");
        showSnackBar("Manage task", data["message"].toString(), Colors.red);
        break;

      /// Get Chat Listing
      case getMediaTaskChatListReq:
        var data = jsonDecode(response);
        debugPrint("getMediaTaskChatListReq Error : $data");
        if (data["errors"] != null) {
          showSnackBar("Error", data["errors"]["msg"].toString(), Colors.red);
        } else {
          showSnackBar("Error", data.toString(), Colors.red);
        }
        break;

      case reqGetDetailsById:
        var data = jsonDecode(response);
        debugPrint("content detail Error : $data");
        break;
    }
  }

  @override
  void onResponse({required int requestCode, required String response}) {
    switch (requestCode) {
      /// Upload Media
      case uploadTaskMediaReq:
        var data = jsonDecode(response);
        debugPrint("uploadTaskMediaReq Success : $data");
        // imageId = data["data"] != null ? data["data"]["_id"] : "";
        //  debugPrint("imageID=========> $imageId");
        var mediaMap = {
          "attachment": data["image_name"] ?? "",
          "watermark": data["watermark"] ?? "",
          "attachment_name": data["attachme_name"] ?? "",
          "attachment_size": data["video_size"] ?? "",
          "thumbnail_url": data["videothubnail_path"] ?? "",
          "image_id": data["data"] != null ? data["data"]["_id"] : "",
        };
        socketEmitFunc(
            socketEvent: "media message",
            messageType: "media",
            dataMap: mediaMap,
            mediaType: data["type"] ?? "image");
/*
        if (_chatId.isNotEmpty) {
          var map = {
            "chat_id": _chatId,
            "status": true,
          };

          socketEmitFunc(
              socketEvent: "reqstatus", messageType: "", dataMap: map);
          _chatId = "";
          _againUpload = false;
        }

        uploadSuccess = true;*/
        setState(() {});
        break;

      /// Get Chat Listing
      case getMediaTaskChatListReq:
        var data = jsonDecode(response);
        debugPrint("getMediaTaskChatListReq Success::::: $data");
        var dataModel = data["response"] as List;
        contentView = data["views"].toString();
        contentPurchased = data["purchased_count"].toString();
        if (data["rating"] != null) {
          ratingReviewController1.text = data["rating"]["review"];
          ratings = double.parse(data["rating"]["rating"]);
          // dataList.addAll(data["rating"]["features"].toList());
          isRatingGiven = true;
          for (String data in data["rating"]["features"]) {
            dataList.add(data);
          }
        }
        chatList.clear();
        chatList =
            dataModel.map((e) => ManageTaskChatModel.fromJson(e)).toList();
        debugPrint("chatList length::::: ${chatList.length}");
        isLoading = true;

        setState(() {});

        break;

      case reqGetDetailsById:
        var data = jsonDecode(response);
        log("getDetail data Success::::: $data");
        var dataList = data['response'] as List;
        earningTransactionDataList =
            dataList.map((e) => EarningTransactionDetail.fromJson(e)).toList();
        setState(() {});
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TransactionDetailScreen(
                      type: "received",
                      transactionData: earningTransactionDataList[0],
                    )));
        break;
    }
  }
}

class MediaModel {
  XFile? mediaFile;
  String mimetype = "";

  MediaModel({
    required this.mediaFile,
    required this.mimetype,
  });
}
