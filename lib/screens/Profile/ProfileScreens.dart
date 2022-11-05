import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mytask/helper/Colors.dart';
import 'package:mytask/helper/TextStyle.dart';
import 'package:mytask/screens/AuthScreen/Authscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helper/LocalData_pers.dart';

class ProfileScreens extends StatefulWidget {
  ProfileScreens({Key? key}) : super(key: key);

  @override
  State<ProfileScreens> createState() => _ProfileScreensState();
}

class _ProfileScreensState extends State<ProfileScreens>
    with TickerProviderStateMixin {
  String name = "";
  localData() async {
    final pers = await SharedPreferences.getInstance();
    setState(() {
      name = pers.getString(Shareper.username)!;
    });
  }

  late TabController _tabController;
  @override
  void initState() {
    localData();
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40),
              side: BorderSide(
                color: Colors.white,
                width: 2,
              )),
          child: Icon(Icons.add),
        ),
        backgroundColor: appColor.screenBackGround,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          title: Text(
            "Profile",
            style: GoogleFonts.fuzzyBubbles(),
          ),
          actions: [
            IconButton(
                onPressed: () async {}, icon: Icon(FontAwesomeIcons.edit)),
            IconButton(onPressed: () {}, icon: Icon(FontAwesomeIcons.add)),
            IconButton(
                onPressed: () {}, icon: Icon(FontAwesomeIcons.barsStaggered)),
            IconButton(
                onPressed: () async {
                  final pers = await SharedPreferences.getInstance();
                  pers.clear();
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => AuthScreen()));
                },
                icon: Icon(FontAwesomeIcons.signOut)),
          ],
        ),
        body: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: [
            CircleAvatar(
              radius: 50,
              child: CircleAvatar(
                radius: 47,
                backgroundColor: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: ProfiletextStyle.NameStyle,
                ),
                SizedBox(width: 2),
                Icon(
                  Icons.verified,
                  color: appColor.verifiedIconsColors,
                  size: 18,
                )
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(width: 5),
                Column(
                  children: [
                    Text(
                      "0",
                      style: ProfiletextStyle.NumberStyle,
                    ),
                    SizedBox(height: 5),
                    Text(
                      "POSTS",
                      style: ProfiletextStyle.profileText1,
                    )
                  ],
                ),
                Container(
                  width: 1,
                  height: 28,
                  color: Colors.white,
                ),
                Column(
                  children: [
                    Text(
                      "0",
                      style: ProfiletextStyle.NumberStyle,
                    ),
                    SizedBox(height: 5),
                    Text(
                      "FOLLOWERS",
                      style: ProfiletextStyle.profileText1,
                    )
                  ],
                ),
                Container(
                  width: 1,
                  height: 28,
                  color: Colors.white,
                ),
                Column(
                  children: [
                    Text(
                      "0",
                      style: ProfiletextStyle.NumberStyle,
                    ),
                    SizedBox(height: 5),
                    Text(
                      "FOLLOWING",
                      style: ProfiletextStyle.profileText1,
                    )
                  ],
                ),
                SizedBox(width: 5),
              ],
            ),
            Container(
                height: 50,
                width: double.infinity,
                child: TabBar(
                    // physics: BouncingScrollPhysics(),
                    indicator: UnderlineTabIndicator(
                      borderSide: BorderSide(
                          color: Colors.white,
                          width: 3,
                          strokeAlign: StrokeAlign.outside),
                      insets: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 0.0),
                    ),
                    controller: _tabController,
                    tabs: [
                      Tab(icon: Icon(Icons.view_cozy_rounded)),
                      Tab(icon: Icon(Icons.square_foot_sharp)),
                      Tab(icon: Icon(Icons.person_outline_outlined))
                    ])),
            Container(
              height: MediaQuery.of(context).size.height,
              child: TabBarView(controller: _tabController, children: [
                _postView(),
                Center(
                    child: Text(
                  "2 tab",
                  style: ProfiletextStyle.NameStyle,
                )),
                Center(
                    child: Text(
                  "3 tab",
                  style: ProfiletextStyle.NameStyle,
                ))
              ]),
            )
          ],
        ));
  }

  Widget _postView() {
    return GridView.builder(
      // padding: EdgeInsets.all(5),

      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      itemCount: 18,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Container(
          margin: EdgeInsets.only(left: 3, right: 3, top: 5),
          height: 100,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
        );
      },
    );
  }
}
