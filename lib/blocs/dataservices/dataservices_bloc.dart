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
            'Failed to fetch dataservices. Is your device online?'));
      }
    });
    on<UpdateDataservice>((event, emit) async {
      try {
        emit(DataserviceLoading(event.dataservice));
        final mList = await apiRepository.updateDataservice(event.dataservice);
        DataserviceModel dataservice = mList.item1;
        String? error = mList.item2;
        if (error != null) {
          emit(DataserviceError(dataservice, error));
        } else {
          emit(DataserviceLoaded(dataservice));
        }
      } on NetworkError {
        emit(DataserviceError(event.dataservice,
            'Failed to update dataservice. Is your device online?'));
      }
    });
  }
}
