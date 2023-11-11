
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ttachienew/splash_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // String storageLocation = (await getApplicationCacheDirectory()).path;
  final cacheDir = await getTemporaryDirectory();
  String cachePath = cacheDir.path;
  await FastCachedImageConfig.init(subDir: cachePath, clearCacheAfter: const Duration(days: 15));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'NoteKeeper',
      debugShowCheckedModeBanner: false,

theme: ThemeData(
  inputDecorationTheme: const InputDecorationTheme(

    filled: true, //<-- SEE HERE
    fillColor: Color.fromARGB(255,55, 69, 80),
    //<-- SEE HERE




  ),
    scaffoldBackgroundColor:Color.fromARGB(255,55, 69, 80),
),
      home: SplashScreen(),
    );
  }
}