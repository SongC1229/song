import 'package:flutter/material.dart';
import 'util_ui.dart';

class Motto extends StatelessWidget{

  const Motto({@required this.refreshMain});
  final refreshMain;
  @override
  Widget build(BuildContext context) {

    String temp1='';
    String temp2='';
    return new Material( //创建透明层
      type: MaterialType.transparency, //透明类型
      child: new Center( //保证控件居中效果
        child: new SizedBox(
          width: 280.0,
          height: 300.0,
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
                      gDialogTitle(context, " 签名", Icons.loyalty),
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
                                fontFamily: GConfig.font
                            ),
                          ),
                          TextField(
                              onChanged: (String str){//输入监听
                                temp1=str;
                              },
                              keyboardType: TextInputType.text,//设置输入框文本类型
                              textAlign: TextAlign.left,//设置内容显示位置是否居中等
                              decoration: new InputDecoration(
                                hintText: GConfig.name,
                              ),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal,
                                fontFamily: GConfig.font,

                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 5.0),),
                          Text("签名：",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.normal,
                                fontFamily: GConfig.font
                            ),
                          ),
                          TextField(
                              onChanged: (String str){//输入监听
                                temp2=str;
                              },
                              keyboardType: TextInputType.text,//设置输入框文本类型
                              textAlign: TextAlign.left,//设置内容显示位置是否居中等
                              decoration: new InputDecoration(
                                hintText:GConfig.motto,
                              ),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                fontWeight: FontWeight.normal,
                                fontFamily: GConfig.font
                            ),
                          ),
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 5.0),),
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
                              temp1==""?temp1="":GConfig.name=temp1;
                              temp2==""?temp2="":GConfig.motto=temp2;
                              refreshMain();
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


