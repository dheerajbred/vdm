package com.lekapin.videodownloader;

import android.os.Environment;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;


//import com.jeffmony.downloader.DownloadConstants;
import com.jeffmony.downloader.common.DownloadConstants;

import com.jeffmony.downloader.VideoDownloadConfig;
import com.jeffmony.downloader.VideoDownloadManager;
import com.jeffmony.downloader.listener.DownloadListener;
import com.jeffmony.downloader.m3u8.M3U8;
import com.jeffmony.downloader.m3u8.*;
//import com.jeffmony.downloader.m3u8.M3U8Ts;
import com.jeffmony.downloader.model.VideoTaskItem;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** VideodownloaderPlugin */
public class VideodownloaderPlugin implements FlutterPlugin, MethodCallHandler {

  private static String TAG = "VideoDownloaderPlugin";

  private MethodChannel channel;
  private FlutterPluginBinding pluginBinding;
  private static boolean inited = false;
  private DownloadListener downloadListener = new DownloadListener() {
    @Override
    public void onDownloadDefault(VideoTaskItem item) {
      UpdateItem("default", item);
    }

    @Override
    public void onDownloadPending(VideoTaskItem item) {
      UpdateItem( "pending", item);
    }

    @Override
    public void onDownloadPrepare(VideoTaskItem item) {
      UpdateItem( "prepare", item);
    }

    @Override
    public void onDownloadStart(VideoTaskItem item) {
      UpdateItem( "start", item);
    }

    @Override
    public void onDownloadProgress(VideoTaskItem item) {
      UpdateItem( "progress", item);
    }

    @Override
    public void onDownloadSpeed(VideoTaskItem item) {
      UpdateItem( "speed", item);
    }

    @Override
    public void onDownloadPause(VideoTaskItem item) {
      UpdateItem( "pause", item);
    }

    @Override
    public void onDownloadError(VideoTaskItem item) {
      UpdateItem( "error", item);
    }

    @Override
    public void onDownloadSuccess(VideoTaskItem item) {
      UpdateItem( "success", item);
    }
  };

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    if(inited) return;
    inited = true;
    pluginBinding = flutterPluginBinding;
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "videodownloader");
    channel.setMethodCallHandler(this);
    VideoDownloadManager.getInstance().setGlobalDownloadListener(downloadListener);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("init")) {
      Log.d(TAG, call.arguments.toString());

//      File file = VideoStorageUtils.getVideoCacheDir(pluginBinding.getApplicationContext());
      File file = new File(Environment.getExternalStorageDirectory(), "dheer_tmp_omg");
      System.out.println("**********file begin: " + file.getAbsolutePath());


      String cacheDirectoryPath = (String)call.argument("cacheDirectoryPath");
      Integer readTimeout = (Integer)call.argument("readTimeout");
      Integer connTimeout = (Integer)call.argument("connTimeout");
      Boolean redirect = (Boolean)call.argument("redirect");
      Boolean ignoreAllCertErrors = (Boolean)call.argument("ignoreAllCertErrors");
      Integer concurrentCount = (Integer)call.argument("concurrentCount");
      if(cacheDirectoryPath != null) file = new File(cacheDirectoryPath);
      file.mkdir();
      VideoDownloadConfig config = new VideoDownloadManager.Build(pluginBinding.getApplicationContext())
              .setCacheRoot(file.getAbsolutePath())
//              .setUrlRedirect(redirect == null ? true: redirect)
              .setTimeOut(readTimeout == null ? DownloadConstants.READ_TIMEOUT : readTimeout,
                      connTimeout == null ? DownloadConstants.CONN_TIMEOUT : connTimeout)
              .setConcurrentCount(concurrentCount == null ? DownloadConstants.CONCURRENT : concurrentCount)
              .setIgnoreCertErrors(ignoreAllCertErrors == null ? true : false)
              .buildConfig();
      VideoDownloadManager.getInstance().initConfig(config);
      Log.d(TAG, "Folder cache location " + file.getAbsolutePath());
      result.success(true);
    } else if(call.method.equals("startDownload")) {
      final String url = (String) call.arguments;
      Log.d(TAG, "downloading " + url);
      final VideoTaskItem item = new VideoTaskItem(url);

      File savdir = new File(Environment.getExternalStorageDirectory(), "saveName");
      item.setSaveDir(savdir.getAbsolutePath());
      System.out.println("*************UpdateItem setSaveDir: " + savdir.getAbsolutePath() + "\n"
              + "a:  " + Environment.getExternalStorageDirectory().getAbsolutePath() + "\n"
              + "b:  " + Environment.getDataDirectory().getAbsolutePath() + "\n"
              + "c:  " + Environment.getDownloadCacheDirectory().getAbsolutePath() + "\n"
              + "d:  " + Environment.getRootDirectory().getAbsolutePath() + "\n"
      );

      VideoDownloadManager.getInstance().startDownload(item);
      result.success(true);
    } else if(call.method.equals("startDownloadWithHeader")) {
        final String url = (String)call.argument("url");
        final Map obj = call.argument("headers");
        final HashMap<String, String> headers = new HashMap<>();
        Iterator it = obj.entrySet().iterator();
        while (it.hasNext()) {
          Map.Entry pair = (Map.Entry)it.next();
          headers.put((String)pair.getKey(), (String)pair.getValue());
        }
        Log.d(TAG, "downloading " + url);
        Log.d(TAG, "headers " + headers.toString());
        final VideoTaskItem item = new VideoTaskItem(url);
        VideoDownloadManager.getInstance().startDownload(item, headers);
        result.success(true);
    } else if(call.method.equals("pause")) {
      final String url = (String)call.arguments;
      Log.d(TAG, "pause " + url);
      VideoDownloadManager.getInstance().pauseDownloadTask(url);
      result.success(true);
    } else if(call.method.equals("pauseAll")) {
      Log.d(TAG, "pause all");
      VideoDownloadManager.getInstance().pauseAllDownloadTasks();
      result.success(true);
    } else if(call.method.equals("resume")) {
      final String url = (String) call.arguments;
      Log.d(TAG, "resume " + url);
      VideoDownloadManager.getInstance().resumeDownload(url);
      result.success(true);
    } else if(call.method.equals("delete")) {
      final String url = (String)call.argument("url");
      final Boolean deleteSourceFile = (Boolean)call.argument("deleteSourceFile");
      Log.d(TAG, "delete " + url);
      VideoDownloadManager.getInstance().deleteVideoTask(url, deleteSourceFile);
      result.success(true);
    } else {
      result.notImplemented();
    }
  }

  void UpdateItem(String type, VideoTaskItem item) {
    final Map<String, Object> args = new HashMap();
    Map<String, Object> itemJson = new HashMap();
    args.put("type", type);
    args.put("url", item.getUrl());
    itemJson.put("url", item.getUrl());
    itemJson.put("downloadCreateTime", item.getDownloadCreateTime());
    itemJson.put("taskState", item.getTaskState());
    itemJson.put("mimeType", item.getMimeType());
    itemJson.put("finalUrl", item.getFinalUrl());
    itemJson.put("errorCode", item.getErrorCode());
    itemJson.put("videoType", item.getVideoType());
    itemJson.put("totalTs", item.getTotalTs());
    itemJson.put("curTs", item.getCurTs());
    itemJson.put("speed", item.getSpeed());
    itemJson.put("percent", item.getPercent());
    itemJson.put("downloadSize", item.getDownloadSize());
    itemJson.put("totalSize", item.getTotalSize());
    itemJson.put("fileHash", item.getFileHash());
    itemJson.put("saveDir", item.getSaveDir());
    itemJson.put("isCompleted", item.isCompleted());
    itemJson.put("isInDatabase", item.isInDatabase());
    itemJson.put("lastUpdateTime", item.getLastUpdateTime());
    itemJson.put("fileName", item.getFileName());
    itemJson.put("filePath", item.getFilePath());
    itemJson.put("paused", item.isPaused());

    System.out.println("**********UpdateItem getSaveDir: " + item.getSaveDir());

    File savdir = new File(Environment.getExternalStorageDirectory(), "saveName");
//    item.setSaveDir(savdir.getAbsolutePath());
    System.out.println("*************UpdateItem setSaveDir: " + savdir.getAbsolutePath() + "\n"
            + "a:  " + Environment.getExternalStorageDirectory().getAbsolutePath() + "\n"
            + "b:  " + Environment.getDataDirectory().getAbsolutePath() + "\n"
            + "c:  " + Environment.getDownloadCacheDirectory().getAbsolutePath() + "\n"
            + "d:  " + Environment.getRootDirectory().getAbsolutePath() + "\n"
    );

    final M3U8 m3 = item.getM3U8();
    if(m3 != null) {
      Map<String, Object> m3u8 = new HashMap();

      m3u8.put("url", item.getUrl());
      m3u8.put("targetDuration", m3.getTargetDuration());
      m3u8.put("sequence", m3.getInitSequence());
      m3u8.put("version", m3.getVersion());
      m3u8.put("hasEndList", m3.hasEndList());
      m3u8.put("curTsIndex", 0);

      final List<Map<String, Object>> m3u8ts = new ArrayList();
      final List<M3U8Seg> m3list = m3.getTsList();
      for (int i = 0; i < m3list.size(); i++) {
        final M3U8Seg mm = m3list.get(i);
        Map<String, Object> mm2 = new HashMap();
        mm2.put("duration", mm.getDuration());
        mm2.put("index", i);
        mm2.put("url", mm.getUrl());
        mm2.put("name", mm.getName());
        mm2.put("tsSize", mm.getTsSize());
        mm2.put("hasDiscontinuity", mm.hasDiscontinuity());
        mm2.put("hasKey", mm.hasKey());
        mm2.put("method", mm.getMethod());
        mm2.put("keyUri", mm.getKeyUri());
        mm2.put("keyIV", mm.getKeyIV());
        mm2.put("isMessy", mm.isMessyKey());
        m3u8ts.add(mm2);
      }
      m3u8.put("tsList", m3u8ts);

      itemJson.put("m3u8", m3u8);
    }

    args.put("item", itemJson);
    new Handler(Looper.getMainLooper()).post(new Runnable() {
      @Override
      public void run() {
        channel.invokeMethod("updateItem", args);
      }
    });

  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
    pluginBinding = null;
  }
}
