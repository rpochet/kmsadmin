part of 'sparql_bloc.dart';

abstract class SparqlEvent extends Equatable {
  const SparqlEvent();

  @override
  List<Object> get props => [];
}

class GetSparqlQueriesList extends SparqlEvent {}
