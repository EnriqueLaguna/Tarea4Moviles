import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:http/http.dart';

part 'listacuenta_event.dart';
part 'listacuenta_state.dart';

class ListacuentaBloc extends Bloc<ListacuentaEvent, ListacuentaState> {
  ListacuentaBloc() : super(ListacuentaInitial()) {
    on<ListacuentaEvent>(loadListaCuentas);
  }
  final String url = "https://api.sheety.co/d89b0f60f5a721cba13b0538b7530c40/dummyApi/cuentas";

  void loadListaCuentas(ListacuentaEvent event, Emitter emitter) async{
    var MapaCuenta = await _getListacuentas();
    if (MapaCuenta == null){
      emitter(ListacuentaErrorState(errMsg: "Muerte"));
    } else {
      emitter(ListcuentaReady(mapaCuenta: MapaCuenta));

    }
    
  }

  Future _getListacuentas() async {
    try {
      Response res = await get(Uri.parse(url));
      if(res.statusCode == HttpStatus.ok)
        return jsonDecode(res.body);
    } catch (e) {print(e);}
  }

}

