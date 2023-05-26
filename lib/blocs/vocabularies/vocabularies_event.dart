part of 'vocabularies_bloc.dart';

abstract class VocabulariesEvent extends Equatable {
  const VocabulariesEvent();

  @override
  List<Object> get props => [];
}

class GetVocabulariesList extends VocabulariesEvent {}

class UpdateVocabulary extends VocabulariesEvent {
  final VocabularyModel vocabulary;

  const UpdateVocabulary(this.vocabulary);

  @override
  List<Object> get props => [vocabulary];
}
