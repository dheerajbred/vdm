import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

// In any callback call the below method
Future<String?> openFolderPicker() async {
  final result = await FilePicker.platform.getDirectoryPath();
  if (result != null) {
    return result;
  }
  return null;
}
