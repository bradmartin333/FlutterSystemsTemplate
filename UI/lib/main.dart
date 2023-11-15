import 'package:flutter/material.dart';
import 'package:flutter_sys_template/app_model.dart';
import 'package:flutter_sys_template/pages/alpha.dart';
import 'package:flutter_sys_template/pages/map_solver.dart';
import 'package:flutter_sys_template/pages/one.dart';
import 'package:flutter_sys_template/native_json.dart';
import 'package:provider/provider.dart';

void main() => runApp(ChangeNotifierProvider(
      create: (context) => AppModel(),
      child: const SysApp(),
    ));

class SysApp extends StatelessWidget {
  const SysApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.dark,
        ),
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

const List<Tab> tabs = <Tab>[
  Tab(
    text: 'Map Solver',
    icon: Icon(Icons.map),
  ),
  Tab(
    text: 'Alpha',
    icon: Icon(Icons.settings_accessibility_rounded),
  ),
  Tab(
    text: 'One',
    icon: Icon(Icons.hive_rounded),
  ),
];

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  initState() {
    super.initState();
    initPortListener(context);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Builder(
        builder: (BuildContext context) {
          final TabController tabController = DefaultTabController.of(context);
          tabController.addListener(
            () {
              if (!tabController.indexIsChanging) {
                // Your code goes here.
                // To get index of current tab use tabController.index
              }
            },
          );
          return Scaffold(
            appBar: AppBar(
              title: const Text('Systems App'),
              bottom: TabBar(
                labelColor: Colors.black,
                unselectedLabelColor: Colors.white,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                indicator: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    color: Theme.of(context).indicatorColor),
                tabs: tabs,
              ),
            ),
            body: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                mapSolver(),
                alpha(),
                one(),
              ],
            ),
            bottomSheet:
                Consumer<AppModel>(builder: (context, appModel, child) {
              return Text(jsonStateString());
            }),
          );
        },
      ),
    );
  }
}
