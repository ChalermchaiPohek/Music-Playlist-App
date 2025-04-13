import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:music_playlist_app/router/route_path.dart';
import 'package:music_playlist_app/router/routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome
      .setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown
    ],
  )
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: RoutePath.playlistPath,
      debugShowCheckedModeBanner: false,
      getPages: Routes.routers,
      // title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const CartScreen(),
    );
  }
}