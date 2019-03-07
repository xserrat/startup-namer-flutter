import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Namer',
      theme: ThemeData.dark(),
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
  final Set<WordPair> _stored_words = new Set<WordPair>();
  final List<WordPair> _allSuggestions = <WordPair>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Namer'),
        actions: <Widget>[
          new IconButton(
              icon: const Icon(Icons.list), onPressed: _showStoredWordsPage)
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void _showStoredWordsPage() {
    Navigator.of(context).push(_buildStoredWordsRoute());
  }

  MaterialPageRoute _buildStoredWordsRoute() {
    return MaterialPageRoute<void>(builder: (BuildContext context) {
      final Iterable<ListTile> wordRows =
          _stored_words.map((WordPair aWordPair) {
        return ListTile(
            title: Text(aWordPair.asPascalCase, style: _wordPairFont));
      });

      final List<Widget> wordRowsWithinEmptySpaces =
          ListTile.divideTiles(tiles: wordRows, context: context).toList();

      return Scaffold(
        appBar: AppBar(
          title: Text('Favourite Startup Names'),
        ),
        body: ListView(children: wordRowsWithinEmptySpaces),
      );
    });
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
    final bool isAlreadySaved = _stored_words.contains(wordPair);

    final IconData favouriteIconMarked = Icons.favorite;
    final IconData favouriteIconUnmarked = Icons.favorite_border;

    final Icon favouriteIcon = new Icon(
        isAlreadySaved ? favouriteIconMarked : favouriteIconUnmarked,
        color: isAlreadySaved ? Colors.red : null);
    final IconButton favouriteButton = new IconButton(
        icon: favouriteIcon,
        onPressed: () {
          setState(() {
            if (isAlreadySaved) {
              _stored_words.remove(wordPair);

              return;
            }

            _stored_words.add(wordPair);
          });
        });

    return ListTile(
      title: Text(
        wordPair.asPascalCase,
        style: _wordPairFont,
      ),
      trailing: favouriteButton,
    );
  }
}
