import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../blocs/dataservices/dataservices_bloc.dart';
import '../models/dataservices_model.dart';
import '../resources/api_repository.dart';

class DataservicesPage extends StatefulWidget {
  const DataservicesPage({super.key});

  @override
  _DataservicesPageState createState() => _DataservicesPageState();
}

class _DataservicesPageState extends State<DataservicesPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(t!.dataservices)),
      body: _buildListDataservice(),
    );
  }

  Widget _buildListDataservice() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: BlocProvider(
        create: (context) => DataservicesBloc(
            apiRepository: RepositoryProvider.of<ApiRepository>(context))
          ..add(GetDataservicesList()),
        child: BlocListener<DataservicesBloc, DataservicesState>(
          listener: (context, state) {
            if (state is DataservicesError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
          child: BlocBuilder<DataservicesBloc, DataservicesState>(
            builder: (context, state) {
              if (state is DataservicesInitial) {
                return _buildLoading();
              } else if (state is DataservicesLoading) {
                return _buildLoading();
              } else if (state is DataservicesLoaded) {
                return _buildDataserviceList(context, state.dataservicesModel);
              } else if (state is DataservicesError) {
                return Container();
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  void uploadDataservice(context, dataservice) {
    BlocProvider.of<DataserviceBloc>(context).add(
      UpdateDataservice(dataservice.name, dataservice.uri),
    );
  }

  Widget _buildDataserviceList(BuildContext context, DataservicesModel model) {
    var t = AppLocalizations.of(context);
    var numItems = model.dataservices.length;
    return SizedBox(
      width: double.infinity,
      child: DataTable(
        columns: <DataColumn>[
          DataColumn(
            label: Text(t!.uri),
          ),
          DataColumn(
            label: Text(t.actions),
          ),
        ],
        rows: List<DataRow>.generate(
          numItems,
          (int index) =>
              _buildDataservice(context, index, model.dataservices[index]),
        ),
      ),
    );
  }

  DataRow _buildDataservice(
      BuildContext context, int index, DataserviceModel model) {
    return DataRow(
      color: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        // All rows will have the same selected color.
        if (states.contains(MaterialState.selected)) {
          return Theme.of(context).colorScheme.primary.withOpacity(0.08);
        }
        // Even rows will have a grey color.
        if (index.isEven) {
          return Colors.grey.withOpacity(0.3);
        }
        return null; // Use default value for other states and odd rows.
      }),
      cells: <DataCell>[
        DataCell(Text(model.uri)),
        DataCell(
          BlocProvider(
            create: (context) => DataserviceBloc(
                apiRepository: RepositoryProvider.of<ApiRepository>(context)),
            child: BlocListener<DataserviceBloc, DataserviceState>(
              listener: (context, state) {
                if (state is DataserviceError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message!),
                    ),
                  );
                }
              },
              child: BlocBuilder<DataserviceBloc, DataserviceState>(
                builder: (context, state) {
                  if (state is DataserviceInitial) {
                    return Row(
                      children: _buildActions(context, model, false, false),
                    );
                  } else if (state is DataserviceLoading) {
                    return Row(
                      children: _buildActions(context, model, false, false),
                    );
                  } else if (state is DataserviceLoaded) {
                    return Row(
                      children: _buildActions(context, model, true, false),
                    );
                  } else if (state is DataserviceError) {
                    return Row(
                      children: _buildActions(context, model, true, true),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildActions(context, model, loaded, error) {
    var actions = List<Widget>.empty(growable: true);
    actions.add(IconButton(
      icon: const Icon(Icons.upload),
      onPressed: () {
        uploadDataservice(context, model);
      },
    ));
    if (loaded && !error) {
      actions.add(const Icon(Icons.sync, color: Colors.green));
    } else if (loaded && error) {
      actions.add(const Icon(Icons.sync, color: Colors.red));
    }
    return actions;
  }

  Widget _buildLoading() => const Center(child: CircularProgressIndicator());
}
