import 'dart:convert';

import 'package:chari/API.dart';
import 'package:chari/models/models.dart';
import 'package:chari/screens/screens.dart';
import 'package:chari/utility/utility.dart';
import 'package:chari/widgets/custom_alert_dialog.dart';
import 'package:chari/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomeScreen extends StatefulWidget {
  final List<Project> projects;
  final List<ProjectType> project_types;
  final bool isLogin;
  HomeScreen({Key key, @required this.projects,this.project_types,this.isLogin}) : super(key: key);

  @override
  _HomeScreenState createState()=> _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen>{

  int _selectedProjectType  = 0;
  var listProjectIdFavorite = new List<String>();


  @override
  initState() {
    super.initState();
    _getlistProjectIdFavorite();
    _selectedProjectType  = 0;
  }

  @override
  dispose() {
    super.dispose();
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
            'Trang chủ',
            style: const TextStyle(
              color: kPrimaryHighLightColor,
              fontSize: 27.0,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.2,
            ),
          ),
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              floating: true,
              title: widget.project_types.length == 0 ? Text(""):
              Text(
                widget.project_types.where((i) => i.id==_selectedProjectType).elementAt(0).name.toString(),
                style: const TextStyle(
                  fontSize: 16.0,
                  color: kPrimaryHighLightColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              actions: <Widget>[
                widget.project_types.length == 0 ? Text(""):
                PopupMenuButton<ProjectType>(
                  icon:  Icon(Icons.menu_open_outlined,color: kPrimaryHighLightColor,),
                  onSelected: (ProjectType result) { setState(() {
                    _selectedProjectType = result.id;
                    print(_selectedProjectType);
                  }); },
                  itemBuilder: (BuildContext context) {
                    return widget.project_types.map((ProjectType choice) {
                      return PopupMenuItem(
                        value: choice,
                        child: Text(choice.name),
                      );
                    }).toList();
                  },
                )
              ],
            ),

            _selectedProjectType == 0 ?
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return buildPostSection(widget.projects[index]);
                },
                childCount: widget.projects.length,
              ),
            )
                :
            (widget.projects.where((i) => i.prt_id==_selectedProjectType).length != 0 ?
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return buildPostSection(widget.projects.where((i) => i.prt_id==_selectedProjectType).elementAt(index));
                },
                childCount: widget.projects.where((i) => i.prt_id==_selectedProjectType).length,
              ),
            )
                :
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
              ))

          ],
        )
    );
  }

  //Function and dialog
  _getlistProjectIdFavorite() async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String temp = _prefs.getString('donator_favorite_project');
    if(temp!=null){
      setState(() {
        listProjectIdFavorite = temp.split(" ");
      });
    }
  }

  _changeStateFavorite(int project_id,bool curstate)async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if(!widget.isLogin){
      _showDialogAskForLoginOrRegister(context);
      return;
    }
    if(curstate){
      API.postRemoveProjectFromFavorite(project_id, _prefs.get("donator_id"),_prefs.getString('token')).then((response) {
        setState(() {
          _prefs.setString('donator_favorite_project',json.decode(response.body)['favoriteProject']);
        });
      });
      listProjectIdFavorite.remove(project_id.toString());
    }else{
      API.postAddProjectToFavorite(project_id, _prefs.get("donator_id"),_prefs.getString('token')).then((response) {
        setState(() {
          _prefs.setString('donator_favorite_project',json.decode(response.body)['favoriteProject']);
        });
      });
      listProjectIdFavorite.add(project_id.toString());
    }
  }

  _showDialogAskForLoginOrRegister(BuildContext context){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            content: Container(
              width: MediaQuery.of(context).size.width / 1,
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Text("Để thực hiện chức năng này bạn hãy đăng nhập trước",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5),
                    RoundedButton(
                        text: "Đăng nhập",
                        press: (){
                          Navigator.pop(context);
                          Navigator.push(context,MaterialPageRoute(builder: (BuildContext ctx) => LoginScreen()));
                        }
                    ),
                    Container(
                      height: 1.5,
                      color: Colors.grey[300],
                      margin: EdgeInsets.symmetric(horizontal: 0),
                    ),
                    SizedBox(height: 10),
                    Text("Nếu chưa có tài khoản đăng ký ngay tại đây"),
                    RoundedButton(
                        text: "Đăng ký",
                        press: (){
                          Navigator.pop(context);
                          Navigator.push(context,MaterialPageRoute(builder: (BuildContext ctx) => SignUpScreen()));
                        }
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  //Build component
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
              _changeStateFavorite(project.prj_id,listProjectIdFavorite.contains(project.prj_id.toString())),
            },
            child: listProjectIdFavorite.contains(project.prj_id.toString()) == true ?
            Icon(Icons.favorite, size: 35, color: kPrimaryColor.withOpacity(0.9))
                :
            Icon(Icons.favorite, size: 35, color: Colors.white.withOpacity(0.9)),
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
          if (project.status != 'OVERDUE')
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
          if (project.status == 'OVERDUE')
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
            if(project.status == 'ACTIVATING')
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
            if(project.status != 'ACTIVATING')
              Column(),
          ],
        ),
        if(project.status == 'ACTIVATING')
          Container(
            width: 125,
            height: 35,
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: kPrimaryHighLightColor),
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
                    color: kPrimaryHighLightColor),
              ),
            ),
          ),
        if(project.status == 'REACHED')
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
        if(project.status == 'OVERDUE')
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
