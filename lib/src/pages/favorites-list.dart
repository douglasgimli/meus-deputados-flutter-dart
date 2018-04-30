import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/deputy.dart';

class ListFavoritesPage extends StatefulWidget {
  ListFavoritesPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ListFavoritesState createState() => new _ListFavoritesState();
}

class _ListFavoritesState extends State<ListFavoritesPage> {
  ScrollController controller;

  int _page = 1;
  List _items = new List();
  List<String> _favorites = new List<String>();

  @override
  void initState() {
    _getFavorites();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _getFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = (prefs.getStringList('favorites') ?? new List<String>());
    setState(() {
      _favorites = favorites;
    });
    _printDeputies();
  }

  _printDeputies() async {
    List deputies = await fetchDeputies(_page);
    setState(() {
      _page++;
      List filteredDeputies = new List();
      deputies.forEach((deputy) {
        if (_favorites.contains(deputy.id.toString())) {
          filteredDeputies.add(deputy);
        }
      });
      _items.addAll(filteredDeputies);
    });
    if (deputies.length > 0) {
      _printDeputies();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Favoritos'),
        leading: new IconButton(icon: new Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop()),
      ),
      body:  new Scrollbar(
        child: _buildFavoritesList(),
      )
    );
  }

  Widget _buildFavoritesList() {
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        final deputy = _items[i];
        return _buildDeputyRow(deputy);
      },
      itemCount: _items.length,
    );
  }

  Widget _buildDeputyRow(Deputy deputy) {
    return new Card(
      child: new Container(
        padding: const EdgeInsets.all(20.0),
        child: new Row(
          children: <Widget>[
            new Container(
              child: new CircleAvatar(
                backgroundColor: Colors.amber,
                backgroundImage:  new NetworkImage(deputy.picture),
              )
            ),
            new Expanded(
              child: new Container(
                padding: const EdgeInsets.only(left: 20.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      deputy.name,
                      style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w200),
                      overflow: TextOverflow.ellipsis,
                    ),
                    new Text(
                      deputy.stateInitials,
                      style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
                    )
                  ]
                )
              ),
            ),
          ],
        )
      )
    );
  }
}
