import 'package:flutter/material.dart';
import 'package:flutter_sys_template/pages/alpha.dart';
import 'package:flutter_sys_template/pages/beta.dart';
import 'package:flutter_sys_template/pages/charlie.dart';

void main() => runApp(const SysApp());

class SysApp extends StatelessWidget {
  const SysApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
            title: const Text("Systems App"),
            leading: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.question_answer_rounded),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.question_answer_rounded),
              ),
            ],
            bottom: TabBar(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.white,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              indicator: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)),
                  color: Theme.of(context).secondaryHeaderColor),
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
        );
      }),
    );
  }
}
