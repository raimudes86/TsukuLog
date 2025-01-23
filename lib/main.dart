import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tsukulog/pages/my_home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:tsukulog/pages/sign_in_page.dart';
import 'package:tsukulog/pages/sign_up_page.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'つくログ',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //デバッグバナーを消す
      debugShowCheckedModeBanner: false,
      //言語設定を日本語に
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("ja", "JP"),
      ],
      routes: {
        '/home/true': (context) =>
            const MyHomePage(title: 'つくログ', isLoggedin: true),
        '/home/false': (context) =>
            const MyHomePage(title: 'つくログ', isLoggedin: false),
        '/signUp': (context) => const SignUpPage(),
        '/signIn': (context) => const SignInPage(),
      },
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // ローディング中はローディング画面を表示
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.hasData) {
          // ユーザーがログインしている場合
          return const MyHomePage(title: 'つくログ', isLoggedin: true);
        }
        // ユーザーがログインしていない場合
        // return const MyHomePage(title: 'つくログ', isLoggedin: false);
        return const MyHomePage(title: 'つくログ', isLoggedin: false);
      },
    );
  }
}
