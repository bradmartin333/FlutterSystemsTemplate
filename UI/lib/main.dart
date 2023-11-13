import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sys_template/app_bloc.dart';
import 'package:flutter_sys_template/pages/alpha.dart';
import 'package:flutter_sys_template/pages/beta.dart';
import 'package:flutter_sys_template/pages/charlie.dart';
import 'package:flutter_sys_template/native_json.dart';

void main() => runApp(const SysApp());

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
      home: BlocProvider(
        create: (context) => AppBloc(),
        child: const HomePage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

const List<Tab> tabs = <Tab>[
  Tab(
    text: 'Alpha',
    icon: Icon(Icons.settings_accessibility_rounded),
  ),
  Tab(
    text: 'Beta',
    icon: Icon(Icons.roundabout_left_rounded),
  ),
  Tab(
    text: 'Charlie',
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
      child: Builder(builder: (BuildContext context) {
        final TabController tabController = DefaultTabController.of(context);
        tabController.addListener(() {
          if (!tabController.indexIsChanging) {
            // Your code goes here.
            // To get index of current tab use tabController.index
          }
        });
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
            children: [
              alphaWidget(),
              betaWidget(),
              charlieWidget(),
            ],
          ),
          bottomSheet: Text(validJSON() ? 'FFI OK' : 'FFI FAIL'),
        );
      }),
    );
  }
}
