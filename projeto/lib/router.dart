import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'pages/login_page.dart';
import 'pages/notes_page.dart';
import 'pages/full_note_page.dart';
import 'pages/camera_page.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/notes',
      builder: (context, state) => const NotesPage(),
    ),
    GoRoute(
      path: '/notes/:noteId',
      builder: (context, state) {
        final noteId = state.params['noteId'];

        if (noteId == null) return const Placeholder();

        return FullNotePage(noteId: noteId);
      },
    ),
    GoRoute(
      path: '/camera',
      builder: (context, state) => const CameraPage(),
    ),
  ],
);
