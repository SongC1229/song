import 'package:flutter/material.dart';
import 'global_config.dart';
import 'dialog_about.dart';
import 'dialog_fontselet.dart';
import 'dialog_backimg.dart';
//import 'main.dart';
import 'dialog_motto.dart';

class MyDrawer extends StatefulWidget {
  MyDrawer({@required this.refreshMain});
  final refreshMain;

  @override
  _MyDrawerState createState() => new _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: <Widget>[
          Positioned(
              top: 0.0,
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child:Container(
                color: GlobalConfig.appBackgroundColor,
                child: Column(children: <Widget>[
                    _userHeader(),
                    new Divider(color: Colors.grey, height: 1,), //分割线控件
                    ListTile(
                      title: Text("签 名",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 5.0,
                            fontFamily: GlobalConfig.font
                        ),
                      ),
                      leading: Icon(Icons.loyalty,color: Colors.cyan,),
                      onTap:setMotto,
                    ),
                    new Divider(color: Colors.grey, height: 1,), //分割线控件
                    ListTile(
                      leading: Icon(GlobalConfig.dark==true?Icons.brightness_high:Icons.brightness_2,color: Colors.cyan,),
                      title: Text(GlobalConfig.dark == true ? "日 间" : "夜 间",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 5.0,
                            fontFamily: GlobalConfig.font
                        ),
                      ),
                      onTap: () {
                        GlobalConfig.dark=!GlobalConfig.dark;
                        GlobalConfig.dark == true ?GlobalConfig.appBackgroundColor=Colors.blueGrey:GlobalConfig.appBackgroundColor=Color(0xFFD6D5B7);
                        widget.refreshMain();
                      },
                    ),
                    new Divider(color: Colors.grey, height: 1,), //分割线控件
                    ListTile(
                      title: Text("字 体",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 5.0,
                            fontFamily: GlobalConfig.font
                        ),
                      ),
                      leading: Icon(Icons.font_download,color: Colors.cyan,),
                      onTap:_selectFont,
                    ),
                    new Divider(color: Colors.grey, height: 1,), //分割线控件
                    ListTile(
                      title: Text("背 景",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                            letterSpacing: 5.0,
                            fontFamily: GlobalConfig.font
                        ),
                      ),
                      leading: Icon(Icons.image,color: Colors.cyan),
                      onTap:_setBackimg,
                    ),
                    new Divider(color: Colors.grey, height: 1,), //分割线控件
                    new ListTile( //退出按钮
                        leading: Icon(Icons.info,color: Colors.cyan,),
                        title: new Text('关 于',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16.0,
                              fontWeight: FontWeight.normal,
                              letterSpacing: 5.0,
                              fontFamily: GlobalConfig.font
                          ),
                        ),
                        onTap: _aboutPage
                    ),
                    new Divider(color: Colors.grey, height: 1,), //分割线控件
                  ],
                  )
                )
          ),
          Positioned(
            left: 10.0,
            bottom: 10.0,
            child:Container(
              child:new Align(
                alignment:FractionalOffset.center,
                child: new Text("☺  https://github.com/Sningi",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                      fontFamily: GlobalConfig.font
                  ),
                ),
              ),
            )
          ),

        ],
      ),
    );
  }

  Widget _userHeader(){
    return UserAccountsDrawerHeader(
      accountName: new Text(GlobalConfig.name,
        style: TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            letterSpacing: 4.0,
            fontFamily: GlobalConfig.font
        ),
      ), //用户名
      accountEmail: new Text(GlobalConfig.motto,
        style: TextStyle(
            color: Colors.black,
            fontSize: 17.0,
            fontWeight: FontWeight.normal,
            letterSpacing: 3.0,
            fontFamily: GlobalConfig.font
        ),
      ), //用户邮箱

      currentAccountPicture: new GestureDetector( //用户头像
        onTap: () => print('current user'),
        child: new CircleAvatar( //圆形图标控件
          backgroundImage: ExactAssetImage(GlobalConfig.backimg[4]),
        ),
      ),
      decoration: BoxDecoration(
        image: new DecorationImage(
          fit: BoxFit.cover,
          // image: new NetworkImage('https://raw.githubusercontent.com/flutter/website/master/_includes/code/layout/lakes/images/lake.jpg')
          //可以试试图片调取自本地。调用本地资源，需要到pubspec.yaml中配置文件路径
          image: ExactAssetImage(GlobalConfig.backimg[5]),
        ),
      ),
      margin: EdgeInsets.only(bottom: 0.0),
    );
  }


  // 方法调用
  void _selectFont() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return FontSelectDialog(refreshMain: widget.refreshMain,);
        });
  }

  void _aboutPage() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AboutDia();
        });
  }

  void _setBackimg() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return BackImg();
        });
  }

  void setMotto() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Motto(refreshMain: widget.refreshMain);
        });
  }


}





