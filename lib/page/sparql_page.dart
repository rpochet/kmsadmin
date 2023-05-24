import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../blocs/sparql/sparql_bloc.dart';
import '../resources/api_repository.dart';

class SparqlPage extends StatefulWidget {
  const SparqlPage({super.key});

  @override
  _SparqlPageState createState() => _SparqlPageState();
}

class _SparqlPageState extends State<SparqlPage> {
  //final SparqlBloc _newsBloc = SparqlBloc();

  @override
  void initState() {
    //_newsBloc.add(GetSparqlQueriesList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(t!.sparql)),
      body: _buildListSparqlQuery(),
    );
  }

  Widget _buildListSparqlQuery() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: BlocProvider(
        create: (context) => SparqlBloc(
            apiRepository: RepositoryProvider.of<ApiRepository>(context))
          ..add(GetSparqlQueriesList()),
        child: BlocListener<SparqlBloc, SparqlState>(
          listener: (context, state) {
            if (state is SparqlError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
          child: BlocBuilder<SparqlBloc, SparqlState>(
            builder: (context, state) {
              if (state is SparqlInitial) {
                return _buildLoading();
              } else if (state is SparqlQueriesLoading) {
                return _buildLoading();
              } else if (state is SparqlQueriesLoaded) {
                return Container();
              } else if (state is SparqlError) {
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

  Widget _buildLoading() => const Center(child: CircularProgressIndicator());
}
