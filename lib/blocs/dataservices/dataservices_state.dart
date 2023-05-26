part of 'dataservices_bloc.dart';

abstract class DataservicesState extends Equatable {
  const DataservicesState();

  @override
  List<Object?> get props => [];
}

class DataservicesInitial extends DataservicesState {}

class DataservicesLoading extends DataservicesState {}

class DataservicesLoaded extends DataservicesState {
  final DataservicesModel dataservicesModel;

  const DataservicesLoaded(this.dataservicesModel);

  @override
  List<Object?> get props => [dataservicesModel];
}

class DataservicesError extends DataservicesState {
  final String message;

  const DataservicesError(this.message);

  @override
  List<Object?> get props => [message];
}

class DataserviceLoading extends DataservicesState {
  final DataserviceModel dataserviceModel;
  const DataserviceLoading(this.dataserviceModel);

  @override
  List<Object?> get props => [dataserviceModel];
}

class DataserviceLoaded extends DataservicesState {
  final DataserviceModel dataserviceModel;
  const DataserviceLoaded(this.dataserviceModel);
}

class DataserviceError extends DataservicesState {
  final DataserviceModel dataserviceModel;
  final String error;
  const DataserviceError(this.dataserviceModel, this.error);

  @override
  List<Object?> get props => [dataserviceModel, error];
}
