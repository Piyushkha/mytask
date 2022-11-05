import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytask/screens/MainScreen/ComplitedaTask.dart';
import 'package:mytask/screens/MainScreen/Drawer.dart';
import 'package:mytask/screens/MainScreen/Mytask.dart';
import 'package:mytask/screens/MainScreen/ProfileScreen.dart';
import 'package:mytask/screens/MainScreen/RejectTasks.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../AuthScreen/Authscreen.dart';

class Homescreen extends StatefulWidget {
  Homescreen({Key? key}) : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> with TickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TabController(length: 3, vsync: this);
  }

  final _advancedDrawerController = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    return AdvancedDrawer(
      rtlOpening: true,
      drawer: DrawerApp(_advancedDrawerController, _advancedDrawerController),
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text("MY TASK'S"),
            // centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProfileScreen()));
                  },
                  icon: CircleAvatar()),
              IconButton(
                  onPressed: () {
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => ProfileScreen()));
                  },
                  icon: Icon(
                    Icons.home,
                    size: 25,
                  )),
              IconButton(
                  onPressed: () async {
                    final pers = await SharedPreferences.getInstance();
                    pers.clear();
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => AuthScreen()));
                  },
                  icon: Icon(
                    Icons.logout,
                    size: 25,
                  )),
            ],
            bottom: TabBar(
                automaticIndicatorColorAdjustment: true,
                physics: NeverScrollableScrollPhysics(),
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(
                      color: Colors.white,
                      width: 3,
                      strokeAlign: StrokeAlign.outside),
                  insets: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 0.0),
                ),
                controller: _controller,
                tabs: [
                  Tab(
                    child: Text(
                      "MY TASK",
                      style: GoogleFonts.fuzzyBubbles(),
                    ),
                    icon: Icon(Icons.spatial_tracking_sharp),
                  ),
                  Tab(
                    child: Text(
                      "COMPLITED TASK",
                      style: GoogleFonts.fuzzyBubbles(),
                      textAlign: TextAlign.center,
                    ),
                    icon: Icon(Icons.task_alt_rounded),
                  ),
                  Tab(
                    child: Text(
                      "REJECTS TASK",
                      style: GoogleFonts.fuzzyBubbles(),
                      textAlign: TextAlign.center,
                    ),
                    icon: Icon(Icons.cancel_sharp),
                  )
                ]),
          ),
          body: TabBarView(
            physics: BouncingScrollPhysics(),
            controller: _controller,
            children: [Mytask(), Complitedtask(), Rejecttask()],
          )),
    );
  }
}
