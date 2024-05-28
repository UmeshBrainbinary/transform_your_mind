import 'dart:developer';
import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:transform_your_mind/core/utils/extension_utils.dart';

class ImageUtils {
  static  compressImage(XFile? image) async {
    try {
      if (image != null) {
        String fileExt =
        (image.name.getFileExtension() ?? '.jpeg').toLowerCase();
        String fileName = '${DateTime.now().millisecondsSinceEpoch}$fileExt';
        final targetDir = await path_provider.getTemporaryDirectory();

        /// Target path where we store our temporary file.
        String targetPath = '${targetDir.absolute.path}$fileName';

        /// Here, we are checking file extension.
        switch (fileExt) {
          case '.jpg':
          case '.jpeg':
          case '.png':
          case '.heic':
          case '.webp':
            {
              return await FlutterImageCompress.compressAndGetFile(
                  image.path, targetPath,
                  quality: 85,
                  format: (fileExt == '.heic')
                      ? CompressFormat.heic
                      : (fileExt == '.webp')
                      ? CompressFormat.webp
                      : (fileExt == '.png')
                      ? CompressFormat.png
                      : CompressFormat.jpeg);
            }
          default:
            return File(image.path);
        }
      }
    } on Exception catch (e) {
      log('Failed to compress image: $e');
    }
    return null;
  }
}
