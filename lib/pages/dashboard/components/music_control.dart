import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:getx_app/audio_service/components/control_buttons.dart';
import 'package:getx_app/audio_service/components/seek_bar.dart';
import 'package:getx_app/audio_service/media_state.dart';
import 'package:rxdart/rxdart.dart';

class MusicControl extends StatelessWidget {
  Stream<Duration> get _bufferedPositionStream => audioHandler.playbackState
      .map((state) => state.bufferedPosition)
      .distinct();
  Stream<Duration?> get _durationStream =>
      audioHandler.mediaItem.map((item) => item?.duration).distinct();
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          AudioService.position,
          _bufferedPositionStream,
          _durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: StreamBuilder<MediaItem?>(
            stream: audioHandler.mediaItem.asBroadcastStream(),
            builder: (context, snapshot) {
              final mediaItem = snapshot.data;
              if (mediaItem == null) return const SizedBox();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (mediaItem.artUri != null)
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Image.network('${mediaItem.artUri!}'),
                      ),
                    ),
                  Text(mediaItem.album ?? '',
                      style: Theme.of(context).textTheme.headline6),
                  Text(mediaItem.title),
                  ControlButtons(audioHandler),
                  StreamBuilder<PositionData>(
                    stream: _positionDataStream.asBroadcastStream(),
                    builder: (context, snapshot) {
                      final positionData = snapshot.data ??
                          PositionData(
                              Duration.zero, Duration.zero, Duration.zero);
                      return SeekBar(
                        duration: positionData.duration,
                        position: positionData.position,
                        onChangeEnd: (newPosition) {
                          audioHandler.seek(newPosition);
                        },
                      );
                    },
                  ),
                  Row(
                    children: [
                      StreamBuilder<AudioServiceRepeatMode>(
                        stream: audioHandler.playbackState
                            .asBroadcastStream()
                            .map((state) => state.repeatMode)
                            .distinct(),
                        builder: (context, snapshot) {
                          final repeatMode =
                              snapshot.data ?? AudioServiceRepeatMode.none;
                          const icons = [
                            Icon(Icons.repeat, color: Colors.grey),
                            Icon(Icons.repeat, color: Colors.orange),
                            Icon(Icons.repeat_one, color: Colors.orange),
                          ];
                          const cycleModes = [
                            AudioServiceRepeatMode.none,
                            AudioServiceRepeatMode.all,
                            AudioServiceRepeatMode.one,
                          ];
                          final index = cycleModes.indexOf(repeatMode);
                          return IconButton(
                            icon: icons[index],
                            onPressed: () {
                              audioHandler.setRepeatMode(cycleModes[
                                  (cycleModes.indexOf(repeatMode) + 1) %
                                      cycleModes.length]);
                            },
                          );
                        },
                      ),
                      StreamBuilder<bool>(
                        stream: audioHandler.playbackState
                            .asBroadcastStream()
                            .map((state) =>
                                state.shuffleMode ==
                                AudioServiceShuffleMode.all)
                            .distinct(),
                        builder: (context, snapshot) {
                          final shuffleModeEnabled = snapshot.data ?? false;
                          return IconButton(
                            icon: shuffleModeEnabled
                                ? const Icon(Icons.shuffle,
                                    color: Colors.orange)
                                : const Icon(Icons.shuffle, color: Colors.grey),
                            onPressed: () async {
                              final enable = !shuffleModeEnabled;
                              await audioHandler.setShuffleMode(enable
                                  ? AudioServiceShuffleMode.all
                                  : AudioServiceShuffleMode.none);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    ));
  }
}
