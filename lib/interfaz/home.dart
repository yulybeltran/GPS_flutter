import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:reto4/controlador/controladorgeneral.dart';
import 'package:reto4/interfaz/listar.dart';
import 'package:reto4/peticiones/peticionesBD.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Location',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  controladorGeneral Control = Get.find();
  void consultarPosicion() async {
    Position posi = await peticionesBD.determinePosition();
    Control.cargarPOS(posi.toString());
    print(posi.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () {
                Alert(
                        type: AlertType.warning,
                        title: "ATENCIÖN!!!",
                        desc:
                            "Esta seguro que deea eliminar TODAS las ubicaciones.",
                        buttons: [
                          DialogButton(
                              color: Colors.green,
                              child: Text("SI"),
                              onPressed: () {
                                peticionesBD.EliminarTodos();
                                Control.CargarBDtotal();
                                Navigator.pop(context);
                              }),
                          DialogButton(
                              color: Colors.red,
                              child: Text("NO"),
                              onPressed: () {
                                Navigator.pop(context);
                              })
                        ],
                        context: context)
                    .show();
              },
              icon: Icon(Icons.delete_forever_outlined))
        ],
      ),
      body: listar(),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.location_on_outlined),
          onPressed: () {
            consultarPosicion();
            Alert(
                    title: "ATENCION!!!",
                    desc: "Seguro desea registrar esta ubicación" +
                        Control.POS +
                        "?",
                    type: AlertType.info,
                    buttons: [
                      DialogButton(
                          color: Colors.green,
                          child: Text("Si"),
                          onPressed: () {
                            final coordenadas = Control.POS;
                            final fechahora = DateTime.now();
                            peticionesBD.guardarPocision(
                                coordenadas, fechahora.toString());
                            Control.CargarBDtotal();
                            Navigator.pop(context);
                          }),
                      DialogButton(
                          color: Colors.red,
                          child: Text("No"),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ],
                    context: context)
                .show();
          }),
    );
  }
}
