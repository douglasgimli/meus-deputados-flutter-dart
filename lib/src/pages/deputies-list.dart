import 'package:flutter/material.dart';

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
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: _buildDeputiesList(),
    );
  }

  Widget _buildDeputiesList() {
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        // return new Divider();
        return _buildDeputyRow();
      },
      itemCount: 2,
    );
  }

  Widget _buildDeputyRow() {
    return new Container(
      padding: const EdgeInsets.all(20.0),
      child: new Row(
        children: <Widget>[
          new Column(
            children: <Widget>[
              new CircleAvatar(
                backgroundColor: Colors.amber,
              )
            ],
          ),
          new Column(
            children: <Widget>[
              new Container(
                padding: const EdgeInsets.all(20.0),
                child: new Row(
                  children: <Widget>[
                    new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Text(
                          'Meu deputado',
                          style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w200),
                        ),
                        new Text(
                          'Informações do deputado',
                          style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal),
                        )
                      ]
                    )
                  ],
                )
              )
            ],
          )
        ],
      )
    );
  }
}
