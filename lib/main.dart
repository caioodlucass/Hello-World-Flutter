import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(),
    );
  }
}

 class MyHomePage extends StatefulWidget {

  MyHomePageState createState() => new MyHomePageState();

}
 class MyHomePageState extends State<MyHomePage> {

  String cep;
  var data;
  int status = 0;

  // 0 => Inicial (sem saida)
  // 1 => Carregando
  // 2 => OK
  // 3 => Erro

  final _formKey = new GlobalKey<FormState>();

  void submit() async{

    if(_formKey.currentState.validate()){
setState(() {
  status = 1; //Início

});
      _formKey.currentState.save();
      var response = await http.get('http://api.postmon.com.br/v1/cep/$cep');//no site 99apis tem essas urls
      //var response = await http.get('http://api.postmon.com.br/v1/cep/+cep');
      if(response.statusCode == 200) //200 é OK! e 400 ou 404 é erro
        setState(() {
          status = 2; //sucesso!
          data: json.decode(response.body);
        });
      else
        setState(() {
          status = 3;//Erro
        });
    }
  }

  Widget responseWidget() => status == 0?
  SizedBox(): status == 1?
      Center(child: CircularProgressIndicator()):
      status == 2?
      Center(
        child: Column(
        children: <Widget>[
          Icon(Icons.home, size: 60,),
          data['logradouro'] != null
          ?Text(data['logradouro'],
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w200),) //data = variavel; logradouro = posição, a string onde o dado foi armazenado
          ?Text(data['Não há rua'], style:  TextStyle( fontSize: 30, fontWeight: FontWeight.w200),

  )
      )
      : Center(
    child: Column(
      children: <Widget>[
        Icon(Icons.close),
        Text(data['Erro no CEP'])
      ],
    ),
  );


  @override
   Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Decode de cep'),
        centerTitle: true,backgroundColor: Colors.amber,

      ),
      body: Column(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Padding(//delimitar espaçamento para inserir dados, formando uma caixinha, sem isso a linha de inserção é de fora a fora
              padding: EdgeInsets.all(20),
              child: TextFormField( //TextFormField é a linha de inserção que faz subir o teclado

                validator: (inputText){
                  if(inputText.isEmpty)return 'Digite algo';
                  if(inputText.length<8)return 'Digite um cep valido';
                  return null;
                },

                onSaved: (inputText){
                  cep: inputText;
                },

                //coisas de Design
                maxLength: 8,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText:  'Digite seu cep'),


              ),
            ) ,
          ),
          Center(
            child: FlatButton(
              child: Text('Buscar'),
              onPressed: () => submit(),
            ),
          ),
          SizedBox(
            height: 50,
          ),
          responseWidget()
        ],

      ),
    );
  }

 }

