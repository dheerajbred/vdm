import 'package:http/io_client.dart';

class GoogleHttpClient extends IOClient {
  final Map<String, String> _headers;

  GoogleHttpClient(this._headers) : super();
}

class DownloadsArguments {
  final String videoUrl;
  final String thumbUrl;
  final String name;
  final String headers;
  final String isgrabbed;

  DownloadsArguments(
      this.videoUrl, this.thumbUrl, this.name, this.headers, this.isgrabbed);
}
