import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../main.dart';
import '../models/dataservices_model.dart';
import '../models/sparql_queries_model.dart';

class ApiProvider {
  static final log = Logger('ApiProvider');
  final Dio _dio = Dio();
  static final _url = Environment.apiUrl;
  static final _authorizationHeader = Environment.apiToken;
  static const _jsonAcceptHeader = 'application.json';
  final _defaultHeader = Options(
    headers: {
      'Accept': _jsonAcceptHeader,
      'Authorization': _authorizationHeader,
    },
  );

  Future<DataservicesModel> fetchDataservices() async {
    try {
      Response response =
          await _dio.get('$_url/service/dataservice', options: _defaultHeader);
      return DataservicesModel.fromJson(response.data);
    } catch (error, stacktrace) {
      log.severe('Exception occured: $error stackTrace: $stacktrace');
      return DataservicesModel(dataservices: List.empty());
    }
  }

  Future<DataserviceModel> updateDataservice(dataservice) async {
    try {
      Response response = await _dio.delete(
          '$_url/service/dataservice/${dataservice.name}',
          options: _defaultHeader);
      if (response.statusCode == 204) {
        var body = {
          'name': dataservice.name,
        };
        response = await _dio.post('$_url/service/dataservice',
            data: body, options: _defaultHeader);
        if (response.statusCode == 200) {
          var loadId = response.data.payload.loadId;
          var done = false;
          while (!done) {
            response = await _dio.get('$_url/service/dataservice',
                queryParameters: {'loadId': loadId}, options: _defaultHeader);
            if (response.statusCode == 200) {
              if (response.data.payload.overallStatus) {
                return DataserviceModel(
                    uri: dataservice.uri,
                    name: dataservice.name,
                    status: response.data.payload.overallStatus.status);
              } else if (response.data.payload.feedCount) {
                return DataserviceModel(
                    uri: dataservice.uri,
                    name: dataservice.name,
                    status: response.data.payload.feedCount[0].keys.first);
              }
            }
          }
        }
        return DataserviceModel(
          uri: dataservice.uri,
          name: dataservice.name,
          status:
              'Unable to start uploading dataservice graph: got ${response.statusCode}, expected 200',
        );
      } else {
        return DataserviceModel(
          uri: dataservice.uri,
          name: dataservice.name,
          status:
              'Unable to delete dataservice graph: got ${response.statusCode}, expected 204',
        );
      }
    } catch (error, stacktrace) {
      log.severe('Exception occured: $error stackTrace: $stacktrace');
      return DataserviceModel(
          name: dataservice.name,
          uri: dataservice.uri,
          status: error.toString());
    }
  }

  Future<SparqlQueriesModel> fetchSparqlQueries() async {
    try {
      Response response = await _dio.get('$_url/service/sparql/queries',
          options: _defaultHeader);
      return SparqlQueriesModel.fromJson(response.data);
    } catch (error, stacktrace) {
      log.severe('Exception occured: $error stackTrace: $stacktrace');
      return SparqlQueriesModel(sparqlQueries: List.empty());
    }
  }
}
