import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geotales/providers/file_provider.dart';
import 'package:geotales/providers/map_provider.dart';
import 'package:geotales/widgets/file_upload_dialog.dart';
import 'package:provider/provider.dart';

class MarkerDialog extends StatelessWidget {
  final BoxConstraints constraints;

  const MarkerDialog({Key? key, required this.constraints}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: Colors.transparent,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Consumer2<FileProvider, MapProvider>(
                builder: (context, files, map, child) {
              files.fetchImages(); // fetch the latest images

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '(${map.currentLocation.latitude}, ${map.currentLocation.longitude})',
                    style: const TextStyle(fontSize: 12, color: Colors.brown),
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.5,
                    child: ListView.separated(
                      itemCount: files.markerFiles.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final markerFile = files.markerFiles[index];
                        return ListTile(
                          title: Text(
                            markerFile.fileName,
                            style: TextStyle(
                              fontSize: 15,
                              color: theme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Posted by ${markerFile.userEmail}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.colorScheme.secondary,
                                ),
                              ),
                              Text(
                                "Date: ${markerFile.uploadTimestamp}",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(
                                  markerFile.url,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  child: InteractiveViewer(
                                    panEnabled: true,
                                    boundaryMargin: const EdgeInsets.all(8),
                                    minScale: 0.5,
                                    maxScale: 4,
                                    child: Image.network(
                                      markerFile.url,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const AlertDialog(
                              content: FileUploadDialog(),
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: theme.primaryColor,
                      ),
                      child: const Text("Upload File"),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
