import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

class ListWords extends StatefulWidget {
  @override
  ListWordsState createState() => ListWordsState();
}

class ListWordsState extends State<ListWords> {
  final List<WordPair> _suggestions = <WordPair>[];
  final Set<WordPair> _savedSuggestions = Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Popular English Words"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
          )
        ],
      ),
      body: _buildListSuggestion(),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _savedSuggestions.map(
            (WordPair pair) {
              return new ListTile(
                title: new Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return new Scaffold(
            // Add 6 lines from here...
            appBar: new AppBar(
              title: const Text('Saved Suggestions'),
            ),
            body: new ListView(children: divided),
          ); // ... to here.
        },
      ),
    );
  }

  Widget _buildListSuggestion() {
    Widget _buildRow(WordPair suggestion) {
      final bool saved = _savedSuggestions.contains(suggestion);
      return ListTile(
        title: Text(
          suggestion.asPascalCase,
          style: _biggerFont,
        ),
        trailing: Icon(saved ? Icons.favorite : Icons.favorite_border,
            color: saved ? Colors.red : null),
        onTap: () {
          setState(() {
            if (saved) {
              _savedSuggestions.remove(suggestion);
            } else {
              _savedSuggestions.add(suggestion);
            }
          });
        },
      );
    }

    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider(); /*2*/

          final index = i ~/ 2; /*3*/
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          return _buildRow(_suggestions[index]);
        });
  }
}
