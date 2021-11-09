class GeniusResponse {
  int? artistNames;
  int? headerImageThumbnailUrl;

  GeniusResponse(res) {
    print(res);
  }

  GeniusResponse.fromJson(Map<String, dynamic> json) {
    artistNames = json['artist_names'];
    headerImageThumbnailUrl = json['header_image_thumbnail_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['artist_names'] = this.artistNames;
    data['header_image_thumbnail_url'] = this.headerImageThumbnailUrl;

    return data;
  }
}
