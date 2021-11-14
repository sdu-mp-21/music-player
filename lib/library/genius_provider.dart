import 'package:get/get_connect.dart';
import 'package:getx_app/library/api_request.dart';

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
  Map<String, dynamic> getSchema(a, t, s, h) {
    return {
      "artistName": a,
      "thumbnailUrl": t,
      "songName": s,
      "headerImage": h
    };
  }

  Map<String, dynamic> fromJson(Map<String, dynamic> json) {
    return getSchema(json['artist_names'], json["header_image_thumbnail_url"],
        json["full_title"], json['header_image_url']);
  }

  Map<String, dynamic> fromNullData(String query) {
    List<String> song = query.split(" - ");
    return getSchema(
        song[0],
        "https://cbdworship.com/assets/images/album_art/placeholder.png",
        song[1],
        "https://cbdworship.com/assets/images/album_art/placeholder.png");
  }

  GeniusProvider(String query, Function cb) {
    ApiRequest(url: "https://api.genius.com/search/", data: {'q': query}).get(
        onSuccess: (r) {
      GeniusAPIResponse response = GeniusAPIResponse(r.data);
      if (response.hasResults()) {
        Map<String, dynamic> songData = response.data[0]["result"];
        cb(fromJson(songData));
      } else {
        cb(fromNullData(query));
      }
    }, onError: (d) {
      print(d);
    });
  }
}
