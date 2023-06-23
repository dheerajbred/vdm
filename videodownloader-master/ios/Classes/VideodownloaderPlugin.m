#import "VideodownloaderPlugin.h"
#if __has_include(<videodownloader/videodownloader-Swift.h>)
#import <videodownloader/videodownloader-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "videodownloader-Swift.h"
#endif

@implementation VideodownloaderPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftVideodownloaderPlugin registerWithRegistrar:registrar];
}
@end
