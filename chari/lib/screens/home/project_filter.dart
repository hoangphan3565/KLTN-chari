import 'dart:convert';

import 'package:chari/models/models.dart';
import 'package:chari/utility/utility.dart';
import 'package:chari/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:chari/services/services.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Filter extends StatefulWidget {
  List<ProjectType> project_types;
  List<City> cities;
  bool isLogin;
  final Donator donator;

  bool favorite;
  List<String> listCityIdSelected;
  List<String> listProjectTypeIdSelected;
  List<String> listStatusSelected;


  Filter({Key key,this.cities,this.project_types,this.isLogin,this.donator,
    this.favorite,this.listStatusSelected,this.listProjectTypeIdSelected,this.listCityIdSelected}) : super(key: key);

  @override
  _FilterState createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  final _multiSelectKey = GlobalKey<FormFieldState>();
  int numViewProjectType = 4;


  bool activating=false;
  bool reached=false;
  bool overdue=false;
  final String A = "ACTIVATING";
  final String R = "REACHED";
  final String O = "OVERDUE";


  String donatorid;
  String cids;
  String ptids;
  String status;


  List<bool> listProjectTypeSelected = [];

  var _items;
  List<City> _selectedCity = [];



  _checkFilterItem() async{
    SharedPreferences p = await SharedPreferences.getInstance();

    widget.favorite? donatorid=widget.donator.id.toString():donatorid='*';

    if(widget.listCityIdSelected.isEmpty){
      widget.listCityIdSelected.add('*');
    }
    cids = widget.listCityIdSelected.toString().substring(1, widget.listCityIdSelected.toString().length-1);

    if(!widget.listProjectTypeIdSelected.contains('*') && widget.listProjectTypeIdSelected.length==0){
      widget.listProjectTypeIdSelected.add('*');
    }else if(widget.listProjectTypeIdSelected.contains('*') && widget.listProjectTypeIdSelected.length>=2){
      widget.listProjectTypeIdSelected.remove('*');
    }ptids = widget.listProjectTypeIdSelected.toString().substring(1, widget.listProjectTypeIdSelected.toString().length-1);

    if(!widget.listStatusSelected.contains('*') && widget.listStatusSelected.length==0){
      widget.listStatusSelected.add('*');
    }else if(widget.listStatusSelected.contains('*') && widget.listStatusSelected.length>=2){
      widget.listStatusSelected.remove('*');
    }status = widget.listStatusSelected.toString().substring(1, widget.listStatusSelected.toString().length-1);

    p.setBool('favorite',widget.favorite);
    p.setStringList('listCityIdSelected',widget.listCityIdSelected);
    p.setStringList('listProjectTypeIdSelected',widget.listProjectTypeIdSelected);
    p.setStringList('listStatusSelected',widget.listStatusSelected);

    p.setString('donatorFavorite',donatorid);
    p.setString('ctids',cids);
    p.setString('ptids',ptids);
    p.setString('status',status);
  }


  _reset() async{
    SharedPreferences p = await SharedPreferences.getInstance();
    setState(() {
      widget.favorite=false;
      activating=false;
      reached=false;
      overdue=false;
      widget.listCityIdSelected = ['*'];
      widget.listProjectTypeIdSelected = ['*'];
      widget.listStatusSelected = ['*'];
      listProjectTypeSelected.clear();
      _selectedCity.clear();
      for(int i=0;i<widget.project_types.length;i++){
        listProjectTypeSelected.add(false);
      }
    });
    p.setBool('favorite',false);
    p.setStringList('listCityIdSelected',['*']);
    p.setStringList('listProjectTypeIdSelected',['*']);
    p.setStringList('listStatusSelected',['*']);
    _checkFilterItem();
  }

  _initData() async{
    // init selected status
    widget.listStatusSelected.contains(A)?activating=true:activating=false;
    widget.listStatusSelected.contains(R)?reached=true:reached=false;
    widget.listStatusSelected.contains(O)?overdue=true:overdue=false;

    // init selected project type
    if(widget.listProjectTypeIdSelected.contains('*')){
      for(int i=0;i<widget.project_types.length;i++){
        listProjectTypeSelected.add(false);
      }
    }else{
      for(int i=0;i<widget.project_types.length;i++){
        if(widget.listProjectTypeIdSelected.contains(widget.project_types[i].id.toString())){
          listProjectTypeSelected.add(true);
        }else{
          listProjectTypeSelected.add(false);
        }
      }
    }

    // init selected city
    if(widget.listCityIdSelected.contains('*')){
      _selectedCity.clear();
    }else{
      for(int i=0;i<widget.cities.length;i++){
        if(widget.listCityIdSelected.contains(widget.cities[i].id.toString())){
          _selectedCity.add(widget.cities[i]);
        }
      }
    }
  }
  @override
  void initState() {
    _initData();
    _items = widget.cities.map((city) => MultiSelectItem<City>(city, city.name)).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height*0.9,
      padding: EdgeInsets.only(right: 24, left: 24, top:18, bottom: 12),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 32,
                ),
                Text(
                  "Bộ lọc",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 32,
                ),

                Text(
                  "Tỉnh thành",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(
                  height: 16,
                ),

                MultiSelectBottomSheetField<City>(
                  key: _multiSelectKey,
                  initialChildSize: 0.7,
                  initialValue: _selectedCity,
                  maxChildSize: 0.95,
                  searchHint: "Tìm kiếm",
                  cancelText: Text("Hủy",style: TextStyle(fontSize: 17,color: kPrimaryHighLightColor,fontWeight: FontWeight.bold,),),
                  confirmText: Text("Xác nhận",style: TextStyle(fontSize: 17,color: kPrimaryHighLightColor,fontWeight: FontWeight.bold,),),
                  decoration: BoxDecoration(
                    color: Colors.black12.withOpacity(0.02),
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  buttonIcon: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.black87,
                  ),
                  title: Text("Tỉnh thành",style: TextStyle(fontSize: 20)),
                  buttonText: Text("Chọn tỉnh thành",style: TextStyle(fontSize: 15),),
                  items: _items,
                  searchable: true,
                  onConfirm: (values) {
                    setState(() {
                      _selectedCity = values;
                      widget.listCityIdSelected = _selectedCity.map((e) => e.id.toString()).toList();
                    });
                    _multiSelectKey.currentState.validate();
                  },
                ),

                SizedBox(height: 16,),
                Container(
                  height: 1,
                  color: Colors.grey[300],
                  margin: EdgeInsets.symmetric(horizontal: 0),
                ),
                SizedBox(height: 16,),

                Text(
                  "Gói từ thiện",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(
                  height: 16,
                ),


                for(int i=0;i<numViewProjectType;i=i+2)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SelectItem(
                        text: widget.project_types[i].name,
                        width: size.width*0.42,
                        onTapSelectItem: ()=>{
                          setState(() {
                            listProjectTypeSelected[i]==true?listProjectTypeSelected[i]=false:listProjectTypeSelected[i]=true;
                            listProjectTypeSelected[i]==true?widget.listProjectTypeIdSelected.add(widget.project_types[i].id.toString()):widget.listProjectTypeIdSelected.remove(widget.project_types[i].id.toString());
                          })
                        },
                        selected: listProjectTypeSelected[i],
                      ),
                      if((i+1)<widget.project_types.length)
                        SelectItem(
                          text: widget.project_types[i+1].name,
                          width: size.width*0.42,
                          onTapSelectItem: ()=>{
                            setState(() {
                              listProjectTypeSelected[i+1]==true?listProjectTypeSelected[i+1]=false:listProjectTypeSelected[i+1]=true;
                              listProjectTypeSelected[i+1]==true?widget.listProjectTypeIdSelected.add(widget.project_types[i+1].id.toString()):widget.listProjectTypeIdSelected.remove(widget.project_types[i+1].id.toString());
                            })
                          },
                          selected: listProjectTypeSelected[i+1],
                        ),
                    ],
                  ),
                if(numViewProjectType != widget.project_types.length )
                  Center(
                    child: FlatButton(
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                      onPressed: ()=>{
                        setState(() {
                          if(numViewProjectType<=widget.project_types.length-4){
                            numViewProjectType+=4;
                          }else{
                            numViewProjectType+= widget.project_types.length - numViewProjectType;
                          }
                        })
                      },
                      child: Text(
                        'Xem thêm',
                        style: TextStyle(color: kPrimaryHighLightColor,fontSize: 16),
                      ),
                    ),
                  ),
                if(numViewProjectType == widget.project_types.length )
                  Center(
                    child: FlatButton(
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                      onPressed: ()=>{
                        setState(() {
                          numViewProjectType=4;
                        })
                      },
                      child: Text(
                        'Ẩn bớt',
                        style: TextStyle(color: kPrimaryHighLightColor,fontSize: 16),
                      ),
                    ),
                  ),


                Container(
                  height: 1,
                  color: Colors.grey[300],
                  margin: EdgeInsets.symmetric(horizontal: 0),
                ),
                SizedBox(height: 16,),

                Text(
                  "Trạng thái dự án",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(
                  height: 16,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SelectItem(
                      text: 'Đang hoạt động',
                      width: size.width*0.29,
                      onTapSelectItem: ()=>{
                        setState(() {
                          activating==true?activating=false:activating=true;
                          activating==true?widget.listStatusSelected.add(A):widget.listStatusSelected.remove(A);
                        })
                      },
                      selected: activating,
                    ),
                    SelectItem(
                      text: 'Đã thành công',
                      width: size.width*0.28,
                      onTapSelectItem: ()=>{
                        setState(() {
                          reached==true?reached=false:reached=true;
                          reached==true?widget.listStatusSelected.add(R):widget.listStatusSelected.remove(R);
                        })
                      },
                      selected: reached,
                    ),
                    SelectItem(
                      text: 'Đã thất bại',
                      width: size.width*0.28,
                      onTapSelectItem: ()=>{
                        setState(() {
                          overdue==true?overdue=false:overdue=true;
                          overdue==true?widget.listStatusSelected.add(O):widget.listStatusSelected.remove(O);
                        })
                      },
                      selected: overdue,
                    ),
                  ],
                ),
                SizedBox(height: 16,),
                Container(
                  height: 1,
                  color: Colors.grey[300],
                  margin: EdgeInsets.symmetric(horizontal: 0),
                ),
                SizedBox(height: 16,),
                if(widget.isLogin==true)
                  CheckboxListTile(
                    activeColor: kPrimaryHighLightColor,
                    title: const Text('Dự án yêu thích',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    value: widget.favorite,
                    onChanged: (bool value) {
                      setState(() {
                        widget.favorite? widget.favorite=false:widget.favorite=true;
                      });
                    },
                    secondary: const Icon(Icons.favorite_rounded,color: kPrimaryHighLightColor,),
                  ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
          Positioned(
            right: size.width*0.35,top:-26,
            child: Icon(Icons.horizontal_rule_rounded,size: 60,color: Colors.black38,),
          ),
          Positioned(
            right: 0,bottom: 0,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ActionButton(
                    width: size.width/3.5,
                    onPressed:() => {
                      _reset(),
                      Navigator.pop(context,'confirm_filter'),
                    },
                    buttonText: 'Thiết lập lại',
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  ActionButton(
                    width: size.width/4,
                    onPressed: () => {
                      _checkFilterItem(),
                      Navigator.pop(context,'confirm_filter'),
                    },
                    buttonText: 'Áp dụng',
                    buttonColor: kPrimaryHighLightColor,
                    textColor: Colors.white,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}