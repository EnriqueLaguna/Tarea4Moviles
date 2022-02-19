part of 'listacuenta_bloc.dart';

abstract class ListacuentaEvent extends Equatable {
  const ListacuentaEvent();

  @override
  List<Object> get props => [];
}

class LoadListaCuentas extends ListacuentaEvent {
  
}