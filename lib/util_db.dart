import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'global_config.dart';
final theme={1:"Tpoem",2:"Spoem",3:"song"};
bool dbexist=false;
bool confexist=false;
Database shidb;
Map<String, dynamic> confjson;
String docDir;
const platform = const MethodChannel("sning.ttspeak");

void speech(var data) async{
  await platform.invokeMethod("speakpoem",data["title"]+"，"+data["author"]+"。"+data["content"]);
}

void stopspeech() async{
  await platform.invokeMethod("stopspeak");
}

Future updateconf() async{
  confjson["font"]=GlobalConfig.font;
  confjson["dark"]=GlobalConfig.dark;
  confjson["motto"]=GlobalConfig.motto;
  confjson["name"]=GlobalConfig.name;
  JsonEncoder encoder=new JsonEncoder();
  String jsonString=encoder.convert(confjson);
  if(docDir==null){
    docDir = (await getApplicationDocumentsDirectory()).path;
  }
  new File(docDir+"/conf.json").writeAsString(jsonString);
}

void initconf( var refreshApp) async{
  if(docDir==null){
    docDir = (await getApplicationDocumentsDirectory()).path;
  }
  var confpath=docDir+"/conf.json";
  confexist=FileSystemEntity.isFileSync(confpath);
  if(!confexist){
//    print("拷贝配置文件");
    await rootBundle.loadString('asset/config.json').then((value) async{
      await new File(confpath).writeAsString(value).whenComplete((){
        confexist=true;
        JsonDecoder decoder = new JsonDecoder();
        confjson = decoder.convert(value);
        GlobalConfig.font=confjson["font"];
        GlobalConfig.dark=confjson["dark"];
        GlobalConfig.motto=confjson["motto"];
        GlobalConfig.name=confjson["name"];
        GlobalConfig.dark?GlobalConfig.appBackgroundColor=GlobalConfig.night:GlobalConfig.appBackgroundColor=GlobalConfig.light;
        refreshApp();
      });
    });
  }
  else{
    new File(confpath).readAsString().then((value){
//      print("加载配置文件");
      JsonDecoder decoder = new JsonDecoder();
      confjson = decoder.convert(value);
      GlobalConfig.font=confjson["font"];
      GlobalConfig.dark=confjson["dark"];
      GlobalConfig.motto=confjson["motto"];
      GlobalConfig.name=confjson["name"];
      GlobalConfig.dark?GlobalConfig.appBackgroundColor=GlobalConfig.night:GlobalConfig.appBackgroundColor=GlobalConfig.light;
      refreshApp();
    });
  }
}


void initPoem() async{
  //数据库不存在就拷贝，存在就加载
  if(docDir==null){
    docDir = (await getApplicationDocumentsDirectory()).path;
  }
  var dbpath =docDir+"/shi.db";
  dbexist=FileSystemEntity.isFileSync(dbpath);
//  print(dbexist);
  if(!dbexist){
    Fluttertoast.showToast(
      msg: "拷贝数据中...\n下拉以刷新",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
    );
//    print("Creating new copy from asset");
    ByteData data = await rootBundle.load("asset/shi.db");
    List<int> bytes =
    data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await new File(dbpath).writeAsBytes(bytes).whenComplete(()async{
      dbexist=true;
      try {
        shidb = await openDatabase(dbpath);
      } catch (e) {
        print(e);
      }
    });
  }
  else{
    try {
      shidb = await openDatabase(dbpath);
    } catch (e) {
      print(e);
    }
  }
}



Future<Map> getData(int cate,int id) async{
//  print(GlobalConfig.font.toString());
  if(shidb==null){
//    Fluttertoast.showToast(
//        msg: "数据库为空，获取失败",
//        toastLength: Toast.LENGTH_SHORT,
//        gravity: ToastGravity.CENTER,
//        textcolor: '#000000'
//    );
    return null;
  }
  String sql;
  id==0?sql="SELECT * FROM "+theme[cate]+" ORDER BY RANDOM() limit 1":sql="select * from "+theme[cate]+" where id= $id";
  List<Map> data = await shidb.rawQuery(sql);
  String title =data[0]["title"];
  String author = data[0]["author"];//utf8.decode(list[0]["author"]);
  String content = data[0]["content"];
  int love = data[0]["love"];
  id =data[0]["id"];
  if(content.length<125){
    content=content+"\n";
  }
  else if(content.length<160){
    content=content+"\n";
  }
//  print(id);
  return {"id":id,"title":title,"author":author,"content":content,"love":love};
}



//搜索
Future<List>  dbSearch(String key,int catepoem,int b) async{
  if(shidb==null){
    Fluttertoast.showToast(
        msg: "数据库为空,查询失败",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
    );
    return null;
  }

  List<Map<String, dynamic>> data;
  Map c={1:"title",2:"author",3:"content"};
  String sql="select * from "+theme[catepoem]+" where "+c[b]+" like '%"+key+"%' limit 500;";
//  print(sql);
  data = await shidb.rawQuery(sql);
  return data;
}

Future dbUpdateLove(int id,int love,int cate) async{
  if(shidb==null){
    Fluttertoast.showToast(
        msg: "数据库为空,更改失败",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
    );
    return null;
  }
  String sql="update "+theme[cate]+" set love= ? where id= ?";
  await shidb.rawUpdate(sql,[love,id]);
}

Future dbUpdatePoem(int id,String title,String author,String content,int cate) async{
  if(shidb==null){
    Fluttertoast.showToast(
        msg: "数据库为空,更改失败",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
    );
    return null;
  }
  String sql="update "+theme[cate]+" set title= ?, author= ?,content= ? where id= ?";
  await shidb.rawUpdate(sql,[title,author,content,id]);
}

Future dbDelete(int id,int cate) async{
  if(shidb==null){
    Fluttertoast.showToast(
        msg: "数据库为空,删除失败",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
    );
    return null;
  }
  String sql="delete from "+theme[cate]+" where id=$id";
  int count=await shidb.rawDelete(sql);
  if(count!=1){
    Fluttertoast.showToast(
        msg: "删除失败",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
    );
  }
}


//搜索
Future<List>  dbDelectLove(int pomecate) async{
  if(shidb==null){
    Fluttertoast.showToast(
        msg: "数据库为空，查询失败",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
    );
    return null;
  }
  var data;
  String sql="select id, title,author,content from "+theme[pomecate]+" where love=1;";
  data = await shidb.rawQuery(sql);
  return data;
}
