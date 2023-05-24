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
