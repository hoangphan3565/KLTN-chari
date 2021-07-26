import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:chari/models/models.dart';
import 'package:chari/screens/screens.dart';
import 'package:chari/services/services.dart';
import 'package:chari/utility/utility.dart';
import 'package:chari/widgets/widgets.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:video_player/video_player.dart';



class PostDetailsScreen extends StatefulWidget {
  final int post_id;
  final Donator donator;
  PostDetailsScreen({@required this.post_id,this.donator});
  @override
  _PostDetailsScreenState createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  final dataKey = new GlobalKey();
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  bool _isLoading=true;
  Project project;
  Post post;

  _getPostById() async {
    await PostService.getPostById(widget.post_id).then((response) {
      setState(() {
        final Map res = json.decode(utf8.decode(response.bodyBytes));
        post = Post.fromJson(res);
        this.initializePlayer(post.video_url);
      });
    });
    await ProjectService.getProjectById(post.projectId).then((response) {
      setState(() {
        final Map res = json.decode(utf8.decode(response.bodyBytes));
        project = Project.fromJson(res);
        this.initializePlayer(project.video_url);
        _isLoading=false;
      });
    });
  }


  @override
  void initState() {
    _getPostById();
    super.initState();
  }

  @override
  void dispose() {
    this._videoPlayerController.dispose();
    _isLoading=false;
    super.dispose();
  }
  

  Future<void> initializePlayer(String video_url) async {
    _videoPlayerController = VideoPlayerController.network(video_url);
    await _videoPlayerController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: false,
      showControls: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.red,
        handleColor: Colors.blue,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.lightGreen,
      ),
      placeholder: Container(
        color: Colors.grey,
      ),
      autoInitialize: true,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Thông tin chi tiết',
          style: const TextStyle(
            color: kPrimaryColor,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            letterSpacing: -1.2,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.more_vert,
            ),
            onPressed: () {
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 0),
              decoration: BoxDecoration(
                  color: _isLoading? Colors.white:Colors.grey.withOpacity(0.2),
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(0))),
              child: SingleChildScrollView(
                child:_isLoading?Container(
                  margin: EdgeInsets.symmetric(vertical: size.height/4,horizontal: size.width/2.5),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/loading.gif",
                        height: size.height * 0.13,
                      ),
                    ],
                  ),
                ): Column(
                  children: [
                    if(post.video_url!=null)
                      buildPostVideo(),
                    if(post.video_url==null)
                      buildMainImage(post),
                    SizedBox(height: 8),
                    buildPostInfo(post),
                    buildPostDetails(post),
                  ],
                ),
              ),
            ),
          )
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        padding: EdgeInsets.fromLTRB(0,5,0,5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(0)),
        child: Row(
          children: [
            SizedBox(width: MediaQuery.of(context).size.width * 0.02,),
            _isLoading? SizedBox():
            (project.status=='ACTIVATING')?
            ActionButton(
              height: 45,
              fontSize: 18,
              width: MediaQuery.of(context).size.width * 0.96,
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DonateScreen(project: project,donator: widget.donator,)),
                ),
              },
              buttonText: 'Quyên góp ngay',
              buttonColor: kPrimaryHighLightColor,
              textColor: Colors.white,
            ):
            ActionButton(
              height: 45,
              fontSize: 18,
              width: MediaQuery.of(context).size.width * 0.96,
              onPressed: () => {
                Navigator.of(context).pop()
              },
              buttonText: 'Quay lại',
              // buttonColor: kPrimaryHighLightColor,
              // textColor: Colors.white,
            ),
            SizedBox(width: MediaQuery.of(context).size.width * 0.02,),
          ],
        ),
      ),
    );
  }


  Container buildMainImage(Post Post) {
    return Container(
      height: MediaQuery.of(context).size.width - 180,
      decoration: BoxDecoration(
        color: const Color(0xff7c94b6),
        image: DecorationImage(
          image: NetworkImage(Post.image_url),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        border: Border.all(
          color: Colors.orange.withOpacity(0.3),
          width: 1.0,
        ),
      ),
    );
  }

  Container buildPostVideo() {
    return Container(
      height: MediaQuery.of(context).size.width - 180,
      child: _chewieController != null &&_chewieController.videoPlayerController.value.initialized ? Chewie( controller: _chewieController,) :
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text('Đang tải'),
        ],
      ),
    );
  }

  Container buildPostInfo(Post post){
    return Container(
      margin: EdgeInsets.fromLTRB(8,5,8,5),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }


  Container buildPostDetails(Post post){
    return Container(
      margin: EdgeInsets.fromLTRB(8,5,8,5),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Text(
            post.post_content,
            style: TextStyle(
                fontSize: 14,
                color: Colors.black),
          ),
          SizedBox(height: 20),
          Container(
            height: 1,
            color: Colors.grey[300],
            margin: EdgeInsets.symmetric(horizontal: 0),
          ),
          SizedBox(height: 20),
          Text(
            "Hình ảnh",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          SizedBox(height: 5),
          Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/images/loading.gif")
                  ))
          ),
          Container(
              child: Column(children: <Widget>[
                CarouselSlider(
                  options: CarouselOptions(
                    autoPlay: true,
                    aspectRatio: 2.0,
                    enlargeCenterPage: true,
                  ),
                  items: post.imgList.map((item) => Container(
                    child: Container(
                      margin: EdgeInsets.all(5.0),
                      child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          child: Stack(
                            children: <Widget>[
                              Image.network(item, fit: BoxFit.cover, width: 1000.0),
                              Positioned(
                                bottom: 0.0,
                                left: 0.0,
                                right: 0.0,
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                                ),
                              ),
                            ],
                          )
                      ),
                    ),
                  )).toList(),
                ),
              ],)
          ),
          SizedBox(height: 20),
          Container(
            height: 1,
            color: Colors.grey[300],
            margin: EdgeInsets.symmetric(horizontal: 0),
          ),
        ],
      ),
    );
  }
}