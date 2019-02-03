import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'util_db.dart';
import 'global_config.dart';
import 'dialog_remove.dart';
import 'dialog_update.dart';
class SearchPage extends StatefulWidget {
  SearchPage({Key key,
    this.controller,
    this.velocity = 10,
  }) : super(key: key);


  final ScrollController controller;

  /// Critical value that determine to show [QuickScrollbar].
  /// If the scroll delta offset greater than [velocity], the
  /// quick scrollbar will show.
  final int velocity;

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with SingleTickerProviderStateMixin{

  double _offsetTop = 105.0;
  double _barHeight = 30.0;
  // Animation controller for show/hide bar .
  AnimationController _animationController;
  Animation _animation;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _animationController =
    new AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _animation = Tween(begin: 1.0, end: 0.0).animate(_animationController);
    _animationController.value = 1.0;
  }

  void _fadeBar() {
    if(_animationController.value==1.0) return;
    _timer?.cancel();
    _timer = new Timer(Duration(seconds: 1), () {
      _animationController.animateTo(1.0);
      _animationController.forward();
    });
  }

  bool _handleNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      if (notification.scrollDelta.abs() > widget.velocity &&
          notification.metrics.maxScrollExtent != double.infinity) {
        _animationController.value = 0.0;
      }
    }
    setState(() {
      double total = notification.metrics.extentBefore +
          notification.metrics.extentAfter;
      _offsetTop = notification.metrics.extentBefore / total *
          (notification.metrics.extentInside - _barHeight)+105;
      _fadeBar();
    });
    return true;
  }

  @override
  void dispose() {
    _animationController.dispose();
    _timer?.cancel();
    super.dispose();
  }


  List<DropdownMenuItem> getpoemcate(){
    List<DropdownMenuItem> items=new List();
    DropdownMenuItem dropdownMenuItem1=new DropdownMenuItem(
      child:new Text(" 唐 诗",style: TextStyle(fontFamily:GlobalConfig.font,)),
      value: 1,
    );
    items.add(dropdownMenuItem1);
    DropdownMenuItem dropdownMenuItem2=new DropdownMenuItem(
      child:new Text(" 宋 词",style: TextStyle(fontFamily:GlobalConfig.font,)),
      value: 2,
    );
    items.add(dropdownMenuItem2);
    DropdownMenuItem dropdownMenuItem3=new DropdownMenuItem(
      child:new Text(" 诗 经",style: TextStyle(fontFamily:GlobalConfig.font,)),
      value: 3,
    );
    items.add(dropdownMenuItem3);
    return items;
  }

  List<DropdownMenuItem> getcate(){
    List<DropdownMenuItem> items=new List();
    DropdownMenuItem dropdownMenuItem1=new DropdownMenuItem(
      child:new Text(" 标 题",style: TextStyle(fontFamily:GlobalConfig.font,)),
      value: 1,
    );
    items.add(dropdownMenuItem1);
    DropdownMenuItem dropdownMenuItem2=new DropdownMenuItem(
      child:new Text(" 作者|章节",style: TextStyle(fontFamily:GlobalConfig.font,)),
      value: 2,
    );
    items.add(dropdownMenuItem2);
    DropdownMenuItem dropdownMenuItem3=new DropdownMenuItem(
      child:new Text(" 内 容",style: TextStyle(fontFamily:GlobalConfig.font,)),
      value: 3,
    );
    items.add(dropdownMenuItem3);
    return items;
  }

  void _search() {
    dbSearch(key,value1,value2).then((result,) {
      Fluttertoast.showToast(
          msg: "查询到"+result.length.toString()+"条",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
      );
      setState(() {
          data =result;
      });
    });
  }


  var value1=1;
  var value2=1;
  var key="";
  var data;

  @override
  Widget build(BuildContext context) {
//    print("searchpage refresh");
    ScrollController scrollController =
        widget.controller
            ?? PrimaryScrollController.of(context)
            ?? ScrollController();


    Widget stack= Stack(children: <Widget>[
      Container(
        margin: EdgeInsets.only(top: 105.0,left: 15.0,bottom: 5.0,right: 15.0),
        child:ListView(
          children: genList(),

        ),
      ),
      Column(
            children:<Widget>[
              Container(
                height: 40.0,
                child:
                TextField(
                  onChanged: (String str){//输入监听
                      key=str.replaceAll(" ", "%");
                  },
                  onSubmitted:(String str){//提交监听
                      key=str.replaceAll(" ", "%");
                  },
                  keyboardType: TextInputType.text,//设置输入框文本类型
                  textAlign: TextAlign.left,//设置内容显示位置是否居中等
                  decoration: new InputDecoration(
                      hintText: " 按条件查询|关键字以空格隔开",
                      border: InputBorder.none,
                    ),
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontFamily: GlobalConfig.font
                  ),
                ),
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  color:Colors.white,
                ),
                margin: EdgeInsets.only(left:15.0,top: 10.0,bottom: 5.0,right: 15.0),
              ),
              Container(
                margin: EdgeInsets.only(left:15.0,top: 5.0,right: 15.0,bottom: 0.0),
                height: 40.0,
                child:
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(width: 1.0, color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          color:Colors.white,
                        ),
                        child: DropdownButtonHideUnderline(
                               child: DropdownButton(
                                  items: getpoemcate(),
                                  value: value1,//下拉菜单选择完之后显示给用户的值
                                  onChanged: (T){//下拉菜单item点击之后的回调
                                    setState(() {
                                      value1=T;
                                    });
                                  },
                                  style: TextStyle(//设置文本框里面文字的样式
                                      color: Colors.lightBlue
                                  ),
                                  iconSize: 20.0,//设置三角标icon的大小
                                ),
                        )
                      ),
                      flex: 2,
                    ),


                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 5.0),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1.0, color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          color:Colors.white,
                        ),
                        child:
                          DropdownButtonHideUnderline(
                            child:DropdownButton(
                              items: getcate(),
                              value: value2,//下拉菜单选择完之后显示给用户的值
                              onChanged: (T){//下拉菜单item点击之后的回调
                                setState(() {
                                  value2=T;
                                });
                              },
                              style: TextStyle(//设置文本框里面文字的样式
                                  color: Colors.lightBlue
                              ),
                              iconSize: 20.0,//设置三角标icon的大小
                            ),
                          )
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 5.0),
                        child:RaisedButton(
                            onPressed:_search,
                            color: Colors.blue,
                            child: Icon(Icons.search,size: 23.0)
                        ),
//                        color: Colors.blue,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1.0, color: Colors.blue),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          color:Colors.blue,
                        ),
                      ),
                      flex: 2,
                    ),
                  ],
                )
              ),


            ]
          )  ,


      Positioned(
          top: _offsetTop,
          right: 0.0,
          child: GestureDetector(
            child: Padding(
              padding: const EdgeInsets.only(right: 3.0),
              child: FadeTransition(
                child: Material(
                  color: Color(0xffe8e8e8),
                  elevation: .8,
                  child: SizedBox(
                      height: _barHeight,
                      width: 20.0,
                      child: Icon(
                        Icons.unfold_more,
                        color: Colors.grey[600],
                        size: 20.0,
                      )
                  ),
                ),
                opacity: _animation,
              ),
            ),
            onVerticalDragStart: (DragStartDetails details) {
              _timer?.cancel();
            },
            onVerticalDragUpdate: (DragUpdateDetails details) {
              var position = scrollController.position;

              double pixels = (position.extentBefore + position.extentAfter) *details.delta.dy / (position.extentInside - _barHeight);
              pixels += position.pixels;
              scrollController.jumpTo(pixels.clamp(0.0, position.maxScrollExtent));
            },
            onVerticalDragEnd: (details) {
              _fadeBar();
            },
          )
      ),

      ]
    );

    return NotificationListener<ScrollNotification>(
      onNotification: _handleNotification,
      child: stack,
    );
  }


  List<Widget> genList() {
    if(data==null){
      return <Widget> [Container()];
    }
    if(data.length==0){
      return <Widget> [Container(
      )];
    }
    return data.map<Widget>((eachdata) {
      return _buildresult(eachdata);
    }).toList();
  }

  Widget _buildresult(Map eachdata) {
    return Container(
          margin: EdgeInsets.only(bottom: 10.0),
          decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: Colors.purple),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            image: DecorationImage(
                image:ExactAssetImage(GlobalConfig.backimg[0]),
                fit: BoxFit.cover
            ),
          ),
          child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(left:5.0,bottom:3.0,top: 5.0),
                    child:Text(
                      eachdata["title"]+"·"+eachdata["author"],
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                          fontFamily: GlobalConfig.font
                      ),
                    ),
                  ),
                Padding(padding: EdgeInsets.only(left:5.0,top: 3.0),
                  child:Text(
                    eachdata["content"],
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 2.0,
                        fontFamily: GlobalConfig.font
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new IconButton(
                      icon: Icon(Icons.favorite,color: eachdata["love"]==0?Color(0xFFB0B0B0):Colors.red,),
                        onPressed: () {
                          var temp;
                          eachdata["love"]==0?temp=1:temp=0;
                          dbUpdateLove(eachdata["id"],temp,value1).whenComplete((){
                            _search();
                          });
                        },
                      tooltip: '收藏',
                    ),
                    new IconButton(
                        icon: Icon(Icons.volume_up),
                        onPressed: (){
                          speech(eachdata);
                        },
                        tooltip: '朗读',
                      ),
                    new IconButton(
                        icon: Icon(Icons.stop),
                        onPressed: (){
                          stopspeech();
                        },
                        tooltip: '停止',
                      ),
                    new IconButton(
                        icon: Icon(Icons.delete_outline),
                        onPressed: (){
                          showDeleteDialog(context,eachdata["id"],eachdata["title"],eachdata["author"]);
                        },
                        tooltip: '删除',
                      ),
                    new IconButton(
                      icon: Icon(Icons.create),
                      onPressed: (){
                        showUpdateDialog(context,eachdata["id"],eachdata["title"],eachdata["author"],eachdata["content"]);
                      },
                      tooltip: '修正',
                    ),
                  ],),
              ],
          ),
      );
  }

  void showDeleteDialog(BuildContext context,int id,String poemtitle,String author) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Remove(refreshfather: _search,id: id,poemtitle: poemtitle,author: author,cate: value1,dbremove: true,);
        });
  }

  void showUpdateDialog(BuildContext context,int id,String poemtitle,String author,String content) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Update(refreshfather: _search,id: id,poemtitle: poemtitle,author: author,content: content,cate: value1);
        });
  }
}

