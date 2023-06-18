import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geotales/providers/file_upload_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime_type/mime_type.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class FileUploadDialog extends StatelessWidget {
  const FileUploadDialog({Key? key});

  String _getMimeType(String filePath) {
    String? mimeType = mime(filePath);
    return mimeType ?? 'application/octet-stream';
  }

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
                          isPrivate: fileUploadProvider.imageDataList[index]
                              ['isPrivate'],
                          onDismissed: () {
                            fileUploadProvider.removeImage(index);
                          },
                          onTogglePrivacy: (value) {
                            fileUploadProvider.updateImagePrivacy(
                              index,
                              value,
                            );
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
                            final mimeType = _getMimeType(pickedFile.path);
                            final imageData = {
                              'filename': pickedFile.name,
                              'data': bytes,
                              'url': pickedFile.path,
                              'path': pickedFile.path,
                              'mimeType': mimeType,
                              'isPrivate': false
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
                            final mimeType = _getMimeType(pickedFile.path);
                            final imageData = {
                              'filename': pickedFile.name,
                              'data': bytes,
                              'url': pickedFile.path,
                              'path': pickedFile.path,
                              'mimeType': mimeType,
                              'isPrivate': false
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

class DismissibleImage extends StatelessWidget {
  final String imageUrl;
  final String imagePath;
  final bool isPrivate;
  final VoidCallback onDismissed;
  final ValueChanged<bool> onTogglePrivacy;

  const DismissibleImage({
    Key? key,
    required this.imageUrl,
    required this.imagePath,
    required this.isPrivate,
    required this.onDismissed,
    required this.onTogglePrivacy,
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
          Positioned(
            top: 8,
            left: 8,
            child: Row(
              children: [
                Text('Private'),
                Switch(
                  value: isPrivate,
                  onChanged: onTogglePrivacy,
                ),
              ],
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
