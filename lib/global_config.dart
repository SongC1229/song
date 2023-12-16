import 'package:flutter/material.dart';



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
  static double fontSize=14;
  static List<String> fontnames=["方正楷体","方正准圆","安卓系统"];
  static List<String> poemcate = ['唐 诗', '宋 词', '诗 经', '搜 索'];
  static String motto="但愿人长久，千里共婵娟";
  static String name="Yoona";
  static String temp1="";
  static String temp2="";
  static bool backfromlove=false;
}
Text Gtext(String text){
  return Text(text, style: TextStyle(fontFamily:GConfig.font, fontSize: GConfig.fontSize));
}