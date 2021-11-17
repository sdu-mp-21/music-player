import 'package:audio_service/audio_service.dart';
import 'package:getx_app/audio_service/audio_player_handler.dart';

class PlayerState {
  static var nowPlaying = {};
}

class MediaState {
  final MediaItem? mediaItem;
  final Duration position;

  MediaState(this.mediaItem, this.position);
}

late AudioPlayerHandlerImpl audioHandler;
