import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getx_app/audio_service/media_state.dart';

class MiniPlayBack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PlaybackState>(
      stream: audioHandler.playbackState,
      builder: (context, snapshot) {
        final playbackState = snapshot.data;
        final processingState = playbackState?.processingState;
        final playing = playbackState?.playing;
        if (processingState == AudioProcessingState.loading ||
            processingState == AudioProcessingState.buffering) {
          return Container(
            child: IconButton(
              icon: const Icon(CupertinoIcons.play_arrow),
              onPressed: audioHandler.play,
            ),
          );
        } else if (playing != true) {
          return IconButton(
            icon: const Icon(CupertinoIcons.play_arrow),
            onPressed: audioHandler.play,
          );
        } else {
          return IconButton(
            icon: const Icon(CupertinoIcons.pause),
            onPressed: audioHandler.pause,
          );
        }
      },
    );
  }
}
