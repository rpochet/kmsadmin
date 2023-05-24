import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../resources/api_repository.dart';
import '../../models/dataservices_model.dart';

part 'dataservice_event.dart';
part 'dataservice_state.dart';

class DataserviceBloc extends Bloc<DataserviceEvent, DataserviceState> {
  final ApiRepository apiRepository;
  DataserviceBloc({required this.apiRepository}) : super(DataserviceInitial()) {
    on<UpdateDataservice>((event, emit) async {
      try {
        emit(DataserviceLoading());
        final mList = await apiRepository.updateDataservice(event);
        emit(DataserviceLoaded(mList));
      } on NetworkError {
        emit(const DataserviceError(
            "Failed to update dataservice. Is your device online?"));
      }
    });
  }
}
