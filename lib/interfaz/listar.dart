import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reto4/controlador/controladorgeneral.dart';
import 'package:reto4/peticiones/peticionesBD.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class listar extends StatefulWidget {
  const listar({super.key});

  @override
  State<listar> createState() => _listarState();
}

class _listarState extends State<listar> {
  @override
  controladorGeneral Control = Get.find();
  void initState() {
    super.initState();
    Control.CargarBDtotal();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          child: Control.ListaPosicion?.isEmpty == false
              ? ListView.builder(
                  itemCount: Control.ListaPosicion!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: ListTile(
                        leading: Icon(Icons.location_on),
                        title:
                            Text(Control.ListaPosicion![index]["coordenadas"]),
                        subtitle:
                            Text(Control.ListaPosicion![index]["fechahora"]),
                        trailing: IconButton(
                            onPressed: () {
                              Alert(
                                      type: AlertType.warning,
                                      title: "ATENCIÖN!!!",
                                      desc:
                                          "Esta seguro que desea eliminar ESTA ubicación.",
                                      buttons: [
                                        DialogButton(
                                            color: Colors.green,
                                            child: Text("SI"),
                                            onPressed: () {
                                              peticionesBD.EliminarPosicion(
                                                  Control.ListaPosicion![index]
                                                      ["id"]);
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
                            icon: Icon(Icons.delete_forever)),
                      ),
                    );
                  },
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ));
  }
}
