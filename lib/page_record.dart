import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
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
  StreamSubscription? _playerSubscription;

  bool _isRecording = false;
  bool _isPlaying = false;
  Timer? _timer;
  int _seconds = 0;
  FlutterSoundRecorder? _recorder;
  late String tempFile;
  int _curPlayId=0;
  int _curRecordId=0;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }


  _initPlayer() async {
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
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));
  }


  ///开始播放，这里做了一个播放状态的回调
  void startPlayer(int index) async {
    String _currentFile =  '${GConfig.appDir}/record_${index.toString()}.aac';
    try {
      //判断文件是否存在
      if (await _fileExists(_currentFile)) {
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
        printInfo("未录制");
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
      _playerSubscription?.cancel();
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

  void _requestPermissionsAndStartRecord() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      Permission.storage,
    ].request();

    if (statuses[Permission.microphone]!.isGranted &&
        statuses[Permission.storage]!.isGranted) {
      tempFile = '${GConfig.appDir}/record_temp.aac';
      _startRecording();
    } else {
      printInfo("无权限");
    }
  }

  void _startRecording() async {
    try{
    _recorder = await FlutterSoundRecorder().openRecorder();
    printInfo("temp: "+tempFile);
    await _recorder!.startRecorder(toFile: tempFile);
    printInfo("started ");
    } catch (err) {
      printInfo(err.toString());
    }
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

  void _startStopRecord(int index) async {
    if (_isRecording) {
      _recorder?.stopRecorder();
      _recorder?.closeRecorder();
      _timer?.cancel();
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
        _saveRecording(index);
      }
      setState(() {
        _seconds = 0;
        _isRecording = false;
      });
    }
    else {
      _requestPermissionsAndStartRecord();
    }
  }


  void _startStopPlay(int index) async {
    if (_isPlaying) {
      stopPlayer();
    }
    else {
      startPlayer(index);
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // 取消计时器
    super.dispose();
  }

  Future<void> _saveRecording(int index) async {
    // 获取外部存储目录路径
    // Directory? externalDir = await getExternalStorageDirectory();
    // String targetPath = '${externalDir!.path}/recording.aac';
    String _currentFile = '${GConfig.appDir}/record_${index.toString()}.aac';
    try {
      // 复制录音文件到外部存储目录
      File(tempFile!).copySync(_currentFile);
      printInfo("保存至:" + _currentFile);
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
              height: 60,
              margin: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
                color: Colors.white54,
              ),
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  new Container(
                    height: 50,
                    margin: EdgeInsets.fromLTRB(5.0, 15.0, 5.0, 10.0),
                    child:Text("${index+1}",
                        style: TextStyle(
                        fontSize: 20.0,
                        fontFamily: GConfig.font
                    ),),
                  ),
                  new Container(
                    width: 200,
                    height: 50,
                    margin: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 5.0),
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
                      color: Colors.white,
                    ),
                    child:
                    TextField(
                      onChanged: (String str) { //输入监听
                        GConfig.recordTitle[index] = str;
                        updateconf();
                        setState(() {});
                      },
                      decoration: new InputDecoration(
                        hintText: "输入录音名",
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
                    ),
                  ),
                new Container(
                  width: 60,
                    child:
                    ElevatedButton(
                      onPressed:() {
                          _startStopRecord(index);
                          _curRecordId = index;
                        },

                      child: Text(_isRecording&&(_curRecordId==index) ? '停止' : '录音',
                        style: TextStyle(
                            fontSize: 10,
                            fontFamily: GConfig.font),),
                    ),
                ),
                new Container(
                  width: 60,
                  child:
                    ElevatedButton(
                      onPressed:(){
                          _startStopPlay(index);
                          _curPlayId = index;
                        },
                      child: Text(_isPlaying&&(_curPlayId==index) ? '停止' : '播放',
                        style: TextStyle(
                            fontSize: 10,
                            fontFamily: GConfig.font),),
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
                color: Colors.white54,
              ),
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child:Padding(padding: EdgeInsets.only(left: 10)),
                      flex:1,
                  ),
                  Expanded(
                      child: 
                      new Container(
                        height: 50,
                        margin: EdgeInsets.fromLTRB(5.0, 15.0, 5.0, 10.0),
                        child:Text("${index+1}",
                            style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: GConfig.font
                        ),),
                      ),
                      flex:2
                  ),
                  Expanded(
                      child: 
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
                      flex:10,
                  ),
                Expanded(
                  child: 
                  new IconButton(
                    icon: Icon(Icons.record_voice_over_outlined,color: Colors.blue,),
                    onPressed: (){
                      speech(GConfig.ttsTitle[index]);
                    },
                    tooltip: '朗读',
                  ),
                  flex:2,
                ),
                Expanded(
                  child: IconButton(
                    icon: Icon(Icons.voice_over_off_outlined,color: Colors.blue),
                    onPressed: (){
                      stopSpeech();
                    },
                    tooltip: '停止',
                  ),
                  flex:2
                ),
                Expanded(
                      child:Padding(padding: EdgeInsets.only(left: 10)),
                      flex:1,
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
                  child: ListView(
                    children: genTTSList(10)
                  )
              ),
              flex: 8,
          ),
          Expanded(
            child:
              new Container(
                  margin: const EdgeInsets.only(left:10.0,right: 10.0,bottom: 10.0,top: 10.0),
                  child: ListView(
                    children: genRecordSelect(10)
                  )
              ),
              flex: 7,
            ),
          Expanded(
            child:
            Container(
              alignment: Alignment.center,
              child: gText(""
                  "录音时长 $_seconds s"),
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }
}