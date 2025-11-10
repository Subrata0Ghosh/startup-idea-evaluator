import 'package:flutter/material.dart';
import 'package:startup_idea_evaluator/models/idea_model.dart';
import 'package:startup_idea_evaluator/services/storage_service.dart';
import 'package:startup_idea_evaluator/widgets/idea_card.dart';

class LeaderboardScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;
  final bool isDark;

  const LeaderboardScreen({super.key, required this.onToggleTheme, required this.isDark});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<StartupIdea> _ideas = [];
  late String selectedValue;
  List<String> dropDownValues = ['Rating', 'Votes'];

  @override
  void initState() {
    super.initState();
    selectedValue = dropDownValues[0];
    _loadIdeas();
  }

  Future<void> _loadIdeas() async {
    _ideas = await StorageService().loadIdeas();
    _sortIdeas();
    setState(() {});
  }

  Future<void> _upvote(int index) async {
    _ideas[index] = StartupIdea(
      name: _ideas[index].name,
      tagline: _ideas[index].tagline,
      description: _ideas[index].description,
      rating: _ideas[index].rating,
      votes: _ideas[index].votes + 1,
    );
    await StorageService().saveIdeas(_ideas);
    _sortIdeas(); // Re-sort after upvote
    setState(() {});
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Upvoted ${_ideas[index].name}!')),
    );
  }

  void _sortIdeas() {
    if (selectedValue == 'Rating') {
      _ideas.sort((a, b) => b.rating.compareTo(a.rating));
    } else {
      _ideas.sort((a, b) => b.votes.compareTo(a.votes));
    }
    _ideas = _ideas.take(5).toList();  // Limit to top 5
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: Icon(widget.isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                 ? [Colors.grey.shade900, Colors.grey.shade800]
                : [Colors.white, Colors.grey.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Sort by: '),
                  DropdownButton<String>(
                    value: selectedValue,
                    items: dropDownValues.map<DropdownMenuItem<String>>((
                      String value,
                    ) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedValue = newValue;
                          _sortIdeas();
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: _ideas.isEmpty
                  ? const Center(child: Text('No ideas yet'))
                  : ListView.builder(
                      itemCount: _ideas.length,
                      itemBuilder: (context, index) {
                        final idea = _ideas[index];
                        return IdeaCard(idea: idea, rank: index + 1, onUpvote: () => _upvote(index), onCopied: () { if (!mounted) return; ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Idea Copied!'))); });
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/submit');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/ideas');
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
