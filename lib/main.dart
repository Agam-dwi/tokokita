import 'package:flutter/material.dart';
import 'package:tokokita/helpers/user_info.dart';
import 'package:tokokita/ui/login_page.dart';
import 'package:tokokita/ui/produk_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget page = const Center(
    child: CircularProgressIndicator(),
  );

  bool isDark = false;

  @override
  void initState() {
    super.initState();
    isLogin();
  }

  void toggleTheme() {
    setState(() {
      isDark = !isDark;
    });
  }

  void isLogin() async {
    var token = await UserInfo().getToken();

    setState(() {
      if (token != null) {
        page = ProdukPage(
          onThemeChanged: toggleTheme,
        );
      } else {
        page = LoginPage(
          onThemeChanged: toggleTheme,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toko Kita',
      debugShowCheckedModeBanner: false,

      theme: ThemeData.light(),

      darkTheme: ThemeData.dark(),

      themeMode:
          isDark ? ThemeMode.dark : ThemeMode.light,

      home: page,
    );
  }
}
