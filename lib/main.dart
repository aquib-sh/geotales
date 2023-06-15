import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geotales/providers/file_provider.dart';
import 'package:geotales/providers/file_upload_provider.dart';
import 'package:geotales/providers/map_provider.dart';
import 'package:geotales/providers/session_provider.dart';
import 'package:geotales/screens/login_screen.dart';
//import 'package:geotales/screens/splash_screen.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SessionProvider sessionProvider = SessionProvider(FirebaseAuth.instance);
    MapProvider mapProvider = MapProvider();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => sessionProvider),
        ChangeNotifierProvider(create: (context) => mapProvider),
        ChangeNotifierProvider(create: (context) => FileProvider()),
        ChangeNotifierProxyProvider2<SessionProvider, MapProvider,
            FileUploadProvider>(
          create: (context) => FileUploadProvider(
            Provider.of<SessionProvider>(context, listen: false),
            Provider.of<MapProvider>(context, listen: false),
          ),
          update: (context, session, map, previous) =>
              previous!..update(session: session, map: map),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'GeoTales',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: LoginScreen(),
      ),
    );
  }
}
