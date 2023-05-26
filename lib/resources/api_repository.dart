import 'package:kmsadmin/models/vocabularies_model.dart';
import 'package:tuple/tuple.dart';

import '../main.dart';
import '../models/dataservices_model.dart';
import '../models/sparql_queries_model.dart';
import 'api_provider.dart';
import 'data_storage.dart';

class ApiRepository {
  final _provider = ApiProvider();
  static DataStorage storage = new DataStorage();

  Future<DataservicesModel> fetchDataservicesList() async {
    if (Environment.useLocalApi) {
      return Future.value(DataservicesModel.fromJson(
          await storage.readJson("dataservices.srj")));
    } else {
      return _provider.fetchDataservices();
    }
  }

  Future<Tuple2<DataserviceModel, String?>> updateDataservice(dataservice) {
    Future<String?> error = _provider.updateDataservice(dataservice);
    return error
        .then((value) => Tuple2<DataserviceModel, String?>(dataservice, value));
  }

  Future<SparqlQueriesModel> fetchSparqlQueriesList() async {
    if (Environment.useLocalApi) {
      return Future.value(
          SparqlQueriesModel.fromJson(await storage.readJson("queries.srj")));
    } else {
      return _provider.fetchSparqlQueries();
    }
  }

  Future<VocabulariesModel> fetchVocabulariesList() async {
    if (Environment.useLocalApi) {
      return Future.value(VocabulariesModel.fromJson(
          await storage.readJson("vocabularies.srj")));
    } else {
      return _provider.fetchVocabularies();
    }
  }

  Future<Tuple2<VocabularyModel, String?>> updateVocabulary(vocabulary) {
    Future<String?> error = _provider.updateVocabulary(vocabulary);
    return error
        .then((value) => Tuple2<VocabularyModel, String?>(vocabulary, value));
  }
}

class NetworkError extends Error {}
