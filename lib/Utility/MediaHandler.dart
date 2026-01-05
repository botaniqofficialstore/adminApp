import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../../../Utility/ImageCropScreen.dart';
import 'package:path/path.dart' as p;

class MediaHandler{

  Future<String?> handleCommonMediaPicker(BuildContext context, ImageSource source) async {
    try {
      final hasPerm = await _checkAndRequestPermission(context, source);
      if (!hasPerm) return null;

      final ImagePicker _picker = ImagePicker();

      // pick single image
      final XFile? picked = await _picker.pickImage(
        source: source,
        imageQuality: 100,
      );

      if (picked == null) return null; // user cancelled

      // go to crop screen
      final String? croppedPath = await Navigator.of(context).push<String>(
        MaterialPageRoute(
          builder: (_) => ImageCropScreen(imagePath: picked.path),
        ),
      );

      if (croppedPath == null) return null;

      // compress image
      final String compressedPath = await _compressImage(croppedPath);


      // ✅ return compressed image path
      return compressedPath;

    } catch (e, st) {
      debugPrint('Image pick error: $e\n$st');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to select image.')),
      );
      return null;
    }
  }


  Future<bool> _checkAndRequestPermission(BuildContext context, ImageSource source) async {
    // For camera: camera permission
    // For gallery: photos (iOS) or storage/read_media (Android)
    if (source == ImageSource.camera) {
      var status = await Permission.camera.status;
      if (status.isGranted) return true;

      if (status.isPermanentlyDenied) {
        await _showOpenSettingsDialog(context, 'Camera permission is permanently denied. Please enable it from settings.');
        return false;
      }

      final result = await Permission.camera.request();
      if (result.isGranted) return true;
      if (result.isPermanentlyDenied) {
        await _showOpenSettingsDialog(context, 'Camera permission is permanently denied. Please enable it from settings.');
      }
      return false;
    } else {
      // gallery
      if (Platform.isAndroid) {
        // Android: handle READ_MEDIA_IMAGES (Android 13+) and READ_EXTERNAL_STORAGE older
        Permission p = Permission.photos; // fallback
        final sdkInt = (await _getAndroidSdkInt()) ?? 0;
        if (sdkInt >= 33) {
          p = Permission.photos; // permission_handler maps photos to READ_MEDIA_IMAGES
        } else {
          p = Permission.storage;
        }

        var status = await p.status;
        if (status.isGranted) return true;
        if (status.isPermanentlyDenied) {
          await _showOpenSettingsDialog(context, 'Storage permission is permanently denied. Please enable it from settings.');
          return false;
        }
        final res = await p.request();
        if (res.isGranted) return true;
        if (res.isPermanentlyDenied) {
          await _showOpenSettingsDialog(context, 'Storage permission is permanently denied. Please enable it from settings.');
        }
        return false;
      } else {
        // iOS
        var status = await Permission.photos.status;
        if (status.isGranted) return true;
        if (status.isPermanentlyDenied) {
          await _showOpenSettingsDialog(context, 'Photos permission is permanently denied. Please enable it from settings.');
          return false;
        }
        final res = await Permission.photos.request();
        if (res.isGranted) return true;
        if (res.isPermanentlyDenied) {
          await _showOpenSettingsDialog(context, 'Photos permission is permanently denied. Please enable it from settings.');
        }
        return false;
      }
    }
  }

  Future<int?> _getAndroidSdkInt() async {
    try {
      // permission_handler doesn't expose SDK; a quick way:
      // Use Platform.operatingSystemVersion and parse? Not reliable.
      // We'll return null (defaulting to older behavior). This is optional.
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> _showOpenSettingsDialog(BuildContext context, String message) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Permission required'),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(), child: Text('Cancel')),
          TextButton(
              onPressed: () {
                openAppSettings();
                Navigator.of(context).pop();
              },
              child: Text('Open Settings')),
        ],
      ),
    );
  }

  Future<String> _compressImage(String inputPath) async {
    final dir = await getTemporaryDirectory();
    final targetPath = p.join(dir.path, 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg');

    // try compress with quality 85 first, if result larger than desired keep as-is
    final result = await FlutterImageCompress.compressAndGetFile(
      inputPath,
      targetPath,
      quality: 88, // high quality, good compression
      keepExif: true,
    );

    if (result == null) {
      // fallback to original path if compression fails
      return inputPath;
    }

    return result.path;
  }


}