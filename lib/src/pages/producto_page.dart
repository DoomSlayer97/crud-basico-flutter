import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/models/producto_model.dart';
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

  bool _salidaAlert = false;
  bool _guardando = false;

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
        )
      )
    );
  }

  Widget _crearBotonEliminar(BuildContext context) {

    if (!_esNuevo) return IconButton(
      icon: Icon( Icons.delete ),
      onPressed: ()  async {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Atencion"),
            content: Text("¿Desea eliminar el producto?"),
            actions: [
              FlatButton(
                child: Text("Ok"),
                onPressed: () {

                  productosBloc.eliminarProducto(producto.id);

                  setState(() {

                    _salidaAlert = true;           
                    Navigator.of(context).pop();    

                  });


                },
              ),
              FlatButton(
                child: Text("Cancel"),
                onPressed: () {

                  setState(() {

                    _salidaAlert = false;           
                    Navigator.of(context).pop();    
                    
                  });

                  
                },
              )
            ],
          )
        );
        
        if (_salidaAlert) {

          Navigator.pop(context);

        }



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

    setState(() {_guardando = true; });

    if ( producto.id == null ) {

      productosBloc.agregarProducto(producto);

    } else {

      productosBloc.editarProducto(producto);

    }

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



