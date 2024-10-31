import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_management_app/task_provider.dart';
import 'package:task_management_app/task_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TaskProvider()),
      ],
      child: MaterialApp(
        title: 'Task Management App',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          scaffoldBackgroundColor: Colors.grey[100],
          textTheme: TextTheme(
            titleLarge: TextStyle(
              color: Colors.teal[700],
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
            bodyMedium: TextStyle(
              color: Colors.black87,
            ),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.teal[600],
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
            elevation: 4,
          ),
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.teal[400],
            textTheme: ButtonTextTheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.teal[300],
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          cardTheme: CardTheme(
            color: Colors.white,
            shadowColor: Colors.teal[100],
            elevation: 5,
            margin: EdgeInsets.all(8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: TaskScreen(),
      ),
    );
  }
}
