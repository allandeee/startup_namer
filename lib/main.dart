import 'package:flutter/material.dart';
import "package:english_words/english_words.dart";

void main() => runApp(NamerApp());

class NamerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final wordPair = WordPair.random();
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      darkTheme: ThemeData.dark(),
      home: RandomWords(),
    );
  }
}

/// Stateful widgets maintain state that might change during the lifetime
/// of the widget.
/// This stateful widget does little else besides creating its State class.
class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}

/// Usage of the generic State class specialised for use with RandomWords.
/// Most of the app's logic and state resides here - it maintains the state 
/// for the RandomWords widget.
/// - Holds the generated word pairs
/// - Must contain (overriden) build method
class RandomWordsState extends State<RandomWords> {
  final List<WordPair> _suggestions = <WordPair>[];     // for storing suggested word pairings
  final Set<WordPair> _saved = Set<WordPair>();     // stores user-favourited word pairings; Set does not allow duplicates
  final TextStyle _biggerFont = const TextStyle(fontSize: 18);      // for making the font size larger

  @override
  Widget build(BuildContext context) {
    // final WordPair wordPair = WordPair.random();
    // return Text(wordPair.asPascalCase);

    // Scaffold implements the basic Material Design visual layout.
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        // add the list icon to the app bar, navigating to a new route when pressed
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushSaved () {
    // pushes the route to the Navigator's stack.
    Navigator.of(context).push(
      MaterialPageRoute<void>(   
        builder: (BuildContext context) {
          // maps the word pairs in the _saved set to a list-like collection (iterable) of ListTile widgets that
          final Iterable<ListTile> tiles = _saved.map(
            (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );
          // this is the final variable containing the favourited word pairs and dividers
          final List<Widget> divided = ListTile
            // add horizontal spacing between each ListTile
            .divideTiles(
              context: context,
              tiles: tiles,
            )
            .toList();
          
          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ), 
    );
  }

  /// This builds the ListView that displays the suggested word pairings
  Widget _buildSuggestions() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      // The itemBuilder callback is called once per suggested 
      // word pairing, and places each suggestion into a ListTile
      // row. For even rows, the function adds a ListTile row for
      // the word pairing. For odd rows, the function adds a 
      // Divider widget to visually separate the entries. 
      itemBuilder: (BuildContext _context, int i) {
        if (i.isOdd) {
          return Divider();   // 1 pixel high divider
        }

        // The syntax "i ~/ 2" divides i by 2 and returns an 
        // integer result.
        // For example: 1, 2, 3, 4, 5 becomes 0, 1, 1, 2, 2.
        // This calculates the actual number of word pairings 
        // in the ListView,minus the divider widgets.
        final int index = i ~/ 2;
        // If you've reached the end of the available word
        // pairings...
        if (index >= _suggestions.length) {
          // ...then generate 10 more and add them to the 
          // suggestions list.
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      }
    );
  }

  /// Builds and returns each new pair in a ListTile.
  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = _saved.contains(pair);    // check to ensure that word pairing has not already been added to favourites
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      // widget to display after the title; typically an Icon
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        // setState is used to notify the framework that state has changed; triggers call to the build() method
        setState(() {
          alreadySaved ? _saved.remove(pair) : _saved.add(pair);
        });
      },
    );
  }

}