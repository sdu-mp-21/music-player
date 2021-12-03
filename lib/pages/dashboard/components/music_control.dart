import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:getx_app/audio_service/audio_player_handler.dart';
import 'package:getx_app/audio_service/components/control_buttons.dart';
import 'package:getx_app/audio_service/components/seek_bar.dart';
import 'package:rxdart/rxdart.dart';

class MusicControl extends StatelessWidget {
  final AudioPlayerHandlerImpl audioHandler;

  MusicControl(this.audioHandler);

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
    final screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder<MediaItem?>(
      stream: audioHandler.mediaItem,
      builder: (context, snapshot) {
        final mediaItem = snapshot.data;
        if (mediaItem == null) return const SizedBox();
        return Column(
          children: [
            if (mediaItem.artUri != null)
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                padding: const EdgeInsets.only(top: kBottomNavigationBarHeight),
                child: Center(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/placeholder.png',
                          height: screenWidth * 0.8,
                          width: screenWidth * 0.8,
                          image: '${mediaItem.artUri!}',
                        ))),
              ),
            Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Text(mediaItem.album ?? '',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headline6)),
            Container(
                padding:
                    EdgeInsets.only(left: 50, right: 50, top: 10, bottom: 20),
                child: Text(
                  mediaItem.title,
                  maxLines: 1,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                )),
            StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data ??
                    PositionData(Duration.zero, Duration.zero, Duration.zero);
                return SeekBar(
                  duration: positionData.duration,
                  position: positionData.position,
                  onChangeEnd: (newPosition) {
                    audioHandler.seek(newPosition);
                  },
                );
              },
            ),
            ControlButtons(this.audioHandler),
          ],
        );
      },
    );
  }
}
