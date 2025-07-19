// PDF Viewer Page
import 'dart:io'; // Import for File handling
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';




import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerPage extends StatelessWidget {
  final String base64Pdf;

  PDFViewerPage({required this.base64Pdf});

  Uint8List _decodeBase64Pdf(String base64String) {
    return base64.decode(base64String);
  }

  @override
  Widget build(BuildContext context) {
    // Decode the Base64 string into bytes
    Uint8List pdfBytes = _decodeBase64Pdf(base64Pdf);

    return Scaffold(
      appBar: AppBar(
        title: Text('Certification Viewer'),
        backgroundColor: const Color(0xFF062029),
      ),
      body: SfPdfViewer.memory(pdfBytes),
    );
  }
}
