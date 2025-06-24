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

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  // FIX: Make the controller nullable to handle initialization state.
  CameraController? _controller;
  late Future<void> _initializeControllerFuture;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    // Allows us to react to app lifecycle changes (e.g., app goes to background).
    WidgetsBinding.instance.addObserver(this);
    // Start the initialization process.
    _initializeControllerFuture = _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // FIX: Wrap initialization in a try-catch to handle errors.
    try {
      final cameras = await availableCameras();
      // Ensure we have at least one camera.
      if (cameras.isEmpty) {
        throw Exception('No cameras found on this device.');
      }

      final controller = CameraController(
        cameras[0], // Use the primary back camera
        ResolutionPreset.high,
        enableAudio: false,
      );

      await controller.initialize();
      
      // If initialization is successful, assign it to our controller.
      if (mounted) {
        setState(() {
          _controller = controller;
        });
      }
    } catch (e) {
      debugPrint("Failed to initialize camera: $e");
      // Propagate the error to be caught by the FutureBuilder.
      rethrow;
    }
  }

  // FIX: Handle app lifecycle state changes to re-initialize the camera
  // if the user backgrounds and returns to the app.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeControllerFuture = _initializeCamera();
      setState(() {}); // Re-trigger the FutureBuilder
    }
  }

  @override
  void dispose() {
    // Remove the observer.
    WidgetsBinding.instance.removeObserver(this);
    // FIX: Use a null-safe call to dispose of the controller.
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _onTakePhoto() async {
    if (_isProcessing || _controller == null) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      await _initializeControllerFuture;

      // FIX: Use the non-null asserted controller.
      final XFile imageFile = await _controller!.takePicture();
      final String filePath = imageFile.path;

      if (context.mounted) {
        context.read<NotesController>().addPhotoToNote(widget.noteId, filePath);

        if (context.canPop()) {
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
          // FIX: Add a check for errors during initialization.
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Erro ao iniciar a câmera: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          // Once the Future is complete, display the camera preview.
          if (snapshot.connectionState == ConnectionState.done && _controller != null) {
            return Stack(
              fit: StackFit.expand,
              children: [
                // FIX: Use the non-null asserted controller.
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
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            );
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
