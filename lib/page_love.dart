import 'package:flutter/material.dart';
import 'util_db.dart';
import 'global_config.dart';
import 'dialog_remove.dart';
class LoveListpage extends StatefulWidget {
  LoveListpage({@required this.ptheme,this.refreshpoem});
  final ptheme;
  final refreshpoem;
  @override
  _LoveListpageState createState() => _LoveListpageState();
}

class _LoveListpageState extends State<LoveListpage> with SingleTickerProviderStateMixin {

  var data;
  int cate=0;
  @override
  void initState() {
    super.initState();
    cate=widget.ptheme;
    if(cate==3)
      cate=0;
    _searchLove();
  }

  void _searchLove() {
     dbDelectLove(cate+1).then((result,) {
      setState(() {
          data = result;
      });
    });
  }

  void _select(int choice) {
    setState(() {
      cate = choice;
      _searchLove();
    });
  }

  void showRemoveDialog(BuildContext context,int id,String poemtitle,String author) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Remove(refreshfather: _searchLove,id: id,poemtitle: poemtitle,author: author,cate: cate,dbremove: false,);
        });
  }
  @override
  Widget build(BuildContext context) {
    return
      PopScope(
            canPop: true,
            onPopInvoked: (bool ) {
              GlobalConfig.backfromlove=true;
              widget.refreshpoem();
              Navigator.of(context).pop(true);
            },
          child:Scaffold(
              backgroundColor:GlobalConfig.appBackgroundColor,
              appBar:PreferredSize(
                preferredSize: Size.fromHeight(45.0),
                  child:
                    AppBar(
                      leading: IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: (){
                            GlobalConfig.backfromlove=true;
                            widget.refreshpoem();
                            Navigator.pop(context); //关闭对话框
                            }
                          ),
                      title: Text('收藏',style: new TextStyle(fontFamily: GlobalConfig.font,)),
                      centerTitle: true,
                      actions: <Widget>[
                        // overflow menu
                        PopupMenuButton<int>(
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.arrow_drop_down),
                              Text(GlobalConfig.poemcate[cate],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.normal,
                                    letterSpacing: 5.0,
                                    fontFamily: GlobalConfig.font
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(right: 20),)
                            ],
                          ),
                          onSelected: _select,
                          itemBuilder: (BuildContext context) {
                            return [0,1,2].map((int choice) {
                              return PopupMenuItem<int>(
                                value: choice,
                                child: Text(GlobalConfig.poemcate[choice],
                                    style:TextStyle(
                                    color: Colors.lightBlue,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.normal,
                                    letterSpacing: 5.0,
                                    fontFamily: GlobalConfig.font
                                  ),
                                ),
                              );
                            }).toList();
                          },
                        ),
                      ],
                  )
            ),
                body:Container(
                    margin: EdgeInsets.only(left: 15.0,right: 15.0),
                    child:ListView(
                      children: genList(),
                    ),
                  )  ,
              )
      );
  }

  List<Widget> genList() {
    if(data==null){
      return <Widget> [Container()];
    }
    if(data.length==0){
      return <Widget> [Container(
      )];
    }
    return data.map<Widget>((eachdata) {
      return _buildresult(eachdata);
    }).toList();
  }

  Widget _buildresult(Map eachdata) {
    return Container(
      margin: EdgeInsets.only(top:8.0,bottom: 5.0),
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.purple),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        image: DecorationImage(
            image:ExactAssetImage(GlobalConfig.backimg[0]),
            fit: BoxFit.cover
        ),
      ),
      child: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(left:5.0,bottom:3.0,top: 5.0),
            child:Text(
              eachdata["title"]+"·"+eachdata["author"],
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  fontFamily: GlobalConfig.font
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(left:5.0,top: 3.0),
            child:Text(
              eachdata["content"],
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.normal,
                  letterSpacing: 2.0,
                  fontFamily: GlobalConfig.font
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new IconButton(
                icon: Icon(Icons.volume_up),
                onPressed: (){
                  speech(eachdata);
                },
                tooltip: '朗读',
              ),
              new IconButton(
                icon: Icon(Icons.stop),
                onPressed: (){
                  stopspeech();
                },
                tooltip: '朗读',
              ),
              new IconButton(
                icon: Icon(Icons.delete_outline),
                onPressed: (){
                  showRemoveDialog(context,eachdata["id"],eachdata["title"],eachdata["author"]);
                },
                tooltip: '删除',
              ),
//            ),
          ],),

        ],
      ),
    );
  }
}