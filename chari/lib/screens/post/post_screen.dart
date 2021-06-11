import 'dart:convert';
import 'package:chari/models/donator_notification.dart';
import 'package:chari/models/models.dart';
import 'package:chari/models/project_model.dart';
import 'package:chari/screens/home/projectdetails_screen.dart';
import 'package:chari/screens/screens.dart';
import 'package:chari/services/services.dart';
import 'package:chari/utility/utility.dart';
import 'package:chari/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PostScreen extends StatefulWidget {
  List<Project> projects;
  List<Post> posts;
  Donator donator;
  PostScreen({Key key, @required this.projects,this.posts,this.donator}) : super(key: key);
  @override
  _PostScreenState createState()=> _PostScreenState();
}

class _PostScreenState extends State<PostScreen>{


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius:
              BorderRadius.vertical(top: Radius.circular(0))),
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.white,
                floating: true,
                title: Image.asset(
                  "assets/icons/logo.png",
                  height: size.height * 0.04,
                ),
                actions: <Widget>[
                  IconButton(
                    splashRadius: 20,
                    icon: Icon(
                      FontAwesomeIcons.search,
                      size: 19,
                    ),
                    onPressed: () {
                      // do something
                    },
                  ),
                  IconButton(
                    splashRadius: 20,
                    icon: Icon(
                      Icons.settings,
                    ),
                    onPressed: () {
                    },
                  ),
                ],
              ),
              widget.projects.length == 0 ?
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(top: 300.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Chưa có bài viết nào!",
                            style: const TextStyle(
                              fontSize: 16.0,
                              color: kPrimaryHighLightColor,
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  childCount: 1,
                ),
              )
                  :
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return buildPostSection(widget.posts[index]);
                  },
                  childCount: widget.posts.length,
                ),
              )
            ],
          )
      ),
    );
  }

  GestureDetector buildPostSection(Post post) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PostDetailsScreen(post: post,project: widget.projects.where((p) => p.prj_id==post.projectId).elementAt(0),donator: widget.donator,)),
        );
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(8,4,8,4),
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildPostPicture(post),
            SizedBox(
              height: 10,
            ),
            //Tên dự án
            Text(
              post.post_name,
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
  Stack buildPostPicture(Post post) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.width - 200,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(post.image_url),
              )),
        ),
      ],
    );
  }
}
