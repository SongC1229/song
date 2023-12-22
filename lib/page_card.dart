import 'dart:async';
import 'package:flutter/material.dart';
import 'util_db.dart';
import 'global_config.dart';

class CardPage extends StatefulWidget {
  CardPage({@required this.ptheme,@required this.initdata,@required this.color});
  final ptheme;
  final initdata;
  final color;
  @override
  _CardPageState createState() => new _CardPageState();
}

class _CardPageState extends State<CardPage>{


  // RefreshIndicator requires key to implement state
  final GlobalKey<RefreshIndicatorState> _refreshKey =
  GlobalKey<RefreshIndicatorState>();
  late Map data;
  var backimg;

  Future<Null> _refresh() {
    return getData(widget.ptheme,0).then((resultdata) {
      setState(() {
        if(resultdata!=null){
          data =resultdata;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    backimg=ExactAssetImage(GConfig.backimg[widget.ptheme]);
    // 初始数据
    data=widget.initdata;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshKey.currentState!.show();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:GConfig.appBackgroundColor,
      body: RefreshIndicator(
        key: _refreshKey,
        // child is typically ListView or CustomScrollView
        child: ListView(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top:5.0,left: 15.0,right: 15.0),
                child:Row(
                    children: <Widget>[
                      ElevatedButton (
                          onPressed:(){speech(data);},
                          child: Row(children: <Widget>[
                            Icon(Icons.audiotrack,size: 23.0),
                            Text("朗读",
                                style: TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.normal,
                                letterSpacing: 5.0,
                                fontFamily: GConfig.font
                                ),
                            )
                          ],
                          ),
                          ),
                        Padding(padding: EdgeInsets.only(left: 10.0),),
                      ElevatedButton (
                            onPressed:stopSpeech,
                            child: Row(children: <Widget>[
                              Icon(Icons.stop,size: 23.0),
                              Text("停止",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.normal,
                                    letterSpacing: 5.0,
                                    fontFamily: GConfig.font
                                ),
                              )
                            ],
                            )
                        ),
//                        Padding(padding: EdgeInsets.only(left: 10.0),),
//                        RaisedButton(
//                            onPressed:_continuespeech,
//                            color: Colors.blue,
//                            child: Row(children: <Widget>[
//                              Icon(Icons.last_page,size: 23.0),
//                              Text("继续",
//                                style: TextStyle(
//                                    color: widget.color,
//                                    fontSize: 16.0,
//                                    fontWeight: FontWeight.bold,
//                                    letterSpacing: 5.0,
//                                    fontFamily: GlobalConfig.fonts
//                                ),
//                              )
//                            ],
//                            )
//                        ),
                    ]
                   ),
                 ),
              Container(
                margin: const EdgeInsets.only(left:15.0,right: 15.0,bottom: 15.0,top: 10.0),
                decoration: new BoxDecoration(
                  border: new Border.all(width: 1.0, color: Colors.purple),
                  borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
                  image: new DecorationImage(
                      image:backimg,
                      fit: BoxFit.cover
                  ),
                ),
                child: _buildpoem()
              ),
            ]
        ),
        onRefresh: _refresh,
      ),
    );
  }


  Widget _buildpoem(){
    if(GConfig.backfromlove){
//      print("重新确定");
    getData(widget.ptheme, data["id"]).then((resultdata) {
        if(resultdata!=null){
          if(resultdata["love"]!=data["love"]){
            setState(() {
              data["love"]=resultdata["love"];
            });
          }
        }
      });
    if(widget.ptheme==3)
      GConfig.backfromlove=false;
    }
    return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children:<Widget>[
          Container(
            margin: EdgeInsets.only(right:15.0),
            child:new Align(
              alignment:FractionalOffset.topRight,
              child: FloatingActionButton(
                child: Icon(Icons.favorite,size: 30,color:  data["love"]==0?Color(0xFFB0B0B0):Colors.red,),
                onPressed: () {
                  setState(() {
                    data["love"]==0?data["love"]=1:data["love"]=0;
                    dbUpdateLove(data["id"],data["love"],widget.ptheme);
                  });
                },
                elevation: 0.0,
                backgroundColor: Color(0x00000000),
              ),
            ),
          ),
          gText(data["title"], color: widget.color,sizeAdjust:4, fontWeight: FontWeight.bold),
          Padding(padding: EdgeInsets.only(top: 3.0),
            child:gText(data["author"],color: widget.color,sizeAdjust:-2,fontWeight: FontWeight.w200)
          ),
          Padding(
            padding: EdgeInsets.only(right: 0.0,left: 10.0,bottom: 20.0,top: 4.0),
            child:gText(data["content"], color: widget.color),
            )
        ]
    );
  }

}
