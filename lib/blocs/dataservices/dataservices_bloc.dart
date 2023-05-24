import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../resources/api_repository.dart';
import '../../models/dataservices_model.dart';

part 'dataservices_event.dart';
part 'dataservices_state.dart';

class DataservicesBloc extends Bloc<DataservicesEvent, DataservicesState> {
  final ApiRepository apiRepository;
  DataservicesBloc({required this.apiRepository})
      : super(DataservicesInitial()) {
    on<GetDataservicesList>((event, emit) async {
      try {
        emit(DataservicesLoading());
        final mList = await apiRepository.fetchDataservicesList();
        emit(DataservicesLoaded(mList));
      } on NetworkError {
        emit(const DataservicesError(
            "Failed to fetch dataservices. Is your device online?"));
      }
    });
  }
}
