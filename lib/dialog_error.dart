import 'package:flutter/material.dart';
import 'global_config.dart';

class ErrorDia extends StatelessWidget{

  const ErrorDia({ Key key,@required this.errormsg }) : super(key: key);
  final errormsg;
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
                    Container(width:30.0,child:Icon(Icons.error,color: Colors.red)),
                    Container(
                      width:170,
                      child:new Align(
                        alignment:FractionalOffset.centerLeft,
                        child: new Text(" 异常",
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
                  height: 200,
                  margin: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 5.0),
                  padding: EdgeInsets.fromLTRB(5.0, 15.0, 10.0, 15.0),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
                    color: Colors.grey,
                  ),
                  child:new Text("异常信息:\n    $errormsg",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        height: 1.2,
                        fontWeight: FontWeight.normal,
                        fontFamily:GlobalConfig.font
                    ),
                    maxLines:8 ,
                    overflow: TextOverflow.clip,
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