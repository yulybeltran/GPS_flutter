import 'package:get/get.dart';
import 'package:reto4/peticiones/peticionesBD.dart';

class controladorGeneral extends GetxController {
  final Rxn<List<Map<String, dynamic>>> _listaPosicion =
      Rxn<List<Map<String, dynamic>>>();

  final _POS = "".obs;
  void cargarPOS(String x) {
    _POS.value = x;
  }

  String get POS => _POS.value;

  void cargarPosicion(List<Map<String, dynamic>> X) {
    _listaPosicion.value = X;
  }

  List<Map<String, dynamic>>? get ListaPosicion => _listaPosicion.value;

  Future<void> CargarBDtotal() async {
    final datos = await peticionesBD.ListarTodasPocisiones();
    cargarPosicion(datos);
  }
}
