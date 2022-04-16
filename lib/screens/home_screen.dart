import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AudioPlayerHandler _audioPlayerHandler; // singleton.
  @override
  void initState() {
    // TODO: implement initState
    _audioPlayerHandler = AudioPlayerHandler();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Audio Service 2204")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                child: Text("Play"), onPressed: _audioPlayerHandler.play),
            ElevatedButton(
                child: Text("Pause"), onPressed: _audioPlayerHandler.stop),
          ],
        ),
      ),
    );
  }
}

class AudioPlayerHandler extends BaseAudioHandler {
  final _tts = FlutterTts();
  bool _finished = false;

  @override
  Future<void> play() async {
    for (var n = 1; !_finished && n <= 10; n++) {
      _tts.speak("$n");
      await Future.delayed(Duration(seconds: 1));
    }
  }

  @override
  Future<void> stop() async {
    // Stop speaking the numbers
    _finished = true;
  }
}
