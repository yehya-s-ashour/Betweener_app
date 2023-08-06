import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tt9_betweener_challenge/controllers/link_controller.dart';
import 'package:tt9_betweener_challenge/controllers/user_controller.dart';
import 'package:tt9_betweener_challenge/views/add_link_view.dart';
import 'package:tt9_betweener_challenge/views/search_view.dart';

import '../constants.dart';
import '../models/link.dart';
import '../models/user.dart';

class HomeView extends StatefulWidget {
  static String id = '/homeView';
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late Future<User> user;
  late Future<List<Link>> links;

  @override
  void initState() {
    user = getLocalUser();
    links = getLinks(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsetsDirectional.only(
          start: 20.0,
          end: 20.0,
          top: 20.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, SearchView.id);
                    },
                    icon: Icon(
                      Icons.search_outlined,
                      size: 35,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.qr_code_scanner_outlined,
                      size: 35,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
              child: FutureBuilder(
                future: user,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      'Welcome, ${snapshot.data?.user?.name!.toUpperCase()}',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 32,
                          fontWeight: FontWeight.w700),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            SizedBox(
              height: 400,
              child: SvgPicture.asset(
                'assets/imgs/qr.svg',
              ),
            ),
            Center(
                child: Container(
              margin: EdgeInsetsDirectional.only(bottom: 25),
              height: 2,
              width: 250,
              color: Colors.black,
            )),
            SizedBox(
              height: 100,
              child: FutureBuilder(
                future: links,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final linkCount = snapshot.data!.length;
                    return SizedBox(
                      height: 100,
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.all(12),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          if (index < linkCount) {
                            final link = snapshot.data?[index].title;
                            return Row(
                              children: [
                                Container(
                                  width: 120,
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: kLinksColor,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '$link',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            // Show the "Add" button at the end of the ListView
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, AddLinkView.id)
                                    .then((value) {
                                  if (value == true) {
                                    setState(() {
                                      links = getLinks(context);
                                    });
                                  }
                                });
                              },
                              child: Container(
                                padding: EdgeInsetsDirectional.only(top: 5),
                                height: 100,
                                width: 120,
                                decoration: BoxDecoration(
                                    color: kSecondaryColor,
                                    borderRadius: BorderRadius.circular(15)),
                                child: const Column(
                                  children: [
                                    Icon(
                                      Icons.add,
                                      size: 30,
                                      color: Colors.black45,
                                    ),
                                    Text(
                                      'Add Link',
                                      style: TextStyle(
                                          color: Colors.black45,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            width: 8,
                          );
                        },
                        itemCount: linkCount + 1, // Add 1 for the "Add" button
                      ),
                    );
                  }

                  return const Center(
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
              ),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
