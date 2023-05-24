import '../models/dataservices_model.dart';
import '../models/sparql_queries_model.dart';
import 'api_provider.dart';

class ApiRepository {
  final _provider = ApiProvider();

  Future<DataservicesModel> fetchDataservicesList() {
    return _provider.fetchDataservices();
  }

  Future<DataserviceModel> updateDataservice(dataservice) {
    return _provider.updateDataservice(dataservice);
  }

  Future<SparqlQueriesModel> fetchSparqlQueriesList() {
    return _provider.fetchSparqlQueries();
  }
}

class NetworkError extends Error {}
