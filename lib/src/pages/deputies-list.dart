import 'dart:async';
import 'package:flutter/material.dart';
import '../services/deputy.dart';

class DeputiesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Deputies',
      theme: new ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: new ListDeputiesPage(title: 'Deputados'),
    );
  }
}

class ListDeputiesPage extends StatefulWidget {
  ListDeputiesPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ListDeputiesState createState() => new _ListDeputiesState();
}

class _ListDeputiesState extends State<ListDeputiesPage> {
  ScrollController controller;
  List items = new List();
  int page = 1;
  bool fetchingDeputies = false;

  @override
  void initState() {
    controller = new ScrollController()..addListener(_scrollListener);
    _printDeputies();
    super.initState();
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  _printDeputies() async {
    List deputies = await fetchDeputies(page);
    setState(() {
      page++;
      items.addAll(deputies);
      fetchingDeputies = false;
    });
  }

  void _scrollListener() {
    if (controller.position.extentAfter < 500 && !fetchingDeputies) {
      setState(() {
        fetchingDeputies = true;
      });
      _printDeputies();
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
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
        if (items.length > 0) {
          return _buildDeputyRow(items[i]);
        }
        return new CircularProgressIndicator();
      },
      itemCount: items.length,
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
            new Container(
              child: new Icon(Icons.favorite_border, color: Colors.black45)
            ),
          ],
        )
      )
    );
  }
}
