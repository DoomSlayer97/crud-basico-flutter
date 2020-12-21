import 'package:formvalidation/src/providers/productos_provider.dart';
import "package:rxdart/rxdart.dart";
import 'package:formvalidation/src/models/producto_model.dart';

class ProductosBloc {

  final _productosController = new BehaviorSubject<List<Producto>>();
  final _cargandoController = new BehaviorSubject<bool>();

  final _productosProvider = new ProductsProvider();

  Stream<List<Producto>> get productosStream => _productosController.stream;
  Stream<bool> get cargandoStream => _cargandoController.stream;

  void cargarProductos() async {

    final productos = await _productosProvider.cargarProductos();

    _productosController.sink.add( productos );

  }

  void agregarProducto( Producto producto ) async {

    _cargandoController.sink.add(false);

    await _productosProvider.crearProducto(producto);

    _cargandoController.sink.add(true);

  }

  void editarProducto( Producto producto ) async {

    _cargandoController.sink.add(false);

    await _productosProvider.editarProducto(producto);

    _cargandoController.sink.add(true);

  }

  void eliminarProducto(int id) async {

    await _productosProvider.eliminarProducto(id);

  }

  dispose() {
    _productosController?.close();
    _cargandoController?.close();
  }

}