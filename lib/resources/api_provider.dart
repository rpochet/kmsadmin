import 'package:dio/dio.dart';
import 'package:kmsadmin/models/vocabularies_model.dart';
import 'package:logging/logging.dart';

import '../main.dart';
import '../models/dataservices_model.dart';
import '../models/sparql_queries_model.dart';

class ApiProvider {
  static final log = Logger('ApiProvider');
  final Dio _dio = Dio();
  static final _url = Environment.apiUrl;
  static final _authorizationHeader = Environment.apiToken;
  static const _jsonAcceptHeader = 'application/json';
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

  Future<String?> updateDataservice(dataservice) async {
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

        return waitLoading(response);
      } else {
        return 'Unable to delete dataservice graph: got ${response.statusCode}, expected 204';
      }
    } catch (error, stacktrace) {
      log.severe('Exception occured: $error stackTrace: $stacktrace');
      return error.toString();
    }
  }

  Future<SparqlQueriesModel> fetchSparqlQueries() async {
    try {
      Response response =
          await _dio.get('$_url/service/sparql/query', options: _defaultHeader);
      return SparqlQueriesModel.fromJson(response.data);
    } catch (error, stacktrace) {
      log.severe('Exception occured: $error stackTrace: $stacktrace');
      return SparqlQueriesModel(sparqlQueries: List.empty());
    }
  }

  Future<VocabulariesModel> fetchVocabularies() async {
    try {
      Response response =
          await _dio.get('$_url/service/vocabulary', options: _defaultHeader);
      return VocabulariesModel.fromJson(response.data);
    } catch (error, stacktrace) {
      log.severe('Exception occured: $error stackTrace: $stacktrace');
      return VocabulariesModel(vocabularies: List.empty());
    }
  }

  Future<String?> updateVocabulary(vocabulary) async {
    if (vocabulary.type == 'bulk') {
      Response response;
      try {
        if (!vocabulary.path.startsWith('ep-enrichment')) {
          response = await _dio.delete(
              '$_url/vocabulary/load/${vocabulary.name}',
              options: _defaultHeader);
          if (response.statusCode != 204) {
            return 'Load failed: unable to delete vocabulary: ${response.statusCode}';
          }
        }
        response = await _dio.post('$_url/vocabulary/load',
            data: {
              'name': vocabulary.path,
              'namedGraphUri': vocabulary.namedGraphUri,
              'format': vocabulary.format
            },
            options: _defaultHeader);
      } catch (error, stacktrace) {
        log.severe('Exception occured: $error stackTrace: $stacktrace');
        return error.toString();
        /*vocabulary.loadStatus = 'LOAD_ERROR';
        if (error.response && error.response.data) {
          vocabulary.loadError = error.response.data.detailedMessage;
        } else {
          vocabulary.loadError = error;
        }*/
      }

      return waitLoading(response);
    } else {
      try {
        Response response = await _dio.post('$_url/vocabulary/update',
            data: {'name': vocabulary.path}, options: _defaultHeader);
        if (response.statusCode == 200) {
          return null;
        } else {
          return 'Load failed ${response.statusCode}';
        }
      } catch (error, stacktrace) {
        log.severe('Exception occured: $error stackTrace: $stacktrace');
        return error.toString();
        /*vocabulary.loadStatus = 'LOAD_ERROR';
        if (error.response && error.response.data) {
          vocabulary.loadError = error.response.data.detailedMessage;
        } else {
          vocabulary.loadError = error;
        }*/
      }
    }
  }

  Future<String?> waitLoading(response) async {
    String? error;
    if (response.statusCode == 200) {
      var loadId = response.data['payload']['loadId'];
      var done = false;
      while (!done) {
        response = await _dio.get('$_url/service/dataservice',
            queryParameters: {'loadId': loadId}, options: _defaultHeader);
        if (response.statusCode == 200) {
          Map payload = response.data['payload'];
          Map? overallStatus = payload['overallStatus'];
          if (overallStatus!['status'] == 'LOAD_COMPLETED') {
            error = null;
            done = true;
          } else if (overallStatus['status'] == 'LOAD_IN_PROGRESS' ||
              overallStatus['status'] == 'LOAD_IN_QUEUE') {
            // Wait again
            await Future.delayed(const Duration(seconds: 5));
          } else if (overallStatus['status'] != null) {
            error = overallStatus['status'];
            done = true;
          } else if (payload['feedCount'] != null) {
            error = payload['feedCount'][0].keys.first;
            done = true;
          } else if (response.data) {
            error = null;
            done = true;
          }
        }
      }
    } else {
      error = 'Load failed ${response.statusCode}';
    }
    return error;
  }
}
