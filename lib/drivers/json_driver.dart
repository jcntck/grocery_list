import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class JsonDriver {
  static Future<File> _getFile(String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/data/$filename.json');
    if (!file.existsSync()) await file.create();
    return file;
  }

  static Future<dynamic> saveData(String filename, dynamic data) async {
    String jsonData = json.encode(data);
    final file = await _getFile(filename);
    final result = await file.writeAsString(jsonData);
    return json.decode(await result.readAsString());
  }

  static Future<List?> readData(String filename) async {
    try {
      final file = await _getFile(filename);
      final results = await file.readAsString();
      final List list = json.decode(results);
      return list;
    } catch (e) {
      return null;
    }
  }
}
