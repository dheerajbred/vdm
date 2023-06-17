import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:videodownloader/videotaskitem.dart';
export 'package:videodownloader/videotaskitem.dart';

class VideoDownloader {
  static VideoDownloader _instance = VideoDownloader._internal();
  static const MethodChannel _channel = const MethodChannel('videodownloader');
  static bool _inited = false;
  List<VideoTaskItem?> items = [];

  VideoDownloader._internal() {
    _channel.setMethodCallHandler(_channelHandler);
  }

  Future<dynamic> _channelHandler(MethodCall methodCall) async {
    if (methodCall.method == "updateItem") {
      final type = methodCall.arguments["type"] as String;
      final url = methodCall.arguments["url"] as String;
      final it = Map<String, dynamic>.from(methodCall.arguments["item"]);
      final item = _instance.items.firstWhere(
        (element) => element?.url == url,
        orElse: () => null,
      );
      try {
        if (item != null) item.updateItem(type, it);
      } catch (e) {
        print(e);
      }
    }
    return Future.value(null);
  }

  static Future<dynamic> init({VideoDownloadConfig? config}) {
    _inited = true;
    return _channel.invokeMethod('init',  config!.toJSON());
  }

  static Future<dynamic> startDownload(VideoTaskItem item) {
    if (!_inited) throw 'call init first';
    if (_instance.containUrl(item.url)) {
      throw 'url exist';
    }
    _instance.items.add(item);
    return _channel.invokeMethod('startDownload', item.url);
  }

  static Future<dynamic> startDownloadWithHeader(VideoTaskItem item,
      {required Map<String, String> headers}) {
    if (!_inited) throw 'call init first';
    if (_instance.containUrl(item.url)) {
      throw 'url exist';
    }
    _instance.items.add(item);
    return _channel.invokeMethod(
        'startDownloadWithHeader', {'url': item.url, 'headers': headers});
  }

  static Future<dynamic> pause(VideoTaskItem item) {
    if (!_inited) throw 'call init first';
    return _channel.invokeMethod("pause", item.url);
  }

  static Future<dynamic> pauseAll(VideoTaskItem item) {
    if (!_inited) throw 'call init first';
    return _channel.invokeMethod("pauseAll");
  }

  static Future<dynamic> resume(VideoTaskItem item) {
    if (!_inited) throw 'call init first';
    return _channel.invokeMethod("resume", item.url);
  }

  static Future<dynamic> delete(VideoTaskItem item,
      { required bool deleteSourceFile}) {
    if (!_inited) throw 'call init first';
    _instance.items =
        _instance.items.where((element) => element?.url != item.url).toList();
    return _channel.invokeMethod(
        "delete", {"url": item.url, "deleteSourceFile": deleteSourceFile});
  }

  static VideoTaskItem? generateItem(String url) {
    return _instance.items.firstWhere(
      (e) => e?.url == url,
      orElse: () => VideoTaskItem(url: url),
    );
  }

  containUrl(String url) {
    int index = items.indexWhere((element) => element?.url == url);
    return index >= 0;
  }
}

class VideoDownloadConfig {
  String? cacheDirectoryPath;
  int? readTimeout;
  int? connTimeout;
  bool? redirect;
  bool? ignoreAllCertErrors;
  int? concurrentCount;
  VideoDownloadConfig({
    this.cacheDirectoryPath,
    this.readTimeout,
    this.connTimeout,
    this.redirect,
    this.ignoreAllCertErrors,
    this.concurrentCount,
  });
  Map<String, dynamic> toJSON() {
    return {
      'cacheDirectoryPath': cacheDirectoryPath,
      'readTimeout': readTimeout,
      'connTimeout': connTimeout,
      'redirect': redirect,
      'ignoreAllCertErrors': ignoreAllCertErrors,
      'concurrentCount': concurrentCount,
    };
  }
}
