import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/idea_model.dart';

class StorageService {

  Future<void> saveIdea(StartupIdea idea) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> ideasJson = prefs.getStringList('ideas') ?? [];
    ideasJson.add(jsonEncode(idea.toMap()));
    await prefs.setStringList('ideas', ideasJson);
  }

  Future<void> saveIdeas(List<StartupIdea> ideas) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> ideasJson = ideas.map((idea) => jsonEncode(idea.toMap())).toList();
    await prefs.setStringList('ideas', ideasJson);
  }

  Future<List<StartupIdea>> loadIdeas() async{
    final prefs =await SharedPreferences.getInstance();
    List<String> ideasJson =prefs.getStringList('ideas')?? [];
    return ideasJson.map((json) => StartupIdea.fromMap(jsonDecode(json))).toList();
  }

}
