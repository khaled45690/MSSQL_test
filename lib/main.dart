import 'package:flutter/material.dart';
import 'package:sql_conn/sql_conn.dart';
import 'package:sql_conn/sql_conn.dart';

import 'src/Feature/DeliveryData/DeliveryDataScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const DeliveryDataScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  @override
  initState() {
    super.initState();
    connectToDataBase();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
  
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

void connectToDataBase() async {
 await SqlConn.connect(
      ip: "196.218.142.75",
      port: "1455",
      databaseName: "10102020",
      username: "sa",
      password: "bbs66666");
      
  print(SqlConn.isConnected);
  var res = await SqlConn.readData("SELECT * from dbo.Products");
    print(res);

     await SqlConn.disconnect();
}
