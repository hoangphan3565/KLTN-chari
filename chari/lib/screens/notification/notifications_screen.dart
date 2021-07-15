import 'dart:convert';
import 'package:quiver/async.dart';
import 'package:chari/models/donator_notification.dart';
import 'package:chari/models/models.dart';
import 'package:chari/models/project_model.dart';
import 'package:chari/screens/home/project_details_screen.dart';
import 'package:chari/screens/screens.dart';
import 'package:chari/services/services.dart';
import 'package:chari/utility/utility.dart';
import 'package:chari/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsScreen extends StatefulWidget {
  Donator donator;
  int total;
  NotificationsScreen({Key key, @required this.donator,this.total}) : super(key: key);
  @override
  _NotificationsScreenState createState()=> _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>{

  var push_notification_list = new List<PushNotification>();
  var favorite_notification_list = new List<bool>();
  var projects_ready_to_move_money = new List<Project>();

  int size = 10;
  int numOfItem=0;
  int page = 1;
  var inpage_donator_notification_list=List<DonatorNotification>();
  var p = List<Project>();


  TextEditingController _searchQueryController = TextEditingController();
  bool _isTapingSearchKey = false;
  bool _isSearching = false;
  bool _isLoading = true;
  String searchQuery = "*";

  _getProjectAndNavigate(DonatorNotification n) async {
    await ProjectService.getProjectById(n.project_id).then((response) {
      setState(() {
        List<dynamic> list = json.decode(utf8.decode(response.bodyBytes));
        p = list.map((model) => Project.fromJson(model)).toList();
      });
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ProjectDetailsScreen(project: p.elementAt(0),donator: widget.donator,)),
    );
  }

  _getProjectReadyToMoveMoney(int money) async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String token = _prefs.getString('token');
    ProjectService.getProjectReadyToMoveMoney(money, token).then((response) {
      setState(() {
        List<dynamic> list = json.decode(utf8.decode(response.bodyBytes));
        projects_ready_to_move_money = list.map((model) => Project.fromJson(model)).toList();
      });
    });
  }

  _getPushNotification() async{
    DonatorNotificationService.getPushNotification(widget.donator.token).then((response) {
      setState(() {
        List<dynamic> list = json.decode(utf8.decode(response.bodyBytes));
        push_notification_list = list.map((model) => PushNotification.fromJson(model)).toList();
      });
    });
  }

  _getFavoriteNotification() async{
    DonatorService.getFavoriteNotificationList(widget.donator.id, widget.donator.token).then((response) {
      setState(() {
        List<bool> list = (json.decode(response.body) as List<dynamic>).cast<bool>();
        favorite_notification_list = list;
      });
    });
  }

  _countTotalNotification() async{
    await DonatorNotificationService.getTotalDonatorNotificationByDonatorId('*',widget.donator.id,widget.donator.token).then((response) {
      dynamic res = utf8.decode(response.bodyBytes);
      setState(() {
        widget.total = int.tryParse(res);
      });
    });
  }

  _getNotification(){
    DonatorNotificationService.getDonatorNotificationListByDonatorIdPageASizeB(searchQuery,widget.donator.id,page,size,widget.donator.token).then((response) {
      setState(() {
        List<dynamic> list = json.decode(utf8.decode(response.bodyBytes));
        inpage_donator_notification_list = list.map((model) => DonatorNotification.fromJson(model)).toList();
        _isLoading=false;
      });
    });
  }

  _getMoreDonatorNotification(){
    DonatorNotificationService.getDonatorNotificationListByDonatorIdPageASizeB(searchQuery,widget.donator.id,page,size,widget.donator.token).then((response) {
      setState(() {
        List<dynamic> list = json.decode(utf8.decode(response.bodyBytes));
        inpage_donator_notification_list += list.map((model) => DonatorNotification.fromJson(model)).toList();
      });
    });
  }

  void loadMore() {
    setState(() {
      if(numOfItem<=widget.total-size){
        numOfItem+=size;
      }else{
        numOfItem+= widget.total - numOfItem;
      }
      if(numOfItem>inpage_donator_notification_list.length){
        page++;
        _getMoreDonatorNotification();
        print('Call API!!');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getNotification();
    _getPushNotification();
    _getFavoriteNotification();
    if(widget.total>=size){numOfItem=size;}
    else{numOfItem = widget.total;}
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(0))
          ),
          child: NotificationListener<ScrollNotification>(
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
                    title: _isSearching?_buildSearchField():Image.asset(
                      "assets/icons/logo.png",
                      height: size.height * 0.05,
                    ),
                    actions: _buildActions()
                  ),
                  _isLoading==true?
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: size.height/3),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/images/loading.gif",
                                height: size.height * 0.13,
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: 1,
                    ),
                  ):
                  (inpage_donator_notification_list.length==0?
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: size.height/3.5),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/icons/nodata.png",
                                height: size.height * 0.13,
                              ),
                              Text(
                                "Không tìm thấy kết quả!",
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
                  ) :
                  SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            return (index == inpage_donator_notification_list.length ) ?
                            Container(
                              child: FlatButton(
                                child: Text("",style: TextStyle(color: kPrimaryHighLightColor),),
                                onPressed: () {
                                  loadMore();
                                },
                              ),
                            ) : buildNotificationInfo(inpage_donator_notification_list[index],index);
                          },
                          childCount: (numOfItem < widget.total) ? inpage_donator_notification_list.length + 1 : inpage_donator_notification_list.length,
                        ),
                      ))
                ],
              )
          )
      ),
    );
  }

  _showSettingDialog(BuildContext context) {
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
              SettingNotificationScreen(push_notification_list:push_notification_list,favorite_notification_list:favorite_notification_list)
            ],
          );
        }
    );
  }

  _showProjectsReadyToMoveMoneyDialog(BuildContext context,List<Project> projects,int handling_project_id,int donator_id,int money,String token,int index){
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
                    Text("Chọn dự án muốn chuyển",
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
                    for(int i=0;i<projects.length;i++)
                      buildProjectInfo(projects.elementAt(i),handling_project_id,donator_id,money,token,index),
                    RoundedButton(
                        text: "Quay lại",
                        press: (){
                          Navigator.pop(context);
                        }
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  _showAskForMoveMoneyDialog(BuildContext context,int project_id,int donator_id,int money,String token,int index){
    Size size = MediaQuery.of(context).size;
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
          return Container(
            padding: EdgeInsets.only(right: 24, left: 24, top: 12, bottom: 24),
            child: Stack(
              children: [
                Positioned(
                  right: size.width*0.35,top:-26,
                  child: Icon(Icons.horizontal_rule_rounded,size: 60,color: Colors.black38,),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 16),
                      Text("Xử lý chuyển dời tiền",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        height: 1.5,
                        color: Colors.grey[300],
                        margin: EdgeInsets.symmetric(horizontal: 0),
                      ),
                      SizedBox(height: 10),
                      Text("Tổng số tiền",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                      Text(MoneyUtility.convertToMoney(money.toString())+" đ",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      RoundedButton(
                          text: "Chuyển đến dự án khác",
                          press: (){
                            _showProjectsReadyToMoveMoneyDialog(context,projects_ready_to_move_money,project_id,donator_id,money,token,index);
                          }
                      ),
                      Text("Hoặc",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                      RoundedButton(
                          text: "Chuyển đến quỹ chung",
                          textColor: kPrimaryHighLightColor,
                          color: kPrimaryLightColor,
                          press: () async {
                            Navigator.pop(context);
                            var res = await DonatorService.putMoveMoney(project_id, donator_id, 0, money, token);
                            var jsRes = json.decode(utf8.decode(res.bodyBytes));
                            Fluttertoast.showToast(
                                msg: jsRes['message'],
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: kPrimaryColor,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                            if(jsRes['errorCode']==0){
                              inpage_donator_notification_list.elementAt(index).handled=true;
                              initState();
                            }
                          }
                      ),
                    ],
                  ),
                ),
              ],
            ),

          );
        }
    );
  }

  _showInformDialog(BuildContext context){
    Size size = MediaQuery.of(context).size;
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
              Container(
                padding: EdgeInsets.only(right: 24, left: 24, top: 12, bottom: 24),
                child: Stack(
                  children: [
                    Positioned(
                      right: size.width*0.35,top:-26,
                      child: Icon(Icons.horizontal_rule_rounded,size: 60,color: Colors.black38,),
                    ),
                    Column(
                      children: <Widget>[
                        SizedBox(height: 16),
                        Text("Trường hợp này đã được xử lý",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          height: 1.5,
                          color: Colors.grey[300],
                          margin: EdgeInsets.symmetric(horizontal: 0),
                        ),
                        SizedBox(height: 10),
                        RoundedButton(
                            text: "Đóng",
                            press: (){
                              Navigator.pop(context);
                            }
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        }
    );
  }

  Container buildProjectInfo(Project project,int handling_project_id,int donator_id,int money,String token,int index){
    return Container(
            margin: EdgeInsets.fromLTRB(0,5,0,5),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(width: 1, color: Colors.black),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        project.project_name,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Đạt được ',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: Colors.black),
                          ),
                          Text(
                            (project.cur_money/project.target_money*100).toStringAsFixed(1)+" %",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      RoundedButton(
                          text: "Chuyển",
                          textColor: kPrimaryHighLightColor,
                          color: kPrimaryLightColor,
                          press: () async {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            var res = await DonatorService.putMoveMoney(handling_project_id,donator_id,project.prj_id,money,token);
                            var jsRes = json.decode(utf8.decode(res.bodyBytes));
                            Fluttertoast.showToast(
                                msg: jsRes['message'],
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: kPrimaryColor,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                            if(jsRes['errorCode']==0){
                              inpage_donator_notification_list.elementAt(index).handled=true;
                              initState();
                            }
                          }
                      ),
                    ],
                  ),
                ),
              ],
            )
        );
  }

  GestureDetector buildNotificationInfo(DonatorNotification notification,int index){
    return GestureDetector(
        onTap: () async {
          _getProjectReadyToMoveMoney(notification.total_money);
          if(notification.topic!='CLOSED'&&notification.topic!=null){
            _getProjectAndNavigate(notification);
          }
          if(notification.topic=='CLOSED'){
            if(notification.handled==true){
              _showInformDialog(context);
            }
            if(notification.handled!=true){
              SharedPreferences _prefs = await SharedPreferences.getInstance();
              _showAskForMoveMoneyDialog(context,notification.project_id,_prefs.getInt('donator_id'),notification.total_money,_prefs.getString('token'),index);
            }
          }
        },
        child:  Container(
          margin: EdgeInsets.fromLTRB(5,5,5,0),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 10,
                offset: Offset(5, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Text(
                          notification.title,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        if(notification.topic=='CLOSED' && notification.handled==true)
                          Text(
                            ' (Đã xử lý)',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ),
                        if(notification.topic=='CLOSED' && notification.handled==false)
                          Text(
                            ' (Chưa xử lý)',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      notification.message,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      DateFormat('kk:mm dd-MM-yy').format(DateTime.parse(notification.create_time)),
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Container(
                height: 90,
                width: 75,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(notification.project_image)
                    )),
              )
            ],
          ),
        )
    );
  }

  Widget _buildSearchField() {
    return SearchField(
      hintText: 'Tìm kiếm thông báo',
      controller: _searchQueryController,
      showClearIcon: _isTapingSearchKey,
      onTapClearIcon: _clearSearchQuery,
      onChanged: (query) => _updateSearchQuery(query),
      onSubmitted: (query) => _letSearch(query),
    );
  }


  List<Widget> _buildActions() {
    Size size = MediaQuery.of(context).size;
    if (_isSearching) {
      return <Widget>[
        ActionButton(
          width: 75,
          height: 25,
          onPressed: ()=>{_stopSearching(),},
          buttonText: 'Đóng',
          borderRadius: 0.0,
          borderColor: Colors.white70,
          buttonColor: Colors.white,
          textColor: kPrimaryHighLightColor,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ];
    }

    return <Widget>[
      IconButton(
          splashRadius: size.height * 0.03,
          icon: Icon(
            FontAwesomeIcons.search,
            size: size.height * 0.03,
            color: kPrimaryHighLightColor,
          ),
          onPressed: _startSearch
      ),
      IconButton(
        splashRadius: 20,
        icon: Icon(
          Icons.settings_rounded,
          color: kPrimaryHighLightColor,
          size: size.height * 0.036,
        ),
        onPressed: () {
          _showSettingDialog(context);
        },
      ),
    ];
  }

  _resetElement(){
    setState(() {
      this.size = 5;
      this.numOfItem=0;
      this.page = 1;
    });
  }

  _getNewData(){
    _resetElement();
    setState(() {
      this.inpage_donator_notification_list.clear();
      _getNotification();
      _countTotalNotification();
    });
  }

  _startSearch() {
    setState(() {
      _isSearching = true;
    });
    _resetElement();
  }


  _letSearch(String searchKey) {
    if(searchQuery!='' && searchQuery!='*'){
      setState(() {
        _isLoading=true;
      });
      _getNewData();
    }
  }

  _updateSearchQuery(String newQuery) {
    setState(() {
      if(newQuery!=''){
        setState(() {
          _isTapingSearchKey=true;
          searchQuery = newQuery;
        });
      }else{
        _isTapingSearchKey=false;
      }
    });
  }

  _stopSearching() {
    setState(() {
      _isLoading = true;
    });
    _clearSearchQuery();
    _getNewData();
    setState(() {
      _isSearching = false;
    });
  }

  _clearSearchQuery() async {
    setState(() {
      _searchQueryController.clear();
      _updateSearchQuery("");
      searchQuery="*";
      _isTapingSearchKey=false;
    });
  }
}
