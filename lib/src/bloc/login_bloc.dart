
import 'dart:async';

import 'package:formvalidation/src/bloc/validators.dart';
import 'package:rxdart/rxdart.dart';


class LoginBloc with Validators {

  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  //Recuperar los datos del string
  Stream<String> get emailStream => _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream => _passwordController.stream.transform(validarPassword);

  Stream<bool> get formValidStream => Rx.combineLatest2(
    emailStream,
    passwordStream,
    (e, p) => true
  );

  /* Insertar valores al string */
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  
  void dispose() {
    _emailController?.close();
    _passwordController?.close();
  }

  //obtener el ultimo valor integrado a los streams
  String get email    => _emailController.value;
  String get password => _passwordController.value;
  

}

