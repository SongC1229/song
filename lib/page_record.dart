import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart'; //录音权限
import 'package:audio_session/audio_session.dart'; //录音权限
import 'package:song/util_db.dart';
import 'util_ui.dart';

class RecordPage extends StatefulWidget{

  RecordPage();

  @override
  _RecordState createState() => new _RecordState();
}

class _RecordState extends State<RecordPage> {


  FlutterSoundPlayer player = FlutterSoundPlayer();
  late StreamSubscription _playerSubscription;

  bool _isRecording = false;
  bool _isPlaying = false;
  Timer? _timer;
  int _seconds = 0;
  FlutterSoundRecorder? _recorder;
  String? _filePath;
  String? _currentFile;
  String? tempFile;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    initPlayer();
    _requestPermissionsAndStartRecording();
  }


  initPlayer() async {
    Directory? appDocDir = await getApplicationDocumentsDirectory();
    _filePath = '${appDocDir.path}/recording_';
    tempFile = _filePath! + "temp" + ".aac";

    await player.closePlayer();
    await player.openPlayer();
    await player
        .setSubscriptionDuration(const Duration(milliseconds: 10));
//这块是设置音频，暂时没用到可以不用设置
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
      AVAudioSessionCategoryOptions.allowBluetooth |
      AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
      AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gainTransient,
      androidWillPauseWhenDucked: true,
    ));
  }


  ///开始播放，这里做了一个播放状态的回调
  void startPlayer() async {
    _currentFile = _filePath! + _currentIndex.toString() + '.aac';
    try {
      //判断文件是否存在
      if (await _fileExists(_currentFile!)) {
        print("play state: " + player.isPlaying.toString());
        if (player.isPlaying) {
          player.stopPlayer();
        }
        setState(() {
          _isPlaying = true;
        });
        await player.startPlayer(
            fromURI: _currentFile,
            codec: Codec.aacADTS,
            // sampleRate: 44000,
            whenFinished: () {
              stopPlayer();
              setState(() {
                _isPlaying = false;
                print("play finish");
              });
              // callBack(0);
            });
      } else {
        Fluttertoast.showToast(
          msg: "未录制",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
        _isPlaying = false;
      }
      //监听播放进度
      _playerSubscription = player.onProgress!.listen((e) {});
      // callBack(1);
    } catch (err) {
      print("play start err");
      print(err);
      // callBack(0);
    }
  }


  /// 结束播放
  void stopPlayer() async {
    try {
      await player.stopPlayer();
      cancelPlayerSubscriptions();
    } catch (err) {
      print("stop on call");
      print(err);
    }
    setState(() {
      _isPlaying = false;
    });
  }

  /// 取消播放监听
  void cancelPlayerSubscriptions() {
    if (_playerSubscription != null) {
      _playerSubscription!.cancel();
    }
  }

  ///获取播放状态
  Future<PlayerState> getPlayState() async {
    return await player.getPlayerState();
  }

  /// 释放播放器
  void releaseFlauto() async {
    try {
      await player.closePlayer();
    } catch (e) {
      print(e);
    }
  }

  /// 判断文件是否存在
  Future<bool> _fileExists(String path) async {
    return await File(path).exists();
  }

  void _requestPermissionsAndStartRecording() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      Permission.storage,
    ].request();

    if (statuses[Permission.microphone]!.isGranted &&
        statuses[Permission.storage]!.isGranted) {
      // _startRecording();
    } else {
      // 权限被拒绝
    }
  }

  void _startRecording() async {
    Fluttertoast.showToast(
      msg: "开始录音",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
    _recorder = await FlutterSoundRecorder().openRecorder();
    await _recorder!.startRecorder(toFile: tempFile);

    setState(() {
      _isRecording = true;
      _seconds = 0; // 重置计时器
    });

    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        _seconds++;
      });

    });
  }

  void _startStop() async {
    if (_isRecording) {
      _recorder?.stopRecorder();
      _recorder?.closeRecorder();
        bool? isSelect = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("提示",style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: GConfig.font
                    ),),
            //title 的内边距，默认 left: 24.0,top: 24.0, right 24.0
            //默认底部边距 如果 content 不为null 则底部内边距为0
            //            如果 content 为 null 则底部内边距为20
            titlePadding: EdgeInsets.all(10),
            //标题文本样式
            titleTextStyle: TextStyle(color: Colors.black87, fontSize: 16),
            //中间显示的内容
            content: Text("覆盖录音?"),
            //中间显示的内容边距
            //默认 EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0)
            contentPadding: EdgeInsets.all(10),
            //中间显示内容的文本样式
            contentTextStyle: TextStyle(color: Colors.black54, fontSize: 14),
            //底部按钮区域
            actions: <Widget>[
              TextButton(
                child: Text("确定",style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: GConfig.font
                    ),),
                onPressed: () {
                  // 关闭 返回 false
                  Navigator.of(context).pop(true);
                },
              ),
              TextButton(
                child: Text("取消",style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: GConfig.font
                    ),),
                onPressed: () {
                  //关闭 返回true
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          );
        },
      );
      if(isSelect!=null && isSelect==true){
        _saveRecording();
        Fluttertoast.showToast(
          msg: "保存至:" + _currentFile!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
        );
      }
      setState(() {
        _seconds = 0;
        _isRecording = false;
      });
      _timer?.cancel();
    }
    else {
      _startRecording();
    }
  }


  void _startStopPlay() async {
    if (_isPlaying) {
      stopPlayer();
    }
    else {
      startPlayer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // 取消计时器
    super.dispose();
  }

  Future<void> _saveRecording() async {
    // 获取外部存储目录路径
    // Directory? externalDir = await getExternalStorageDirectory();
    // String targetPath = '${externalDir!.path}/recording.aac';
    _currentFile = _filePath! + _currentIndex.toString() + '.aac';
    try {
      // 复制录音文件到外部存储目录
      File(tempFile!).copySync(_currentFile!);
    } catch (e) {
      print('保存录音文件失败: $e');
      return null;
    }
  }
  List<Widget> genRecordSelect(int sum) {
    List<Widget> selectList = [];
    for (var index = 0; index < sum; index++) {
      selectList.add(
          new Container(
              // width: 250,
              height: 50,
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  new Container(
                    width: 120,
                    height: 50,
                    margin: EdgeInsets.only(bottom: 10),
                    child:
                    new RadioListTile(
                        value: index,
                        groupValue: _currentIndex,
                        title: Text(
                          (index + 1).toString(),
                          style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: GConfig.font
                          ),
                        ),
                        onChanged: (T) {
                          setState(() {
                            if (T != null)
                              _currentIndex = T;
                          });
                        }),
                  ),
                  new Container(
                    width: 250,
                    height: 30,
                    margin: EdgeInsets.only(top: 20),
                    child:
                    TextField(
                      onChanged: (String str) { //输入监听
                        GConfig.recordTitle[index] = str;
                        updateconf();
                        setState(() {});
                      },
                      // decoration: new InputDecoration(
                      //   hintText: GConfig.recordTitle[index],
                      // ),
                      keyboardType: TextInputType.text,
                      //设置输入框文本类型
                      textAlign: TextAlign.left,
                      //设置内容显示位置是否居中等
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                          fontWeight: FontWeight.normal,
                          fontFamily: GConfig.font
                      ),
                      controller:TextEditingController.fromValue(
                                  TextEditingValue(
                                    text: GConfig.recordTitle[index],
                                    selection: TextSelection.fromPosition(
                                        TextPosition(
                                            affinity: TextAffinity.downstream,
                                            offset: GConfig.recordTitle[index].length)))
                        ),
                    ),
                  ),

                ],
              )
          )
      );
    }
    selectList..add(Padding(padding: EdgeInsets.only(bottom: 10)));
    return selectList;
  }


  List<Widget> genTTSList(int sum) {
    List<Widget> _ttsList = [];
    for (var index = 0; index < sum; index++) {
      _ttsList.add(
          new Container(
              height: 60,
              margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
                color: Colors.grey,
              ),
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  new Container(
                    height: 50,
                    margin: EdgeInsets.fromLTRB(5.0, 15.0, 5.0, 10.0),
                    child:Text("$index",
                        style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: GConfig.font
                    ),),
                  ),
                  new Container(
                    width: 250,
                    height: 50,
                    margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
                      color: Colors.white,
                    ),
                    child:
                    TextField(
                      onChanged: (String str) { //输入监听
                        GConfig.ttsTitle[index] = str;
                        updateconf();
                        setState(() {});
                      },
                      decoration: new InputDecoration(
                        // hintText: "恭喜发财",
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.text,
                      //设置输入框文本类型
                      textAlign: TextAlign.left,
                      //设置内容显示位置是否居中等
                      style: TextStyle(
                          fontSize: 18.0,
                          fontFamily: GConfig.font
                      ),
                      controller:TextEditingController.fromValue(
                                  TextEditingValue(
                                    text: GConfig.ttsTitle[index],
                                    selection: TextSelection.fromPosition(
                                        TextPosition(
                                            affinity: TextAffinity.downstream,
                                            offset: GConfig.ttsTitle[index].length)))
                      ),
                    ),
                  ),
                  new IconButton(
                    icon: Icon(Icons.record_voice_over_outlined,color: Colors.blue,),
                    onPressed: (){
                      speech(GConfig.ttsTitle[index]);
                    },
                    tooltip: '朗读',
                  ),
                  new IconButton(
                    icon: Icon(Icons.voice_over_off_outlined,color: Colors.blue),
                    onPressed: (){
                      stopSpeech();
                    },
                    tooltip: '停止',
                  ),

                ],
              )
          )
      );
    }
    return _ttsList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GConfig.appBackgroundColor,
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child:
              new Container(
                  margin: const EdgeInsets.only(left:10.0,right: 10.0,bottom: 10.0,top: 10.0),
                  // decoration: new BoxDecoration(
                  //   borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
                  //   color: Colors.lightBlue,
                  // ),
                  child: ListView(
                    children: genTTSList(10)
                  )
              ),
              flex: 4,
          ),
          Expanded(
            child:
              new Container(
                  margin: const EdgeInsets.only(left:10.0,right: 10.0,bottom: 10.0,top: 10.0),
                  decoration: new BoxDecoration(
                    borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
                    color: Colors.lightBlue,
                  ),
                  child: ListView(
                    children: genRecordSelect(10)
                  )
              ),
              flex: 4,
            ),
          Expanded(
            child:new Container(
              margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, .0),
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
                // color: Colors.lightBlue,
              ),
              child:Row(
                      children: [
                      Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  // color:Colors.white,
                                ),
                                child: 
                                  ElevatedButton(
                                    onPressed: _startStop,
                                    child: Text(_isRecording ? '停止' : '录音',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: GConfig.font),),
                                  ),
                              ),
                              flex: 3,
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: 10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  // color:Colors.white,
                                ),
                                child:Text('时长: $_seconds s',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          fontFamily: GConfig.font
                                      ),
                                    ),
                              ),
                              flex: 3,
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: 5.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(1.0)),
                                  // color:Colors.white,
                                ),
                                child:
                                    ElevatedButton(
                                      onPressed: _startStopPlay,
                                      child: Text(_isPlaying ? '停止' : '播放',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontFamily: GConfig.font),),
                                    ),
                              ),
                              flex: 3,
                            ),
                          ],
                    ),
                  ),
            flex: 1,
          ),
        ],
      ),
    );
  }
}