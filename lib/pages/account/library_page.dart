import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_app/components/loading_overlay.dart';
import 'package:getx_app/audio_service/media_state.dart';
import 'package:getx_app/globals/settings.dart';

import 'library_controller.dart';

class LibraryPage extends GetView<LibraryController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LibraryController>(builder: (controller) {
      return Scaffold(
          body: LoadingOverlay(
              isLoading: controller.loading(),
              key: Key("23"),
              child: ListView.builder(
                  itemCount: controller.getLength(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () {
                        controller.setPlaying(index);
                      },
                      leading: Image.network(
                          controller.getItem(index)["thumbnailUrl"]),
                      title: Text(
                        controller.getItem(index)["songName"],
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        controller.getItem(index)["artistName"],
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  })));
    });
  }
}
/**
 *         Container(
                          height: 240.0,
                          child: StreamBuilder<QueueState>(
                            stream: audioHandler.queueState,
                            builder: (context, snapshot) {
                              final queueState =
                                  snapshot.data ?? QueueState.empty;
                              final queue = queueState.queue;
                              return ReorderableListView(
                                onReorder: (int oldIndex, int newIndex) {
                                  if (oldIndex < newIndex) newIndex--;
                                  audioHandler.moveQueueItem(
                                      oldIndex, newIndex);
                                },
                                children: [
                                  for (var i = 0; i < queue.length; i++)
                                    Dismissible(
                                      key: ValueKey(queue[i].id),
                                      background: Container(
                                        color: Colors.redAccent,
                                        alignment: Alignment.centerRight,
                                        child: const Padding(
                                          padding: EdgeInsets.only(right: 8.0),
                                          child: Icon(Icons.delete,
                                              color: Colors.white),
                                        ),
                                      ),
                                      onDismissed: (dismissDirection) {
                                        audioHandler.removeQueueItemAt(i);
                                      },
                                      child: Material(
                                        color: i == queueState.queueIndex
                                            ? Colors.grey.shade300
                                            : null,
                                        child: ListTile(
                                          title: Text(queue[i].title),
                                          onTap: () =>
                                              audioHandler.skipToQueueItem(i),
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                        ),
 */