import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../resources/api_repository.dart';
import '../../models/sparql_queries_model.dart';

part 'sparql_event.dart';
part 'sparql_state.dart';

class SparqlBloc extends Bloc<SparqlEvent, SparqlState> {
  final ApiRepository apiRepository;
  SparqlBloc({required this.apiRepository}) : super(SparqlInitial()) {
    on<GetSparqlQueriesList>((event, emit) async {
      try {
        emit(SparqlQueriesLoading());
        final mList = await apiRepository.fetchSparqlQueriesList();
        emit(SparqlQueriesLoaded(mList));
      } on NetworkError {
        emit(const SparqlError("Failed to fetch data. Is your device online?"));
      }
    });
  }
}
