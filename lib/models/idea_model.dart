class StartupIdea {
  final String name;
  final String tagline;
  final String description;
  final int rating;
  final int votes;

  StartupIdea({
    required this.name,
    required this.tagline,
    required this.description,
    required this.rating,
    required this.votes,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'tagline': tagline,
      'description': description,
      'rating': rating,
      'votes': votes,
    };
  }

  factory StartupIdea.fromMap(Map<String, dynamic> map) {
    return StartupIdea(
      name: map['name'] as String,
      tagline: map['tagline'] as String,
      description: map['description'] as String,
      rating: map['rating'] as int,
      votes: map['votes'] as int,
    );
  }
}
