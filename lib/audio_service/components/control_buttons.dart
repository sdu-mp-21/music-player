import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getx_app/audio_service/components/seek_bar.dart';
import 'package:getx_app/audio_service/audio_player_handler.dart';

class ControlButtons extends StatelessWidget {
  final AudioPlayerHandlerImpl audioHandler;

  ControlButtons(this.audioHandler);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        StreamBuilder<AudioServiceRepeatMode>(
          stream: audioHandler.playbackState
              .map((state) => state.repeatMode)
              .distinct(),
          builder: (context, snapshot) {
            final repeatMode = snapshot.data ?? AudioServiceRepeatMode.none;
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
                    (cycleModes.indexOf(repeatMode) + 1) % cycleModes.length]);
              },
            );
          },
        ),
        StreamBuilder<QueueState>(
          stream: audioHandler.queueState,
          builder: (context, snapshot) {
            final queueState = snapshot.data ?? QueueState.empty;
            return IconButton(
              icon: const Icon(Icons.skip_previous),
              onPressed:
                  queueState.hasPrevious ? audioHandler.skipToPrevious : null,
            );
          },
        ),
        StreamBuilder<PlaybackState>(
          stream: audioHandler.playbackState,
          builder: (context, snapshot) {
            final playbackState = snapshot.data;
            final processingState = playbackState?.processingState;
            final playing = playbackState?.playing;
            if (playing != true) {
              return IconButton(
                icon: const Icon(CupertinoIcons.play_circle_fill),
                iconSize: 64.0,
                onPressed: audioHandler.play,
              );
            } else {
              return IconButton(
                icon: const Icon(
                  CupertinoIcons.pause_circle_fill,
                ),
                iconSize: 64.0,
                onPressed: audioHandler.pause,
              );
            }
          },
        ),
        StreamBuilder<QueueState>(
          stream: audioHandler.queueState,
          builder: (context, snapshot) {
            final queueState = snapshot.data ?? QueueState.empty;
            return IconButton(
              icon: const Icon(Icons.skip_next),
              onPressed: queueState.hasNext ? audioHandler.skipToNext : null,
            );
          },
        ),
        StreamBuilder<bool>(
          stream: audioHandler.playbackState
              .map((state) => state.shuffleMode == AudioServiceShuffleMode.all)
              .distinct(),
          builder: (context, snapshot) {
            final shuffleModeEnabled = snapshot.data ?? false;
            return IconButton(
              icon: shuffleModeEnabled
                  ? const Icon(Icons.shuffle, color: Colors.white)
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
    );
  }
}
