import 'package:flutter/material.dart';
import 'util_ui.dart';
import 'util_db.dart';
class Remove extends StatelessWidget{

  const Remove({@required this.refreshfather,@required this.id,@required this.table,@required this.poemtitle,@required this.author,@required this.dbremove});
  final refreshfather;
  final poemtitle;
  final author;
  final id;
  final table;
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
              color: GConfig.appBackgroundColor,
            ),
            child:
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                gDialogTitle(context, dbremove?" 删除":" 移除", Icons.warning),
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
                        fontFamily:GConfig.font
                    ),
                    maxLines:6 ,
                    overflow: TextOverflow.clip,
                  ),
                ),
                Row(
                  mainAxisAlignment:MainAxisAlignment.end ,
                  children: <Widget>[
                    new TextButton(
                      child:new Text("确定",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                            fontFamily: GConfig.font
                        ),
                      ),
                      onPressed: (){
                        if(dbremove){
                          //删除数据
                          dbDelete(id, table).whenComplete((){
                            refreshfather();
                          });
                        }
                        else
                          {
                            dbUpdateLove(id,0,table).whenComplete((){
                              refreshfather();
                            });
                          }
                        Navigator.of(context).pop();
                      },),

                    Padding(padding: EdgeInsets.only(left: 10.0),),
                    new TextButton(
                      child:new Text("取消",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                            fontFamily: GConfig.font
                        ),
                      ),
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


