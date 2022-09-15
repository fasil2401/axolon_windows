// import 'dart:io';

import 'dart:io';

import 'package:axolon_container/services/db_helper/db_helper.dart';
import 'package:axolon_container/utils/Routes/route_manger.dart';
import 'package:axolon_container/utils/Theme/theme_provider.dart';
import 'package:axolon_container/utils/shared_preferences/shared_preferneces.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
  }
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // await DbHelper().database;
  await UserSimplePreferences.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Axolon ERP',
      debugShowCheckedModeBanner: false,
      theme: ThemeProvider().theme,
      // home: SplashScreen(),
      initialRoute: RouteManager().routes[0].name,
      getPages: RouteManager().routes,
    );
  }
}
