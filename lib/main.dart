import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:project_flutter/firebase_options.dart';
import 'package:project_flutter/movie/on_boarding/onboarding_view.dart';
import 'package:project_flutter/injector.dart';
import 'package:project_flutter/movie/providers/movie_get_discover_provider.dart';
import 'package:project_flutter/movie/providers/movie_get_now_playing_provider.dart';
import 'package:project_flutter/movie/providers/movie_get_top_rated_provider.dart';
import 'package:project_flutter/movie/providers/movie_get_cast_provider.dart';
import 'package:provider/provider.dart';
import 'package:project_flutter/movie/providers/movie_search_provider.dart';
import 'package:project_flutter/movie/providers/bookmark_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  setup();
  runApp(const MyApp());

  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => sl<MovieGetDiscoverProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => sl<MovieGetTopRatedProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => sl<MovieGetNowPlayingProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => sl<MovieSearchProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => sl<MovieGetCastProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => sl<BookmarkProvider>(),
        ),
      ],
      child: MaterialApp(
        title: 'Movie DB',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const OnboardingView(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
