import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:videodownloader/m3u8t.dart';

class VideoTaskState {
  static const int DEFAULT = 0;
  static const int PENDING = -1;
  static const int PREPARE = 1;
  static const int START = 2;
  static const int DOWNLOADING = 3;
  static const int PROXYREADY = 4;
  static const int SUCCESS = 5;
  static const int ERROR = 6;
  static const int PAUSE = 7;
  static const int ENOSPC = 8;
}

class VideoTaskItem {
  String url;
  int? downloadCreateTime;
  int? taskState;
  String? mimeType;
  String? finalUrl;
  int? errorCode;
  int? videoType;
  M3U8? m3u8;
  int? totalTs;
  int? curTs;
  double? speed;
  double? percent;
  int? downloadSize;
  int? totalSize;
  String? fileHash;
  String? saveDir;
  bool? isCompleted;
  bool? isInDatabase;
  int? lastUpdateTime;
  String? fileName;
  String? filePath;
  bool? paused;

  VoidCallback? onDownloadDefault;
  VoidCallback? onDownloadPending;
  VoidCallback? onDownloadPrepare;
  VoidCallback? onDownloadStart;
  VoidCallback? onDownloadProgress;
  VoidCallback? onDownloadSpeed;
  VoidCallback? onDownloadPause;
  VoidCallback? onDownloadError;
  VoidCallback? onDownloadSuccess;

  VideoTaskItem({
    required this.url,
    this.downloadCreateTime,
    this.taskState = VideoTaskState.DEFAULT,
    this.mimeType,
    this.finalUrl,
    this.errorCode,
    this.videoType,
    this.m3u8,
    this.totalTs,
    this.curTs,
    this.speed,
    this.percent,
    this.downloadSize,
    this.totalSize,
    this.fileHash,
    this.saveDir,
    this.isCompleted,
    this.isInDatabase,
    this.lastUpdateTime,
    this.fileName,
    this.filePath,
    this.paused,
    this.onDownloadDefault,
    this.onDownloadPending,
    this.onDownloadPrepare,
    this.onDownloadStart,
    this.onDownloadSpeed,
    this.onDownloadPause,
    this.onDownloadProgress,
    this.onDownloadSuccess,
    this.onDownloadError,
  });

  Map<String, dynamic> toJson() {
    return {
      'url': url,
    };
  }

  readFromJson(Map<String, dynamic> json) {
    url = json['url'];
    downloadCreateTime = json['downloadCreateTime'];
    taskState = json['taskState'];
    mimeType = json['mimeType'];
    finalUrl = json['finalUrl'];
    errorCode = json['errorCode'];
    videoType = json['videoType'];
    m3u8 = m3u8 == null
        ? json['m3u8'] == null
            ? null
            : (M3U8()..fromJson(Map<String, dynamic>.from(json['m3u8'])))
        : m3u8?.fromJson(Map<String, dynamic>.from(json['m3u8']));
    totalTs = json['totalTs'];
    curTs = json['curTs'];
    speed = json['speed'];
    percent = json['percent'];
    downloadSize = json['downloadSize'];
    totalSize = json['totalSize'];
    fileHash = json['fileHash'];
    saveDir = json['saveDir'];
    isCompleted = json['isCompleted'];
    isInDatabase = json['isInDatabase'];
    lastUpdateTime = json['lastUpdateTime'];
    fileName = json['fileName'];
    filePath = json['filePath'];
    paused = json['paused'];
  }

  updateItem(String type, Map<String, dynamic> json) {
    readFromJson(json);
    if (type == "default") {
      onDownloadDefault?.call();
    } else if (type == "pending") {
      onDownloadPending?.call();
    } else if (type == "prepare") {
      onDownloadPrepare?.call();
    } else if (type == "start") {
      onDownloadStart?.call();
    } else if (type == "progress") {
      onDownloadProgress?.call();
    } else if (type == "speed") {
      onDownloadSpeed?.call();
    } else if (type == "error") {
      onDownloadError?.call();
    } else if (type == "pause") {
      onDownloadPause?.call();
    } else if (type == "success") {
      onDownloadSuccess?.call();
    }
  }

  String _getSize(double size) {
    const giga = 1024 * 1024 * 1024;
    const mega = 1024 * 1024;
    const kilo = 1024;
    final f = NumberFormat('###.00#');
    if (size >= giga) {
      double i = (size / giga);
      return '${f.format(i)} GB';
    } else if (size >= mega) {
      double i = (size / mega);
      return '${f.format(i)} MB';
    } else if (size >= kilo) {
      double i = (size / kilo);
      return '${f.format(i)} KB';
    }
    return '${f.format(size)} B';
  }

  String _getPercent(double percent) {
    final f = NumberFormat('###.00#');
    return '${f.format(percent)}%';
  }

  String speedString() {
    return '${_getSize(speed ?? 0)}/s';
  }

  String percentString() {
    return _getPercent(percent ?? 0);
  }

  String downloadSizeString() {
    return _getSize((downloadSize ?? 0).toDouble());
  }

  String totalSizeString() {
    return _getSize((totalSize ?? 0).toDouble());
  }

  //////////////dheer speedDouble
  double? speedDouble() {
    return speed;
  }

  String taskStateString() {
    switch (taskState) {
      case VideoTaskState.DEFAULT:
        return 'default';
      case VideoTaskState.PREPARE:
        return 'prepare';
      case VideoTaskState.PENDING:
        return 'pending';
      case VideoTaskState.DOWNLOADING:
        return 'downloading';
      case VideoTaskState.START:
        return 'start';
      case VideoTaskState.SUCCESS:
        return 'success';
      case VideoTaskState.ERROR:
        return 'error';
      case VideoTaskState.ENOSPC:
        return 'enospc';
      case VideoTaskState.PAUSE:
        return 'pause';
      case VideoTaskState.PROXYREADY:
        return 'proxyready';
    }
    return 'default';
  }

  String? pause() {
    return null;
  }

  resume() {}
}
