import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geotales/models/user_file.dart';

class FileProvider extends ChangeNotifier {
  List<UserFile> markerFiles = [];

  Future<void> fetchImages() async {
    final url = Uri.parse('http://localhost:3000/images');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      markerFiles = List<UserFile>.from(
        data.map((item) => UserFile.fromJson(item)),
      );
    } else {
      print('Failed to fetch images');
    }
  }
}
