import 'package:flutter/material.dart';
import 'package:getx_app/audio_service/audio_player_handler.dart';
import 'package:getx_app/pages/dashboard/components/song_item.dart';

class QueueList extends StatelessWidget {
  final AudioPlayerHandlerImpl audioHandler;

  QueueList(this.audioHandler);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: kBottomNavigationBarHeight),
      child: StreamBuilder<QueueState>(
        stream: audioHandler.queueState,
        builder: (context, snapshot) {
          final queueState = snapshot.data ?? QueueState.empty;
          final queue = queueState.queue;
          return ReorderableListView(
            onReorder: (int oldIndex, int newIndex) {
              if (oldIndex < newIndex) newIndex--;
              audioHandler.moveQueueItem(oldIndex, newIndex);
            },
            children: [
              for (var i = 0; i < queue.length; i++)
                Container(
                    key: Key(i.toString()),
                    child: SongItem(
                        onTap: () {
                          audioHandler.skipToQueueItem(i);
                        },
                        index: i,
                        title: queue[i].album!,
                        artUri: queue[i].artUri!,
                        artist: queue[i].artist!))
            ],
          );
        },
      ),
    );
  }
}
