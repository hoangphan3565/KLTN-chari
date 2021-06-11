import 'dart:convert';

import 'package:chari/services/services.dart';
import 'package:chari/models/models.dart';
import 'package:chari/screens/screens.dart';
import 'package:chari/utility/utility.dart';
import 'package:chari/widgets/custom_alert_dialog.dart';
import 'package:chari/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomeScreen extends StatefulWidget {
  final List<Project> projects;
  final List<ProjectType> project_types;
  final Donator donator;
  final bool isLogin;
  HomeScreen({Key key, @required this.projects,this.project_types,this.donator,this.isLogin}) : super(key: key);

  @override
  _HomeScreenState createState()=> _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen>{

  int _selectedProjectType  = 0;
  var listProjectIdFavorite = new List<String>();

  TabController tabController;

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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: CustomScrollView(
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
                IconButton(
                  splashRadius: 20,
                  icon: Icon(
                    FontAwesomeIcons.filter,
                    size: 18,
                  ),
                  onPressed: () {
                    _showBottomSheet();
                  },
                ),
              ],
            ),
            SliverAppBar(
              backgroundColor:  Colors.white,
              pinned: true,
              centerTitle: true,
              title: widget.project_types.length == 0 ? Text(""):
              Text(
                widget.project_types.where((i) => i.id==_selectedProjectType).elementAt(0).name.toString(),
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              actions: <Widget>[
                widget.project_types.length == 0 ? Text(""):
                PopupMenuButton<ProjectType>(
                  icon:  Icon(FontAwesomeIcons.slidersH,size: 18,),
                  onSelected: (ProjectType result) {
                    setState(() {
                      _selectedProjectType = result.id;
                    });
                  },
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
                  return buildProjectSection(widget.projects[index]);
                },
                childCount: widget.projects.length,
              ),
            )
                :
            (widget.projects.where((i) => i.prt_id==_selectedProjectType).length != 0 ?
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  return buildProjectSection(widget.projects.where((i) => i.prt_id==_selectedProjectType).elementAt(index));
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
                           "Chưa có dự án nào!",
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
                    Text("Đăng nhập hoặc đăng ký",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      height: 1.5,
                      color: Colors.grey[300],
                      margin: EdgeInsets.symmetric(horizontal: 0),
                    ),
                    SizedBox(height: 10),
                    Text("Bạn cần có tài khoản để thực hiện chức năng này"),
                    RoundedButton(
                        text: "Đăng nhập",
                        press: (){
                          Navigator.pop(context);
                          Navigator.push(context,MaterialPageRoute(builder: (BuildContext ctx) => LoginScreen()));
                        }
                    ),
                    RoundedButton(
                        text: "Đăng ký",
                        textColor: kPrimaryHighLightColor,
                        color: kPrimaryLightColor,
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

  GestureDetector buildProjectSection(Project project) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProjectDetailsScreen(project: project,donator: widget.donator,)),
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
            buildProjectPicture(project),
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
              height: 10,
            ),
            Row(
              children: [
                Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: const Color(0xff7c94b6),
                    image: DecorationImage(
                      image: NetworkImage(project.project_type_image_url),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    border: Border.all(
                      color: Colors.orange.withOpacity(0.3),
                      width: 1.0,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  project.project_type_name,
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.black),
                ),
                SizedBox(
                  width: size.width *0.23,
                ),
                if (project.status == 'ACTIVATING' && project.prj_id!=0)
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5), color: Colors.orange.withOpacity(0.3),
                    ),
                    child:Text(
                      " Còn "+project.remaining_term.toString()+" Ngày",
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                          color: kPrimaryHighLightColor),
                    ),
                  ),
              ],
            ),

            SizedBox(
              height: 10,
            ),
            buildProgressPercentRow(project),
            SizedBox(
              height: 15,
            ),
            buildInfoDetailsRow(context,project),
          ],
        ),
      ),
    );
  }

  Stack buildProjectPicture(Project project) {
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
                image: NetworkImage(project.image_url),
              )),
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      MoneyUtility.convertToMoney(project.cur_money.toString()) + " đ",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Text(
                      " / "+ MoneyUtility.convertToMoney(project.target_money.toString()) + " đ",
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                if (project.status == 'ACTIVATING')
                  LinearPercentIndicator(
                    width: MediaQuery.of(context).size.width-52,
                    lineHeight: 7.0,
                    percent: percent,
                    progressColor: kPrimaryColor,
                  ),
                if (project.status == 'REACHED')
                  LinearPercentIndicator(
                    width: MediaQuery.of(context).size.width-52,
                    lineHeight: 7.0,
                    percent: percent,
                    progressColor: Colors.green,
                  ),

              ],
            ),
          if (project.status == 'OVERDUE')
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      MoneyUtility.convertToMoney(project.cur_money.toString())  + " đ",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Text(
                      " / "+ MoneyUtility.convertToMoney(project.target_money.toString()) + " đ",
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                LinearPercentIndicator(
                  width: MediaQuery.of(context).size.width-52,
                  lineHeight: 7.0,
                  percent: percent,
                  progressColor: Colors.grey,
                ),
              ],
            )
        ]);
  }

  Row buildInfoDetailsRow(BuildContext context, Project project) {
    Size size = MediaQuery.of(context).size;
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
                  project.achieved.toString()+" %",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ],
            ),
          ],
        ),
        if(project.status == 'ACTIVATING')
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
            child:FlatButton(
              onPressed:() => {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DonateScreen(project: project,donator: widget.donator,)),
                ),
              },
              child: Text(
                "Quyên góp",
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                    color: kPrimaryHighLightColor),
              ),
            ),
          ),
        if(project.status == 'REACHED')
          Container(
            width: size.width/3,
            height: 35,
            decoration: BoxDecoration(
                border: Border.all(width: 1.5, color: Colors.black54),
                borderRadius: BorderRadius.circular(8), color: Colors.white),
            child:FlatButton(
              onPressed:() => {},
              child: Text(
                "Đạt mục tiêu",
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                    color: Colors.black54),
              ),
            ),
          ),
        if(project.status == 'OVERDUE')
          Container(
            width: size.width/3,
            height: 35,
            decoration: BoxDecoration(
                border: Border.all(width: 1.5, color: Colors.grey),
                borderRadius: BorderRadius.circular(8), color: Colors.white),
            child:FlatButton(
              onPressed:() => {},
              child: Text(
                "Hết hạn",
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey),
              ),
            ),
          ),
      ],
    );
  }

  void _showBottomSheet(){
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
          return Wrap(
            children: [
              Filter(),
            ],
          );
        }
    );
  }

}
