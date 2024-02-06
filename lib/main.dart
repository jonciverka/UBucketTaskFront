import 'package:flutter/material.dart';
import 'package:flutter_cupertino_bottom_sheet/flutter_cupertino_bottom_sheet.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ubuckettask/Rutas/get_rutas.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return CupertinoBottomSheetRepaintBoundary(
      child: MaterialApp(
        navigatorKey: cupertinoBottomSheetNavigatorKey,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'), // Inglés
          Locale.fromSubtags(languageCode: 'zh'),
        ],
        title: 'Local Contact',
        // theme: ThemeData(
        //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        //   useMaterial3: true,
        // ),
        initialRoute: '/',
        routes: getRutas(),
      ),
    );
  }
}
