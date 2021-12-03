import 'package:flutter/material.dart';
import 'package:getx_app/audio_service/media_state.dart';
import 'package:getx_app/globals/cached_music.dart';

class SongItem extends StatelessWidget {
  final int index;
  final String title;
  final Uri artUri;
  final String artist;
  final onTap;
  SongItem(
      {required this.onTap,
      required this.index,
      required this.title,
      required this.artUri,
      required this.artist});
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        key: Key(index.toString()),
        duration: Duration(milliseconds: 299),
        margin: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
            color: audioHandler.getCurrentIndex() == index
                ? Colors.amber.shade900
                : Colors.transparent,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: ListTile(
          dense: true,
          title: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          leading: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: FadeInImage.assetNetwork(
                placeholder: 'assets/placeholder.png',
                height: 40,
                width: 40,
                image: artUri.toString()),
          ),
          subtitle: Text(
            artist,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: onTap,
        ));
  }
}
