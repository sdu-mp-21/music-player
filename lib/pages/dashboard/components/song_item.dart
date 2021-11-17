import 'package:flutter/material.dart';
import 'package:getx_app/audio_service/media_state.dart';

class SongItem extends StatelessWidget {
  final int index;
  final String title;
  final Uri artUri;
  final String artist;
  SongItem(
      {required this.index,
      required this.title,
      required this.artUri,
      required this.artist});
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        key: Key(index.toString()),
        duration: Duration(milliseconds: 299),
        color: audioHandler.getCurrentIndex() == index
            ? Colors.amber
            : Colors.transparent,
        child: ListTile(
          title: Text(title),
          leading: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Image.network(artUri.toString())),
          subtitle: Text(artist),
          onTap: () {
            audioHandler.skipToQueueItem(index);
          },
        ));
  }
}
