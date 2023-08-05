import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tt9_betweener_challenge/constants.dart';
import 'package:tt9_betweener_challenge/controllers/link_controller.dart';
import 'package:tt9_betweener_challenge/models/link.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Link>> links;

  @override
  void initState() {
    links = getLinks(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users List'),
        centerTitle: true,
      ),
      body: Center(
        child: SizedBox(
          width: 400,
          child: FutureBuilder(
            future: links,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final linkCount = snapshot.data!.length;
                return SizedBox(
                  child: ListView.builder(
                    itemCount: linkCount,
                    itemBuilder: (context, index) {
                      final title = snapshot.data?[index].title;
                      final link = snapshot.data?[index].link;
                      return Slidable(
                          endActionPane: ActionPane(
                            motion: const BehindMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {},
                                backgroundColor: Colors.red,
                                icon: Icons.delete,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              SizedBox(width: 10),
                              SlidableAction(
                                onPressed: (context) {},
                                backgroundColor: Colors.blue,
                                icon: Icons.delete,
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: Container(
                              height: 70,
                              margin: EdgeInsetsDirectional.only(
                                  top: 20, start: 50, end: 50, bottom: 20),
                              padding: EdgeInsetsDirectional.only(top: 6),
                              decoration: BoxDecoration(
                                color: kLinksColor,
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
        ),
      ),
    );
  }
}
