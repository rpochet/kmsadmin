import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../resources/api_repository.dart';
import '../../models/vocabularies_model.dart';

part 'vocabularies_event.dart';
part 'vocabularies_state.dart';

class VocabulariesBloc extends Bloc<VocabulariesEvent, VocabulariesState> {
  final ApiRepository apiRepository;
  VocabulariesBloc({required this.apiRepository})
      : super(VocabulariesInitial()) {
    on<GetVocabulariesList>((event, emit) async {
      try {
        emit(VocabulariesLoading());
        final mList = await apiRepository.fetchVocabulariesList();
        emit(VocabulariesLoaded(mList));
      } on NetworkError {
        emit(const VocabulariesError(
            'Failed to fetch data. Is your device online?'));
      }
    });
    on<UpdateVocabulary>((event, emit) async {
      try {
        emit(VocabularyLoading(event.vocabulary));
        final mList = await apiRepository.updateVocabulary(event.vocabulary);
        VocabularyModel vocabulary = mList.item1;
        String? error = mList.item2;
        if (error != null) {
          emit(VocabularyError(vocabulary, error));
        } else {
          emit(VocabularyLoaded(vocabulary));
        }
      } on NetworkError {
        emit(VocabularyError(
            event.vocabulary, 'Failed to fetch data. Is your device online?'));
      }
    });
  }
}
