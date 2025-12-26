import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_filex/open_filex.dart';

class PdfDownloader {
  static Future<void> downloadImagesAsPdf({
    required List<String> imageUrls,
    required String fileName,
  }) async {
    try {
      // 1️⃣ Request permission (Android only)
      if (Platform.isAndroid) {
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          throw 'Storage permission denied';
        }
      }

      // 2️⃣ Create PDF
      final pdf = pw.Document();

      for (final url in imageUrls) {
        final imageBytes = await _downloadImage(url);
        final image = pw.MemoryImage(imageBytes);

        pdf.addPage(
          pw.Page(
            build: (_) => pw.Center(
              child: pw.Image(image, fit: pw.BoxFit.contain),
            ),
          ),
        );
      }

      // 3️⃣ Save file
      final Uint8List pdfBytes = await pdf.save();

      // 📱 MOBILE / DESKTOP
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$fileName.pdf');
      await file.writeAsBytes(pdfBytes);

      // 4️⃣ Open PDF
      await OpenFilex.open(file.path);

    } catch (e) {
      rethrow;
    }
  }

  static Future<Uint8List> _downloadImage(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw 'Failed to load image';
    }
    return response.bodyBytes;
  }

}
