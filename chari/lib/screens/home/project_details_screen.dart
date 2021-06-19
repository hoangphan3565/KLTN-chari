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
import 'package:fluttertoast/fluttertoast.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_player/video_player.dart';



class ProjectDetailsScreen extends StatefulWidget {
  final Project project;
  final Donator donator;
  ProjectDetailsScreen({@required this.project,this.donator});
  @override
  _ProjectDetailsScreenState createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  final dataKey = new GlobalKey();
  VideoPlayerController _videoPlayerController;
  ChewieController _chewieController;

  List<String> listProjectIdFavorite = new List<String>();

  var listDonation = new List<DonateDetailsOfProject>();
  int numViewDonation = 0;

  var listComment = new List<Comment>();
  int numViewComment = 0;

  bool viewAll = false;

  @override
  void initState() {
    super.initState();
    this.initializePlayer(widget.project.video_url);
    _getDonation();
    _getComment();
    timeago.setLocaleMessages('vi',timeago.ViMessages());

  }

  @override
  void dispose() {
    super.dispose();
    this._videoPlayerController.dispose();
  }

  _getDonation() {
    DonateDetailsService.getDonateDetailsByProjectId(widget.project.prj_id).then((response) {
      setState(() {
        List<dynamic> list = json.decode(utf8.decode(response.bodyBytes));
        listDonation = list.map((model) => DonateDetailsOfProject.fromJson(model)).toList();
        if(listDonation.length>=5){
          numViewDonation=5;
        }else{
          numViewDonation = listDonation.length;
        }
      });
    });
  }

  _getComment() {
    CommentService.getCommentListByProjectId(widget.project.prj_id).then((response) {
      setState(() {
        List<dynamic> list = json.decode(utf8.decode(response.bodyBytes));
        listComment = list.map((model) => Comment.fromJson(model)).toList();
        if(listComment.length>=3){
          numViewComment=3;
        }else{
          numViewComment = listComment.length;
        }
      });
    });
  }

  _sendComment(String name,String content,BuildContext context) {
    if(widget.donator!=null){
      name = widget.donator.full_name;
    }
    if(name!='' && content!=''){
      CommentService.saveComment(widget.project.prj_id,name,content).then((response) {
        setState(() {
          List<dynamic> list = json.decode(utf8.decode(response.bodyBytes));
          listComment = list.map((model) => Comment.fromJson(model)).toList();
          if(listComment.length>=3){
            numViewComment=3;
          }else{
            numViewComment = listComment.length;
          }
        });
      });
      Navigator.pop(context);
    }else{
      Fluttertoast.showToast(
          msg: "Hãy điền đầy đủ thông tin",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: kPrimaryColor,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
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
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(0))),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if(widget.project.video_url!=null)
                      buildProjectVideo(),
                    if(widget.project.video_url==null)
                      buildMainImage(widget.project),
                    SizedBox(height: 8),
                    buildProjectInfo(widget.project),  
                    buildProjectDetails(widget.project),
                    buildCommentContainer(context),
                    if(!listDonation.isEmpty)
                      buildRecentDonatorList(context),
                  ],
                ),
              ),
            ),
          )
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Row(
        children: [
          SizedBox(width: MediaQuery.of(context).size.width * 0.02,),
          Container(
            height: 45,
            width: MediaQuery.of(context).size.width * 0.6,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4), color: kPrimaryColor),
            child:((widget.project.status=='ACTIVATING')?
            FlatButton(
              onPressed:()=> {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DonateScreen(project: widget.project,donator: widget.donator,)),
                ),
              },
              child: Text(
                "Quyên góp ngay",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            )
                :
            FlatButton(
              onPressed:()=> {
                Navigator.of(context).pop()
              },
              child: Text(
                "Quay lại",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            )
            ),
          ),
          SizedBox(width: MediaQuery.of(context).size.width * 0.02,),
          Container(
            height: 45,
            width: MediaQuery.of(context).size.width * 0.34,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4), color: kPrimaryColor),
            child: FlatButton(
              onPressed:()=> {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DonateScreen(project: widget.project,donator: widget.donator,)),
                ),
              },
              child: Text(
                "Chia sẻ",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            )
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.white12,
                spreadRadius: 1,
              )
            ],
            color: Colors.white12.withOpacity(0.1),
            borderRadius: BorderRadius.circular(0)),
        child: Row(
          children: [
            buildNavBarItem(),
          ],
        ),
      ),
    );
  }

  Widget buildNavBarItem() {
    return GestureDetector(
      child: Container(
        width: MediaQuery.of(context).size.width*0.9,
        height: 30,
      ),
    );
  }

  Container buildMainImage(Project project) {
    return Container(
      height: MediaQuery.of(context).size.width - 180,
      decoration: BoxDecoration(
        color: const Color(0xff7c94b6),
        image: DecorationImage(
          image: NetworkImage(project.image_url),
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
  
  Container buildProjectVideo() {
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

  Container buildProjectInfo(Project project){
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
            project.project_name,
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            project.brief_description,
            style: TextStyle(
                fontSize: 15,
                color: Colors.black54),
          ),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }

  Container buildProjectDetails(Project project){
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
          buildProgressPercentRow(project),
          SizedBox(height: 10),
          buildInfoDetailsRow(project),
          SizedBox(height: 20),
          Container(
            height: 1,
            color: Colors.grey[300],
            margin: EdgeInsets.symmetric(horizontal: 0),
          ),
          SizedBox(height: 20),
          Text(
            "Thông tin dự án",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          SizedBox(height: 10),
          viewAll==false?
          Text(
            widget.project.description.substring(0, 180),
            style: TextStyle(
                fontSize: 14,
                color: Colors.black),
          ):Text(
            widget.project.description,
            style: TextStyle(
                fontSize: 14,
                color: Colors.black),
          ),
          viewAll==false?
          Center(
            child: FlatButton(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              onPressed: ()=>{
                setState(() {
                  viewAll=true;
                })
              },
              child: Text(
                'Xem thêm',
                style: TextStyle(color: kPrimaryHighLightColor,fontSize: 16),
              ),
            ),
          ):Center(
            child: FlatButton(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
              onPressed: ()=>{
                setState(() {
                  viewAll=false;
                })
              },
              child: Text(
                'Ẩn bớt',
                style: TextStyle(color: kPrimaryHighLightColor,fontSize: 16),
              ),
            ),
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
                  items: widget.project.imgList.map((item) => Container(
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

  Row buildInfoDetailsRow(Project project) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Text(
                  "Lượt quyên góp",
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
                Text(
                  project.num_of_donations.toString(),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
            SizedBox(
              width: 50,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Đạt được",
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
                Text(
                  (project.cur_money/project.target_money*100).round().toString()+" %",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
            SizedBox(
              width: 40,
            ),
            if (project.status == 'ACTIVATING')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Thời hạn còn",
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    project.remaining_term.toString()+" Ngày",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              ),
            if (project.status == 'REACHED')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Đã đạt mục tiêu",
                    style: TextStyle(
                      fontSize: 13,
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              ),
            if (project.status == 'OVERDUE')
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Đã hết thời hạn",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                ],
              )
          ],
        ),
      ],
    );
  }

  Row buildProgressPercentRow(Project project) {
    double percent;
    if(project.cur_money >= project.target_money){
      percent = 1.0;
    }
    else{
      percent = project.cur_money / project.target_money;
    }
    return Row(
        children: [
          if (project.status != 'OVERDUE')
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Đã quyên góp ",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black),
                    ),
                    Text(
                      MoneyUtility.convertToMoney(project.cur_money.toString()),
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Text(
                      " / "+ MoneyUtility.convertToMoney(project.target_money.toString()) + " đ",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black),
                    ),

                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width*0.9,
                  lineHeight: 8.0,
                  percent: percent,
                  progressColor: kPrimaryColor,
                ),
              ],
            ),
          if (project.status == 'OVERDUE')
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Đã quyên góp ",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black),
                    ),
                    Text(
                      MoneyUtility.convertToMoney(project.cur_money.toString()),
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Text(
                      " / "+ MoneyUtility.convertToMoney(project.target_money.toString()) + " đ",
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black),
                    ),

                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width*0.9,
                  lineHeight: 8.0,
                  percent: percent,
                  progressColor: Colors.grey,
                ),
              ],
            )
        ]);
  }

  Container buildCommentContainer(BuildContext context){
    Size size = MediaQuery.of(context).size;
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Bình luận",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Container(
                width: size.width/3,
                height: 35,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: kPrimaryHighLightColor),
                  borderRadius: BorderRadius.circular(8), color: kPrimaryLightColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: FlatButton(
                  onPressed:() => {
                    _showCommentDialog(context)
                  },
                  child: Text(
                    "Gửi bình luận",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.normal,
                        color: kPrimaryHighLightColor),
                  ),
                ),
              ),

            ],
          ),

          SizedBox(height:5),
          if(!listComment.isEmpty)
            for(int i=0;i<numViewComment;i++)
              buildComment(listComment[i],context),

          if(numViewComment != listComment.length )
            Center(
              child: FlatButton(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                onPressed: ()=>{
                  setState(() {
                    if(numViewComment<=listComment.length-5){
                      numViewComment+=5;
                    }else{
                      numViewComment+= listComment.length - numViewComment;
                    }
                  })
                },
                child: Text(
                  'Xem thêm',
                  style: TextStyle(color: kPrimaryHighLightColor,fontSize: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Row buildComment(Comment comment,BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5,
                ),
                if(comment.donator_name!=null)
                  Text(
                    comment.donator_name,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                    ),
                  ),
                if(comment.donator_name==null)
                  Text(
                    "Nhà hảo tâm",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                    ),
                  ),
                if(comment.content!=null)
                  Container(
                    width: MediaQuery.of(context).size.width*0.9,
                    child: Text(
                      comment.content,
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.black),
                    ),
                  ),
                SizedBox(
                  height: 3,
                ),
                Text(
                  timeago.format(DateTime.parse(comment.comment_date), locale: 'vi'),
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.normal,
                      color: Colors.black54),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  _showCommentDialog(BuildContext context) {
    var focusNode = FocusNode();
    focusNode.requestFocus();
    TextEditingController _nameField = TextEditingController();
    TextEditingController _contentField = TextEditingController();
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        builder: (BuildContext context){
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(right: 24, left: 24, top: 32, bottom: 24),
              child: Column(
                children: <Widget>[
                  Text("Bình luận",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryHighLightColor,
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    height: 1.5,
                    color: Colors.grey[300],
                    margin: EdgeInsets.symmetric(horizontal: 0),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Column(
                      children: [
                        if(widget.donator==null)
                          RoundedInputField(
                            icon: Icons.person,
                            hintText: 'Tên',
                            keyboardType: TextInputType.name,
                            controller: _nameField,
                            onTapClearIcon: ()=>{_nameField.clear()},
                            onChanged: (value) {},
                          ),
                        RoundedInputField(
                          icon: Icons.chat_outlined,
                          hintText: 'Nội dung',
                          focusNode: focusNode,
                          keyboardType: TextInputType.name,
                          controller: _contentField,
                          onTapClearIcon: ()=>{_contentField.clear()},
                          onChanged: (value) {},
                        ),
                        RoundedButton(
                          text: "Gửi",
                          press: (){
                            _sendComment(_nameField.text,_contentField.text,context);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  Container buildRecentDonatorList(BuildContext context){
    return Container(
      margin: EdgeInsets.fromLTRB(8,5,8,20),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Hoạt động quyên góp gần đây",
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
          SizedBox(height:5),

          if(!listDonation.isEmpty)
            for(int i=0;i<numViewDonation;i++)
              buildDonationInfo(listDonation[i]),

          if(numViewDonation != listDonation.length )
            Center(
              child: FlatButton(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                onPressed: ()=>{
                  setState(() {
                    if(numViewDonation<=listDonation.length-5){
                      numViewDonation+=5;
                    }else{
                      numViewDonation+= listDonation.length - numViewDonation;
                    }
                  })
                },
                child: Text(
                  'Xem thêm',
                  style: TextStyle(color: kPrimaryHighLightColor,fontSize: 16),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Row buildDonationInfo(DonateDetailsOfProject donation) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 5,
                ),
                if(donation.donator_name!=null)
                  Text(
                    donation.donator_name,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                    ),
                  ),
                if(donation.donator_name==null)
                  Text(
                    "Nhà hảo tâm",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                    ),
                  ),
                if(donation.phone!=null)
                  Text(
                    donation.phone,
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54),
                  ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ],
        ),
        Text(
          MoneyUtility.convertToMoney(donation.money) + " đ",
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black),
        ),
        if(donation.status=='FAILED')
          Text(
            " (Đã chuyển dời tiền)",
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Colors.red),
          ),
      ],
    );
  }



}