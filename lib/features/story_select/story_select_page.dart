import 'package:bibi/features/local_storage.dart';
import 'package:flutter/material.dart';

class StorySelectPage extends StatefulWidget {
  const StorySelectPage({super.key});

  @override
  State<StorySelectPage> createState() => _StorySelectPageState();
}

class _StorySelectPageState extends State<StorySelectPage> {
  final LocalStorage _localStorage = LocalStorage();
  List<String>? _storyListing;

  @override
  void initState() {
    super.initState();
    _getStoryListing();
  }

  Future<void> _getStoryListing() async {
    List<String> paths = await _localStorage.directoryListPaths;
    setState(() {
      _storyListing = paths;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_storyListing == null) {
      return Container();
    }
    return Center(
        child: Column(
            children: _storyListing!
                .map((entry) => Card(
                        child: Column(children: [
                      ListTile(
                        leading: const Icon(Icons.book),
                        title: Text(entry),
                        subtitle: const Text('click'),
                      )
                    ])))
                .toList()));
  }
}
