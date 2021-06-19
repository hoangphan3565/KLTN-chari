import 'dart:convert';
import 'dart:convert' show utf8;
import 'package:chari/models/models.dart';
import 'package:chari/models/project_model.dart';
import 'package:chari/screens/screens.dart';
import 'package:chari/services/services.dart';
import 'package:chari/utility/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PostScreen extends StatefulWidget {
  // List<Project> projects;
  List<Post> posts;
  int total;
  Donator donator;
  PostScreen({Key key, @required this.posts,this.donator,this.total}) : super(key: key);
  @override
  _PostScreenState createState()=> _PostScreenState();
}

class _PostScreenState extends State<PostScreen>{

  int step = 4;
  int numViewItem=0;
  var inpage_posts_list=List<Post>();
  var p = List<Project>();

  _getProjectAndNavigate(Post post) async {
    await ProjectService.getProjectById(post.projectId).then((response) {
      setState(() {
        List<dynamic> list = json.decode(utf8.decode(response.bodyBytes));
        p = list.map((model) => Project.fromJson(model)).toList();
      });
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PostDetailsScreen(post: post,project: p.elementAt(0),donator: widget.donator,)),
    );
  }

  _getMorePost(){
    PostService.getPostsFromAToB(numViewItem,numViewItem+step).then((response) {
      setState(() {
        List<dynamic> list = json.decode(utf8.decode(response.bodyBytes));
        inpage_posts_list += list.map((model) => Post.fromJson(model)).toList();
      });
    });
  }

  void loadMore() {
    _getMorePost();
    setState(() {
      if(numViewItem<=widget.total-step){
        numViewItem+=step;
      }else{
        numViewItem+= widget.total - numViewItem;
      }
      numViewItem += step;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      inpage_posts_list=widget.posts;
      if(widget.total>=step){numViewItem=step;}
      else{numViewItem = widget.total;}
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
              loadMore();
            }
            return true;
          },
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.white,
                floating: true,
                centerTitle: false,
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
                ],
              ),
              widget.posts.length == 0 ?
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
                            "Chưa có tin từ thiện nào!",
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
                    return (index == inpage_posts_list.length ) ?
                    Container(
                      child: FlatButton(
                        child: Text("Đang tải...",style: TextStyle(color: kPrimaryHighLightColor),),
                        onPressed: () {
                          loadMore();
                        },
                      ),
                    ) : buildPostSection(inpage_posts_list[index]);
                  },
                  childCount: (numViewItem <= widget.total) ? inpage_posts_list.length + 1 : inpage_posts_list.length,
                ),
              )
            ],
          )
      )
    );
  }

  GestureDetector buildPostSection(Post post) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (){
        _getProjectAndNavigate(post);
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


