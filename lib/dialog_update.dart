import 'package:flutter/material.dart';
import 'global_config.dart';
import 'util_db.dart';
class Update extends StatefulWidget{

  const Update({@required this.refreshfather,@required this.id,@required this.cate,@required this.poemtitle,@required this.author,@required this.content});
  final refreshfather;
  final poemtitle;
  final author;
  final id;
  final cate;
  final content;

  @override
  _UpdateState createState() => new _UpdateState();
}

class _UpdateState extends State<Update> {

  TextEditingController tit;
  TextEditingController aut;
  TextEditingController con;
  @override
  void initState() {
    super.initState();
    tit=new TextEditingController(text:widget.poemtitle);
    aut=new TextEditingController(text: widget.author);
    con=new TextEditingController(text:widget.content);
  }

  @override
  Widget build(BuildContext context) {
    return new Material( //创建透明层
      type: MaterialType.transparency, //透明类型
      child: new Center( //保证控件居中效果
        child: new SizedBox(
          width: 280.0,
          height: 360.0,
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
                    Container(width:30.0,child:Icon(Icons.create,color: Colors.cyan)),
                    Container(
                      width:170,
                      child:new Align(
                        alignment:FractionalOffset.centerLeft,
                        child: new Text(" 修正",
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
                  margin: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 0.0),
                  padding: EdgeInsets.fromLTRB(5.0, 15.0, 10.0, 10.0),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
                    color: Colors.grey,
                  ),
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("内容：",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                            fontFamily: GlobalConfig.font
                        ),
                      ),
                      Container(height:100,
                        margin:EdgeInsets.only(top: 3.0),color:Colors.white30,
                        child:ListView(
                          children: <Widget>[
                            EditableText(
                                controller:con,
                                cursorColor: Colors.blue,
                                onSubmitted:(String str){//提交监听
                                  con.text=str;
                                },
                                focusNode: FocusNode(),
                                keyboardType: TextInputType.multiline,//设置输入框文本类型
                                maxLines: 6,
                                textAlign: TextAlign.left,//设置内容显示位置是否居中等
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: GlobalConfig.font,
                                ),
                            ),
                          ],
                        ),),
                      Text("标题：",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                            fontFamily: GlobalConfig.font
                        ),
                      ),
                      Container(height:25,margin:EdgeInsets.only(top: 3.0),color:Colors.white30,
                        child:
                          EditableText(
                            controller:tit,
                            cursorColor: Colors.blue,
                            focusNode: FocusNode(),
                            keyboardType: TextInputType.text,//设置输入框文本类型
                            textAlign: TextAlign.left,//设置内容显示位置是否居中等
                            style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                            fontFamily: GlobalConfig.font
                            ),
                          ),
                      ),
                      Text("作者：",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                          fontFamily:GlobalConfig.font,
                        ),
                      ),
                      Container(height:25,margin:EdgeInsets.only(top: 3.0),color:Colors.white30,
                        child:
                          EditableText(
                            controller:aut,
                            cursorColor: Colors.blue,
                            focusNode: FocusNode(),
                              keyboardType: TextInputType.text,//设置输入框文本类型
                              textAlign: TextAlign.left,//设置内容显示位置是否居中等
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.normal,
                                  fontFamily: GlobalConfig.font
                              ),
                          ),
                      )
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 5.0),),
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
                        dbUpdatePoem(widget.id,tit.text,aut.text,con.text,widget.cate).whenComplete((){
                          widget.refreshfather();
                        });
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


