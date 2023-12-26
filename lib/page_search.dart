import 'package:flutter/material.dart';
import 'util_db.dart';
import 'util_ui.dart';
import 'dialog_remove.dart';
import 'dialog_update.dart';
class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with SingleTickerProviderStateMixin{

  @override
  void initState() {
    super.initState();
  }


  @override
  void dispose() {
    super.dispose();
  }


  List<DropdownMenuItem> getpoemcate(){
    Map<String, String> poemcate ={
      "唐 诗":"Tpoem",
      "宋 词":"Spoem",
      "诗 经":"song"
    };
    List<DropdownMenuItem> cate = [];
    for (var key in poemcate.keys){
      cate.add(DropdownMenuItem(
          child: gText(key),
          value: poemcate[key]));
    }
    return cate;
  }

  List<DropdownMenuItem> getCate(){
    Map<String, int> searchType ={
      "标 题":1,
      "作者|章节":2,
      "内 容":3
    };
    List<DropdownMenuItem> cate = [];
    for (var key in searchType.keys){
      cate.add(DropdownMenuItem(
          child: gText(key),
          value: searchType[key]));
    }
    return cate;
  }

  void _search() {
    dbSearch(key,table,value2).then((result,) {
      var len=0;
      if(result !=null)
        len = result.length;
      printInfo("查询到$len条");
      setState(() {
          data =result;
      });
    });
  }


  var table="Tpoem";
  var value2=1;
  var key="";
  var data;
  final ScrollController _firstController = ScrollController();
  @override
  Widget build(BuildContext context) {
    Widget stack= Stack(children: <Widget>[
      Container(
        margin: EdgeInsets.only(top: 110.0,left: 10.0,bottom: 5.0,right: 10.0),
        child:Scrollbar(
          thumbVisibility: true,
          controller: _firstController,
          child:ListView(
            controller: _firstController,
            children: genList(),
          ),
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
                      fontFamily: GConfig.font
                  ),
                ),
                decoration: BoxDecoration(
                  border: Border.all(width: 1.0, color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  color:Colors.white,
                ),
                margin: EdgeInsets.only(left:10.0,top: 10.0,bottom: 5.0,right: 10.0),
              ),
              Container(
                margin: EdgeInsets.only(left:10.0,top: 5.0,right: 10.0,bottom: 0.0),
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
                                  value: table,//下拉菜单选择完之后显示给用户的值
                                  onChanged: (T){//下拉菜单item点击之后的回调
                                    setState(() {
                                      table=T;
                                    });
                                  },
                                  style: TextStyle(//设置文本框里面文字的样式
                                      color: Colors.lightBlue
                                  ),
                                  iconSize: 20.0,//设置三角标icon的大小
                                ),
                        )
                      ),
                      flex: 3,
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 10.0),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1.0, color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          color:Colors.white,
                        ),
                        child:
                          DropdownButtonHideUnderline(
                            child:DropdownButton(
                              items: getCate(),
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
                      flex: 3,
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 5.0),
                        child:ElevatedButton (
                            onPressed:_search,
                            child: Icon(Icons.search,size: 23.0)
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(1.0)),
                          // color:Colors.blue,
                        ),
                      ),
                      flex: 2,
                    ),
                  ],
                )
              ),
            ]
          )  ,
      ]
    );

    return stack;
  }


  List<Widget> genList() {
    if(data==null||data.length==0){
      return <Widget> [Container()];
    }
    return data.map<Widget>((eachdata) => _buildresult(eachdata)).toList();
  }

  Widget _buildresult(Map eachdata) {
    return Container(
          margin: EdgeInsets.only(bottom: 10.0),
          decoration: BoxDecoration(
            border: Border.all(width: 1.0, color: Colors.purple),
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            image: DecorationImage(
                image:ExactAssetImage(GConfig.backimg["search"]!),
                fit: BoxFit.cover
            ),
          ),
          child: Column(
              children: <Widget>[
                Padding(padding: EdgeInsets.only(left:5.0,bottom:3.0,top: 5.0),
                    child:gText(eachdata["title"]+"·"+eachdata["author"],sizeAdjust:2, fontWeight:FontWeight.bold),
                  ),
                Padding(padding: EdgeInsets.only(left:5.0,top: 3.0),
                  child:gText(eachdata["content"]),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new IconButton(
                      icon: Icon(Icons.favorite,color: eachdata["love"]==0?Color(
                          0x99FFFFFF)
                          :Colors.lightBlueAccent,),
                        onPressed: () {
                          var temp;
                          eachdata["love"]==0?temp=1:temp=0;
                          dbUpdateLove(eachdata["id"],temp,table).whenComplete((){
                            _search();
                          });
                        },
                      tooltip: '收藏',
                    ),
                    new IconButton(
                        icon: Icon(Icons.music_note_outlined,color: Colors.lightBlueAccent,),
                        onPressed: (){
                          speech(eachdata["title"]+","+eachdata["author"]+"。"+eachdata["content"]);
                        },
                        tooltip: '朗读',
                      ),
                    new IconButton(
                        icon: Icon(Icons.music_off_outlined,color: Colors.lightBlueAccent),
                        onPressed: (){
                          stopSpeech();
                        },
                        tooltip: '停止',
                      ),
                    new IconButton(
                        icon: Icon(Icons.delete_forever,color: Colors.lightBlueAccent),
                        onPressed: (){
                          showDeleteDialog(context,eachdata["id"],eachdata["title"],eachdata["author"]);
                        },
                        tooltip: '删除',
                      ),
                    new IconButton(
                      icon: Icon(Icons.edit,color: Colors.lightBlueAccent),
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
          return Remove(refreshfather: _search,id: id,poemtitle: poemtitle,author: author,table: table,dbremove: true,);
        });
  }

  void showUpdateDialog(BuildContext context,int id,String poemtitle,String author,String content) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Update(refreshfather: _search,id: id,poemtitle: poemtitle,author: author,content: content,table: table);
        });
  }
}

