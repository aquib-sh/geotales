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
      final List<dynamic> responseData = jsonDecode(response.body);
      markerFiles = responseData
          .map((item) => UserFile.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      print('Failed to fetch images');
    }
  }
}
