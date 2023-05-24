part of 'dataservices_bloc.dart';

abstract class DataservicesEvent extends Equatable {
  const DataservicesEvent();

  @override
  List<Object> get props => [];
}

class GetDataservicesList extends DataservicesEvent {}
