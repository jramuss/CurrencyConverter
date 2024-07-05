import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    home: Home(),
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          hintStyle: TextStyle(color: Colors.amber),
        )),
  ));
}

final url = 'http://economia.awesomeapi.com.br/json/last/USD-BRL,EUR-BRL';

Future <Map<String,dynamic>>getData() async {
  final response = await http.get(Uri.parse(url));
  var responseDecode = jsonDecode(response.body);
  return responseDecode;
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();


  late double dolar ;
  late double euro;

  void _clearAll(){
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  void _realChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }
  void _dolarChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar* this.dolar).toStringAsFixed(2);
    euroController.text = (dolar*this.dolar / euro).toStringAsFixed(2);


  }
  void _euroChanged(String text){
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro* this.euro). toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text(
            ('\$Conversor\$'),
            style: TextStyle(color: Colors.amber),
          ),
          centerTitle: true,
        ),
        body: FutureBuilder <Map<String,dynamic>>(
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return (Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blueGrey,
                  ),
                ));
              } else if (snapshot.hasError) {
                return Text('Erro: ${snapshot.error}',
                    style: TextStyle(color: Colors.white));
              } else {
                dolar = double.parse(snapshot.data!['USDBRL'] ['high'].toString());
                euro = double.parse(snapshot.data!['EURBRL'] ['high'].toString());


                return SingleChildScrollView(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(
                        Icons.monetization_on,
                        size: 150.0,
                        color: Colors.amber,
                      ),
                        buildTextField('Reais', 'R\$', realController, _realChanged),
                      Divider(),
                        buildTextField('Dólares', 'US\$', dolarController,_dolarChanged),
                      Divider(),
                      buildTextField('Euros', '€', euroController, _euroChanged),
                    ],
                  ),
                );
              }
            }));
  }
}
 Widget buildTextField(String label, String prefix,TextEditingController c,Function f){
  return TextField(
    controller: c,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.amber),
      border: OutlineInputBorder(),
      prefixText: prefix,
    ),
    style: TextStyle(
        color: Colors.amber, fontSize: 25
    ),
    onChanged: (texto){
      f(texto);
    },
    keyboardType: TextInputType.number,
  );

}
