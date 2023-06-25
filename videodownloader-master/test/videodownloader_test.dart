import 'package:flutter/services.dart' as ser;
import 'package:flutter_test/flutter_test.dart';

void main() {
  const ser.MethodChannel channel = ser.MethodChannel('videodownloader');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMethodCallHandler((ser.MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    //expect(await Videodownloader.platformVersion, '42');
  });
}
