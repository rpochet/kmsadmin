part of 'dataservice_bloc.dart';

abstract class DataserviceState extends Equatable {
  const DataserviceState();

  @override
  List<Object?> get props => [];
}

class DataserviceInitial extends DataserviceState {}

class DataserviceLoading extends DataserviceState {}

class DataserviceLoaded extends DataserviceState {
  final DataserviceModel dataserviceModel;
  const DataserviceLoaded(this.dataserviceModel);
}

class DataserviceError extends DataserviceState {
  final String? message;
  const DataserviceError(this.message);
}
