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
              color: GConfig.appBackgroundColor,
            ),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                gDialogTitle(context, " 关于", Icons.info),
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
                        fontFamily:GConfig.font
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
                        fontFamily:GConfig.font
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
                  child:new Text("YeZi v0.9 by Flutter 3.16",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.normal,
                        letterSpacing: 2.0,
                        fontFamily:GConfig.font
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