import 'dart:convert';
import 'dart:io' show File, Platform;
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => context.go('/notes'),
        ),
      ),
      body: Center(
        child: IconButton(
          iconSize: 80,
          icon: const Icon(Icons.camera_alt, color: Colors.white),
          onPressed: () async {
            Uint8List? imageBytes;

            if (kIsWeb) {
              // Web: use file_picker
              final result = await FilePicker.platform.pickFiles(
                type: FileType.image,
              );
              if (result != null && result.files.single.bytes != null) {
                imageBytes = result.files.single.bytes!;
              }
            } else {
              final picker = ImagePicker();
              final picked = await picker.pickImage(
                source: ImageSource.camera,
              );
              if (picked != null) {
                imageBytes = await File(picked.path).readAsBytes();
              }
            }

            if (imageBytes == null) return;
            final base64Image = base64Encode(imageBytes);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Enviando imagem para OCR...')),
            );

            final response = await http.post(
              Uri.parse(
                'https://your-cloud-function-url',
              ), // replace with your URL
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode({'image_base64': base64Image}),
            );

            if (response.statusCode == 200) {
              final text = jsonDecode(response.body)['text'];
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Texto extraído: $text')));
            } else {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Erro: ${response.body}')));
            }
          },
        ),
      ),
    );
  }
}
