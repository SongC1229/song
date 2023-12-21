package sning.song;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

import android.speech.tts.TextToSpeech;
import android.speech.tts.TextToSpeech.OnInitListener;
import android.speech.tts.UtteranceProgressListener;

import android.widget.Toast;
import android.media.AudioManager;
import java.util.Locale;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import android.content.Context;
import android.os.Bundle;
public class MainActivity extends FlutterActivity implements OnInitListener {

  private AudioManager mAM;
  private TextToSpeech tts;
  private static final String CHANNEL = "sning.ttspeak";
  private boolean support=false;
//   if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {//API>21,设置状态栏颜色透明
//      getWindow().setStatusBarColor(0);
//    }
  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
     GeneratedPluginRegistrant.registerWith(flutterEngine);

     new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
             .setMethodCallHandler(
                 (call, result) -> {
//                通过methodCall可以获取参数和方法名  执行对应的平台业务逻辑即可
                   switch (call.method) {
                     case "speakPoem":
                       if(support)
                         tts.speak(call.arguments.toString(), TextToSpeech.QUEUE_FLUSH, null,null);
                       else {
                         Toast.makeText(this,"无语音引擎",Toast.LENGTH_SHORT).show();
                       }
                       break;
                     case "stopSpeak":
                       if(support)
                         tts.stop();
                       break;
                     case "continuespeak":break;
                     case "updateChannel":
                       setChannel(Integer.parseInt(call.arguments.toString()));
                       System.out.println(String.format("An切换音道: %s", call.arguments.toString()));
                       break;
                   }
                 }
     );
  }

  private void setChannel(int channel) {
    Toast.makeText(this, String.format("切换音道:%d", channel), Toast.LENGTH_SHORT).show();
    try {
      //播放音频流类型
      setVolumeControlStream(AudioManager.STREAM_MUSIC);
      //播放音频流类型
      Class audioSystemClass = Class.forName("android.media.AudioSystem");
      Method setForceUse = audioSystemClass.getMethod("setForceUse", int.class, int.class);
      AudioManager audioManager = (AudioManager) getApplicationContext().getSystemService(Context.AUDIO_SERVICE);
//      audioManager.setMicrophoneMute(false);
//      audioManager.setSpeakerphoneOn(true);
      audioManager.setMode(AudioManager.MODE_NORMAL);
      // setForceUse.invoke(null, 1, 1);
      setForceUse.invoke(null, 1, 1);

    } catch (Exception e) {
      e.printStackTrace();
    }
  }

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    //初始化语音。这是一个异步操作。初始化完成后调用oninitListener(第二个参数)。
    tts = new TextToSpeech(this, this);
    this.mAM = (AudioManager) getApplicationContext().getSystemService(Context.AUDIO_SERVICE);
  }
  @Override
  public void onInit(int status) {
    // 判断是否转化成功
    if (status == TextToSpeech.SUCCESS) {
      //默认设定语言为中文，原生的android貌似不支持中文。
      tts.setLanguage(Locale.CHINA);
      //设置音调0.3以下感觉是机器人语音
      tts.setPitch(0.9f);
      //设置语速
      tts.setSpeechRate(0.95f);
      support=true;
//      Toast.makeText(this,"支持语音",Toast.LENGTH_SHORT).show();
      tts.setOnUtteranceProgressListener(new UtteranceProgressListener() { // from class: com.rcx.easytouch.SpeakUtil.1.1
                                  @Override // android.speech.tts.UtteranceProgressListener
                                  public void onError(String str) {
                                  }

                                  @Override // android.speech.tts.UtteranceProgressListener
                                  public void onStart(String str) {
                                    requestFocus();
                                  }

                                  @Override // android.speech.tts.UtteranceProgressListener
                                  public void onDone(String str) {
                                    abandonFocus();
                                  }
                              });
    }
  }

  @Override
  protected void onDestroy() {
    if (tts != null){
      abandonFocus();
      this.tts.stop();
      this.tts.shutdown();
    }
    super.onDestroy();
  }
  private boolean requestFocus() {
      return 1 == this.mAM.requestAudioFocus(null, 13, 2);
  }

  private boolean abandonFocus() {
      return 1 == this.mAM.abandonAudioFocus(null);
  }
}