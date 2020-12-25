
import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/models/producto_model.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final productosBloc = Provider.productosBloc(context);
    productosBloc.cargarProductos();

    return Scaffold(
      appBar: AppBar(
        title: Text("Listado productos")
      ),
      body: _crearListado(productosBloc),
      floatingActionButton: _crearButton(context),
    );
  }

  Widget _crearListado(ProductosBloc productosBloc) {

    return StreamBuilder(
      stream: productosBloc.productosStream,
      builder: (BuildContext context, AsyncSnapshot<List<Producto>> snapshot){
        if ( snapshot.hasData ) {

          final productos = snapshot.data;

          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, i) => _crearItem(productos[i], productosBloc ,context)
          );

        } else {
          return Center( child: CircularProgressIndicator() );
        }
      },
    );

  }

  Widget _crearButton(BuildContext context) {

    return FloatingActionButton(
      child: Icon( Icons.add ),
      backgroundColor: Colors.deepPurple,
      onPressed: () => Navigator.pushNamed( context, "producto" ),
    );

  }

  Widget _crearItem(Producto producto, ProductosBloc productosBloc ,BuildContext context) {

    return ListTile(
      title: Text('${producto.titulo} - ${producto.valor}'),
      subtitle: Text( producto.disponible.toString() ),
      trailing: Icon( Icons.arrow_right ),
      onTap: () async {

        await Navigator.pushNamed(context, "producto", arguments: producto);

      } 
    );
  }

}
