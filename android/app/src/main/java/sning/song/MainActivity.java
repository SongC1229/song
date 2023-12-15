package sning.song;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

import android.speech.tts.TextToSpeech;
import android.speech.tts.TextToSpeech.OnInitListener;
import android.widget.Toast;
import android.media.AudioManager;
import java.util.Locale;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import android.content.Context;
import android.os.Bundle;
//import android.media.AudioSystem;
public class MainActivity extends FlutterActivity implements OnInitListener {

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
                     case "speakpoem":
                       setSpeakerphoneOn(false);
                       if(support)
                         tts.speak(call.arguments.toString(), TextToSpeech.QUEUE_FLUSH, null,null);
                       else {
                         Toast.makeText(this,"无语音引擎",Toast.LENGTH_SHORT).show();
                       }
                       break;
                     case "stopspeak":
                       if(support)
                         tts.stop();
                       break;
                     case "continuespeak":break;
                   }
                 }
     );
  }

  private void setSpeakerphoneOn(boolean on) {
    try {
//播放音频流类型
      setVolumeControlStream(AudioManager.STREAM_VOICE_CALL);
//获得当前类
      Class audioSystemClass = Class.forName("android.media.AudioSystem");
//得到这个方法
      Method setForceUse = audioSystemClass.getMethod("setForceUse", int.class, int.class);
      AudioManager audioManager = (AudioManager) getApplicationContext().getSystemService(Context.AUDIO_SERVICE);
      if (on) {
        audioManager.setMicrophoneMute(false);
        audioManager.setSpeakerphoneOn(true);
        audioManager.setMode(AudioManager.MODE_NORMAL);
// setForceUse.invoke(null, 1, 1);
      } else {
        audioManager.setSpeakerphoneOn(false);
        audioManager.setMode(AudioManager.MODE_NORMAL);
        setForceUse.invoke(null, 0, 0);
        audioManager.setMode(AudioManager.MODE_IN_COMMUNICATION);
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
  }

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    //初始化语音。这是一个异步操作。初始化完成后调用oninitListener(第二个参数)。
    tts = new TextToSpeech(this, this);
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
    }
  }

  @Override
  protected void onDestroy() {
    if (tts != null)
      tts.shutdown();
    super.onDestroy();
  }

}