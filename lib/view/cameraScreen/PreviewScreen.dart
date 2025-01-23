import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:presshop/utils/Common.dart';
import 'package:presshop/utils/VideoWidget.dart';
import 'package:presshop/utils/commonEnums.dart';
import 'package:presshop/view/publishContentScreen/PublishContentScreen.dart';
import 'package:video_player/video_player.dart';
import '../../main.dart';
import '../../utils/CommonWigdets.dart';
import 'dart:ui' as ui;
import '../dashboard/Dashboard.dart';
import '../menuScreen/MyContentScreen.dart';
import 'AudioWaveFormWidgetScreen.dart';
import 'CameraScreen.dart';
import 'package:path/path.dart' as path;

class PreviewScreen extends StatefulWidget {
  CameraData? cameraData;
  List<CameraData> cameraListData;
  List<MediaData> mediaList;
  bool pickAgain = false;
  String type = '';

  PreviewScreen(
      {super.key,
      required this.cameraData,
      required this.pickAgain,
      required this.cameraListData,
      required this.mediaList,
      required this.type});

  @override
  State<StatefulWidget> createState() {
    return PreviewScreenState();
  }
}

class PreviewScreenState extends State<PreviewScreen> {
  VideoPlayerController? _controller;

  String currentTIme = "00:00",
      mediaAddress = "",
      mediaDate = "",
      country = "",
      state = "",
      city = "";
  AudioPlayer audioPlayer = AudioPlayer();

  int currentPage = 0;

  bool isLoading = false;
  bool videoPlaying = false, isMoreDisable = false;

  List<MediaData> mediaList = [];

  @override
  void initState() {
    debugPrint("class:::::$runtimeType");
    debugPrint("type:::::${widget.type}");
    super.initState();
    addMediaDataList(widget.cameraListData);
    if (widget.mediaList.isNotEmpty) {
      mediaList = widget.mediaList;
    }
  }

  @override
  void dispose() {
    if (_controller != null && _controller!.value.isPlaying) {
      _controller!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        if (widget.type == "draft") {
          Navigator.pop(context);
        } else {
          mediaList.clear();
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => Dashboard(
                        initialPosition: 2,
                      )),
              (route) => false);
        }

        return false;
      },
      child: Scaffold(
          backgroundColor: Colors.black,
          appBar: null,
          body: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  onPageChanged: (value) {
                    currentPage = value;
                    setState(() {});
                  },
                  itemBuilder: (context, index) {
                    debugPrint("media:::::${mediaList[index].mimeType}");
                    debugPrint("mediaList length:::::${mediaList.length}");
                    return InteractiveViewer(
                      minScale: 0.5,
                      maxScale: 2,
                      scaleEnabled:
                          mediaList[index].mimeType == "image" ? true : false,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          mediaList[index].mimeType.contains("video")
                              ? Align(
                                  alignment: Alignment.center,
                                  child:
                                      VideoWidget(mediaData: mediaList[index]),
                                )
                              : mediaList[index].mimeType.contains("audio")
                                  ? AudioWaveFormWidgetScreen(
                                      mediaPath: mediaList[index].mediaPath,
                                    )
                                  : mediaList[index].mimeType.contains("doc")
                                      ? Center(
                                          child: SizedBox(
                                            height: size.width * numD60,
                                            width: size.width * numD55,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  "${dummyImagePath}doc_black_icon.png",
                                                  fit: BoxFit.contain,
                                                  height: size.width * numD45,
                                                ),
                                                SizedBox(
                                                  height: size.width * numD04,
                                                ),
                                                Text(
                                                  path.basename(mediaList[index]
                                                      .mediaPath),
                                                  textAlign: TextAlign.center,
                                                  style: commonTextStyle(
                                                      size: size,
                                                      fontSize:
                                                          size.width * numD03,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                  maxLines: 2,
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      : mediaList[index]
                                              .mimeType
                                              .contains("pdf")
                                          ? Center(
                                              child: SizedBox(
                                                height: size.width * numD60,
                                                width: size.width * numD55,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      "${dummyImagePath}pngImage.png",
                                                      fit: BoxFit.contain,
                                                      height:
                                                          size.width * numD45,
                                                    ),
                                                    SizedBox(
                                                      height:
                                                          size.width * numD04,
                                                    ),
                                                    Text(
                                                      path.basename(
                                                          mediaList[index]
                                                              .mediaPath),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: commonTextStyle(
                                                          size: size,
                                                          fontSize: size.width *
                                                              numD03,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                      maxLines: 2,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          : SizedBox(
                                              height: size.height,
                                              width: size.width,
                                              child: widget.type!="draft"
                                                  ? Image.file(
                                                      File(mediaList[index]
                                                          .mediaPath),
                                                      fit: BoxFit.cover,
                                                      gaplessPlayback: true,
                                                    )
                                                  : Image.network(
                                                      imageUrlBefore +
                                                          mediaList[index]
                                                              .mediaPath,
                                                      fit: BoxFit.cover,
                                                      gaplessPlayback: true,
                                                    ),
                                            ),
                          mediaList.isNotEmpty && mediaList.length > 1
                              ? Padding(
                                  padding: EdgeInsets.only(
                                      bottom: mediaList[index]
                                              .mimeType
                                              .contains("video")
                                          ? size.width * numD08
                                          : 0),
                                  child: DotsIndicator(
                                    dotsCount: mediaList.length,
                                    position: currentPage,
                                    decorator: const DotsDecorator(
                                      color: Colors.grey, // Inactive color
                                      activeColor: Colors.redAccent,
                                    ),
                                  ),
                                )
                              : Container(),
                          Container(
                            margin: EdgeInsets.only(
                                bottom: mediaList[index].mimeType == "video"
                                    ? size.width * numD11
                                    : mediaList[index].mimeType == "audio"
                                        ? size.width * numD03
                                        : mediaList[index].mimeType == "image"
                                            ? size.width * numD03
                                            : 0),
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * numD04,
                                vertical: size.width * numD04),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                      alignment: Alignment.center,
                                      height: size.width * numD11,
                                      decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.5),
                                          borderRadius: BorderRadius.circular(
                                              size.width * numD04)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "${iconsPath}ic_clock.png",
                                            width: size.width * numD04,
                                            height: size.width * numD04,
                                          ),
                                          SizedBox(
                                            width: size.width * numD02,
                                          ),
                                          Text(
                                            dateTimeFormatter(
                                              dateTime:
                                                  mediaList[index].dateTime,
                                              format: "dd MMM yyyy hh:mm a",
                                            ),
                                            style: commonTextStyle(
                                                size: size,
                                                fontSize: size.width * numD025,
                                                color: Colors.black,
                                                fontWeight: FontWeight.normal),
                                          )
                                        ],
                                      )),
                                ),
                                SizedBox(
                                  width: size.width * numD04,
                                ),
                                Expanded(
                                  child: Container(
                                      height: size.width * numD11,
                                      decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.5),
                                          borderRadius: BorderRadius.circular(
                                              size.width * numD04)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            "${iconsPath}ic_location.png",
                                            width: size.width * numD04,
                                            height: size.width * numD04,
                                          ),
                                          SizedBox(
                                            width: size.width * numD02,
                                          ),
                                          SizedBox(
                                            width: size.width * numD25,
                                            child: Text(
                                              mediaList[index].location,
                                              style: commonTextStyle(
                                                  size: size,
                                                  fontSize:
                                                      size.width * numD025,
                                                  color: Colors.black,
                                                  fontWeight:
                                                      FontWeight.normal),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          )
                                        ],
                                      )),
                                ),
                              ],
                            ),
                          ),
                          !mediaList[index].mimeType.contains("audio")
                              ? Positioned(
                                  top: 0,
                                  bottom: mediaList[index]
                                          .mimeType
                                          .contains("video")
                                      ? size.width * numD08
                                      : 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.1),
                                      ),
                                      child: Image.asset(
                                        "${commonImagePath}watermark1.png",
                                        fit: BoxFit.cover,
                                      )))
                              : Container(),
                          Positioned(
                            top: size.width * numD09,
                            right: size.width * numD04,
                            child: InkWell(
                              /// @aditya 17 sep
                              onTap: () {
                                if (mediaList.isNotEmpty &&
                                    index < mediaList.length) {
                                  if (mediaList.length == 1) {
                                    debugPrint('hello::::::::');
                                    mediaList.removeAt(index);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Dashboard(initialPosition: 2)));
                                  } else {
                                    mediaList.removeAt(index);
                                    if (currentPage >= mediaList.length) {
                                      currentPage = mediaList.length - 1;
                                    }
                                  }
                                }

                                setState(() {});
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle),
                                padding: EdgeInsets.all(size.width * numD01),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.black,
                                  size: size.width * numD05,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: mediaList.length,
                ),
              ),
              /*SizedBox(
                height: size.width * numD02,
              ),*/
              widget.type == "draft"
                  ? Container(
                      height: size.width * numD17,
                      width: double.infinity,
                      color: Colors.white,
                      padding: EdgeInsets.only(
                          left: size.width * numD04,
                          top: size.width * numD02,
                          bottom: size.width * numD02,
                          right: size.width * numD02),
                      child: commonElevatedButton(
                          "Next",
                          size,
                          commonTextStyle(
                              size: size,
                              fontSize: size.width * numD035,
                              color: Colors.white,
                              fontWeight: FontWeight.w700),
                          commonButtonStyle(size, colorThemePink), () {
                        Navigator.pop(context); //  getImageMetaData();
                      }),
                    )
                  : Container(
                      color: Colors.white,
                      padding: EdgeInsets.only(
                          left: size.width * numD04,
                          top: size.width * numD02,
                          bottom: size.width * numD03,
                          right: size.width * numD02),
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: size.width * numD13,
                              child: commonElevatedButton(
                                  "Add More",
                                  size,
                                  commonTextStyle(
                                      size: size,
                                      fontSize: size.width * numD035,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                  commonButtonStyle(
                                      size,
                                      isMoreDisable
                                          ? Colors.grey
                                          : Colors.black), () {
                                if (mediaList.length == 10) {
                                  isMoreDisable = true;
                                  setState(() {});
                                  showSnackBar(
                                      "PRESSHOP",
                                      "Only 10 contents allowed!",
                                      colorThemePink);
                                } else {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (context) =>
                                              const CameraScreen(
                                                picAgain: true,
                                                previousScreen: ScreenNameEnum
                                                    .previewScreen,
                                              )))
                                      .then((value) {
                                    debugPrint(
                                        ":::: Inside Picked Again Image :::: $value");
                                    if (value != null) {
                                      addMediaDataList(value);
                                    }
                                  });
                                }

                                /*getImageMetaData(widget.cameraData);*/
                              }),
                            ),
                          ),
                          SizedBox(width: size.width * numD04),
                          Expanded(
                            child: SizedBox(
                              height: size.width * numD13,
                              child: commonElevatedButton(
                                  "Next",
                                  size,
                                  commonTextStyle(
                                      size: size,
                                      fontSize: size.width * numD035,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                  commonButtonStyle(size, colorThemePink), () {
                                if (widget.pickAgain) {
                                  Navigator.pop(context);
                                  if (widget.type == "draft") {
                                    for (int i = 0; i < mediaList.length; i++) {
                                      var mediaItem = mediaList[i];
                                      PublishData(
                                          imagePath: mediaItem.mediaPath,
                                          address: mediaItem.location,
                                          date: mediaItem.dateTime,
                                          city: "",
                                          state: "",
                                          country: "",
                                          latitude: mediaItem.latitude,
                                          longitude: mediaItem.longitude,
                                          mimeType: mediaItem.mimeType,
                                          videoImagePath: mediaItem.mediaPath,
                                          mediaList: mediaList);
                                    }
                                  } else {
                                    Navigator.pop(
                                        context,
                                        PublishData(
                                            imagePath: widget.cameraData!.path,
                                            address: mediaAddress.isNotEmpty
                                                ? mediaAddress
                                                : widget.cameraListData.first
                                                    .location,
                                            date: mediaDate,
                                            city: city.isNotEmpty
                                                ? city
                                                : widget
                                                    .cameraListData.first.city,
                                            state: state.isNotEmpty
                                                ? state
                                                : widget
                                                    .cameraListData.first.state,
                                            country: country.isNotEmpty
                                                ? country
                                                : widget.cameraListData.first
                                                    .country,
                                            latitude:
                                                widget.cameraData!.latitude,
                                            longitude:
                                                widget.cameraData!.longitude,
                                            mimeType:
                                                widget.cameraData!.mimeType,
                                            videoImagePath: widget
                                                .cameraData!.videoImagePath,
                                            mediaList: mediaList));
                                  }
                                } else {
                                  if (mediaList.isNotEmpty) {
                                    if (widget.cameraListData.isNotEmpty) {
                                      Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => PublishContentScreen(
                                              publishData: PublishData(
                                                  imagePath: widget.cameraData != null
                                                      ? widget.cameraData!.path
                                                      : widget.cameraListData
                                                          .first.path,
                                                  address:
                                                      mediaAddress.isNotEmpty
                                                          ? mediaAddress
                                                          : widget
                                                              .cameraListData
                                                              .first
                                                              .location,
                                                  date: mediaDate.isNotEmpty
                                                      ? mediaDate
                                                      : widget.cameraListData
                                                          .first.dateTime,
                                                  city: city.isNotEmpty
                                                      ? city
                                                      : widget.cameraListData.first.city,
                                                  state: state.isNotEmpty ? state : widget.cameraListData.first.state,
                                                  country: country.isNotEmpty ? country : widget.cameraListData.first.country,
                                                  latitude: widget.cameraData != null ? widget.cameraData!.latitude : widget.cameraListData.first.latitude,
                                                  longitude: widget.cameraData != null ? widget.cameraData!.longitude : widget.cameraListData.first.longitude,
                                                  mimeType: widget.cameraData != null ? widget.cameraData!.mimeType : widget.cameraListData.first.mimeType,
                                                  videoImagePath: widget.cameraData != null ? widget.cameraData!.videoImagePath : widget.cameraListData.first.videoImagePath,
                                                  mediaList: mediaList),
                                              myContentData: null,
                                              hideDraft: false,
                                              docType: widget.type)));
                                    }
                                  }
                                }

                                //  getImageMetaData();
                              }),
                            ),
                          )
                        ],
                      ),
                    ),
            ],
          )),
    );
  }

  void initVideoPlayer(MediaData mData) {
    _controller = null;

    if (mData.mimeType.contains("video") && mData.mediaPath.isNotEmpty) {
      _controller = VideoPlayerController.file(File(mData.mediaPath))
        ..initialize().then((_) {
          setState(() {});
        });

      _controller!.addListener(() {
        currentTIme = _controller!.value.position.inSeconds.toString();
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  /// Gallery Image
/*  Future addMediaDataList(List<CameraData> cDataList) async {
    if (cDataList.isNotEmpty) {
      for (var element in cDataList) {
        mediaList.add(MediaData(
            mediaPath: element.path,
            mimeType: element.mimeType,
            thumbnail: element.videoImagePath,
            location: element.location,
            dateTime: element.dateTime.toString(),
            latitude: element.latitude,
            longitude: element.longitude));
        debugPrint(" path ======> : ${element.path}");
        debugPrint("MedListSize: ${mediaList.length}");
        setState(() {});
      }
    }
  }*/

  Future addMediaDataList(List<CameraData> cDataList) async {
    if (cDataList.isNotEmpty) {
      for (var element in cDataList) {
        mediaList.insert(
            0,
            MediaData(
                mediaPath: element.path,
                mimeType: element.mimeType,
                thumbnail: element.videoImagePath,
                location: element.location,
                dateTime: element.dateTime.toString(),
                latitude: element.latitude,
                longitude: element.longitude));

        debugPrint(" path ======> : ${element.path}");
        debugPrint("MedListSize: ${mediaList.length}");
      }

      setState(() {});
    }
  }
}

class PublishData {
  String imagePath = "";
  String videoImagePath = "";
  String mimeType = "";
  String address = "";
  String date = "";
  String country = "";
  String state = "";
  String city = "";
  String latitude = "";
  String longitude = "";
  List<MediaData> mediaList = [];

  PublishData({
    required this.imagePath,
    required this.address,
    required this.date,
    required this.country,
    required this.state,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.videoImagePath,
    required this.mimeType,
    required this.mediaList,
  });
}

class MediaData {
  String mediaPath = "";
  String mimeType = "";
  String thumbnail = "";
  String dateTime = "";
  String location = "";
  String latitude = "";
  String longitude = "";

  MediaData({
    required this.mediaPath,
    required this.mimeType,
    required this.thumbnail,
    required this.latitude,
    required this.longitude,
    required this.location,
    required this.dateTime,
  });
}
