import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_id/device_id.dart';

class LendHistory extends StatefulWidget {
  @override
  _LendHistoryState createState() => _LendHistoryState();
}

class _LendHistoryState extends State<LendHistory> {
  String _deviceid = 'Unknown';

  @override
  void initState() {
    super.initState();
    initDeviceId();
  }

  Future<void> initDeviceId() async {
    String deviceid;
    deviceid = await DeviceId.getID;
    if (!mounted) return;
    setState(
      () {
        _deviceid = deviceid;
      },
    );
  }

  Widget _lendHistoryCardsBuilder(
      String receipent, String lendContext, int amount, String dateLend) {
    return Padding(
      padding: EdgeInsets.only(top: 2),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.tag_faces,
                color: Colors.red,
              ),
              title: Text(
                "$receipent",
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 8, 0, 1),
                    ),
                    Text(
                      "$lendContext",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 8, 0, 1),
                    ),
                    Text("$dateLend"),
                  ],
                ),
              ),
              trailing: SizedBox(
                child: Text(
                  '₹$amount',
                  textScaleFactor: 1.3,
                ),
                width: 65,
              ),
            ),
            ButtonTheme.bar(
              child: ButtonBar(
                children: <Widget>[
                  FlatButton(
                    child: const Text('Delete'),
                    onPressed: () {
                      Firestore.instance
                          .collection('Users')
                          .document(_deviceid)
                          .collection('lendHistory')
                          .document('$receipent')
                          .delete()
                          .then((_) {
                        print("Document $receipent has been deleted");
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('Users')
          .document(_deviceid)
          .collection('lendHistory')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasError)
              return Center(child: Text('Error: ${snapshot.error}'));
            if (!snapshot.hasData) return Text('No data found!');
            return Container(
              child: SingleChildScrollView(
                child: Column(
                    children: snapshot.data.documents
                        .map((DocumentSnapshot document) {
                  return _lendHistoryCardsBuilder(
                      "${document['Name']}",
                      "${document['Context']}",
                      document['Amount'],
                      "${document['Date']}");
                }).toList()),
              ),
            );
        }
      },
    );
  }
}
