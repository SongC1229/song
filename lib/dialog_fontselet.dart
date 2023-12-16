import 'package:flutter/material.dart';
import 'global_config.dart';

class FontSelectDialog extends StatefulWidget {
  FontSelectDialog({@required this.refreshMain});
  final refreshMain;

  @override
  _FontSelectDialogState createState() => new _FontSelectDialogState();
}

class _FontSelectDialogState extends State<FontSelectDialog> {
  int fontType = 0;
  int fontSize = 0;

  void updateFontType(int v) {
    setState(() {
      GConfig.font = GConfig.fontnames[v];
      widget.refreshMain();
    });
  }

  void updateFontSize(int v) {
    setState(() {
      GConfig.fontSize = 14.0 + 3*v;
      widget.refreshMain();
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (GConfig.font) {
      case "方正楷体":
        fontType = 0;
        break;
      case "方正准圆":
        fontType = 1;
        break;
      case "安卓系统":
        fontType = 2;
        break;
    }
    switch (GConfig.fontSize) {
      case 14.0:
        fontSize = 0;
        break;
      case 17.0:
        fontSize = 1;
        break;
      case 20.0:
        fontSize = 2;
        break;
    }
    return new Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: new Center(
        //保证控件居中效果
        child: new SizedBox(
          width: 280.0,
          height: 450.0,
          child: new Container(
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
              color: GConfig.appBackgroundColor,
            ),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                gDialogTitle(context, " 字体", Icons.font_download),
                new Container(
                  height: 55,
                  margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
                  decoration: new BoxDecoration(
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(8.0)),
                    color: Colors.lightBlue,
                  ),
                  child: new RadioListTile(
                      value: 0,
                      groupValue: fontType,
                      title: new Text(
                        GConfig.fontnames[0] + "效果",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 3.0,
                            fontFamily: GConfig.fontnames[0]),
                      ),
                      onChanged: (T) {
                        updateFontType(T!);
                      }),
                ),
                new Container(
                  height: 55,
                  margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
                  decoration: new BoxDecoration(
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(8.0)),
                    color: Colors.lightBlue,
                  ),
                  child: new RadioListTile(
                      value: 1,
                      groupValue: fontType,
                      title: new Text(
                        GConfig.fontnames[1] + "效果",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 3.0,
                            fontFamily: GConfig.fontnames[1]),
                      ),
                      onChanged: (T) {
                        updateFontType(T!);
                      }),
                ),
                new Container(
                  height: 55,
                  margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
                  decoration: new BoxDecoration(
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(8.0)),
                    color: Colors.lightBlue,
                  ),
                  child: new RadioListTile(
                      value: 2,
                      groupValue: fontType,
                      title: new Text(
                        GConfig.fontnames[2] + "效果",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 3.0,
                            fontFamily: GConfig.fontnames[2]),
                      ),
                      onChanged: (T) {
                        updateFontType(T!);
                      }),
                ),
                new Container(
                  height: 180,
                  margin: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
                  decoration: new BoxDecoration(
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(8.0)),
                    color: Colors.lightBlue,
                  ),
                  child:Column(
                    children: [
                      RadioListTile(
                          value: 0,
                          groupValue: fontSize,
                          title: new Text(
                            "字号小",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                letterSpacing: 3.0,
                                fontFamily: GConfig.font),
                          ),
                          onChanged: (T) {
                            updateFontSize(T!);
                          }),
                      RadioListTile(
                          value: 1,
                          groupValue: fontSize,
                          title: new Text(
                            "字号中",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontWeight: FontWeight.normal,
                                letterSpacing: 3.0,
                                fontFamily: GConfig.font),
                          ),
                          onChanged: (T) {
                            updateFontSize(T!);
                          }),
                      RadioListTile(
                          value: 2,
                          groupValue: fontSize,
                          title: new Text(
                            "字号大",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                                letterSpacing: 3.0,
                                fontFamily: GConfig.font),
                          ),
                          onChanged: (T) {
                            updateFontSize(T!);
                          }),
                    ],
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
