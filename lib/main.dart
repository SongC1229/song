import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:song/page_record.dart';
import 'page_search.dart';
import 'util_ui.dart';
import 'util_db.dart';
import 'page_card.dart';
import 'mydrawer.dart';
import 'page_love.dart';
void main() => runApp(Home());

class Home extends StatefulWidget {
  @override
  State<Home> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home>{
  int _currentIndex = 0;
  var _body;
  var _tabbar;
  var _drawer;


  void initData(){
    Map songdata={"id":6,"title":"\n桃夭","author":"国风・周南","content":"桃之夭夭，灼灼其华。\n之子于归，宜其室家。\n桃之夭夭，有蕡其实。\n之子于归，宜其家室。\n桃之夭夭，其叶蓁蓁。\n之子于归，宜其家人。\n\n","love":0};
    Map tpoemdata={"id":3058,"title":"\n望月怀远","author":"张九龄","content":'海上生明月，天涯共此时。\n情人怨遥夜，竟夕起相思\n灭烛怜光满，披衣觉露滋\n不堪盈手赠，还寝梦佳期。\n\n',"love":0};
    Map spoemdata={"id":9775,"title":"\n钗头凤","author":"唐婉","content":'世情薄,人情恶,雨送黄昏花易落。\n晓风乾,泪痕残。\n欲笺心事，独语斜阑。\n难、难、难！\n人成各,今非昨,病魂尝似秋千索。\n角声寒,夜阑珊。\n怕人寻问，咽泪装欢。\n瞒、瞒、瞒！\n\n',"love":0};
      _body =  IndexedStack(
          children: <Widget>[
              CardPage(ptheme: 1,initdata: tpoemdata,color: Colors.black,),
              CardPage(ptheme: 2,initdata: spoemdata,color: Colors.white,),
              CardPage(ptheme: 3,initdata: songdata,color: Colors.black,),
              SearchPage(),
              RecordPage(),
          ],
          index: _currentIndex,
        );

      _tabbar=CupertinoTabBar(
        height: 60,
        backgroundColor: GConfig.dark == true ?Colors.white70:Colors.white,
        items: <BottomNavigationBarItem>[
          new BottomNavigationBarItem(
             icon: Icon(Icons.dashboard,size: 23.0),
             label: GConfig.poemcate[0],
             // title: Text(GlobalConfig.poemcate[0],style: TextStyle(fontFamily:GlobalConfig.font,fontSize: 14.0),),
           ),
          new BottomNavigationBarItem(
            icon:  Icon(Icons.healing,size: 23.0),
            label: GConfig.poemcate[1],
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.filter_vintage,size: 23.0),
            label: GConfig.poemcate[2],
          ),
          new BottomNavigationBarItem(
           icon: Icon(Icons.search,size: 23.0),
            label: GConfig.poemcate[3],
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.mic_none_rounded,size: 23.0),
            label: GConfig.poemcate[4],
            // title: Text(GlobalConfig.poemcate[0],style: TextStyle(fontFamily:GlobalConfig.font,fontSize: 14.0),),
          ),
        ],

        currentIndex: _currentIndex,
        onTap: (index) {
          this.setState(() {
            _currentIndex = index;
          });
        },
      );
      _drawer=MyDrawer(refreshMain: refreshConf);
  }

  void refreshConf(){
    setState(() {
      updateconf();
    });
  }


  refreshApp(){
    setState(() {
    });
  }

  @override
  void initState() {
    super.initState();
    initconf(refreshApp);
    initPoem();
  }

  @override
  Widget build(BuildContext context) {
    initData();
    return  MaterialApp(
      theme: GConfig.themeData,
      home: Scaffold(
        appBar:
        PreferredSize(
          preferredSize: Size.fromHeight(45.0),
            child:
            AppBar(
              centerTitle:true,
              title: Text(GConfig.poemcate[_currentIndex],style: new TextStyle(fontFamily: GConfig.font,)),
              actions: <Widget>[
              // action button
              TopIcon(cate:_currentIndex,refreshpoem: refreshApp,)
              ]
            )
        ),
        drawer: _drawer,
        body: _body,
        bottomNavigationBar: _tabbar,
        backgroundColor: GConfig.appBackgroundColor,
      ),
    );

  }
}

class TopIcon extends StatelessWidget {
  TopIcon({@required this.cate,this.refreshpoem});
  final cate;
  final refreshpoem;
  @override
  Widget build(BuildContext context) {
    return  IconButton(
        icon: Icon(Icons.assignment,size: 23,color: Colors.grey,),
        onPressed: () {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return LoveListpage(ptheme: cate,refreshpoem:refreshpoem);
              });
        },
      );
  }
}
