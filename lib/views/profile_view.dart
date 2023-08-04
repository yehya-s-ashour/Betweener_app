import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt9_betweener_challenge/constants.dart';
import 'package:tt9_betweener_challenge/controllers/link_controller.dart';
import 'package:tt9_betweener_challenge/controllers/user_controller.dart';
import 'package:tt9_betweener_challenge/models/link.dart';
import 'package:tt9_betweener_challenge/models/user.dart';
import 'package:http/http.dart' as http;

class ProfileView extends StatefulWidget {
  static String id = '/profileView';

  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late Future<User?> user;
  late Future<List<Link>> links;
  late Future<Map<String, dynamic>> followMap;

  String? following;
  String? followers;
  @override
  void initState() {
    user = getLocalUser();
    getFollowingFollowe();
    links = getLinks(context);
    super.initState();
  }

  Future<void> getFollowingFollowe() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    User user = userFromJson(prefs.getString('user')!);
    final response = await http.get(Uri.parse(addUserUrl),
        headers: {'Authorization': 'Bearer ${user.token}'});
    if (response.statusCode == 200) {
      setState(() {
        followers = jsonDecode(response.body)['followers_count'].toString();
        following = jsonDecode(response.body)['following_count'].toString();
      });
    } else {
      throw Exception('Failed search');
    }
  }

  @override
  Widget build(BuildContext context) {
    return followers != null && following != null
        ? SafeArea(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsetsDirectional.only(top: 20.0),
                  child: Center(
                      child: Text(
                    'profile',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w700),
                  )),
                ),
                FutureBuilder(
                  future: user,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        margin: EdgeInsetsDirectional.only(
                          top: 35,
                          start: 35,
                          end: 35,
                        ),
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: kPrimaryColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(children: [
                          Padding(
                            padding:
                                const EdgeInsetsDirectional.only(start: 25.0),
                            child: Image.asset(
                              'assets/imgs/person.png',
                              height: 90,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.only(start: 20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data?.user?.name,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  width: 180,
                                  child: Text(
                                    snapshot.data?.user?.email,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsetsDirectional.only(top: 15),
                                      child: Container(
                                        height: 30,
                                        width: 90,
                                        decoration: BoxDecoration(
                                            color: kSecondaryColor,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Center(
                                          child: Text(
                                            '$following  Follower',
                                            style: TextStyle(
                                                color: kPrimaryColor,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsetsDirectional.only(top: 15),
                                      child: Container(
                                        height: 30,
                                        width: 90,
                                        decoration: BoxDecoration(
                                            color: kSecondaryColor,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Center(
                                          child: Text(
                                            '$followers  Following',
                                            style: TextStyle(
                                                color: kPrimaryColor,
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ]),
                      );
                    }
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
                FutureBuilder(
                  future: links,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final linkCount = snapshot.data!.length;
                      return SizedBox(
                        height: 485,
                        child: ListView.separated(
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsetsDirectional.only(
                            start: 60,
                            end: 60,
                            top: 40,
                          ),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            final title = snapshot.data?[index].title;
                            final link = snapshot.data?[index].link;
                            return Container(
                              width: 90,
                              height: 70,
                              margin: EdgeInsetsDirectional.only(bottom: 20),
                              padding: EdgeInsetsDirectional.only(top: 6),
                              decoration: BoxDecoration(
                                color: kLinksColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      '$title',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      '$link',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              width: 30,
                            );
                          },
                          itemCount: linkCount,
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ],
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
