import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GConfig {
  static Color night=Colors.blueGrey;
  static Color light=Color(0xFFB7D6CF);
  static bool dark = false;
  static ThemeData themeData = new ThemeData(primarySwatch:Colors.blue);
  static Color appBackgroundColor = Color(0xE593ABB2);
  static List<String> backimg=["asset/images/searchback.jpg",
                                "asset/images/tang.jpg",
                                "asset/images/song.jpg",
                                "asset/images/shijing.jpg",
                                "asset/images/icon.jpg",
                                "asset/images/yoona.jpg"
                              ];
  static String font="方正楷体";
  static double fontSize=18;
  static const List<String> fontnames=["方正楷体","安卓系统"];
  static List<String> poemcate = ['唐 诗', '宋 词', '诗 经', '搜 索'];
  static String motto="但愿人长久，千里共婵娟";
  static String name="Yoona";
  static String temp1="";
  static String temp2="";
  static bool backfromlove=false;
  static int channel=0;
  static const platform = const MethodChannel("sning.ttspeak");
}
Text gText(String text){
  return Text(text, style: TextStyle(fontFamily:GConfig.font, fontSize: GConfig.fontSize));
}

Container gDialogTitle(BuildContext context,String title,IconData icon){
  return Container(
      height:42,
      margin:const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0.0),
      child:
      Column(
        children: [
          Row(children: <Widget>[
            Container(width:30.0,child:Icon(icon,color: Colors.cyan)),
            Container(
              width:170,
              child:new Align(
                alignment:FractionalOffset.centerLeft,
                child: new Text(title,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.normal,
                      letterSpacing: 5.0,
                      fontFamily: GConfig.font
                  ),
                ),
              ),
            ),
            Container(
              width: 60,
              height: 30,
              child:FloatingActionButton(
                onPressed: (){
                  Navigator.pop(context); //关闭对话框
                },
                tooltip: '关闭',
                backgroundColor: Colors.white70,

                child: new Icon(Icons.close),
              ),
            ),
          ],
          ),
          new Container(
            margin: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            color:Colors.black54,
            height: 1.5,
          ),
        ],
      )
  );
}