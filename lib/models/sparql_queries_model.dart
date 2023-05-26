class SparqlQueriesModel {
  List<SparqlQueryModel> sparqlQueries;

  SparqlQueriesModel({required this.sparqlQueries});

  factory SparqlQueriesModel.fromJson(Map<String, dynamic> json) =>
      SparqlQueriesModel(
        sparqlQueries: json['results']['bindings']
            .map((d) => SparqlQueryModel.fromJson(d))
            .cast<SparqlQueryModel>()
            .toList(),
      );
}

class SparqlQueryModel {
  String name;
  String query;

  SparqlQueryModel({required this.name, required this.query});

  factory SparqlQueryModel.fromJson(Map<String, dynamic> json) =>
      SparqlQueryModel(
        name: json['name']['value'],
        query: json['query']['value'],
      );
}
