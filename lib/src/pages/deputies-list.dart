import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/deputy.dart';
import 'favorites-list.dart';

class ListDeputiesPage extends StatefulWidget {
  ListDeputiesPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ListDeputiesState createState() => new _ListDeputiesState();
}

class _ListDeputiesState extends State<ListDeputiesPage> {
  ScrollController controller;

  int _page = 1;
  bool _fetchingDeputies = false;
  final _items = new List();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<String> _favorites = new List<String>();

  @override
  void initState() {
    controller = new ScrollController()..addListener(_scrollListener);
    _printDeputies();
    _getFavorites();
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  _printDeputies() async {
    List deputies = await fetchDeputies(_page);
    setState(() {
      _page++;
      _items.addAll(deputies);
      _fetchingDeputies = false;
    });
  }

  void _scrollListener() {
    if (controller.position.extentAfter < 500 && !_fetchingDeputies) {
      setState(() {
        _fetchingDeputies = true;
      });
      _printDeputies();
    }
  }

  _getFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favorites = (prefs.getStringList('favorites') ?? new List<String>());
    setState(() {
      _favorites = favorites;
    });
  }

  _saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', _favorites);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            new UserAccountsDrawerHeader(
                accountName: new Text("Meus Deputados"), accountEmail: null),
            new Column(children: [
              new ListTile(
                leading: new Icon(Icons.people),
                title: new Text("Deputados"),
                selected: true,
              ),
              new ListTile(
                leading: new Icon(Icons.favorite),
                title: new Text("Favoritos"),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (context) => new ListFavoritesPage()),
                  );
                },
              )
            ])
          ],
        ),
      ),
      appBar: new AppBar(
        title: new Text(widget.title),
        leading: new IconButton(icon: new Icon(Icons.menu),
            onPressed: () => _scaffoldKey.currentState.openDrawer()),
      ),
      body:  new Scrollbar(
        child: _buildDeputiesList(),
      )
    );
  }

  Widget _buildDeputiesList() {
    return new ListView.builder(
      controller: controller,
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        return _buildDeputyRow(_items[i]);
      },
      itemCount: _items.length,
    );
  }

  Widget _buildDeputyRow(Deputy deputy) {
    bool isFavorite = _favorites.contains(deputy.id.toString());

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
            new Container(
              child: new GestureDetector(
                child: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.black45
                ),
                onTap: () {
                  setState(() {
                    if (isFavorite) {
                      _favorites.remove(deputy.id.toString());
                    }
                    else {
                      _favorites.add(deputy.id.toString());
                    }
                    _saveFavorites();
                  });
                },
              ),
            ),
          ],
        )
      )
    );
  }
}
