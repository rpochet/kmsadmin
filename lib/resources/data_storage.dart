import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class DataStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<Map<String, dynamic>> readJson(name) async {
    try {
      final path = await _localPath;

      final file = File('$path/kmsadmin/$name');

      final contents = await file.readAsString();

      return json.decode(contents);
    } catch (e) {
      return Map.identity();
    }
  }
}
