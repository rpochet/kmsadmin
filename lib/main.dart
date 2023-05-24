import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kmsadmin/page/sparql_page.dart';
import 'package:logging/logging.dart';

import 'page/dataservices_page.dart';
import 'resources/api_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup logging
  Logger.root.level = Level.ALL; // defaults to Level.INFO
  Logger.root.onRecord.listen((record) {
    print('${record.time} [${record.level.name}] ${record.message}');
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static final log = Logger('MyApp');

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //showSemanticsDebugger: true,
      //debugShowMaterialGrid: true,
      onGenerateTitle: (context) {
        var t = AppLocalizations.of(context);
        return t!.title;
      },
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RepositoryProvider(
        create: (context) => ApiRepository(),
        child: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  // final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context);

    final ButtonStyle style = TextButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
    );

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(
                icon: const Icon(Icons.directions_bike),
                text: t!.apis,
              ),
              Tab(
                icon: const Icon(Icons.directions_car),
                text: t.dataservices,
              ),
              Tab(
                icon: const Icon(Icons.directions_transit),
                text: t.workflow,
              ),
              Tab(
                icon: const Icon(Icons.directions_boat),
                text: t.vocabularies,
              ),
              Tab(
                icon: const Icon(Icons.directions_bus),
                text: t.bulkLoad,
              ),
              Tab(
                icon: const Icon(Icons.directions_car),
                text: t.sparql,
              ),
            ],
          ),
          title: Text(t.title),
          actions: <Widget>[
            TextButton(
              style: style,
              onPressed: () {},
              child: const Text('Debug'),
            ),
            TextButton(
              style: style,
              onPressed: () {},
              child: const Text('Action 2'),
            ),
          ],
        ),
        body: const TabBarView(
          children: [
            Icon(Icons.directions_bike),
            DataservicesPage(),
            Icon(Icons.directions_transit),
            Icon(Icons.directions_boat),
            Icon(Icons.directions_bus),
            SparqlPage(),
          ],
        ),
      ),
    );
  }
}
