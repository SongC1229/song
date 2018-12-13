import 'package:flutter/material.dart';
import 'global_config.dart';

class Motto extends StatelessWidget{

  const Motto({@required this.refreshMain});
  final refreshMain;
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
                          Container(width:30.0,child:Icon(Icons.loyalty,color: Colors.cyan)),
                          Container(
                            width:170,
                            child:new Align(
                              alignment:FractionalOffset.centerLeft,
                              child: new Text(" 签名",
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
                        padding: EdgeInsets.fromLTRB(5.0, 15.0, 10.0, 15.0),
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
                          color: Colors.grey,
                        ),
                        child:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                          Text("昵称：",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.normal,
                                fontFamily: GlobalConfig.font
                            ),
                          ),
                          TextField(
                              onChanged: (String str){//输入监听
                                GlobalConfig.nametemp=str;
                              },
                              keyboardType: TextInputType.text,//设置输入框文本类型
                              textAlign: TextAlign.left,//设置内容显示位置是否居中等
                              decoration: new InputDecoration(
                                hintText: GlobalConfig.name,
                              )
                          ),
                          Padding(padding: EdgeInsets.only(top: 5.0),),
                          Text("签名：",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.normal,
                                fontFamily: GlobalConfig.font
                            ),
                          ),
                          TextField(
                              onChanged: (String str){//输入监听
                                GlobalConfig.mottotemp=str;
                              },
                              keyboardType: TextInputType.text,//设置输入框文本类型
                              textAlign: TextAlign.left,//设置内容显示位置是否居中等
                              decoration: new InputDecoration(
                                hintText:GlobalConfig.motto,
                              )
                          ),
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
                              GlobalConfig.nametemp==""?GlobalConfig.nametemp="":GlobalConfig.name=GlobalConfig.nametemp;
                              GlobalConfig.mottotemp==""?GlobalConfig.mottotemp="":GlobalConfig.motto=GlobalConfig.mottotemp;
                              refreshMain();
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


