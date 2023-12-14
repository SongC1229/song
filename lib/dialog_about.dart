import 'package:flutter/material.dart';
import 'global_config.dart';

class AboutDia extends StatelessWidget{

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
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Container(
                  height:30,
                  margin:const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 5.0),
                  child:Row(children: <Widget>[
                    Container(width:30.0,child:Icon(Icons.info,color: Colors.cyan)),
                    Container(
                      width:170,
                      child:new Align(
                        alignment:FractionalOffset.centerLeft,
                        child: new Text(" 关于",
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
                  height: 50,
                  margin: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 0.0),
                  padding: EdgeInsets.fromLTRB(5.0, 15.0, 10.0, 15.0),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
                    color: Colors.lightBlue,
                  ),
                  child:new Text("作者：sning",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 2.0,
                        fontFamily:GlobalConfig.font
                    ),
                  ),
                ),
                new Container(
                  width: 250,
                  height: 50,
                  margin: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 0.0),
                  padding: EdgeInsets.fromLTRB(5.0, 15.0, 10.0, 15.0),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
                    color: Colors.lightBlue,
                  ),
                  child:new Text("联系qq:1620524565",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 2.0,
                        fontFamily:GlobalConfig.font
                    ),
                  ),
                ),
                new Container(
                  width: 250,
                  height: 50,
                  margin: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 0.0),
                  padding: EdgeInsets.fromLTRB(5.0, 15.0, 10.0, 15.0),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
                    color: Colors.lightBlue,
                  ),
                  child:new Text("yezi v0.2 by Flutter",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 2.0,
                        fontFamily:GlobalConfig.font
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}