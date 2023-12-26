import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GConfig {

  static const Color night=Colors.blueGrey;
  static const Color light=Color(0xFFB7D6CF);
  static const Map<String,String> backimg={
    "search":"asset/images/searchback.jpg",
    "Tpoem":"asset/images/tang.jpg",
    "Spoem":"asset/images/song.jpg",
    "song":"asset/images/shijing.jpg",
    "icon":"asset/images/icon.jpg",
    "yoona":"asset/images/yoona.jpg"};
  static const List<String> fontnames=["方正楷体","安卓系统"];
  static const List<String> tables=["Tpoem","Spoem","song"];
  static const List<String> poemcate = ['唐 诗', '宋 词', '诗 经', '搜 索','录音'];
  static const platform = const MethodChannel("sning.ttspeak");
  static final ThemeData themeData = new ThemeData(primarySwatch:Colors.blue);

  static String appDir="null";
  static Color appBackgroundColor = Color(0xFFB7D6CF);

  static bool dark = false;
  static String font="方正楷体";
  static double fontSize=18;
  static String motto="但愿人长久，千里共婵娟";
  static String name="Yoona";
  static bool backfromlove=false;
  static int channel=0;
  static List<String> recordTitle = ['','','','','','','','','',''];
  static List<String> ttsTitle = ['恭喜发财','恭喜发财','恭喜发财','恭喜发财','恭喜发财','恭喜发财','恭喜发财','恭喜发财','恭喜发财','恭喜发财'];
}

Text gText(String text, {double? sizeAdjust, Color? color, FontWeight? fontWeight}){
  FontWeight fw = fontWeight==null? FontWeight.normal: fontWeight;
  double fs = sizeAdjust==null? GConfig.fontSize: GConfig.fontSize + sizeAdjust;
  if(color!= null)
    return Text(text, style: TextStyle(fontFamily:GConfig.font,color:color, fontSize: fs, fontWeight:fw));
  else
    return Text(text, style: TextStyle(fontFamily:GConfig.font, fontSize: fs,fontWeight: fw));
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

void printInfo(String str){
    Fluttertoast.showToast(
      msg: str,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
}