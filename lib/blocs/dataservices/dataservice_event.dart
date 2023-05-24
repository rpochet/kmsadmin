part of 'dataservice_bloc.dart';

abstract class DataserviceEvent extends Equatable {
  const DataserviceEvent();

  @override
  List<Object> get props => [];
}

class UpdateDataservice extends DataserviceEvent {
  final String name;
  final String uri;

  const UpdateDataservice(this.name, this.uri);
}
