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
      return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
              appBar: AppBar(
                  title: Container(
                      height: 40,
                      child: TextField(
                          onChanged: (value) {
                            if (value != null) controller.searchQuery = value;

                            controller.update();
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide: BorderSide(color: Colors.grey)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.amber),
                              ),
                              hintText: 'Search',
                              hintStyle: TextStyle(
                                fontSize: 18,
                                height: 2.6,
                                fontStyle: FontStyle.italic,
                              ))))),
              body: LoadingOverlay(
                  isLoading: controller.loading(),
                  key: Key("23"),
                  child: ListView.builder(
                      itemCount: controller.getLength(),
                      itemBuilder: (context, index) {
                        final item = controller.getItem(index);
                        if (item == null) return Container();

                        return ListTile(
                          onTap: () {
                            controller.setPlaying(index);
                          },
                          leading: Image.network(item["thumbnailUrl"]),
                          title: Text(
                            item["songName"],
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            item["artistName"],
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }))));
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