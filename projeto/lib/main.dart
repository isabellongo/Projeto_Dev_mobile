import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'controllers/notes_controller.dart';
import 'repositories/notes_repository.dart';
import 'repositories/remote_notes_repository.dart';
import 'router.dart';

void main() async {
  //await Hive.initFlutter();
  //Hive.registerAdapter(NoteAdapter());

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<NotesRepository>(create: (_) => RemoteNotesRepository()),
        ChangeNotifierProvider<NotesController>(
          create: (context) => NotesController(context.read<NotesRepository>()),
        ),
      ],
      child: MaterialApp.router(
        title: 'OCR App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepOrange,
            brightness: Brightness.light,
          ),
          textTheme: TextTheme(
            displayLarge: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.bold,
            ),
            titleLarge: GoogleFonts.oswald(
              fontSize: 30,
              color: Colors.deepOrange,
            ),
            bodyMedium: GoogleFonts.merriweather(),
            displaySmall: GoogleFonts.merriweather(),
          ),
          snackBarTheme: SnackBarThemeData(
            contentTextStyle: GoogleFonts.roboto(fontSize: 20),
            backgroundColor: Colors.deepOrange,
          ),
          appBarTheme: AppBarTheme(
            titleTextStyle: GoogleFonts.oswald(
              color: const Color.fromARGB(255, 167, 39, 0),
              fontSize: 40,
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    );
  }
}
