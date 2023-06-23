
class DownloadEpisodelist {
  String videoname;
  String videourl;
  String imageurl;
  String localurl;
  String downloadertype;
  String headers;
  bool isgrabbed;
  bool iscompleted;

  DownloadEpisodelist._({
    required this.videoname,
    required this.videourl,
    required this.imageurl,
    required this.localurl,
    required this.downloadertype,
    required this.headers,
    required this.isgrabbed,
    required this.iscompleted,
  });
  factory DownloadEpisodelist.fromJson(Map<String, dynamic> json) {
    return DownloadEpisodelist._(
      videoname: json['videoname'],
      videourl: json['videourl'],
      imageurl: json['imageurl'],
      localurl: json['localurl'],
      downloadertype: json['downloadertype'],
      headers: json['headers'],
      isgrabbed: json['isgrabbed'] == '1' ? true : false,
      iscompleted: false,
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['videoname'] = videoname;
    map['videourl'] = videourl;
    map['imageurl'] = imageurl;
    map['localurl'] = localurl;
    map['downloadertype'] = downloadertype;
    map['headers'] = headers;
    map['isgrabbed'] = isgrabbed;
    map['iscompleted'] = iscompleted;
    return map;
  }

  DownloadEpisodelist.fromDb(Map map)
      : videoname = map["videoname"],
        videourl = map["videourl"],
        imageurl = map["imageurl"],
        localurl = map["localurl"],
        downloadertype = map["downloadertype"],
        headers = map["headers"],
        isgrabbed = map['isgrabbed'] == 1 ? true : false,
        iscompleted = map['iscompleted'] == 1 ? true : false;
}

extension StringCasingExtension on String {
  ///capitalize string
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String removeClutter() => length > 0
      ? replaceAll("%20", " ").replaceAll("%E2%98%86", "☆").replaceAll("%E2%99%A1", "♡")
      : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
  String getTitleFromUrl(String? removeformatString) => length > 0
      ? toString().split("/").last.trim().replaceAll("mp4", '').replaceAll(removeformatString.toString(), '')
      : '';
  String removelastString(String? removeformatString) => length > 0
      ? (toString()[toString().length - 1].trim() ==
              removeformatString.toString()
          ? substring(0, toString().length - 1)
          : this)
      : '';
}
