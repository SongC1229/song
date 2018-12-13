package sning.song;

import android.os.Build;
import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

import android.speech.tts.TextToSpeech;
import android.speech.tts.TextToSpeech.OnInitListener;
import android.widget.Toast;

import java.util.Locale;

public class MainActivity extends FlutterActivity implements OnInitListener {

  private TextToSpeech tts;
  private static final String CHANNEL = "sning.ttspeak";
  private boolean support=false;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

//    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {//API>21,设置状态栏颜色透明
//      getWindow().setStatusBarColor(0);
//    }

    GeneratedPluginRegistrant.registerWith(this);

    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
            new MethodChannel.MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
//                通过methodCall可以获取参数和方法名  执行对应的平台业务逻辑即可
                switch (methodCall.method) {
                  case "speakpoem":
                    if (tts==null){
                      inittts();
                    }
                    if(support)
                      tts.speak(methodCall.arguments.toString(), TextToSpeech.QUEUE_FLUSH, null,null);
                    break;
                  case "stopspeak":if(support)
                    tts.stop();
                  break;
                  case "continuespeak":break;
                }
              }
            }
    );

  }


  public void inittts(){
    tts = new TextToSpeech(this, this);
  }

  @Override
  public void onInit(int status) {
    // 判断是否转化成功
    if (status == TextToSpeech.SUCCESS) {
      //默认设定语言为中文，原生的android貌似不支持中文。
      tts.setLanguage(Locale.CHINA);
      //设置音调0.3以下感觉是机器人语音
      tts.setPitch(1.0f);
      //设置语速
      tts.setSpeechRate(0.95f);
//      Toast.makeText(this,"支持语音",Toast.LENGTH_SHORT).show();
      support=true;
    }
    else {
      Toast.makeText(this,"不支持语音",Toast.LENGTH_SHORT).show();
    }
  }

  @Override
  protected void onDestroy() {
    if (tts != null)
      tts.shutdown();
    super.onDestroy();
  }

}