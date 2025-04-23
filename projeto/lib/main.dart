import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'adapters/note_hive_adapter.dart';
import 'repositories/local_notes_repository.dart';
import 'repositories/notes_repository.dart';
import 'controllers/notes_controller.dart';
import 'router.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(NoteAdapter());
  
  runApp(
    MultiProvider(
      providers: [
        Provider<NotesRepository>(
          create: (_) => LocalNotesRepository(),
        ),
        ChangeNotifierProvider<NotesController>(
          create: (context) => NotesController(context.read<NotesRepository>()),
        ),
      ],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'OCR App',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
