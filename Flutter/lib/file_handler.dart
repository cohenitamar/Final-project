import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';

class Utility {
  /// Converts a file at [filePath] into a Base64-encoded string
  static Future<String> fileToBase64(String filePath) async {
    File file = File(filePath);
    List<int> fileBytes = await file.readAsBytes();
    return base64Encode(fileBytes);
  }

  /// Converts a Base64-encoded string [base64String] back into a Uint8List
  /// which can be used by Image.memory or other widgets.
  static Uint8List base64ToBytes(String base64String) {
    return base64Decode(base64String);
  }

  /// Optionally, if you need to convert the base64 back into a file on disk:
  static Future<File> base64ToFile(String base64String, String fileName) async {
    Uint8List bytes = base64.decode(base64String);
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(bytes);
    return file;
  }

  static bool isBase64String(String data) {
    // A more robust approach would be try/catch on `base64.decode(data)`.
    // For simplicity, we just check if decode doesn't throw an error.
    try {
      base64.decode(data);
      return true;
    } catch (e) {
      return false;
    }
  }
  static ImageProvider getImageProvider(String imageData) {
    if (imageData.startsWith('http://') || imageData.startsWith('https://')) {
      // It's a URL
      return NetworkImage(imageData);
    } else if (isBase64String(imageData)) {
      // It's a base64-encoded image
      Uint8List imageBytes = base64ToBytes(imageData);
      return MemoryImage(imageBytes);
    } else {
      // It's likely a file path
      return FileImage(File(imageData));
    }
  }

}
