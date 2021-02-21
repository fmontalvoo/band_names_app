import 'package:band_names_app/src/models/band_model.dart';
import 'package:flutter/material.dart';

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
    // bandas.addAll([
    //   BandModel(id: "1", name: "Heroes del silencio", votes: 5),
    //   BandModel(id: "2", name: "Megadeth", votes: 4),
    //   BandModel(id: "3", name: "AC/DC", votes: 3),
    //   BandModel(id: "4", name: "Scorpions", votes: 3),
    // ]);
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
        onPressed: () {},
      ),
    );
  }

  ListTile _bandTile(BandModel band) {
    return ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(band.name),
        trailing: Text('${band.votes}'),
        onTap: () {});
  }
}
