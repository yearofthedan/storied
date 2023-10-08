import 'package:bibi/features/home/story_selection.dart';
import 'package:bibi/storage/local_storage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LocalStorage _localStorage = LocalStorage();
  List<String>? _storyListing;

  @override
  void initState() {
    super.initState();
    _getStoryListing();
  }

  Future<void> _getStoryListing() async {
    List<String> paths = await _localStorage.getFileNames();
    setState(() {
      _storyListing = paths;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_storyListing == null) {
      return Scaffold(body: Container(color: Colors.green));
    }
    return Scaffold(
        backgroundColor: Colors.green,
        body: Container(
          padding: const EdgeInsets.all(8),
          child: Center(child: StorySelection(_storyListing!)),
        ));
  }
}
