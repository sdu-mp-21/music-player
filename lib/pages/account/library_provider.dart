import 'package:getx_app/library/api_request.dart';
import 'package:getx_app/models/post.dart';

class LibraryProvider {
  final String data;
  LibraryProvider({required this.data});
  void getTrackInfo({
    Function()? beforeSend,
    Function(List<Post> posts)? onSuccess,
    Function(dynamic error)? onError,
  }) {
    ApiRequest(url: 'https://theaudiodb.p.rapidapi.com/searchtrack.php', data: {
      "s": data,
      "t": data,
    }).get(
      onSuccess: (data) {
        print(data);
      },
      onError: (error) => {if (onError != null) onError(error)},
    );
  }
}
