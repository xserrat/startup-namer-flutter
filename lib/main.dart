import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Welcome to Flutter',
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _wordPairFont = const TextStyle(fontSize: 18.0);
  final _allSuggestions = <WordPair>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, currentRow) {
          if (currentRow.isOdd) {
            return Divider();
          }

          final currentWordRow = currentRow ~/ 2;

          if (_isTheLastRowOfTheList(currentWordRow)) {
            _addMoreSuggestions();
          }

          return _buildRowWithWordPair(_allSuggestions[currentWordRow]);
        });
  }

  bool _isTheLastRowOfTheList(int row) {
    return row >= _allSuggestions.length;
  }

  void _addMoreSuggestions() {
    final moreSuggestions = generateWordPairs().take(10);
    _allSuggestions.addAll(moreSuggestions);
  }

  ListTile _buildRowWithWordPair(WordPair wordPair) {
    return ListTile(
      title: Text(
        wordPair.asPascalCase,
        style: _wordPairFont,
      ),
    );
  }
}
