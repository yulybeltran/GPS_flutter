import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
              ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    itemCount: Control.ListaPosicion!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.location_on, color: Colors.green),
                          title:
                              Text(Control.ListaPosicion![index]["coordenadas"], style: GoogleFonts.chewy()),
                          subtitle:
                              Text(Control.ListaPosicion![index]["fechahora"],style: GoogleFonts.chewy()),
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
                                              child: Text("SI",style: GoogleFonts.acme()),
                                              onPressed: () {
                                                peticionesBD.EliminarPosicion(
                                                    Control.ListaPosicion![index]
                                                        ["id"]);
                                                Control.CargarBDtotal();
                                                Navigator.pop(context);
                                              }),
                                          DialogButton(
                                              color: Colors.red,
                                              child: Text("NO", style: GoogleFonts.acme()),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              })
                                        ],
                                        context: context)
                                    .show();
                              },
                              icon: Icon(Icons.delete, color: Colors.red)),
                        ),
                      );
                    },
                  ),
              )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ));
  }
}
