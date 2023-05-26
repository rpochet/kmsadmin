part of 'vocabularies_bloc.dart';

abstract class VocabulariesState extends Equatable {
  const VocabulariesState();

  @override
  List<Object?> get props => [];
}

class VocabulariesInitial extends VocabulariesState {}

class VocabulariesLoading extends VocabulariesState {}

class VocabulariesLoaded extends VocabulariesState {
  final VocabulariesModel vocabulariesModel;
  const VocabulariesLoaded(this.vocabulariesModel);

  @override
  List<Object?> get props => [vocabulariesModel];
}

class VocabulariesError extends VocabulariesState {
  final String message;
  const VocabulariesError(this.message);

  @override
  List<Object?> get props => [message];
}

class VocabularyLoading extends VocabulariesState {
  final VocabularyModel vocabularyModel;
  const VocabularyLoading(this.vocabularyModel);

  @override
  List<Object?> get props => [vocabularyModel];
}

class VocabularyLoaded extends VocabulariesState {
  final VocabularyModel vocabularyModel;
  const VocabularyLoaded(this.vocabularyModel);

  @override
  List<Object?> get props => [vocabularyModel];
}

class VocabularyError extends VocabulariesState {
  final VocabularyModel vocabularyModel;
  final String error;
  const VocabularyError(this.vocabularyModel, this.error);

  @override
  List<Object?> get props => [vocabularyModel, error];
}
