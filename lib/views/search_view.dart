import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tt9_betweener_challenge/constants.dart';
import 'package:tt9_betweener_challenge/controllers/add_user_cont.dart';
import 'package:tt9_betweener_challenge/controllers/search_cont.dart';
import 'package:tt9_betweener_challenge/models/user.dart';
import 'package:tt9_betweener_challenge/views/widgets/custom_text_form_field.dart';
import 'package:http/http.dart' as http;

class SearchView extends StatefulWidget {
  static const id = '/searchView';

  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  TextEditingController searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<UserClass> names = [];
  int? followeeId;

  List<dynamic>? followingList;
  bool? isFollowing = false;
  void submitSearch() async {
    if (_formKey.currentState!.validate()) {
      final body = {
        'name': searchController.text,
      };
      searchLink(body).then((link) async {
        if (mounted) {
          setState(() {
            names = link;
          });
        }
      }).catchError((err) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(err.toString()),
          backgroundColor: Colors.red,
        ));
      });
    }
    setState(() {});
  }

  Future<void> getFollowing() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    User user = userFromJson(prefs.getString('user')!);
    final response = await http.get(Uri.parse(addUserUrl),
        headers: {'Authorization': 'Bearer ${user.token}'});
    if (response.statusCode == 200) {
      setState(() {
        followingList = jsonDecode(response.body)['following'];
        followingList = followingList!.map((e) {
          return e['id'];
        }).toList();
      });
    } else {
      throw Exception('Failed search');
    }
  }

  void addUser() async {
    final body = {
      'followee_id': followeeId.toString(),
    };

    addUserCont(body).catchError((err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(err.toString()),
        backgroundColor: Colors.red,
      ));
    });
  }

  @override
  void initState() {
    getFollowing();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Center(
              child: SizedBox(
                width: 350,
                child: CustomTextFormField(
                  onChanged: (p0) {
                    submitSearch();
                  },
                  controller: searchController,
                  hint: 'Search something...',
                  label: '',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'please enter something to search it';
                    }
                    return null;
                  },
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: names.length,
                itemBuilder: (context, index) {
                  final user = names[index];
                  final linkCount = user.links!.length;
                  return ListTile(
                    onTap: () {
                      followeeId = names[index].id;
                      isFollowing = followingList!.contains(followeeId);
                      setState(() {});

                      print('listtile  $isFollowing');
                      setState(() {
                        showModalBottomSheet(
                            clipBehavior: Clip.hardEdge,
                            isScrollControlled: true,
                            context: context,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                              top: Radius.circular(25.0),
                            )),
                            builder: (BuildContext context) {
                              return StatefulBuilder(builder:
                                  (BuildContext context, StateSetter setState) {
                                return SizedBox(
                                  height: 700,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.only(
                                            top: 20.0),
                                        child: Center(
                                            child: Text(
                                          '${user.name!.toUpperCase()}',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 22,
                                              fontWeight: FontWeight.w700),
                                        )),
                                      ),
                                      Container(
                                        margin: EdgeInsetsDirectional.only(
                                          top: 35,
                                          start: 35,
                                          end: 35,
                                        ),
                                        height: 150,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: kPrimaryColor,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Row(children: [
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .only(start: 25.0),
                                            child: Image.asset(
                                              'assets/imgs/person.png',
                                              height: 90,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsetsDirectional.only(
                                                start: 20.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: 180,
                                                  child: Text(
                                                    user.name!,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 22,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 180,
                                                  child: SizedBox(
                                                    child: Text(
                                                      user.email!,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .only(top: 15),
                                                  child: GestureDetector(
                                                      onTap: isFollowing!
                                                          ? null
                                                          : () {
                                                              addUser();
                                                              isFollowing =
                                                                  true;
                                                              getFollowing();
                                                              submitSearch();

                                                              setState(() {});
                                                            },
                                                      child: Container(
                                                        height: 30,
                                                        width: 90,
                                                        decoration: BoxDecoration(
                                                            color: isFollowing!
                                                                ? Colors.white
                                                                : kSecondaryColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: Center(
                                                          child: Text(
                                                            isFollowing!
                                                                ? 'Following'
                                                                : 'Follow',
                                                            style: TextStyle(
                                                                color:
                                                                    kPrimaryColor,
                                                                fontSize: 17,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                      )),
                                                )
                                              ],
                                            ),
                                          )
                                        ]),
                                      ),
                                      user.links!.length == 0
                                          ? Expanded(
                                              child: ListView.separated(
                                              physics: BouncingScrollPhysics(),
                                              padding:
                                                  EdgeInsetsDirectional.only(
                                                start: 60,
                                                end: 60,
                                                top: 40,
                                              ),
                                              scrollDirection: Axis.vertical,
                                              itemBuilder: (context, index) {
                                                return Container(
                                                  width: 90,
                                                  height: 70,
                                                  margin: EdgeInsetsDirectional
                                                      .only(bottom: 20),
                                                  padding: EdgeInsetsDirectional
                                                      .only(top: 6),
                                                  decoration: BoxDecoration(
                                                    color: kLinksColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child: Center(
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          user.links![index]
                                                              .title!,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 220,
                                                          child: Center(
                                                            child: Text(
                                                              user.links![index]
                                                                  .link!,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                              separatorBuilder:
                                                  (context, index) {
                                                return SizedBox(
                                                  width: 30,
                                                );
                                              },
                                              itemCount: linkCount,
                                            ))
                                          : Container(
                                              margin:
                                                  EdgeInsetsDirectional.only(
                                                      top: 120),
                                              height: 70,
                                              width: 280,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: Color.fromARGB(
                                                    255, 217, 215, 215),
                                              ),
                                              child: Center(
                                                  child: Text(
                                                ' ${user.name!.toUpperCase()} has No links!!',
                                                style: TextStyle(
                                                    letterSpacing: 2,
                                                    fontSize: 22,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )),
                                            ),
                                    ],
                                  ),
                                );
                              });
                            });
                      });
                    },
                    title: Text(
                      user.name!,
                      style: const TextStyle(color: Colors.black),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
