part of 'listacuenta_bloc.dart';


abstract class ListacuentaState extends Equatable {
  const ListacuentaState();
  
  @override
  List<Object> get props => [];
}

class ListacuentaInitial extends ListacuentaState {}

class ListacuentaErrorState extends ListacuentaState {
  final String errMsg;

  ListacuentaErrorState({required this.errMsg});

  @override
  List<Object> get props => [errMsg];
}

class ListcuentaReady extends ListacuentaState {
  final Map mapaCuenta;

  ListcuentaReady({required this.mapaCuenta});

  @override
  List<Object> get props => [];
}