part of 'sparql_bloc.dart';

abstract class SparqlState extends Equatable {
  const SparqlState();

  @override
  List<Object?> get props => [];
}

class SparqlInitial extends SparqlState {}

class SparqlQueriesLoading extends SparqlState {}

class SparqlQueriesLoaded extends SparqlState {
  final SparqlQueriesModel sparqlQueriesModel;
  const SparqlQueriesLoaded(this.sparqlQueriesModel);

  @override
  List<Object?> get props => [sparqlQueriesModel];
}

class SparqlError extends SparqlState {
  final String message;
  const SparqlError(this.message);

  @override
  List<Object?> get props => [message];
}
