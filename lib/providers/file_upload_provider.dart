import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:geotales/providers/map_provider.dart';
import 'package:geotales/providers/session_provider.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:uuid/uuid.dart';

class FileUploadProvider with ChangeNotifier {
  SessionProvider _session;
  MapProvider _map;

  final List<Map<String, dynamic>> _imageDataList = [];

  FileUploadProvider(this._session, this._map);

  List<Map<String, dynamic>> get imageDataList => _imageDataList;

  bool get canUpload => _imageDataList.isNotEmpty;

  void update({required SessionProvider session, required MapProvider map}) {
    _session = session;
    _map = map;
    notifyListeners();
  }

  void addImage(Map<String, dynamic> imageData) {
    _imageDataList.add(imageData);
    notifyListeners();
  }

  void removeImage(int index) {
    _imageDataList.removeAt(index);
    notifyListeners();
  }

  void updateImagePrivacy(int index, bool isPrivate) {
    _imageDataList[index]['isPrivate'] = isPrivate;
    notifyListeners();
  }

  Future<bool?> uploadImages() async {
    bool allUploaded = true;
    List<Map<String, dynamic>> imageDataListCopy = _imageDataList.toList();
    for (var imageData in imageDataListCopy) {
      // Perform the file upload logic using the provider data
      // ...
      final url = Uri.parse('http://localhost:3000/upload');
      final request = http.MultipartRequest('POST', url);

      // Add image file to the request
      final imageFile = http.MultipartFile.fromBytes(
        'image',
        imageData['data'],
        filename: imageData['filename'],
        contentType: MediaType('application', 'octet-stream'),
      );
      request.files.add(imageFile);

      // Add other data to the request
      request.fields['id'] = const Uuid().v4();
      request.fields['userId'] = _session.userId.toString();
      request.fields['userEmail'] = _session.email!;
      request.fields['fileName'] = imageData['filename'];
      request.fields['fileType'] = imageData['mimeType'];
      request.fields['latitude'] = _map.currentLocation.latitude.toString();
      request.fields['longitude'] = _map.currentLocation.longitude.toString();
      request.fields['uploadTimeStamp'] = DateTime.now().toIso8601String();
      request.fields['data'] = base64Encode(imageData['data']);
      request.fields['isPrivate'] = imageData['isPrivate'].toString();

      // Send the request
      final response = await request.send();
      if (response.statusCode != 200) {
        print(await response.stream.bytesToString());
        allUploaded = false;
      }

      // Remove the uploaded image from the list
      _imageDataList.remove(imageData);
      notifyListeners();
    }
    return allUploaded;
  }
}
