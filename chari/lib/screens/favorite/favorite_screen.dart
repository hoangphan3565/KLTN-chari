
import 'dart:convert';

import 'package:chari/API.dart';
import 'package:chari/utility/utility.dart';
import 'package:chari/models/models.dart';
import 'package:chari/screens/screens.dart';
import 'package:chari/utility/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteScreen extends StatefulWidget {
  final List<Project> projects;
  FavoriteScreen({@required this.projects});
  @override
  _FavoriteScreenState createState()=> _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen>{

  var favorite_projects = new List<Project>();
  List<String> listProjectIdFavorite = new List<String>();


  initState() {
    super.initState();
    _getFavoriteProjects();
  }

  dispose() {
    super.dispose();
  }
  _getFavoriteProjects() async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String temp = _prefs.getString('donator_favorite_project');
    if(temp!=null){
      listProjectIdFavorite = temp.split(" ");
    }
    //chọn cái bài viết mà nhà hảo tâm đã quan tâm để lưu vào một danh sách khác
    for (int i = 0;i < widget.projects.length;i++) {
      if(listProjectIdFavorite.contains(widget.projects[i].prj_id.toString()) == true)  {
        setState(() {
          favorite_projects.add(widget.projects[i]);
        });
      }
    }
    //Vì đã tạo một danh sách mới với các bài viết đã quan tâm, Tải hình ảnh của các bài viết này lên để tránh lỗi
    for (int i = 0;i < favorite_projects.length;i++) {
      API.getImageByProjectID(favorite_projects[i].prj_id).then((response) {
        setState(() {
          List<String> imglist = (json.decode(response.body) as List<dynamic>).cast<String>();
          favorite_projects[i].imgList = imglist;
        });
      });
    }
  }

  _removeHeart(Project project)async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    int project_id = _prefs.get("donator_id");
    String token = _prefs.getString('token');
    API.postRemoveProjectFromFavorite(project.prj_id, project_id,token).then((response) {
      setState(() {
        _prefs.setString('donator_favorite_project',json.decode(response.body)['favoriteProject']);
      });
    });
    listProjectIdFavorite.remove(project.prj_id.toString());
    favorite_projects.remove(project);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryLightColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(18),
          ),
        ),
        centerTitle: true,
        title: Text(
          'Đã quan tâm',
          style: const TextStyle(
            color: kPrimaryColor,
            fontSize: 27.0,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.2,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          favorite_projects.length == 0 ?
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
                        "Bạn chưa quan tâm bài viết nào!",
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: kPrimaryColor,
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
                  (context, index){
                return buildPostSection(favorite_projects[index]);},
              childCount: favorite_projects.length,
            ),
          )
        ],
      ),
    );
  }


  Container buildPostSection(Project project) {
    return Container(
      margin: EdgeInsets.fromLTRB(8,4,8,4),
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildPostPicture(project),
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
          //Thông tin vắn tắt
          Text(
            project.brief_description,
            style: TextStyle(
                fontSize: 15,
                color: Colors.black26),
          ),
          SizedBox(
            height: 5,
          ),
          //Dấu phân tách
          Container(
            height: 1.5,
            color: Colors.grey[300],
            margin: EdgeInsets.symmetric(horizontal: 0),
          ),
          SizedBox(
            height: 5,
          ),
          buildProgressPercentRow(project),
          SizedBox(
            height: 5,
          ),
          buildInfoDetailsRow(context,project),
        ],
      ),
    );
  }

  Stack buildPostPicture(Project project) {
    return Stack(
      children: [
        InkWell(
          onTap: ()=>{
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProjectDetailsScreen(project: project,)),
            ),
          },
          child: Container(
            height: MediaQuery.of(context).size.width - 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
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
                  image: NetworkImage(project.image_url),
                )),
          ),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: InkWell(
              onTap: ()=> {
                _removeHeart(project),
              },
              child: Icon(Icons.favorite, size: 35, color: kPrimaryColor.withOpacity(0.9))
          ),
        )
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
          if (project.status != 'overdue')
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Đã quyên góp được ${MoneyUtility.convertToMoney(project.cur_money.toString())} đ / ${MoneyUtility.convertToMoney(project.target_money.toString())} đ",
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.black),
                ),
                SizedBox(
                  height: 8,
                ),
                LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width-60,
                  lineHeight: 8.0,
                  percent: percent,
                  progressColor: kPrimaryColor,
                ),
              ],
            ),
          if (project.status == 'overdue')
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Đã quyên góp được ${MoneyUtility.convertToMoney(project.cur_money.toString())} đ / ${MoneyUtility.convertToMoney(project.target_money.toString())} đ",
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.black),
                ),
                SizedBox(
                  height: 8,
                ),
                LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width-60,
                  lineHeight: 8.0,
                  percent: percent,
                  progressColor: Colors.grey,
                ),
              ],
            )
        ]);
  }

  Row buildInfoDetailsRow(BuildContext context, Project project) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
              width: 20,
            ),
            if(project.status == 'activating')
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
            if(project.status != 'activating')
              Column(),
          ],
        ),
        if(project.status == 'activating')
          Container(
            width: 125,
            height: 35,
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: kPrimaryColor),
                borderRadius: BorderRadius.circular(10), color: kPrimaryLightColor),
            child:FlatButton(
              onPressed:() => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DonateScreen(project: project,)),
                ),
              },
              child: Text(
                "Quyên góp",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: kPrimaryColor),
              ),
            ),
          ),
        if(project.status == 'reached')
          Container(
            width: 180,
            height: 35,
            decoration: BoxDecoration(
                border: Border.all(width: 1.5, color: Colors.grey),
                borderRadius: BorderRadius.circular(10), color: Colors.white),
            child:FlatButton(
              onPressed:() => {},
              child: Text(
                "Đã đạt mục tiêu",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey),
              ),
            ),
          ),
        if(project.status == 'overdue')
          Container(
            width: 125,
            height: 35,
            decoration: BoxDecoration(
                border: Border.all(width: 1.5, color: Colors.grey),
                borderRadius: BorderRadius.circular(10), color: Colors.white),
            child:FlatButton(
              onPressed:() => {},
              child: Text(
                "Đã hết hạn",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey),
              ),
            ),
          ),
      ],
    );
  }
}
