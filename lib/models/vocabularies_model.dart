class VocabulariesModel {
  List<VocabularyModel> vocabularies;

  VocabulariesModel({required this.vocabularies});

  factory VocabulariesModel.fromJson(Map<String, dynamic> json) =>
      VocabulariesModel(
        vocabularies: json['results']['bindings']
            .map((d) => VocabularyModel.fromJson(d))
            .cast<VocabularyModel>()
            .toList(),
      );
}

class VocabularyModel {
  String name;
  String type;
  String path;
  String namedGraphUri;
  String format;

  VocabularyModel(
      {required this.name,
      required this.type,
      required this.path,
      required this.namedGraphUri,
      required this.format});

  factory VocabularyModel.fromJson(Map<String, dynamic> json) =>
      VocabularyModel(
        name: json['name']['value'],
        type: json['type']['value'],
        path: json['path']['value'],
        namedGraphUri: json['namedGraphUri']['value'],
        format: json['format']['value'],
      );
}
