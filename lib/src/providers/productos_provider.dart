
import "dart:convert";
import 'package:formvalidation/src/models/producto_model.dart';
import 'package:rxdart/rxdart.dart';
import "package:http/http.dart" as http;

class ProductsProvider {

  final String _url = "http://192.168.100.34:3000/api";  

  Future<bool> crearProducto ( Producto producto ) async {

    final url = "$_url/productos";

    print( productoToJson( producto ) );

    final resp = await http.post( url, body: productoToJson( producto ), headers: {
      "Content-Type": "application/json"
    });

    final decodedData = json.decode(resp.body);

    print( decodedData );

    return true;

  }

  Future<bool> editarProducto ( Producto producto ) async {

    final url = "$_url/productos/${producto.id.toString()}";

    print( productoToJson( producto ) );

    final resp = await http.put( url, body: productoToJson( producto ), headers: {
      "Content-Type": "application/json"
    });

    final decodedData = json.decode(resp.body);

    print( decodedData );

    return true;

  }

  Future<List<Producto>> cargarProductos() async {

    final url = "$_url/productos";
    final resp = await http.get(url);

    if (resp.body == null) return [];

    final List<dynamic> decodedData = json.decode(resp.body);
    final List<Producto> productos = new List();

    if ( decodedData == null ) return [];

    decodedData.forEach( (prod) {

      final prodTemp = Producto.fromJson(prod);

      productos.add(prodTemp);

    });

    return productos;

  }

  Future<int> eliminarProducto( int id ) async {

    final url = "$_url/productos/$id";

    final resp = await http.delete(url);

    print(resp.body);

    return 1;

  }

}

