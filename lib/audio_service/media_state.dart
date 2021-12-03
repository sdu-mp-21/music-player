import 'package:audio_service/audio_service.dart';
import 'package:getx_app/audio_service/audio_player_handler.dart';
import 'package:getx_app/models/song.dart';

class PlayerState {
  static Song? nowPlaying = null;
}

class MediaState {
  final MediaItem? mediaItem;
  final Duration position;

  MediaState(this.mediaItem, this.position);
}

late AudioPlayerHandlerImpl audioHandler;
