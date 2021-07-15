import 'dart:convert';
import 'dart:convert' show utf8;
import 'package:chari/models/models.dart';
import 'package:chari/models/project_model.dart';
import 'package:chari/screens/screens.dart';
import 'package:chari/services/services.dart';
import 'package:chari/utility/utility.dart';
import 'package:chari/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PostScreen extends StatefulWidget {
  int total;
  Donator donator;
  PostScreen({Key key, @required this.donator,this.total}) : super(key: key);
  @override
  _PostScreenState createState()=> _PostScreenState();
}

class _PostScreenState extends State<PostScreen>{

  int size = 5;
  int numOfItem = 0;
  int page = 1;
  var inpage_posts_list=List<Post>();
  var p = List<Project>();

  TextEditingController _searchQueryController = TextEditingController();
  bool _isTapingSearchKey = false;
  bool _isSearching = false;
  bool _isLoading = true;
  String searchQuery = "*";

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

  _countTotalFoundPosts() async{
    await PostService.getTotalFoundPost(searchQuery).then((response) {
      dynamic res = utf8.decode(response.bodyBytes);
      setState(() {
        widget.total = int.tryParse(res);
      });
    });
  }

  _getPost(){
    PostService.findPostsPageASizeByName(searchQuery,page,size).then((response) {
      setState(() {
        // print(utf8.decode(response.bodyBytes));
        List<dynamic> list = json.decode(utf8.decode(response.bodyBytes));
        inpage_posts_list = list.map((model) => Post.fromJson(model)).toList();
        _isLoading = false;
      });
    });
  }

  _getMorePost(){
    PostService.findPostsPageASizeByName(searchQuery,page,size).then((response) {
      setState(() {
        List<dynamic> list = json.decode(utf8.decode(response.bodyBytes));
        inpage_posts_list += list.map((model) => Post.fromJson(model)).toList();
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
      if(numOfItem>inpage_posts_list.length){
        page++;
        _getMorePost();
        print('Call API!!');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _getPost();
      if(widget.total>=size){numOfItem=size;}
      else{numOfItem = widget.total;}
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&  inpage_posts_list.length >= this.size) {
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
              (inpage_posts_list.length==0?
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
                    return (index == inpage_posts_list.length ) ?
                    Container(
                      child: FlatButton(
                        child: Text("",style: TextStyle(color: kPrimaryHighLightColor),),
                        onPressed: () {
                          loadMore();
                        },
                      ),
                    ) : buildPostSection(inpage_posts_list[index]);
                  },
                  childCount: (numOfItem < widget.total) ? inpage_posts_list.length + 1 : inpage_posts_list.length,
                ),
              ))
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


  Widget _buildSearchField() {
    return SearchField(
      hintText: 'Tìm kiếm tin tức',
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
      this.size = 5;
      this.numOfItem=0;
      this.page = 1;
    });
  }

  _getNewData(){
    _resetElement();
    setState(() {
      this.inpage_posts_list.clear();
      _getPost();
      _countTotalFoundPosts();
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


