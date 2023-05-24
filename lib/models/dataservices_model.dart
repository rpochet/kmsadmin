class DataservicesModel {
  List<DataserviceModel> dataservices;

  DataservicesModel({required this.dataservices});

  factory DataservicesModel.fromJson(Map<String, dynamic> json) =>
      DataservicesModel(
        dataservices: json['results']['bindings']
            .map((d) => DataserviceModel.fromJson(d))
            .cast<DataserviceModel>()
            .toList(),
      );
}

class DataserviceModel {
  String uri;
  String name;
  String? status;

  DataserviceModel({required this.uri, required this.name, this.status});

  factory DataserviceModel.fromJson(Map<String, dynamic> json) =>
      DataserviceModel(
        uri: json['service']['value'],
        name: json['service']['value'].split('/').last,
      );
}
