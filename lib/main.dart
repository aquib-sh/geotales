import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geotales/providers/file_provider.dart';
import 'package:geotales/providers/map_provider.dart';
import 'package:geotales/providers/session_provider.dart';
import 'package:geotales/screens/login_screen.dart';
import 'package:geotales/widgets/file_upload_dialog.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => SessionProvider(FirebaseAuth.instance)),
        ChangeNotifierProvider(create: (context) => MapProvider()),
        ChangeNotifierProvider(create: (context) => FileProvider()),
        ChangeNotifierProvider(create: (context) => FileUploadProvider())
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
