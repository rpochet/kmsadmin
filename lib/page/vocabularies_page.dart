import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kmsadmin/models/vocabularies_model.dart';

import '../blocs/vocabularies/vocabularies_bloc.dart';
import '../resources/api_repository.dart';

class VocabulariesPage extends StatefulWidget {
  const VocabulariesPage({super.key});

  @override
  _VocabulariesPageState createState() => _VocabulariesPageState();
}

class _VocabulariesPageState extends State<VocabulariesPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(t!.vocabularies)),
      body: _buildListVocabularies(),
    );
  }

  Widget _buildListVocabularies() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: BlocProvider(
        create: (context) => VocabulariesBloc(
            apiRepository: RepositoryProvider.of<ApiRepository>(context))
          ..add(GetVocabulariesList()),
        child: BlocListener<VocabulariesBloc, VocabulariesState>(
          listener: (context, state) {
            if (state is VocabulariesError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
          child: BlocBuilder<VocabulariesBloc, VocabulariesState>(
            builder: (context, state) {
              if (state is VocabulariesInitial) {
                return _buildLoading();
              } else if (state is VocabulariesLoading) {
                return _buildLoading();
              } else if (state is VocabulariesLoaded) {
                return _buildVocabularyList(context, state.vocabulariesModel);
              } else if (state is VocabulariesError) {
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

  Widget _buildVocabularyList(BuildContext context, VocabulariesModel model) {
    var t = AppLocalizations.of(context);
    var numItems = model.vocabularies.length;
    return SingleChildScrollView(
      child: SizedBox(
        width: double.infinity,
        child: DataTable(
          columns: <DataColumn>[
            DataColumn(
              label: Text(t!.name),
            ),
            DataColumn(
              label: Text(t.actions),
            ),
          ],
          rows: List<DataRow>.generate(
            numItems,
            (int index) =>
                _buildVocabulary(context, index, model.vocabularies[index]),
          ),
        ),
      ),
    );
  }

  DataRow _buildVocabulary(
      BuildContext context, int index, VocabularyModel model) {
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
        DataCell(Text(model.name)),
        DataCell(
          BlocProvider(
            create: (context) => VocabulariesBloc(
                apiRepository: RepositoryProvider.of<ApiRepository>(context)),
            child: BlocListener<VocabulariesBloc, VocabulariesState>(
              listener: (context, state) {
                if (state is VocabulariesError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                    ),
                  );
                }
              },
              child: BlocBuilder<VocabulariesBloc, VocabulariesState>(
                builder: (context, state) {
                  if (state is VocabulariesInitial) {
                    return Row(
                      children:
                          _buildActions(context, model, false, false, false),
                    );
                  } else if (state is VocabularyLoading) {
                    return Row(
                      children:
                          _buildActions(context, model, true, false, false),
                    );
                  } else if (state is VocabularyLoaded) {
                    return Row(
                      children:
                          _buildActions(context, model, false, true, false),
                    );
                  } else if (state is VocabularyError) {
                    return Row(
                      children:
                          _buildActions(context, model, false, true, true),
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

  List<Widget> _buildActions(context, model, loading, loaded, error) {
    var actions = List<Widget>.empty(growable: true);
    if (!loading) {
      actions.add(IconButton(
        icon: const Icon(Icons.upload),
        onPressed: () {
          uploadVocabulary(context, model);
        },
      ));
    }
    if (loaded && !error) {
      actions.add(
          const Icon(Icons.check_circle_outline_sharp, color: Colors.green));
    } else if (loaded && error) {
      actions.add(const Icon(Icons.unpublished_sharp, color: Colors.red));
    }
    return actions;
  }

  void uploadVocabulary(context, vocabulary) {
    BlocProvider.of<VocabulariesBloc>(context).add(
      UpdateVocabulary(vocabulary),
    );
  }

  Widget _buildLoading() => const Center(child: CircularProgressIndicator());
}
