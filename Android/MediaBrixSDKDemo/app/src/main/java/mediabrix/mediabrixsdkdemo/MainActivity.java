package mediabrix.mediabrixsdkdemo;

import android.content.Context;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import com.mediabrix.android.api.IAdEventsListener;
import com.mediabrix.android.api.MediabrixAPI;

public class MainActivity extends AppCompatActivity implements IAdEventsListener{

    private TextView status;
    private Button load;
    private boolean isLoaded;
    private Context context;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        context = this;
        status = (TextView) findViewById(R.id.status);
        load = (Button) findViewById(R.id.load);
        String baseURL = "http://mobile.mediabrix.com/v2/manifest/";
        String appID = "JxxEkB3BpF";
        MediabrixAPI.setDebug(true);//This method is used enable/disables SDK logs. To turn off SDK logs setDebug to false. By default setDebug is set to true
        MediabrixAPI.getInstance().initialize(context, baseURL, appID, this);//'this' refers to class that is implementing IAdEventsListener interface

        load.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if(!isLoaded){
                    MediabrixAPI.getInstance().load(context, "Rally_Standard_Video");
                }else{
                    MediabrixAPI.getInstance().show(context, "Rally_Standard_Video");
                }
            }
        });
    }

    @Override
    public void onStarted(String s) {
        status.setText("Press Load");
        load.setEnabled(true);
    }

    @Override
    public void onAdReady(String s) {
        isLoaded = true;
        status.setText("Press Show");
        load.setText("Show");
    }

    @Override
    public void onAdUnavailable(String s) {
        isLoaded = false;
        status.setText("Ad Unavailable, Try Again!");
    }

    @Override
    public void onAdShown(String s) {

    }

    @Override
    public void onAdClicked(String s) {

    }

    @Override
    public void onAdRewardConfirmation(String s) {
        Toast.makeText(this, "Reward your user!", Toast.LENGTH_SHORT).show();
    }

    @Override
    public void onAdClosed(String s) {
        status.setText("Press Load");
        load.setText("Load");
    }

    @Override
    public void onResume() {
        MediabrixAPI.getInstance().onResume(this) ; // Registers the MediaBrix service.
                                                    // 'this' refers Activity's context
        super.onResume();
    }

    @Override
    protected void onPause() {
        MediabrixAPI.getInstance().onPause(this); // Unregisters the MediaBrix service.
                                                  // 'this' refers Activity's context
        super.onPause();
    }

    @Override
    public void onDestroy() {
        MediabrixAPI.getInstance().onDestroy(this); // Call onDestroy if this is the LAST or ONLY activity for loading/showing ads
                                                    // 'this' refers Activity's context

        super.onDestroy();
    }


}
