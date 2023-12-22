import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'global_config.dart';
final theme={1:"Tpoem",2:"Spoem",3:"song"};
bool dbexist=false;
bool confexist=false;
dynamic shidb;
Map<String, dynamic> confjson ={};
String docDir="uninit";

void speech(var data) async{
  await GConfig.platform.invokeMethod("speakPoem",data["title"]+"，"+data["author"]+"。"+data["content"]);
}

void stopSpeech() async{
  await GConfig.platform.invokeMethod("stopSpeak");
}
void updateChannel(int chn) async{
  print("切换声道 $chn");
  await GConfig.platform.invokeMethod("updateChannel",chn.toString());
}
Future updateconf() async{
  confjson["font"]=GConfig.font;
  confjson["fontSize"]=GConfig.fontSize;
  confjson["channel"]=GConfig.channel;
  confjson["dark"]=GConfig.dark;
  confjson["motto"]=GConfig.motto;
  confjson["name"]=GConfig.name;
  JsonEncoder encoder=new JsonEncoder();
  String jsonString=encoder.convert(confjson);
  if(docDir=="uninit"){
    docDir = (await getApplicationDocumentsDirectory()).path;
  }
  new File(docDir+"/conf.json").writeAsString(jsonString);
}

void initconf( var refreshApp) async{
  if(docDir=="uninit"){
    docDir = (await getApplicationDocumentsDirectory()).path;
  }
  var confpath=docDir+"/conf.json";
  confexist=FileSystemEntity.isFileSync(confpath);
  if(!confexist){
    await rootBundle.loadString('asset/config.json').then((value) async{
      await new File(confpath).writeAsString(value).whenComplete((){
        confexist=true;
        JsonDecoder decoder = new JsonDecoder();
        confjson = decoder.convert(value);
        GConfig.font=confjson["font"];
        GConfig.dark=confjson["dark"];
        GConfig.motto=confjson["motto"];
        GConfig.name=confjson["name"];
        GConfig.fontSize=confjson["fontSize"];
        GConfig.channel = confjson["channel"];
        GConfig.dark?GConfig.appBackgroundColor=GConfig.night:GConfig.appBackgroundColor=GConfig.light;
        refreshApp();
      });
    });
  }
  else{
    new File(confpath).readAsString().then((value){
//      print("加载配置文件");
      JsonDecoder decoder = new JsonDecoder();
      confjson = decoder.convert(value);
      GConfig.font=confjson["font"];
      GConfig.dark=confjson["dark"];
      GConfig.motto=confjson["motto"];
      GConfig.name=confjson["name"];
      GConfig.fontSize=confjson["fontSize"];
      GConfig.channel = confjson["channel"];
      GConfig.dark?GConfig.appBackgroundColor=GConfig.night:GConfig.appBackgroundColor=GConfig.light;
      refreshApp();
    });
  }
}


void initPoem() async{
  if(docDir=="uninit"){
    docDir = (await getApplicationDocumentsDirectory()).path;
  }
  var dbpath =docDir+"/shi.db";
  dbexist=FileSystemEntity.isFileSync(dbpath);
  //数据库不存在就拷贝，存在就加载
  if(!dbexist){
    Fluttertoast.showToast(
      msg: "拷贝数据中...\n下拉刷新",
      toastLength: Toast.LENGTH_SHORT,
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



Future<Map?> getData(int cate,int id) async{
  String sql;
  id==0?sql="SELECT * FROM "+theme[cate]!+" ORDER BY RANDOM() limit 1":sql="select * from "+theme[cate]!+" where id= $id";
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
Future<List?>  dbSearch(String key,int catepoem,int b) async{

  List<Map<String, dynamic>> data;
  Map c={1:"title",2:"author",3:"content"};
  String sql="select * from "+theme[catepoem]!+" where "+c[b]+" like '%"+key+"%' limit 500;";
//  print(sql);
  data = await shidb.rawQuery(sql);
  return data;
}

Future dbUpdateLove(int id,int love,int cate) async{
  String sql="update "+theme[cate]!+" set love= ? where id= ?";
  await shidb.rawUpdate(sql,[love,id]);
}

Future dbUpdatePoem(int id,String title,String author,String content,int cate) async{
  String sql="update "+theme[cate]!+" set title= ?, author= ?,content= ? where id= ?";
  await shidb.rawUpdate(sql,[title,author,content,id]);
}

Future dbDelete(int id,int cate) async{
  String sql="delete from "+theme[cate]!+" where id=$id";
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
Future<List?>  dbDelectLove(int pomecate) async{
  String sql="select id, title,author,content from "+theme[pomecate]!+" where love=1;";
  var data = await shidb.rawQuery(sql);
  return data;
}
