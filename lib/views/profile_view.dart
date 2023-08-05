import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt9_betweener_challenge/constants.dart';
import 'package:tt9_betweener_challenge/controllers/link_controller.dart';
import 'package:tt9_betweener_challenge/controllers/user_controller.dart';
import 'package:tt9_betweener_challenge/models/link.dart';
import 'package:tt9_betweener_challenge/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:tt9_betweener_challenge/views/widgets/custom_text_form_field.dart';

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
  TextEditingController titleController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? followingCount;
  String? followersCount;
  List<dynamic>? followersList;
  List<dynamic>? followingList;
  @override
  void initState() {
    user = getLocalUser();
    getFollowingFollowe();
    links = getLinks(context);
    super.initState();
  }

  void updateLink(int linkId) async {
    if (_formKey.currentState!.validate()) {
      final body = {
        'title': titleController.text,
        'link': linkController.text,
      };

      updateLinkCont(body, linkId).then((link) async {
        if (mounted) {
          Navigator.pop(context, true);

          setState(() {
            links = getLinks(context);
            titleController.clear();
            linkController.clear();
          });
        }
      }).catchError((err) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(err.toString()),
          backgroundColor: Colors.red,
        ));
      });
    }
  }

  Future<void> getFollowingFollowe() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    User user = userFromJson(prefs.getString('user')!);
    final response = await http.get(Uri.parse(addUserUrl),
        headers: {'Authorization': 'Bearer ${user.token}'});
    if (response.statusCode == 200) {
      setState(() {
        followingCount =
            jsonDecode(response.body)['following_count'].toString();
        followersCount =
            jsonDecode(response.body)['followers_count'].toString();
        followersList = jsonDecode(response.body)['followers'];

        followingList = jsonDecode(response.body)['following'];
      });
    } else {
      throw Exception('Failed search');
    }
  }

  Future<bool> deleteLink(int linkId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    User user = userFromJson(prefs.getString('user')!);
    final response = await http.delete(Uri.parse('$linksUrl/$linkId'),
        headers: {'Authorization': 'Bearer ${user.token}'});
    if (response.statusCode == 200) {
      setState(() {
        links = getLinks(context);
      });
      return true;
    } else {
      throw Exception('Failed search');
    }
  }

  @override
  Widget build(BuildContext context) {
    return followersCount != null || followingCount != null
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
                            padding: EdgeInsetsDirectional.only(start: 15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data?.user?.name,
                                  style: const TextStyle(
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
                                      padding: const EdgeInsetsDirectional.only(
                                          top: 15),
                                      child: GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet(
                                            clipBehavior: Clip.hardEdge,
                                            isScrollControlled: true,
                                            context: context,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                              top: Radius.circular(25.0),
                                            )),
                                            builder: (BuildContext context) {
                                              return SizedBox(
                                                height: 600,
                                                child: ListView.separated(
                                                  physics:
                                                      const BouncingScrollPhysics(),
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Container(
                                                      margin:
                                                          const EdgeInsetsDirectional
                                                              .only(
                                                        top: 20,
                                                        start: 35,
                                                        end: 35,
                                                      ),
                                                      height: 100,
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        color: kSecondaryColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      child: Row(children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                      .only(
                                                                  start: 25.0),
                                                          child: Image.asset(
                                                            'assets/imgs/person.png',
                                                            height: 70,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .only(
                                                                      start:
                                                                          20.0),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                followersList![
                                                                        index]
                                                                    ['name']!,
                                                                style: TextStyle(
                                                                    color:
                                                                        kPrimaryColor,
                                                                    fontSize:
                                                                        22,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                              ),
                                                              SizedBox(
                                                                width: 180,
                                                                child: Text(
                                                                  followersList![
                                                                          index]
                                                                      [
                                                                      'email']!,
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: const TextStyle(
                                                                      color:
                                                                          kPrimaryColor,
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ]),
                                                    );
                                                  },
                                                  itemCount:
                                                      followersList!.length,
                                                  separatorBuilder:
                                                      (context, index) {
                                                    return SizedBox(
                                                      width: 30,
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 90,
                                          decoration: BoxDecoration(
                                              color: kSecondaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Center(
                                            child: Text(
                                              '$followersCount  Follower',
                                              style: TextStyle(
                                                  color: kPrimaryColor,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsetsDirectional.only(top: 15),
                                      child: GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet(
                                            clipBehavior: Clip.hardEdge,
                                            isScrollControlled: true,
                                            context: context,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                              top: Radius.circular(25.0),
                                            )),
                                            builder: (BuildContext context) {
                                              return SizedBox(
                                                height: 600,
                                                child: ListView.separated(
                                                  physics:
                                                      const BouncingScrollPhysics(),
                                                  scrollDirection:
                                                      Axis.vertical,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Container(
                                                      margin:
                                                          const EdgeInsetsDirectional
                                                              .only(
                                                        top: 20,
                                                        start: 35,
                                                        end: 35,
                                                      ),
                                                      height: 100,
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        color: kSecondaryColor,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                      child: Row(children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsetsDirectional
                                                                      .only(
                                                                  start: 25.0),
                                                          child: Image.asset(
                                                            'assets/imgs/person.png',
                                                            height: 70,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .only(
                                                                      start:
                                                                          20.0),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                followingList![
                                                                        index]
                                                                    ['name']!,
                                                                style: TextStyle(
                                                                    color:
                                                                        kPrimaryColor,
                                                                    fontSize:
                                                                        22,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                              ),
                                                              SizedBox(
                                                                width: 180,
                                                                child: Text(
                                                                  followingList![
                                                                          index]
                                                                      [
                                                                      'email']!,
                                                                  maxLines: 1,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: const TextStyle(
                                                                      color:
                                                                          kPrimaryColor,
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ]),
                                                    );
                                                  },
                                                  itemCount:
                                                      followingList!.length,
                                                  separatorBuilder:
                                                      (context, index) {
                                                    return SizedBox(
                                                      width: 30,
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: Container(
                                          height: 30,
                                          width: 90,
                                          decoration: BoxDecoration(
                                              color: kSecondaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Center(
                                            child: Text(
                                              '$followingCount  Following',
                                              style: TextStyle(
                                                  color: kPrimaryColor,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600),
                                            ),
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
                        height: 440,
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
                            final id = snapshot.data?[index].id;
                            return Slidable(
                                endActionPane: ActionPane(
                                  motion: const DrawerMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) {
                                        deleteLink(id!);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                            'Deleted Successfully',
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          backgroundColor: Colors.redAccent,
                                          duration: Duration(seconds: 2),
                                        ));
                                      },
                                      backgroundColor: Colors.red,
                                      icon: Icons.delete,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    SlidableAction(
                                      onPressed: (context) {
                                        titleController.text = title!;
                                        linkController.text = link!;
                                        showModalBottomSheet(
                                            clipBehavior: Clip.hardEdge,
                                            isScrollControlled: true,
                                            context: context,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.vertical(
                                              top: Radius.circular(25.0),
                                            )),
                                            builder: (BuildContext context) {
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                    bottom:
                                                        MediaQuery.of(context)
                                                            .viewInsets
                                                            .bottom),
                                                child: SizedBox(
                                                    height: 350,
                                                    child: Form(
                                                      key: _formKey,
                                                      child: Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 23,
                                                          ),
                                                          Text(
                                                            'Edit \' $title \'',
                                                            style: TextStyle(
                                                                fontSize: 23,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                          SizedBox(
                                                            height: 23,
                                                          ),
                                                          Center(
                                                            child: SizedBox(
                                                              width: 350,
                                                              child:
                                                                  CustomTextFormField(
                                                                onChanged:
                                                                    (p0) {},
                                                                controller:
                                                                    titleController,
                                                                hint:
                                                                    'Instagram,Facebook,...',
                                                                label: 'Title',
                                                                validator:
                                                                    (value) {
                                                                  if (value ==
                                                                          null ||
                                                                      value
                                                                          .isEmpty) {
                                                                    return 'please enter the title';
                                                                  }
                                                                  return null;
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 14,
                                                          ),
                                                          Center(
                                                            child: SizedBox(
                                                              width: 350,
                                                              child:
                                                                  CustomTextFormField(
                                                                onChanged:
                                                                    (p0) {},
                                                                controller:
                                                                    linkController,
                                                                hint:
                                                                    'www.example.com',
                                                                label: 'Link',
                                                                validator:
                                                                    (value) {
                                                                  if (value ==
                                                                          null ||
                                                                      value
                                                                          .isEmpty) {
                                                                    return 'please enter the link';
                                                                  }
                                                                  return null;
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 24,
                                                          ),
                                                          Center(
                                                            child:
                                                                ElevatedButton(
                                                              style: ButtonStyle(
                                                                  backgroundColor:
                                                                      MaterialStatePropertyAll(
                                                                          kSecondaryColor)),
                                                              onPressed: () {
                                                                updateLink(id!);
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(
                                                                        const SnackBar(
                                                                  content: Text(
                                                                    'Updated Successfully',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                  backgroundColor:
                                                                      kLinksColor,
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          2000),
                                                                ));
                                                              },
                                                              child: Text(
                                                                'Update',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                              ),
                                                            ),
                                                          ),
                                                          const Spacer(),
                                                        ],
                                                      ),
                                                    )),
                                              );
                                            });
                                      },
                                      backgroundColor: kSecondaryColor,
                                      icon: Icons.edit,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Container(
                                    height: 70,
                                    margin:
                                        EdgeInsetsDirectional.only(bottom: 20),
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
                                  ),
                                ));
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
