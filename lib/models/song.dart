class Song {
  String? thumnailUrl;
  String? title;
  String? artist;
  String? originalPath;
  String? headerImage;
  Duration? duration;

  Song(
      {required this.thumnailUrl,
      required this.title,
      required this.artist,
      required this.duration,
      required this.originalPath,
      required this.headerImage});

  Song.fromJson(Map<String, dynamic> json) {
    thumnailUrl = json["header_image_thumbnail_url"];
    title = json["full_title"];
    artist = json["artist_names"];
    headerImage = json["header_image_url"];
    if (json["original_path"] != null && json["duration"] != null) {
      duration = Duration(seconds: json["duration"]);
      originalPath = json["original_path"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data["header_image_thumbnail_url"] = thumnailUrl;
    data["full_title"] = title;
    data["artist_names"] = artist;
    data["header_image_url"] = headerImage;
    data["duration"] = duration!.inSeconds;
    data["original_path"] = originalPath;

    return data;
  }

  Song.fromNull(String query) {
    final splitted = query.split("-");
    if (splitted.length == 1) {
      title = splitted[0];
      artist = splitted[0];
    } else {
      title = splitted[0];
      artist = splitted[1];
    }

    thumnailUrl =
        "https://cbdworship.com/assets/images/album_art/placeholder.png";

    headerImage =
        "https://cbdworship.com/assets/images/album_art/placeholder.png";
  }
}
