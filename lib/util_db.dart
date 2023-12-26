import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'util_ui.dart';
final theme={1:"Tpoem",2:"Spoem",3:"song"};
dynamic shidb;

void speech(String str) async{
  await GConfig.platform.invokeMethod("speakPoem",str);
}

void stopSpeech() async{
  await GConfig.platform.invokeMethod("stopSpeak");
}
void updateChannel(int chn) async{
  print("切换声道 $chn");
  await GConfig.platform.invokeMethod("updateChannel",chn.toString());
}

void initconf( var refreshApp) async{
  if(GConfig.appDir=="null"){
    GConfig.appDir = (await getApplicationDocumentsDirectory()).path;
  }
  String confpath= GConfig.appDir+"/conf.json";
  bool confexist=FileSystemEntity.isFileSync(confpath);
  Map<String, dynamic> confjson ={};
  if(!confexist){
    await rootBundle.loadString('asset/config.json').then((value) async{
      await new File(confpath).writeAsString(value).whenComplete((){
        JsonDecoder decoder = new JsonDecoder();
        confjson = decoder.convert(value);
        GConfig.font=confjson["font"];
        GConfig.dark=confjson["dark"];
        GConfig.motto=confjson["motto"];
        GConfig.name=confjson["name"];
        GConfig.fontSize=confjson["fontSize"];
        GConfig.channel = confjson["channel"];
        GConfig.recordTitle = new List<String>.from(confjson["recordTitle"]);
        GConfig.ttsTitle = new List<String>.from(confjson["ttsTitle"]);
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
      GConfig.recordTitle = new List<String>.from(confjson["recordTitle"]);
      GConfig.ttsTitle = new List<String>.from(confjson["ttsTitle"]);
      GConfig.dark?GConfig.appBackgroundColor=GConfig.night:GConfig.appBackgroundColor=GConfig.light;
      refreshApp();
    });
  }
}

Future updateconf() async{
  Map<String, dynamic> confjson ={};
  confjson["font"]=GConfig.font;
  confjson["fontSize"]=GConfig.fontSize;
  confjson["channel"]=GConfig.channel;
  confjson["dark"]=GConfig.dark;
  confjson["motto"]=GConfig.motto;
  confjson["name"]=GConfig.name;
  confjson["recordTitle"]=GConfig.recordTitle;
  confjson["ttsTitle"]=GConfig.ttsTitle;
  JsonEncoder encoder=new JsonEncoder();
  String jsonString=encoder.convert(confjson);
  new File(GConfig.appDir+"/conf.json").writeAsString(jsonString);
}

void initPoem() async{
  if(GConfig.appDir=="null"){
    GConfig.appDir = (await getApplicationDocumentsDirectory()).path;
  }
  String dbpath =GConfig.appDir+"/shi.db";
  bool dbexist=FileSystemEntity.isFileSync(dbpath);
  //数据库不存在就拷贝，存在就加载
  if(!dbexist){
    printInfo("拷贝数据中\n下拉刷新");
    ByteData data = await rootBundle.load("asset/shi.db");
    List<int> bytes =
    data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await new File(dbpath).writeAsBytes(bytes).whenComplete(()async{
      try {
        shidb = await openDatabase(dbpath);
      } catch (e) {
        print(e);
      }
    });
  }
  else{
    try {
      print("加载数据库");
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
    printInfo("删除失败");
  }
}


//搜索
Future<List?>  dbDelectLove(int pomecate) async{
  String sql="select id, title,author,content from "+theme[pomecate]!+" where love=1;";
  var data = await shidb.rawQuery(sql);
  return data;
}
