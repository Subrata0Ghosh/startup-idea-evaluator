import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:startup_idea_evaluator/screens/idea_list_screen.dart';
import 'package:startup_idea_evaluator/screens/idea_submit_screen.dart';
import 'package:startup_idea_evaluator/screens/leaderboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //final prefs = await SharedPreferences.getInstance();
  //await prefs.clear();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Idea Evaluator 🚀',
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      initialRoute: '/submit',
      routes: {
        '/submit': (context) => IdeaSubmitScreen(onToggleTheme: toggleTheme, isDark: isDarkMode),
        '/ideas': (context) => IdeaListScreen(onToggleTheme: toggleTheme, isDark: isDarkMode),
        '/leaderboard': (context) => LeaderboardScreen(onToggleTheme: toggleTheme, isDark: isDarkMode),
      },
    );
  }
}

