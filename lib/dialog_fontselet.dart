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

  void updateFontType(int v) {
    setState(() {
      GConfig.font = GConfig.fontnames[v];
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
    return new Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: new Center(
        //保证控件居中效果
        child: new SizedBox(
          width: 280.0,
          height: 320.0,
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
                  width: 250,
                  height: 50,
                  margin: EdgeInsets.fromLTRB(5.0, 10, 5.0, 0.0),
                  decoration: new BoxDecoration(
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(8.0)),
                    color: Colors.lightBlue,
                  ),
                  child: new RadioListTile(
                      value: 0,
                      groupValue: fontType,
                      title: new Text(
                        GConfig.fontnames[0],
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: GConfig.fontSize,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 3.0,
                            fontFamily: GConfig.fontnames[0]),
                      ),
                      onChanged: (T) {
                        updateFontType(T!);
                      }),
                ),
                new Container(
                  width: 250,
                  height: 50,
                  margin: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 0.0),
                  decoration: new BoxDecoration(
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(8.0)),
                    color: Colors.lightBlue,
                  ),
                  child: new RadioListTile(
                      value: 1,
                      groupValue: fontType,
                      title: new Text(
                        GConfig.fontnames[1],
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: GConfig.fontSize,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 3.0,
                            fontFamily: GConfig.fontnames[1]),
                      ),
                      onChanged: (T) {
                        updateFontType(T!);
                      }),
                ),
                new Container(
                  width: 250,
                  height: 50,
                  margin: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 0.0),
                  decoration: new BoxDecoration(
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(8.0)),
                    color: Colors.lightBlue,
                  ),
                  child: new RadioListTile(
                      value: 2,
                      groupValue: fontType,
                      title: new Text(
                        GConfig.fontnames[2],
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: GConfig.fontSize,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 3.0,
                            fontFamily: GConfig.fontnames[2]),
                      ),
                      onChanged: (T) {
                        updateFontType(T!);
                      }),
                ),
                new Container(
                  width: 250,
                  height: 50,
                  margin: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 0.0),
                  decoration: new BoxDecoration(
                    borderRadius:
                        new BorderRadius.all(new Radius.circular(8.0)),
                    color: Colors.lightBlue,
                  ),
                  child:
                  Row(
                    children: [
                      Text(
                        "  字号",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 3.0,
                            fontFamily: GConfig.font),
                      ),
                      Slider(
                        // 当前值
                        value: GConfig.fontSize,
                        // 拖动中
                        onChanged: (fs) {
                          setState(() {
                            GConfig.fontSize= fs;
                            widget.refreshMain();
                          });
                        },
                        // 拖动开始
                        onChangeStart: (value) {
                          print("_MyHomePageState - build: onChangeStart $value");
                        },
                        // 拖动结束
                        onChangeEnd: (value) {
                          print("_MyHomePageState - build: onChangeEnd $value");
                        },
                        min: 14.0,
                        max: 24.0,
                        // label的数量，比如最小0、最大10、divisions是10，那么label的数量就是10
                        divisions: 10,
                        // 拖动时上方会显示当前值
                        label: "${GConfig.fontSize}",
                        // 激活的颜色
                        activeColor: Colors.blue,
                        // 未激活的颜色
                        inactiveColor: Colors.white,
                      ),
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
