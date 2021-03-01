import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';

import 'package:band_names_app/src/models/band_model.dart';

import 'package:band_names_app/src/services/socket_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<BandModel> bandas = List();

  SocketService _socketService;

  @override
  void initState() {
    this._socketService = Provider.of<SocketService>(context, listen: false);
    this._socketService.socket.on('bandas', _getBands);
    super.initState();
  }

  void _getBands(dynamic payload) {
    this.bandas =
        (payload as List).map((banda) => BandModel.fromJson(banda)).toList();
    setState(() {});
  }

  @override
  void dispose() {
    this._socketService.socket.off('bandas');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1.0,
        title: Text("Bandas", style: TextStyle(color: Colors.black87)),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10.0),
            child: socketService.serverStatus == ServerStatus.Online
                ? Icon(Icons.check_circle, color: Colors.green[300])
                : Icon(Icons.error, color: Colors.red[300]),
          )
        ],
      ),
      body: _body(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: addNewBand,
      ),
    );
  }

  Widget _body() {
    return Container(
      child: Column(
        children: [
          _graph(),
          Expanded(
            child: ListView.builder(
                itemCount: bandas.length,
                itemBuilder: (context, i) => _bandTile(bandas[i])),
          ),
        ],
      ),
    );
  }

  Widget _graph() {
    Map<String, double> dataMap = new Map();

    bandas.forEach((banda) =>
        dataMap.putIfAbsent(banda.name, () => banda.votes.toDouble()));

    return Container(
      width: double.infinity,
      height: 250,
      child: dataMap.isNotEmpty
          ? PieChart(
              dataMap: dataMap,
              animationDuration: Duration(milliseconds: 800),
              chartLegendSpacing: 32,
              chartRadius: MediaQuery.of(context).size.width / 3.2,
              initialAngleInDegree: 0,
              chartType: ChartType.ring,
              ringStrokeWidth: 32,
              centerText: "Bandas",
              legendOptions: LegendOptions(
                showLegendsInRow: false,
                legendPosition: LegendPosition.right,
                showLegends: true,
                legendShape: BoxShape.circle,
                legendTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              chartValuesOptions: ChartValuesOptions(
                showChartValueBackground: true,
                showChartValues: true,
                showChartValuesInPercentage: false,
                showChartValuesOutside: false,
              ),
            )
          : SizedBox(),
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
          onTap: () {
            this._socketService.socket.emit('vote', {'id': band.id});
          }),
      onDismissed: (_) {
        this._socketService.socket.emit('delete-band', {'id': band.id});
      },
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
    if (value.isNotEmpty) {
      this._socketService.socket.emit('add-band', {'name': value});
    }
    Navigator.pop(context);
  }
}
