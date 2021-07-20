import 'dart:convert';
import 'package:chari/services/city_service.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quiver/async.dart';
import 'package:chari/models/models.dart';
import 'package:chari/screens/home/project_filter.dart';
import 'package:chari/screens/screens.dart';
import 'package:chari/services/services.dart';
import 'package:chari/utility/utility.dart';
import 'package:chari/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomeScreen extends StatefulWidget {
  int total;
  List<ProjectType> project_types;
  Donator donator;
  bool isLogin;
  HomeScreen({Key key,this.project_types,this.donator,this.isLogin,this.total}) : super(key: key);

  @override
  _HomeScreenState createState()=> _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen>{

  List<String> listProjectIdFavorite = [];
  List<City> listCity = [];

  TextEditingController _searchQueryController = TextEditingController();
  bool _isApplyFilter = false;
  bool _isTaping = false;
  bool _isSearching = false;
  bool _isLoading = true;
  String searchQuery = "*";

  int size = 5;
  int numOfItem=0;
  int page = 1;
  List<Project> inpage_project_list = [];


  String donatorid;
  String cids;
  String ptids;
  String status;

  _initFilterElement() async{
    SharedPreferences p = await SharedPreferences.getInstance();
    donatorid = p.getString('donatorFavorite');
    cids = p.getString('ctids');
    ptids = p.getString('ptids');
    status = p.getString('status');
    if(donatorid=='*'&&cids=='*'&&ptids=='*'&&status=='*'){
      setState(() {
        _isApplyFilter=false;
      });
    }else{
      setState(() {
        _isApplyFilter=true;
      });
    }
  }

  _countTotalFoundProject() async{
    SharedPreferences p = await SharedPreferences.getInstance();
    await ProjectService.countTotalProjectsByMultiFilterAndSearchKey(
        p.getString('donatorFavorite'), p.getString('ctids'),
        p.getString('ptids'), p.getString('status'),searchQuery).then((response) {
      dynamic res = utf8.decode(response.bodyBytes);
      setState(() {
        widget.total = int.tryParse(res);
      });
      print("Tìm thấy $res kết quả sau khi lọc");
    });
  }

  _getProject() async {
    SharedPreferences p = await SharedPreferences.getInstance();
    await ProjectService.getProjectByFilterAndSearchKey(
        p.getString('donatorFavorite'), p.getString('ctids'),
        p.getString('ptids'), p.getString('status'),searchQuery,page,size).then((response) {
      setState(() {
        // print(utf8.decode(response.bodyBytes));
        List<dynamic> list = json.decode(utf8.decode(response.bodyBytes));
        inpage_project_list = list.map((model) => Project.fromJson(model)).toList();
        _isLoading=false;
      });
    });
  }

  _getMoreProject(){
    ProjectService.getProjectByFilterAndSearchKey(donatorid,cids,ptids,status,searchQuery,page,size).then((response) {
      setState(() {
        List<dynamic> list = json.decode(utf8.decode(response.bodyBytes));
        inpage_project_list += list.map((model) => Project.fromJson(model)).toList();
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
      if(numOfItem>inpage_project_list.length){
        page++;
        print("Call load more API! page:$page");
        _getMoreProject();
      }
    });
  }

  _getCity() async {
    await CityService.getCity().then((response) {
      setState(() {
        List<dynamic> list = json.decode(utf8.decode(response.bodyBytes));
        listCity = list.map((model) => City.fromJson(model)).toList();
      });
    });
  }

  @override
  initState() {
    _initFilterElement();
    _getProject();
    _getlistProjectIdFavorite();
    _getCity();
    if(widget.total>=size){numOfItem=size;}
    else{numOfItem = widget.total;}
    super.initState();
  }

  @override
  dispose() {
    setState(() {
      _isLoading = false;
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&  inpage_project_list.length >= this.size) {
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
                  title: _isSearching ? _buildSearchField() : Image.asset(
                    "assets/icons/logo.png",
                    height: size.height * 0.05,
                  ),
                  actions:_buildActions()
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
                (inpage_project_list.length == 0?
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
                      return (inpage_project_list.length == index ? Container(
                        child: FlatButton(
                          child: Text("",style: TextStyle(color: kPrimaryHighLightColor),),
                          onPressed: () {
                          },
                        ),
                      ) : buildProjectSection(inpage_project_list[index]));
                    },
                    childCount: (numOfItem < widget.total) ? inpage_project_list.length + 1 : inpage_project_list.length,
                  ),
                ))
              ],
            )
        )
    );
  }


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
      DonatorService.postRemoveProjectFromFavorite(project_id, _prefs.get("donator_id"),_prefs.getString('token')).then((response) {
        setState(() {
          _prefs.setString('donator_favorite_project',json.decode(response.body)['favoriteProject']);
        });
      });
      listProjectIdFavorite.remove(project_id.toString());
    }else{
      DonatorService.postAddProjectToFavorite(project_id, _prefs.get("donator_id"),_prefs.getString('token')).then((response) {
        setState(() {
          _prefs.setString('donator_favorite_project',json.decode(response.body)['favoriteProject']);
        });
      });
      listProjectIdFavorite.add(project_id.toString());
    }
  }

  _showDialogAskForLoginOrRegister(BuildContext context){
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
                padding: EdgeInsets.only(right: 24, left: 24, top: 12, bottom: 0),
                child: Stack(
                  children: [
                    Positioned(
                      right: size.width*0.35,top:-27,
                      child: Icon(Icons.horizontal_rule_rounded,size: 60,color: Colors.black38,),
                    ),
                    Column(
                      children: <Widget>[
                        SizedBox(height: 24),
                        Text("Đăng nhập hoặc đăng ký",
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
                  ],
                ),
              ),
            ],
          );
        }
    );
  }

  GestureDetector buildProjectSection(Project project) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProjectDetailsScreen(project_id: project.prj_id,donator: widget.donator,)),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        Container(
                          width: size.width*0.4,
                          height: 40.0,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            project.project_type_name,
                            style: TextStyle(
                                fontSize: 14,
                                color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    if (project.status == 'ACTIVATING' && project.prj_id!=0)
                      Row(
                        children: [
                          Icon(Icons.access_time_rounded,size: 15,color: project.remaining_term > 5 ? Colors.green:Colors.red,),
                          Text(
                              " Còn "+project.remaining_term.toString()+" Ngày",
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: project.remaining_term > 5 ? Colors.green:Colors.red)
                          ),
                        ],
                      ),
                  ],
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
            Icon(Icons.favorite_rounded, size: 35, color: kPrimaryColor.withOpacity(0.9))
                :
            Icon(Icons.favorite_rounded, size: 35, color: Colors.white.withOpacity(0.9)),
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
          ActionButton(
            width: size.width/3,
            onPressed:() => {
              Navigator.push(context, MaterialPageRoute(builder: (context) => DonateScreen(project: project,donator: widget.donator,)),),
            },
            buttonText: 'Quyên góp',
          ),
        if(project.status == 'REACHED')
          ActionButton(
            width: size.width/3,
            onPressed: ()=>{},
            buttonText: 'Đạt mục tiêu',
            borderColor: Colors.black54,
            buttonColor: Colors.white,
            textColor: Colors.black54,
          ),
        if(project.status == 'OVERDUE')
          ActionButton(
            width: size.width/3,
            onPressed: ()=>{},
            buttonText: 'Hết hạn',
            borderColor: Colors.black54,
            buttonColor: Colors.white,
            textColor: Colors.black54,
          ),
      ],
    );
  }

  _showFilterDialog() async{
    SharedPreferences p = await SharedPreferences.getInstance();
    Future<String> future = showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        builder: (BuildContext context){
          return Filter(cities:listCity,project_types: widget.project_types,isLogin: widget.isLogin,donator: widget.donator,
                        favorite: p.getBool('favorite'),listCityIdSelected: p.getStringList('listCityIdSelected'),
                        listProjectTypeIdSelected: p.getStringList('listProjectTypeIdSelected'),
                        listStatusSelected: p.getStringList('listStatusSelected'),);

        }
    );
    future.then((String value) => _closeFilterModal(value));
  }
  _closeFilterModal(String value) {
    setState(() {
      _isLoading=true;
    });
    if(value=='confirm_filter'){
      _getNewData();
    }else{
      setState(() {
        _isLoading=false;
      });
    }
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
      _initFilterElement();
      this.inpage_project_list.clear();
      _getProject();
      _countTotalFoundProject();
      _getlistProjectIdFavorite();
    });
  }

  Widget _buildSearchField() {
    return SearchField(
      hintText: 'Tìm kiếm dự án',
      controller: _searchQueryController,
      showClearIcon: _isTaping,
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
        splashRadius: size.height * 0.03,
        icon: Image.asset(
          _isApplyFilter?"assets/icons/filter_check.png":"assets/icons/filter.png",
          height: size.height * 0.033,
        ),
        onPressed: () {
          _showFilterDialog();
        },
      )
    ];
  }
  _startSearch() {
    _resetElement();
    setState(() {
      _isSearching = true;
    });
  }

  _letSearch(String searchKey) {
    setState(() {
      _isLoading=true;
    });
    if(searchQuery!='' && searchQuery!='*'){
      _getNewData();
    }
  }

  _updateSearchQuery(String newQuery) {
    setState(() {
      if(newQuery!=''){
        setState(() {
          _isTaping=true;
          searchQuery = newQuery;
        });
      }else{
        _isTaping=false;
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
      _isTaping=false;
    });
  }
}
