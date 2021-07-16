import 'dart:convert';
import 'dart:convert' show utf8;
import 'package:chari/widgets/widgets.dart';
import 'package:quiver/async.dart';
import 'package:chari/models/models.dart';
import 'package:chari/screens/screens.dart';
import 'package:chari/services/services.dart';
import 'package:chari/utility/utility.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  final Donator donator;
  int total;
  HistoryScreen({Key key, @required this.donator,this.total}) : super(key: key);
  @override
  _HistoryScreenState createState()=> _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>{

  int size = 10;
  int numOfItem = 0;
  int page = 1;
  var inpage_donate_details_list=List<DonateDetails>();
  var p = List<Project>();

  TextEditingController _searchQueryController = TextEditingController();
  bool _isTapingSearchKey = false;
  bool _isSearching = false;
  bool _isLoading = true;
  String searchQuery = "*";


  _getProjectAndNavigate(DonateDetails d) async {
    await ProjectService.getProjectById(d.project_id).then((response) {
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

  _countTotalDonateHistory() async{
    await DonateDetailsService.getTotalDonateDetailsListByDonatorId('*',widget.donator.id,widget.donator.token).then((response) {
      dynamic res = utf8.decode(response.bodyBytes);
      setState(() {
        widget.total = int.tryParse(res);
      });
    });
  }

  _getDonateHistory(){
    DonateDetailsService.getDonateDetailsListByDonatorIdPageASizeB(searchQuery,widget.donator.id,page,size,widget.donator.token).then((response) {
      setState(() {
        List<dynamic> list = json.decode(utf8.decode(response.bodyBytes));
        inpage_donate_details_list = list.map((model) => DonateDetails.fromJson(model)).toList();
        _isLoading=false;
      });
    });
  }

  _getMoreDonateHistory(){
    DonateDetailsService.getDonateDetailsListByDonatorIdPageASizeB(searchQuery,widget.donator.id,page,size,widget.donator.token).then((response) {
      setState(() {
        List<dynamic> list = json.decode(utf8.decode(response.bodyBytes));
        inpage_donate_details_list += list.map((model) => DonateDetails.fromJson(model)).toList();
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
      if(numOfItem>inpage_donate_details_list.length){
        page++;
        _getMoreDonateHistory();
        print('Load more!');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _getDonateHistory();
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
        child:NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&  inpage_donate_details_list.length >= this.size) {
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
                title:_isSearching?_buildSearchField(): Image.asset(
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
              (inpage_donate_details_list.length==0?
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
                    return (index == inpage_donate_details_list.length ) ?
                    Container(
                      child: FlatButton(
                        child: Text("",style: TextStyle(color: kPrimaryHighLightColor),),
                        onPressed: () {
                          loadMore();
                        },
                      ),
                    ) : buildHistoryInfo(inpage_donate_details_list[index]);
                  },
                  childCount: (numOfItem < widget.total) ? inpage_donate_details_list.length + 1 : inpage_donate_details_list.length,
                ),
              ))
            ],
          )
        )
      ),
    );
  }

  GestureDetector buildHistoryInfo(DonateDetails donate_details){
    return GestureDetector(
        onTap: (){
          _getProjectAndNavigate(donate_details);
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(5,5,5,0),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 20,
                offset: Offset(0, 10),
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
                        Icon(
                          FontAwesomeIcons.heart,
                          size: 16,
                          color: kPrimaryHighLightColor,
                        ),
                        Text(
                          " "+MoneyUtility.convertToMoney(donate_details.money.toString())+' đ',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        if(donate_details.status=='FAILED')
                          Text(
                            " (Đã chuyển dời tiền!)",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                      ],
                    ),

                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      donate_details.project_name,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(
                          DateFormat('kk:mm dd-MM-yy').format(DateTime.parse(donate_details.donate_date)),
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                              color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
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
                        image: NetworkImage(donate_details.project_image)
                    )),
              ),
            ],
          )
        )
    );
  }


  Widget _buildSearchField() {
    return SearchField(
      hintText: 'Tìm kiếm lịch sử',
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
    ];
  }

  _resetElement(){
    setState(() {
      this.size = 10;
      this.numOfItem=0;
      this.page = 1;
    });
  }

  _getNewData(){
    _resetElement();
    setState(() {
      this.inpage_donate_details_list.clear();
      _countTotalDonateHistory();
      _getDonateHistory();
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
      _isLoading=true;
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
