import 'package:flutter/material.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter_audio_service_2204/providers/text_audio_provider.dart';

// late TextPlayerHandler textPlayerHandler;

class PlayPauseStopScreen extends StatelessWidget {
  PlayPauseStopScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Example")),
      body: Center(
        child: StreamBuilder<PlaybackState>(
          stream: textAudioProvider.textPlayerHandler.playbackState,
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
                      onPressed: textAudioProvider.textPlayerHandler.pause)
                else
                  ElevatedButton(
                      child: Text("Play"),
                      onPressed: textAudioProvider.textPlayerHandler.play),
              ],
            );
          },
        ),
      ),
    );
  }
}
