part of 'dataservices_bloc.dart';

abstract class DataservicesEvent extends Equatable {
  const DataservicesEvent();

  @override
  List<Object> get props => [];
}

class GetDataservicesList extends DataservicesEvent {}

class UpdateDataservice extends DataservicesEvent {
  final DataserviceModel dataservice;

  const UpdateDataservice(this.dataservice);

  @override
  List<Object> get props => [dataservice];
}
