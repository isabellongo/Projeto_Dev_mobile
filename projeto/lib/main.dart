// lib/pages/camera_page.dart

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../controllers/notes_controller.dart';

class CameraPage extends StatefulWidget {
  final String noteId;

  const CameraPage({
    super.key,
    required this.noteId,
  });

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw Exception('No cameras found on this device.');
      }

      final controller = CameraController(
        cameras[0],
        ResolutionPreset.high,
        enableAudio: false,
      );
      
      _controller = controller;
      await controller.initialize();
      
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      debugPrint("Failed to initialize camera: $e");
      rethrow;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _onTakePhoto() async {
    if (_controller == null || !_controller!.value.isInitialized || _isProcessing) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final XFile imageFile = await _controller!.takePicture();
      final String filePath = imageFile.path;
      
      if (context.mounted) {
        // --- THIS IS THE FIX ---
        // We now 'await' the controller method to ensure the note is updated
        // before we try to navigate away.
        await context.read<NotesController>().addPhotoToNote(widget.noteId, filePath);

        // This check ensures we only pop if the widget is still in the tree
        // and there is a route to pop back to.
        if (context.mounted && context.canPop()) {
          context.pop();
        }
      }
    } catch (e) {
      debugPrint("Error taking picture: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao capturar foto: $e')),
        );
      }
    } finally {
      // The finally block ensures this runs even if an error occurs.
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Erro ao iniciar a câmera:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }
            
            return Stack(
              fit: StackFit.expand,
              children: [
                CameraPreview(_controller!),
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: IconButton(
                      iconSize: 80,
                      icon: const Icon(Icons.camera_alt, color: Colors.white),
                      onPressed: _onTakePhoto,
                    ),
                  ),
                ),
                if (_isProcessing)
                  Container(
                    color: Colors.black.withValues(),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
