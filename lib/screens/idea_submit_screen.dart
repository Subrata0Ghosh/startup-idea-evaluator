import 'dart:math';
import 'package:flutter/material.dart';
import 'package:startup_idea_evaluator/models/idea_model.dart';
import 'package:startup_idea_evaluator/services/storage_service.dart';
import 'package:startup_idea_evaluator/widgets/custom_input_field.dart';

class IdeaSubmitScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDark;

  const IdeaSubmitScreen({super.key, required this.onToggleTheme, required this.isDark});

  @override
  State<IdeaSubmitScreen> createState() => _IdeaSubmitScreenState();
}

class _IdeaSubmitScreenState extends State<IdeaSubmitScreen> {
  final TextEditingController _startupNameController = TextEditingController();
  final TextEditingController _taglineController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _submitIdea() async {
    // print("submit");
    if (_startupNameController.text.isEmpty ||
        _taglineController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please fill all fields')));
      return;
    }

    final int rating = Random().nextInt(101);

    final StartupIdea idea = StartupIdea(
      name: _startupNameController.text,
      tagline: _taglineController.text,
      description: _descriptionController.text,
      rating: rating,
      votes: 0,
    );
    await StorageService().saveIdea(idea);

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Idea submitted!')));

    _startupNameController.clear();
    _taglineController.clear();
    _descriptionController.clear();

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    Navigator.pushNamed(context, '/ideas');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(widget.isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                "Submit Your Startup Idea 🚀",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87,
                ),
              ),
              SizedBox(height: 15),
              CustomInputField(
                label: 'Startup Name',
                controller: _startupNameController,
                icon: Icons.business,
              ),
              SizedBox(height: 15),
              CustomInputField(
                label: 'Tagline',
                controller: _taglineController,
                icon: Icons.lightbulb,
              ),
              SizedBox(height: 15),
              CustomInputField(
                label: 'Description',
                controller: _descriptionController,
                maxLines: 3,
                icon: Icons.description,
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: _submitIdea,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: const Text(
                  'Submit Idea',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushReplacementNamed(context, '/ideas');
          } else if (index == 2) {
            Navigator.pushReplacementNamed(context, '/leaderboard');
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Ideas'),
          BottomNavigationBarItem(icon: Icon(Icons.leaderboard), label: 'Leaderboard'),
        ],
      ),
    );
  }
}
