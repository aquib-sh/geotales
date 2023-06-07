import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geotales/providers/file_provider.dart';
import 'package:geotales/providers/map_provider.dart';
import 'package:provider/provider.dart';

class MarkerDialog extends StatelessWidget {
  final BoxConstraints constraints;
  const MarkerDialog({super.key, required this.constraints});

  @override
  Widget build(BuildContext context) {
    return Consumer2<FileProvider, MapProvider>(
        builder: (context, files, map, child) => AlertDialog(
              title: const Text("Files in this location"),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '(${map.currentLocation.latitude}, ${map.currentLocation.longitude})',
                    style: const TextStyle(fontSize: 12, color: Colors.brown),
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.7,
                    width: constraints.maxWidth * 0.9,
                    child: ListView.builder(
                      itemCount: files.markerFiles.length,
                      itemBuilder: (context, index) {
                        return (files.markerFiles.isNotEmpty)
                            ? ListTile(
                                title: Text(files.markerFiles[index].fileName,
                                    style: const TextStyle(
                                        fontSize: 15, color: Colors.black)),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Posted by ${files.markerFiles[index].userEmail}",
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.blueGrey),
                                    ),
                                    Text(
                                        "Date: ${files.markerFiles[index].uploadTimestamp}",
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.blueGrey))
                                  ],
                                ),
                                leading: Image.memory(
                                  base64Decode(
                                      files.markerFiles[index].base64Image),
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : null;
                      },
                    ),
                  )
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    //showDialog(
                    //  context: context,
                    //  builder: (BuildContext context) {
                    //    return AlertDialog(
                    //      content: ImageUploaderDialog(
                    //        location: widget.coordinates,
                    //        userId: widget.userId,
                    //        userEmail: widget.userEmail,
                    //        onFileUpload: fetchImages, // Pass the callback
                    //      ),
                    //    );
                    //  },
                    //);
                  },
                  child: const Text("Upload File"),
                ),
              ],
            ));
  }
}
