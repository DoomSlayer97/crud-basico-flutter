import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/models/producto_model.dart';
import 'package:formvalidation/src/providers/productos_provider.dart';
import 'package:formvalidation/src/utils/utils.dart' as utils;

class ProductoPage extends StatefulWidget {

  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  ProductosBloc productosBloc;
  Producto producto = new Producto();

  bool _esNuevo = true;

  @override
  Widget build(BuildContext context) {

    productosBloc = Provider.productosBloc(context);
    final Producto prodData = ModalRoute.of(context).settings.arguments;

    if ( prodData != null ) {

      _esNuevo = false;

      producto = prodData;

    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Productos"),
        actions: [
          _crearBotonEliminar(context)
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _crearNombre(),
                _crearPrecio(),
                _crearDisponible(),
                _crearButton()
              ],
            ),
          ),
        ),
      )
    );
  }

  Widget _crearBotonEliminar(BuildContext context) {

    if (!_esNuevo) return IconButton(
      icon: Icon( Icons.delete ),
      onPressed: () {
      
        productosBloc.eliminarProducto(producto.id);

        productosBloc.cargarProductos();

        Navigator.pop(context);

      },
    );
    else return Container();

  }

  Widget _crearNombre() {
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: "Producto"
      ),
      onSaved: (value) => producto.titulo = value,
    );
  }

  Widget _crearPrecio() {
    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: "Precio"
      ),
      onSaved: (value) => producto.valor = double.parse(value),
      validator: (value) {
      
        if ( utils.isNumeric(value) ) {
          return null;
        } else {
          return "Solo números";
        }

      },
    );
  }

  Widget _crearDisponible() {
    return SwitchListTile(
      value: producto.disponible,
      title: Text("Disponible"),
      activeColor: Colors.deepPurple,
      onChanged: ( value ) => setState(() {
        producto.disponible = value;
      }),
    );
  }

  Widget _crearButton() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      color: Colors.deepPurple,
      textColor: Colors.white,
      label: Text("Guardar"),
      icon: Icon( Icons.save ),
      onPressed: _submit,
    );
  }

  void _submit() {

    formKey.currentState.validate();

    if ( !formKey.currentState.validate() ) return;

    formKey.currentState.save();

    if ( producto.id == null ) {

      productosBloc.agregarProducto(producto);

    } else {

      productosBloc.editarProducto(producto);

    }

    productosBloc.cargarProductos();

    Navigator.pop(context);

  }

  void mostrarSnackbar(String mensaje) {

    final snackbar = SnackBar(
      content: Text(mensaje),
      duration: Duration( milliseconds: 1500 )
    );

    Scaffold.of(context).showSnackBar(snackbar);

  }


}



