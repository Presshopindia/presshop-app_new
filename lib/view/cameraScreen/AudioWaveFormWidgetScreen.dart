import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../utils/Common.dart';
import 'dart:ui' as ui;

import 'PreviewScreen.dart';

class AudioWaveFormWidgetScreen extends StatefulWidget {
  String mediaPath = "";

  AudioWaveFormWidgetScreen({super.key, required this.mediaPath});

  @override
  State<StatefulWidget> createState() {
    return AudioWaveFormWidgetScreenState();
  }
}

class AudioWaveFormWidgetScreenState extends State<AudioWaveFormWidgetScreen> with SingleTickerProviderStateMixin {
  PlayerController waveFormPlayerController = PlayerController(); // Initialise

  bool audioPlaying = false;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initWaveData();
    });
    _controller = AnimationController(vsync: this,duration: Duration(minutes: 1));
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
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 96),
            Flexible(
              flex: 1,
              child: Center(
                child: SizedBox(
                  height: 256,
                  // padding: EdgeInsets.all(size.width * numD04),
                  // decoration: const BoxDecoration(color: colorThemePink, shape: BoxShape.circle),
                  child: Image.asset("assets/commonImages/audio_logo.png")
                ),
              ),
            ),
            // SizedBox(
            //   height: size.width * numD25,
            // ),
            // AudioFileWaveforms(
            //   size: Size(size.width, 100.0),
            //   playerController: waveFormPlayerController,
            //   enableSeekGesture: true,
            //   waveformType: WaveformType.long,
            //   continuousWaveform: true,
            //   playerWaveStyle: PlayerWaveStyle(
            //       fixedWaveColor: Colors.black,
            //       liveWaveColor: colorThemePink,
            //       spacing: 6,
            //       liveWaveGradient: ui.Gradient.linear(
            //         const Offset(70, 50),
            //         Offset(MediaQuery.of(context).size.width / 2, 0),
            //         [Colors.red, Colors.green],
            //       ),
            //       fixedWaveGradient: ui.Gradient.linear(
            //         const Offset(70, 50),
            //         Offset(MediaQuery.of(context).size.width / 2, 0),
            //         [Colors.red, Colors.green],
            //       ),
            //       seekLineColor: colorThemePink,
            //       seekLineThickness: 2,
            //       showSeekLine: true,
            //       showBottom: true,
            //       waveCap: StrokeCap.round),
            // ),
            Lottie.asset(
              "assets/lottieFiles/audio_waves.json",
              controller: _controller
            ),
            Flexible(
              flex: 1,
              child: Center(
                child: InkWell(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () {
                    if (audioPlaying) {
                      pauseSound();
                    } else {
                      playSound();
                    }
                    audioPlaying = !audioPlaying;
                    setState(() {});
                  },
                  child: Container(
                    padding: EdgeInsets.all(size.width * numD015),
                    decoration: const BoxDecoration(color: colorThemePink, shape: BoxShape.circle),
                    child: Container(
                        padding: EdgeInsets.all(size.width * numD02),
                        decoration: BoxDecoration(color: Colors.transparent, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                        child: Icon(
                          audioPlaying ? Icons.pause : Icons.play_arrow_rounded,
                          size: size.width * numD16,
                          color: Colors.white,
                        ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  Future initWaveData() async {
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

    await waveFormPlayerController.startPlayer().then((value) {
      debugPrint("PlayerState: ${waveFormPlayerController.playerState}");
    });
    _controller?.forward();
    // Start audio player
  }

  Future pauseSound() async {
    await waveFormPlayerController.pausePlayer(); // Start audio player
    _controller?.stop();
  }
}
