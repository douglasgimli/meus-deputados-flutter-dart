import 'package:flutter/material.dart';
import 'src/pages/deputies-list.dart';

void main() => runApp(new MaterialApp(
  title: 'Deputies',
  theme: new ThemeData(
    primarySwatch: Colors.indigo,
  ),
  home: new ListDeputiesPage(title: 'Deputados'),
));
