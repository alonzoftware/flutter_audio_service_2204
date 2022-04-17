import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AudioPlayerHandler _audioPlayerHandler; // singleton.
  bool _interrupted = false;
  var _running = false;

  bool get _playing => _audioPlayerHandler.playbackState.value.playing;

  @override
  void initState() {
    // TODO: implement initState
    _audioPlayerHandler = AudioPlayerHandler();
    _init();
    super.initState();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    // Handle audio interruptions.
    session.interruptionEventStream.listen((event) {
      if (event.begin) {
        if (_playing) {
          _audioPlayerHandler.pause();
          _interrupted = true;
        }
      } else {
        switch (event.type) {
          case AudioInterruptionType.pause:
          case AudioInterruptionType.duck:
            if (!_playing && _interrupted) {
              _audioPlayerHandler.play();
            }
            break;
          case AudioInterruptionType.unknown:
            break;
        }
        _interrupted = false;
      }
    });
    // Handle unplugged headphones.
    session.becomingNoisyEventStream.listen((_) {
      if (_playing) _audioPlayerHandler.pause();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Example")),
      body: Center(
        child: StreamBuilder<PlaybackState>(
          stream: _audioPlayerHandler.playbackState,
          builder: (context, snapshot) {
            final playing = snapshot.data?.playing ?? false;
            final processingState =
                snapshot.data?.processingState ?? AudioProcessingState.idle;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (playing)
                  ElevatedButton(
                      child: Text("Pause"),
                      onPressed: _audioPlayerHandler.pause)
                else
                  ElevatedButton(
                      child: Text("Play"), onPressed: _audioPlayerHandler.play),
              ],
            );
          },
        ),
      ),
    );
  }
}

class AudioPlayerHandler extends BaseAudioHandler {
  final _tts = FlutterTts();
  bool _finished = false;

  @override
  AudioPlayerHandler() {
    // Broadcast that we're loading, and what controls are available.
    playbackState.add(playbackState.value.copyWith(
      controls: [MediaControl.play],
      processingState: AudioProcessingState.loading,
    ));
  }

  @override
  Future<void> play() async {
    playbackState.add(playbackState.value.copyWith(
      playing: true,
      controls: [MediaControl.pause],
    ));
    for (var n = 1; !_finished && n <= 10; n++) {
      _tts.speak("$n");
      await Future.delayed(Duration(seconds: 1));
    }
  }

  @override
  Future<void> pause() async {
    // Stop speaking the numbers
    playbackState.add(playbackState.value.copyWith(
      playing: false,
      controls: [MediaControl.play],
    ));
    _finished = true;
  }
}
