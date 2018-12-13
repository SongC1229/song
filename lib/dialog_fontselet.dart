import 'package:flutter/material.dart';
import 'global_config.dart';

class FontSelectDialog extends StatefulWidget {
  FontSelectDialog({@required this.refreshMain});
  final refreshMain;

  @override
  _FontSelectDialogState createState() => new _FontSelectDialogState();
}

class _FontSelectDialogState extends State<FontSelectDialog> {
  int value=3;

  void updateGroupValue(int v){
    setState(() {
      value=v;
      switch(v){
        case 1:GlobalConfig.font=GlobalConfig.fontnames[0];break;
        case 2:GlobalConfig.font=GlobalConfig.fontnames[1];break;
        case 3:GlobalConfig.font=GlobalConfig.fontnames[2];
      }
      widget.refreshMain();
    });
  }

  @override
  Widget build(BuildContext context) {
    switch(GlobalConfig.font){
      case "方正楷体":value=1;break;
      case "方正准圆":value=2;break;
      case "安卓系统":value=3;break;
    }
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

                    Container(width:30.0,child:Icon(Icons.font_download,color: Colors.cyan)),
                    Container(
                      width:170,
                      child:new Align(
                        alignment:FractionalOffset.centerLeft,
                        child: new Text(" 字体",
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
                  height: 55,
                  margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
                    color: Colors.lightBlue,
                  ),
                  child:new RadioListTile(
                      value: 1,
                      groupValue: value,
                      title: new Text(GlobalConfig.fontnames[0]+"效果",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 3.0,
                            fontFamily: GlobalConfig.fontnames[0]
                        ),
                      ),
                      onChanged: (T){
                        updateGroupValue(T);
                      }),
                ),
                new Container(
                  height: 55,
                  margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
                    color: Colors.lightBlue,
                  ),
                  child:new RadioListTile(
                      value: 2,
                      groupValue: value,
                      title: new Text(GlobalConfig.fontnames[1]+"效果",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 3.0,
                            fontFamily:GlobalConfig.fontnames[1]
                        ),
                      ),
                      onChanged: (T){
                        updateGroupValue(T);
                      }),
                ),
                new Container(
                  height: 55,
                  margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
                    color: Colors.lightBlue,
                  ),
                  child:new RadioListTile(
                      value: 3,
                      groupValue: value,
                      title: new Text(GlobalConfig.fontnames[2]+"效果",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 3.0,
                            fontFamily: GlobalConfig.fontnames[2]
                        ),
                      ),
                      onChanged: (T){
                        updateGroupValue(T);
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}