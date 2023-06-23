class M3U8Ts {
  double? duration;
  int? index;
  String? url;
  String? name;
  int? tsSize;
  bool? hasDiscontinuity;
  bool? hasKey;
  String? method;
  String? keyUri;
  String? keyIV;
  bool? isMessyKey;

  M3U8Ts({
    this.duration,
    this.index,
    this.url,
    this.name,
    this.tsSize,
    this.hasDiscontinuity,
    this.hasKey,
    this.method,
    this.keyUri,
    this.keyIV,
    this.isMessyKey,
  });

  static M3U8Ts fromJson(Map<String, dynamic> json) {
    final ret = M3U8Ts();
    ret.readJson(json);
    return ret;
  }

  readJson(Map<String, dynamic> json) {
    duration = json['duration'];
    index = json['index'];
    url = json['url'];
    name = json['name'];
    tsSize = json['tsSize'];
    hasDiscontinuity = json['hasDiscontinuity'];
    hasKey = json['hasKey'];
    method = json['method'];
    keyUri = json['keyUri'];
    keyIV = json['keyIV'];
    isMessyKey = json['isMessy'];
  }
}

class M3U8 {
  String? url;
  String? baseUrl;
  String? hostUrl;
  List<M3U8Ts>? tsList;
  double? targetDuration;
  int? sequence;
  int? version;
  bool? hasEndList;
  int? curTsIndex;
  M3U8({
    this.url,
    this.baseUrl,
    this.hostUrl,
    this.tsList,
    this.targetDuration,
    this.sequence,
    this.version,
    this.hasEndList,
    this.curTsIndex,
  });

  int getDuration() {
    int duration = 0;
    tsList?.forEach((element) {
      duration += element.duration!.toInt();
    });
    return duration;
  }

  fromJson(Map<String, dynamic> json) {
    url = json['url'];
    baseUrl = json['baseUrl'];
    hostUrl = json['hostUrl'];
    tsList = json['tsList'] == null
        ? null
        : List.from(json['tsList'])
            .map((e) => M3U8Ts.fromJson(Map<String, dynamic>.from(e)))
            .toList();
    targetDuration = json['targetDuration'];
    sequence = json['sequence'];
    version = json['version'];
    hasEndList = json['hasEndList'];
    curTsIndex = json['curTsIndex'];
  }
}
