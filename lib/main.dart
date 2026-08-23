import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'root.dart'; // start at welcome screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://jwqwmbqygediwluoimmn.supabase.co',
    publishableKey:
        'sb_publishable_LVIpIBg4ppEjlS2GgRCidw_VStHtQpp', // ✅ correct
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'luv.cosmetics',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ),
      home: const Root(), // 👈 starts at welcome screen
    );
  }
}
