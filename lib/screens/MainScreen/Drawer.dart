import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:mytask/screens/AuthScreen/Authscreen.dart';
import 'package:mytask/screens/MainScreen/RejectTasks.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/HomeScreenModels.dart';

class DrawerApp extends StatelessWidget {
  final value;
  AdvancedDrawerController controller;
  DrawerApp(this.value, this.controller);

  // final List<HomeScreenModels> _list = [
  //   HomeScreenModels(icon: "assets/dark/Church.png", name: "Church"),
  //   HomeScreenModels(icon: "assets/dark/Devotional.png", name: "Devotional"),
  //   HomeScreenModels(icon: "assets/dark/Bibble.png", name: "Bibble"),
  //   HomeScreenModels(icon: "assets/dark/CUG.png", name: "CUG"),
  //   HomeScreenModels(icon: "assets/dark/JOB.png", name: "JOB"),
  //   HomeScreenModels(icon: "assets/dark/Events.png", name: "Events"),
  //   HomeScreenModels(icon: "assets/dark/Connect.png", name: "Connect"),
  //   HomeScreenModels(icon: "assets/dark/Forums.png", name: "Forums"),
  //   HomeScreenModels(icon: "assets/dark/SME.png", name: "SME"),
  // ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        Container(
          margin: const EdgeInsets.only(left: 10, top: 0),
          child: ListTileTheme(
            textColor: Colors.grey,
            iconColor: Colors.grey,
            child: Column(
              // shrinkWrap: true,
              // mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10, top: 15),
                  width: double.infinity,
                  height: 80.0,
                  child: Column(
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  // const CircleAvatar(
                                  //   radius: 35,
                                  //   backgroundColor: Colors.transparent,
                                  //   backgroundImage:
                                  //       AssetImage("assets/icons/profile.png"),
                                  // ),
                                  const SizedBox(width: 15),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            'firstNameLocal,',
                                            // style: AppTextStyle.textStyle17,
                                            // overflow: TextOverflow.visible,
                                            // maxLines: 2,
                                          ),
                                          const SizedBox(width: 5),
                                          // const Image(
                                          //   image: AssetImage(
                                          //       "assets/icons/edit.png"),
                                          //   height: 15,
                                          //   width: 15,
                                          // )
                                        ],
                                      ),
                                      Text(
                                        "emailLocal",
                                        // style: AppTextStyle.textStyle8,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // value.
                                controller.hideDrawer();
                              },
                              child: const Icon(
                                Icons.close,
                                size: 30,
                                color: Colors.grey,
                              ),
                            )
                          ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // ListView.builder(
        //   shrinkWrap: true,
        //   physics: const NeverScrollableScrollPhysics(),
        //   itemCount: _list.length,
        //   itemBuilder: (BuildContext context, int index) {
        //     return GestureDetector(
        //       // onTap: () {
        //       //   Navigator.of(context).push(MaterialPageRoute(
        //       //       builder: (context) => index == 0
        //       //           ? const ChurchScreen()
        //       //           : index == 1
        //       //               ? const DevotionalScreen()
        //       //               : index == 2
        //       //                   ? const BibbleScreen()
        //       //                   : index == 3
        //       //                       ? const CUGScreen()
        //       //                       : index == 4
        //       //                           ? const JOBScreen()
        //       //                           : index == 5
        //       //                               ? const EventsScreen()
        //       //                               : index == 6
        //       //                                   ? const ConnectScreen()
        //       //                                   : index == 7
        //       //                                       ? const ForumsScreen()
        //       //                                       : index == 8
        //       //                                           ? const SMEScreen()
        //       //                                           : const Center()));
        //       // },
        //       child: Container(
        //         margin: const EdgeInsets.only(top: 25, left: 20),
        //         child: Row(
        //           children: [
        //             Image(
        //               image: AssetImage(
        //                 _list[index].icon,
        //               ),
        //               height: 22,
        //               width: 22,
        //               // color: Colors.grey,
        //               // filterQuality: FilterQuality.high,
        //               // colorBlendMode: BlendMode.color,
        //             ),
        //             const SizedBox(width: 10),
        //             Text(_list[index].name),
        //           ],
        //         ),
        //       ),
        //     );
        //   },
        // ),
        // SizedBox(height: 15),
        Container(
            margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
            width: double.infinity,
            color: Colors.grey,
            height: 1),
        GestureDetector(
          onTap: () {
            // Navigator.of(context).push(
            //     MaterialPageRoute(builder: (context) => SettingsScreen()));
          },
          child: Container(
            margin: const EdgeInsets.only(top: 25, left: 20),
            child: Row(
              children: [
                // Image(
                //   image: AssetImage(
                //     "assets/icons/settings.png",
                //   ),
                //   height: 22,
                //   width: 22,
                //   color: Colors.grey,
                //   // filterQuality: FilterQuality.high,
                //   // colorBlendMode: BlendMode.color,
                // ),
                SizedBox(width: 10),
                GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Rejecttask()));
                    },
                    child: Text("Reject Tasks")),
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 25, left: 20),
          child: Row(
            children: const [
              // Image(
              //   image: AssetImage(
              //     "assets/icons/FAQ.png",
              //   ),
              //   height: 22,
              //   width: 22,
              //   color: Colors.grey,
              //   // filterQuality: FilterQuality.high,
              //   // colorBlendMode: BlendMode.color,
              // ),
              SizedBox(width: 10),
              Text("FAQ"),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 25, left: 20),
          child: Row(
            children: const [
              // Image(
              //   image: AssetImage(
              //     "assets/icons/support.png",
              //   ),
              //   height: 22,
              //   width: 22,
              //   color: Colors.grey,
              //   // filterQuality: FilterQuality.high,
              //   // colorBlendMode: BlendMode.color,
              // ),
              SizedBox(width: 10),
              Text("Support"),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 25, left: 20),
          child: Row(
            children: const [
              // Image(
              //   image: AssetImage(
              //     "assets/icons/T&C.png",
              //   ),
              //   height: 22,
              //   width: 22,
              //   color: Colors.grey,
              //   // filterQuality: FilterQuality.high,
              //   // colorBlendMode: BlendMode.color,
              // ),
              SizedBox(width: 10),
              Text("T&C"),
            ],
          ),
        ),
        InkWell(
          onTap: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.clear();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const AuthScreen()),
                (route) => false);
          },
          child: Container(
            margin:
                const EdgeInsets.only(left: 20, top: 30, right: 25, bottom: 30),
            alignment: Alignment.center,
            height: 60,
            width: 200,
            decoration: BoxDecoration(
                color: const Color(0xffF10057),
                borderRadius: BorderRadius.circular(50)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Logout",
                  // style: AppTextStyle.textStyle9,
                ),
                SizedBox(width: 15),
                // Image(
                //   image: AssetImage("assets/icons/Logout.png"),
                //   color: Colors.white,
                //   filterQuality: FilterQuality.high,
                // ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
