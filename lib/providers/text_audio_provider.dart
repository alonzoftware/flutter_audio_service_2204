import 'package:audio_service/audio_service.dart';
import 'package:flutter_audio_service_2204/services/text_player_handler.dart';

class _TextAudioProvider {
  // make this nullable by adding '?'
  static _TextAudioProvider? _instance;

  _TextAudioProvider._() {
    // initialization and stuff
  }

  factory _TextAudioProvider() {
    _instance ??= _TextAudioProvider._();
    // since you are sure you will return non-null value, add '!' operator
    return _instance!;
  }

  late TextPlayerHandler _textPlayerHandler;
  init() async {
    _textPlayerHandler = await AudioService.init(
      builder: () => TextPlayerHandler(),
      config: const AudioServiceConfig(
        androidNotificationChannelId: 'com.mycompany.myapp.channel.audio',
        androidNotificationChannelName: 'Music playback',
      ),
    );
  }

  TextPlayerHandler get textPlayerHandler => _textPlayerHandler;
}

final textAudioProvider = _TextAudioProvider();
