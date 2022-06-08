import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:twake/services/service_bundle.dart';

class PersistedNetworkImageService {
  static final PersistedNetworkImageService _instance =
      PersistedNetworkImageService._internal();

  factory PersistedNetworkImageService() {
    return _instance;
  }

  PersistedNetworkImageService._internal();

  Future<File?> getImageFile(url) async {
    final imageName = path.basename(url);
    final appDir = await path_provider.getApplicationDocumentsDirectory();
    final localPath = path.join(appDir.path, imageName);

    final isFileExists = await File(localPath).exists();

    if (isFileExists) {
      return File(localPath);
    }

    try {
      final response = await http.get(Uri.parse(url));

      final imageFile = File(localPath);
      await imageFile.writeAsBytes(response.bodyBytes);

      return imageFile;
    } catch (e) {
      Logger().w('error while downloading image $url\n$e');
      return null;
    }
  }
}
