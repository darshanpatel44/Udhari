import 'package:flutter/material.dart';
import 'package:udhari/Widgets/borrow.dart';
import 'package:udhari/Widgets/lend.dart';
import 'data_input.dart';
import 'package:udhari/Screens/history.dart';


class First extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Udhari",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  void _showDataScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return InputData();
        },
        fullscreenDialog: true,
      ),
    );
  }

  void _showHistory() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) {
          return History();
        },
        fullscreenDialog: true,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, initialIndex: 0, length: 4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: _showHistory,
            icon: Icon(Icons.history),
          ),
          SizedBox(
            width: 10,
          ),
        ],
        leading: Icon(Icons.face),
        title: Text("Udhari"),
        bottom: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Tab(
              child: Text("Borrow Record"),
            ),
            Tab(
              child: Text("Lend Record"),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Borrow(),
          Lend(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add udhari',
        child: Icon(Icons.add),
        onPressed: _showDataScreen,
      ),
    );
  }
}
