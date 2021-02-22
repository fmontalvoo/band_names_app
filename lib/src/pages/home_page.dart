import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:band_names_app/src/models/band_model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<BandModel> bandas = [
    BandModel(id: "1", name: "Heroes del silencio", votes: 5),
    BandModel(id: "2", name: "Megadeth", votes: 4),
    BandModel(id: "3", name: "AC/DC", votes: 3),
    BandModel(id: "4", name: "Scorpions", votes: 3),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        title: Text("Bandas", style: TextStyle(color: Colors.black87)),
      ),
      body: Container(
        child: ListView.builder(
            itemCount: bandas.length,
            itemBuilder: (context, i) => _bandTile(bandas[i])),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: addNewBand,
      ),
    );
  }

  Widget _bandTile(BandModel band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        child: Icon(
          Icons.delete_forever,
          color: Colors.white,
          size: 42.0,
        ),
      ),
      child: ListTile(
          leading: CircleAvatar(
            child: Text(band.name.substring(0, 2)),
            backgroundColor: Colors.blue[100],
          ),
          title: Text(band.name),
          trailing: Text('${band.votes}'),
          onTap: () {}),
      onDismissed: (direction) {},
    );
  }

  void addNewBand() {
    final textEditingController = TextEditingController();
    if (Platform.isAndroid)
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Nombre de la banda:"),
                content: TextField(
                  controller: textEditingController,
                ),
                actions: [
                  MaterialButton(
                    child: Text("Add"),
                    textColor: Colors.blue,
                    elevation: 1.0,
                    onPressed: () => addBand(textEditingController.text),
                  )
                ],
              ));
    else
      showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
                title: Text("Nombre de la banda:"),
                content: CupertinoTextField(
                  controller: textEditingController,
                ),
                actions: [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: Text("Add"),
                    onPressed: () => addBand(textEditingController.text),
                  ),
                  CupertinoDialogAction(
                    isDestructiveAction: true,
                    child: Text("Close"),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ));
  }

  void addBand(String value) {
    print(value);
    if (value.isNotEmpty) {
      setState(() {
        this
            .bandas
            .add(new BandModel(id: DateTime.now().toString(), name: value));
      });
    }
    Navigator.pop(context);
  }
}
