import 'package:flutter/material.dart';
import 'global_config.dart';
import 'util_db.dart';
class Remove extends StatelessWidget{

  const Remove({@required this.refreshfather,@required this.id,@required this.cate,@required this.poemtitle,@required this.author,@required this.dbremove});
  final refreshfather;
  final poemtitle;
  final author;
  final id;
  final cate;
  final dbremove;

  @override
  Widget build(BuildContext context) {

    return new Material( //创建透明层
      type: MaterialType.transparency, //透明类型
      child: new Center( //保证控件居中效果
        child: new SizedBox(
          width: 280.0,
          height: 280.0,
          child: new Container(
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
              color: GlobalConfig.appBackgroundColor,
            ),
            child:
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Container(
                  height:30,
                  margin:const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 5.0),
                  child:Row(children: <Widget>[
                    Container(width:30.0,child:Icon(Icons.warning,color: Colors.cyan)),
                    Container(
                      width:170,
                      child:new Align(
                        alignment:FractionalOffset.centerLeft,
                        child: new Text(dbremove?" 删除":" 移除",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 5.0,
                              fontFamily: GlobalConfig.font
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 60,
                      child:FloatingActionButton(
                        onPressed: (){
                          Navigator.pop(context); //关闭对话框
                        },
                        tooltip: '关闭',
                        backgroundColor: Colors.red,
                        child: new Icon(Icons.close),
                      ),
                    ),
                  ],
                  ),
                ),
                new Container(
                  margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                  color:Colors.black54,
                  height: 1.5,
                ),
                new Container(
                  width: 250,
                  height: 160,
                  margin: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 5.0),
                  padding: EdgeInsets.fromLTRB(5.0, 15.0, 10.0, 15.0),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
                    color: Colors.grey,
                  ),
                  child:new Text(dbremove?"从数据库删除:\n    标题：$poemtitle\n    作者：$author":"移出收藏:\n    标题：$poemtitle\n    作者：$author",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        height: 1.2,
                        fontWeight: FontWeight.normal,
                        fontFamily:GlobalConfig.font
                    ),
                    maxLines:6 ,
                    overflow: TextOverflow.clip,
                  ),
                ),
                Row(
                  mainAxisAlignment:MainAxisAlignment.end ,
                  children: <Widget>[
                    new FlatButton(
                      child:new Text("确定",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                            fontFamily: GlobalConfig.font
                        ),
                      ),
                      color: Colors.lightBlue,
                      onPressed: (){
                        if(dbremove){
                          //删除数据
                          dbDelete(id, cate).whenComplete((){
                            refreshfather();
                          });
                        }
                        else
                          {
                            dbUpdateLove(id,0,cate+1).whenComplete((){
                              refreshfather();
                            });
                          }
                        Navigator.of(context).pop();
                      },),

                    Padding(padding: EdgeInsets.only(left: 10.0),),
                    new FlatButton(
                      child:new Text("取消",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                            fontFamily: GlobalConfig.font
                        ),
                      ),
                      color: Colors.lightBlue,
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                    ),
                    Padding(padding: EdgeInsets.only(left: 15.0),),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


