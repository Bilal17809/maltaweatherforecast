import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '/presentation/splash/view/splash_view.dart';
import '/core/binders/dependency_injection.dart';
import '/core/local_storage/local_storage.dart';
import 'core/services/services.dart';
import 'core/theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AqiService.initialize();
  DependencyInjection.init();
  OnesignalService.init();
  final storage = LocalStorage();
  final isDark = await storage.getBool('isDarkMode');
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    MaltaWeather(
      themeMode: isDark == true
          ? ThemeMode.dark
          : isDark == false
          ? ThemeMode.light
          : ThemeMode.system,
    ),
  );
}

class MaltaWeather extends StatelessWidget {
  final ThemeMode themeMode;
  const MaltaWeather({super.key, required this.themeMode});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Malta Weather',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: SplashView(),
    );
  }
}
