import 'package:audioplayers/audioplayers.dart';
import 'package:getx_app/library/api_request.dart';
import 'package:getx_app/models/song.dart';
import 'package:just_audio/just_audio.dart' as J;

typedef OnSuccessFunction = void Function(Song song);

class GeniusAPIResponse {
  List<dynamic> data = [];
  GeniusAPIResponse(data) {
    this.data = data["response"]["hits"];
  }

  hasResults() {
    return data.length != 0;
  }
}

class GeniusProvider {
  String query;
  String path;
  GeniusProvider({required this.query, required this.path});

  get({required OnSuccessFunction onSuccess}) async {
    ApiRequest(url: "https://api.genius.com/search/", data: {'q': query}).get(
        onSuccess: (r) async {
      GeniusAPIResponse response = GeniusAPIResponse(r.data);
      try {
        final duration = Duration(seconds: 1000);

        if (response.hasResults()) {
          Map<String, dynamic> songData = response.data[0]["result"];
          final song = Song.fromJson(songData);
          song.duration = duration;
          song.originalPath = path;

          onSuccess(song);
        } else {
          final song = Song.fromNull(query);
          song.duration = duration;
          song.originalPath = path;
          onSuccess(song);
        }
      } catch (e) {
        print(e);
      }
    }, onError: (d) {
      final duration = Duration(seconds: 1000);
      final song = Song.fromNull(query);
      song.duration = duration;
      song.originalPath = path;
      onSuccess(song);
    });
  }
}
