import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/api_client.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiClient.I.init();
  runApp(const ProviderScope(child: App()));
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  String? _token;

  @override
  void initState() {
    super.initState();
    ApiClient.I.token.then((t) => setState(() => _token = t));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MLM Client',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: _token == null ? const LoginScreen() : const HomeScreen(),
    );
  }
}
