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
import android.media.AudioAttributes;
import android.media.AudioFocusRequest;
import android.media.AudioManager;
import java.util.Locale;
import android.content.Context;
import android.os.Bundle;
public class MainActivity extends FlutterActivity implements OnInitListener {

  private AudioManager aM;
  private AudioFocusRequest mreq;
  private TextToSpeech tts;
  private static final String CHANNEL = "sning.ttspeak";
  private boolean support=false;
  private Bundle params = new Bundle();
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
                       if(support){
                         tts.speak(call.arguments.toString(), TextToSpeech.QUEUE_FLUSH,params, params.getString("utteranceId"));
                       }
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
                       break;
                   }
                 }
     );
  }

  @Override
  public void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    //初始化语音。这是一个异步操作。初始化完成后调用oninitListener(第二个参数)。
    tts = new TextToSpeech(this, this);
    aM = (AudioManager) getApplicationContext().getSystemService(Context.AUDIO_SERVICE);
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
                                    reqFocus(13, 2);
                                  }

                                  @Override // android.speech.tts.UtteranceProgressListener
                                  public void onDone(String str) {
                                    abandonFocus();
                                  }
                              });
      params.putString("utteranceId", "utterance");
      params.putInt("streamType", 13);
    }
  }

  @Override
  protected void onDestroy() {
    if (tts != null){
      abandonFocus();
      tts.stop();
      tts.shutdown();
    }
    super.onDestroy();
  }
  public void reqFocus(int streamType, int durationHint) {
    AudioAttributes mAbs = new AudioAttributes.Builder()
            .setLegacyStreamType(streamType).build();
    mreq = new AudioFocusRequest.Builder(aM.AUDIOFOCUS_GAIN_TRANSIENT)
            .setAudioAttributes(mAbs)
            .setOnAudioFocusChangeListener(null)
            .build();
    aM.requestAudioFocus(mreq);
  }
  public void abandonFocus() {
    aM.abandonAudioFocus(null);
  }

  public void setChannel(int channel){
    Toast.makeText(this,String.format("切换声道 %d",channel),Toast.LENGTH_SHORT).show();
    switch(channel){
      case 0:
        abandonFocus();
        break;
      case 13:
        reqFocus(13, 2);
    }
  }
}