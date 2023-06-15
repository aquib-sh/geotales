import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geotales/providers/file_upload_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class FileUploadDialog extends StatelessWidget {
  const FileUploadDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FileUploadProvider>(
      builder: (context, fileUploadProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'File Upload Dialog',
          home: Scaffold(
            body: Center(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: fileUploadProvider.imageDataList.length,
                      itemBuilder: (context, index) {
                        return DismissibleImage(
                          imageUrl: fileUploadProvider.imageDataList[index]
                              ['url'],
                          imagePath: fileUploadProvider.imageDataList[index]
                              ['path'],
                          onDismissed: () {
                            fileUploadProvider.removeImage(index);
                          },
                        );
                      },
                    ),
                  ),
                  Row(
                    children: [
                      SelectButton(
                        onPressed: () async {
                          final pickedFile = await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 80,
                          );
                          if (pickedFile != null) {
                            final bytes = await pickedFile.readAsBytes();
                            final imageData = {
                              'filename': pickedFile.name,
                              'data': bytes,
                              'url': pickedFile.path,
                              'path': pickedFile.path,
                              'mimeType': pickedFile.mimeType
                            };
                            fileUploadProvider.addImage(imageData);
                          }
                        },
                      ),
                      const Spacer(),
                      SelectButton(
                        onPressed: () async {
                          final pickedFile = await ImagePicker().pickImage(
                            source: ImageSource.camera,
                            imageQuality: 80,
                          );
                          if (pickedFile != null) {
                            final bytes = await pickedFile.readAsBytes();
                            final imageData = {
                              'filename': pickedFile.name,
                              'data': bytes,
                              'url': pickedFile.path,
                              'path': pickedFile.path,
                              'mimeType': pickedFile.mimeType
                            };
                            fileUploadProvider.addImage(imageData);
                          }
                        },
                        buttonText: 'Capture',
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: fileUploadProvider.canUpload
                            ? fileUploadProvider.uploadImages
                            : null,
                        child: const Text('Upload'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// class FileUploadProvider with ChangeNotifier {
//   final List<Map<String, dynamic>> _imageDataList = [];

//   List<Map<String, dynamic>> get imageDataList => _imageDataList;

//   bool get canUpload => _imageDataList.isNotEmpty;

//   void addImage(Map<String, dynamic> imageData) {
//     _imageDataList.add(imageData);
//     notifyListeners();
//   }

//   void removeImage(int index) {
//     _imageDataList.removeAt(index);
//     notifyListeners();
//   }

//   void uploadImages() async {
//     for (var imageData in _imageDataList) {
//       // Perform the file upload logic using the provider data

//       // Required fields
//       final request = http.MultipartRequest(
//           "POST", Uri.parse("http://localhost:3000/upload"));
//       request.fields['id'] = const Uuid().v4();
//       // TODO: Add userID from session provider
//       request.fields['userId'] = ;
//       request.fields['userEmail'] = imageData['userEmail'];
//       request.fields['fileName'] = imageData['fileName'];
//       request.fields['fileType'] = imageData['fileType'];
//       request.fields['latitude'] = imageData['latitude'];
//       request.fields['longitude'] = imageData['longitude'];
//       request.fields['uploadTimestamp'] = imageData['uploadTimestamp'];

//       // Send the request
//       final response = await request.send();

//       // Check the response status
//       if (response.statusCode == 200) {
//         // Successful upload
//         print('Image uploaded successfully');
//       } else {
//         // Failed upload
//         print('Image upload failed with status code: ${response.statusCode}');
//       }

//       // Remove the uploaded image from the list
//       _imageDataList.remove(imageData);
//       notifyListeners();
//     }
//   }
// }

class DismissibleImage extends StatelessWidget {
  final String imageUrl;
  final String imagePath;
  final VoidCallback onDismissed;

  const DismissibleImage({
    Key? key,
    required this.imageUrl,
    required this.imagePath,
    required this.onDismissed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (kIsWeb) {
      imageWidget = Image.network(imageUrl);
    } else {
      imageWidget = Image.file(File(imagePath));
    }

    return Dismissible(
      key: Key(kIsWeb ? imageUrl : imagePath),
      direction: DismissDirection.up,
      onDismissed: (_) => onDismissed(),
      child: Stack(
        children: [
          imageWidget,
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.cancel),
              color: Colors.red,
              onPressed: () => onDismissed(),
            ),
          ),
        ],
      ),
    );
  }
}

class SelectButton extends StatelessWidget {
  final void Function()? onPressed;
  final String buttonText;

  const SelectButton({
    Key? key,
    this.onPressed,
    this.buttonText = 'Select',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(buttonText),
    );
  }
}
