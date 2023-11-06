import 'package:flutter/material.dart';
import 'package:flutter_sys_template/pages/alpha.dart';
import 'package:flutter_sys_template/pages/beta.dart';
import 'package:flutter_sys_template/pages/charlie.dart';
import 'package:flutter_sys_template/utilities/ffi_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ffi';

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
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: GoogleFonts.oswald(
            fontSize: 30,
          ),
        ),
      ),
      home: const HomePage(),
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
              onPressed: () {
                run();
              },
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
          persistentFooterAlignment: AlignmentDirectional.bottomCenter,
          persistentFooterButtons: [
            Text("HELLO"),
            IconButton(onPressed: () {}, icon: Icon(Icons.help)),
            Text("HELLO"),
            IconButton(onPressed: () {}, icon: Icon(Icons.help)),
            FilledButton(
              onPressed: () {},
              child: Text("HELP"),
            )
          ],
          bottomSheet: Text("INFO"),
        );
      }),
    );
  }
}
