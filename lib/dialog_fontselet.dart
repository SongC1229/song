import 'package:flutter/material.dart';
import 'package:song/util_db.dart';
import 'global_config.dart';

class FontSelectDialog extends StatefulWidget {
  FontSelectDialog({@required this.refreshMain});
  final refreshMain;

  @override
  _FontSelectDialogState createState() => new _FontSelectDialogState();
}

class _FontSelectDialogState extends State<FontSelectDialog> {

  Container genFontSelect(String fontName){
    return new Container(
        width: 280,
        height: 50,
        margin: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 0.0),
        decoration: new BoxDecoration(
          borderRadius:
          new BorderRadius.all(new Radius.circular(8.0)),
          color: Colors.lightBlue,
        ),
        child: new RadioListTile(
            value: fontName,
            groupValue: GConfig.font,
            title: new Text(
              fontName,
              style: TextStyle(
                  fontSize: GConfig.fontSize,
                  letterSpacing: 3.0,
                  fontFamily: fontName),
            ),
            onChanged: (T) {
              setState(() {
                GConfig.font = T.toString();
                widget.refreshMain();
              });
            }),
      );
  }

  @override
  Widget build(BuildContext context) {
    return new Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: new Center(
        //保证控件居中效果
        child: new SizedBox(
          width: 320.0,
          height: 380.0,
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
                genFontSelect(GConfig.fontnames[0]),
                genFontSelect(GConfig.fontnames[1]),
                new Container(
                  width: 280,
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
                          // print("_MyHomePageState - build: onChangeStart $value");
                        },
                        // 拖动结束
                        onChangeEnd: (value) {
                          // print("_MyHomePageState - build: onChangeEnd $value");
                        },
                        min: 16.0,
                        max: 26.0,
                        // label的数量，比如最小0、最大10、divisions是10，那么label的数量就是10
                        divisions: 10,
                        // 拖动时上方会显示当前值
                        // label: "${GConfig.fontSize}",
                        // 激活的颜色
                        activeColor: Colors.white,
                        // 未激活的颜色
                        inactiveColor: Colors.white,

                      ),

                      Text(
                        "字号 ${GConfig.fontSize.toInt()}",
                        style: TextStyle(
                            fontSize: 16,
                            letterSpacing: 3.0,
                            fontFamily: GConfig.font),
                      ),
                    ],
                  )
                ),

                new Container(
                    width: 280,
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
                        Slider(
                          // 当前值
                          value: GConfig.channel.toDouble(),
                          // 拖动中
                          onChanged: (chn) {
                            setState(() {
                              GConfig.channel= chn.toInt();
                            });
                          },
                          // 拖动开始
                          onChangeStart: (value) {
                            // print("_MyHomePageState - build: onChangeStart $value");
                          },
                          // 拖动结束
                          onChangeEnd: (chn) {
                            setState(() {
                              GConfig.channel= chn.toInt();
                              print("拖动结束 $chn");
                              updateChannel(GConfig.channel);
                            });
                          },
                          min: 0,
                          max: 20,
                          // label的数量，比如最小0、最大10、divisions是10，那么label的数量就是10
                          divisions: 20,
                          // 拖动时上方会显示当前值
                          // label: "${GConfig.fontSize}",
                          // 激活的颜色
                          activeColor: Colors.white,
                          // 未激活的颜色
                          inactiveColor: Colors.white,

                        ),

                        Text(
                          "音道 ${GConfig.channel.toInt()}",
                          style: TextStyle(
                              fontSize: 16,
                              letterSpacing: 3.0,
                              fontFamily: GConfig.font),
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
