import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';

import '../../utils/Common.dart';
import 'dart:ui' as ui;

import 'PreviewScreen.dart';

class AudioWaveFormWidgetScreen extends StatefulWidget {
  String mediaPath = "";

  AudioWaveFormWidgetScreen({super.key,required this.mediaPath});


  @override
  State<StatefulWidget> createState() {
    return AudioWaveFormWidgetScreenState();
  }
}

class AudioWaveFormWidgetScreenState extends State<AudioWaveFormWidgetScreen> {
  PlayerController waveFormPlayerController = PlayerController(); // Initialise

  bool audioPlaying = false;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initWaveData();
    });

  }

  @override
  void dispose() {
    waveFormPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: size.width * numD12,
          ),
          Container(
            padding: EdgeInsets.all(size.width * numD02),
            decoration: const BoxDecoration(
                color: colorThemePink, shape: BoxShape.circle),
            child: Container(
                padding: EdgeInsets.all(size.width * numD07),
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: Colors.white, width: size.width * numD01)),
                child: Icon(
                  Icons.mic_none_outlined,
                  size: size.width * numD25,
                  color: Colors.white,
                )),
          ),
          SizedBox(
            height: size.width * numD25,
          ),
          AudioFileWaveforms(
            size: Size(size.width, 100.0),
            playerController: waveFormPlayerController,
            enableSeekGesture: true,
            waveformType: WaveformType.long,
            continuousWaveform: true,
            playerWaveStyle: PlayerWaveStyle(
                fixedWaveColor: Colors.black,
                liveWaveColor: colorThemePink,
                spacing: 6,
                liveWaveGradient: ui.Gradient.linear(
                  const Offset(70, 50),
                  Offset(MediaQuery.of(context).size.width / 2, 0),
                  [Colors.red, Colors.green],
                ),
                fixedWaveGradient: ui.Gradient.linear(
                  const Offset(70, 50),
                  Offset(MediaQuery.of(context).size.width / 2, 0),
                  [Colors.red, Colors.green],
                ),
                seekLineColor: colorThemePink,
                seekLineThickness: 2,
                showSeekLine: true,
                showBottom: true,
                waveCap: StrokeCap.round),
          ),
          SizedBox(
            height: size.width * numD25,
          ),
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              //initWaveData(index);
              if (audioPlaying) {
                pauseSound();
              } else {
                playSound();
              }
              audioPlaying = !audioPlaying;
              setState(() {});
            },
            child: Icon(
            audioPlaying ? Icons.pause_circle : Icons.play_circle,
            color: colorThemePink,
            size: size.width * numD15,
          ),
          ),
          const Spacer(),
        ],
      ),
    );
  }


  Future initWaveData() async {

// Or directly extract from preparePlayer and initialise audio player
    debugPrint("Wave-path:${widget.mediaPath}");
    await waveFormPlayerController.preparePlayer(
      path: widget.mediaPath,
      shouldExtractWaveform: true,
      noOfSamples: 100,
      volume: 1.0,
    );

    waveFormPlayerController.onPlayerStateChanged.listen((event) {
      if (event.isPaused) {
        audioPlaying = false;
        if (mounted) {
          setState(() {});
        }
      }
    });
  }


  Future playSound() async {
    debugPrint("PlayTheSound");

    await waveFormPlayerController.startPlayer(
        finishMode: FinishMode.pause
    ).then((value) {
      debugPrint("PlayerState: ${ waveFormPlayerController.playerState}");

    });
    // Start audio player
  }

  Future pauseSound() async {
    await waveFormPlayerController.pausePlayer(); // Start audio player
  }
}
