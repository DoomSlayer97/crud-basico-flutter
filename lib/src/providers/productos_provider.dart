
import "dart:convert";
import 'package:formvalidation/src/models/producto_model.dart';
import 'package:rxdart/rxdart.dart';
import "package:http/http.dart" as http;

class ProductsProvider {

  final String _url = "http://192.168.100.34:3000/api";  

  Future<bool> crearProducto ( Producto producto ) async {

    final url = "$_url/productos";

    final resp = await http.post( url, body: productoToJson( producto ), headers: {
      "Content-Type": "application/json"
    });

    final decodedData = json.decode(resp.body);

    return true;

  }

  Future<bool> editarProducto ( Producto producto ) async {

    final url = "$_url/productos/${producto.id.toString()}";

    final resp = await http.put( url, body: productoToJson( producto ), headers: {
      "Content-Type": "application/json"
    });

    final decodedData = json.decode(resp.body);

    return true;

  }

  Future<List<Producto>> cargarProductos() async {

    final url = "$_url/productos";
    final resp = await http.get(url);

    final List<dynamic> decodedData = json.decode(resp.body);
    final List<Producto> productos = new List();

    if (decodedData == null) return [];

    decodedData.forEach( (prod) {

      final prodTemp = Producto.fromJson(prod);

      productos.add(prodTemp);

    });

    productos.forEach( (item) {
      print(json.encode(item.toJson()));
    });

    return productos;

  }

  Future<Producto> cargarProducto(int id) async {

    final url = "$_url/productos/$id";

    final resp = await http.get(url);

    Producto findedProducto = Producto.fromJson( json.decode(resp.body) );

    return findedProducto;

  }

  Future<int> eliminarProducto( int id ) async {

    final url = "$_url/productos/$id";

    final resp = await http.delete(url);

    return 1;

  }

}

