import 'package:flutter/material.dart';
import 'package:flutter_assignment_4/auth_gate.dart';
import 'package:flutter_assignment_4/login_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ecmpnpfiariuqgvzamxn.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVjbXBucGZpYXJpdXFndnphbXhuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzg5MjE3OTgsImV4cCI6MjA5NDQ5Nzc5OH0.4p17boyr86kfIo4RVxz_QvjZz6_x0zbM57_6AwFVy-w'
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        theme: ThemeData(
          inputDecorationTheme: InputDecorationTheme(
              fillColor: Colors.purple,
              filled: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide.none
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none
              ),
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide.none
              )

          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
                backgroundColor: Colors.purple,
                fixedSize: Size.fromWidth(double.maxFinite),
                padding: EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)
                )
            ),
          ),
        ),

      home: AuthGate(),
    );
  }
}

