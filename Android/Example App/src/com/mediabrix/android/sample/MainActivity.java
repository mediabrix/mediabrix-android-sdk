package com.mediabrix.android.sample;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import com.mediabrix.android.api.IAdEventsListener;
import com.mediabrix.android.api.MediabrixAPI;

import java.util.HashMap;

public class MainActivity extends Activity implements IAdEventsListener {

	// These 5 string values will be provided by MediaBrix
	public final static String BASE_URL = "http://staging-mobile-manifest.mediabrix.com/v2/manifest/";
	public final static String APP_ID = "k4L77F6VrC";
	public final static String AD_TARGET_FLEX = "QA_Android_Flex";
	public final static String AD_TARGET_VIEWS = "QA_Android_Views";
	public final static String AD_TARGET_REWARD = "QA_Android_Rewards";

	private TextView labelFlexStatus;
	private TextView labelViewsStatus;
	private TextView labelRewardsStatus;
	private TextView labelMBStatus;

	private Button buttonFlexStart;
	private Button buttonViewsStart;
	private Button buttonRewardStart;

	private Button buttonFlexLoad;
	private Button buttonViewsLoad;
	private Button buttonRewardLoad;

	private EditText txtFlexTitle;
	private EditText txtFlexLoading;
	private EditText txtViewsEntice;
	private EditText txtViewsRescueTitle;
	private EditText txtViewsRescueText;
	private EditText txtViewsRewardText;
	private EditText txtViewsRewardItem;
	private EditText txtViewsOptInText;
	private EditText txtRewardsReward;
	private EditText txtRewardsRewardItem;
	private EditText txtRewardsAchieve;

	private Long flexTime;
	private Long viewsTime;
	private Long rewardsTime;
	private Long manifestTime;
	
	private boolean viewsRewarded;
	private boolean rewardsRewarded;
	

	private HashMap<String, String> createFlexMbrixVars() {
		HashMap<String, String> vars = new HashMap<String, String>();
		if (txtFlexTitle.getText().length() > 0)
			vars.put("title", txtFlexTitle.getText() + "");
		if (txtFlexLoading.getText().length() > 0)
			vars.put("loadingText", txtFlexLoading.getText() + "");
		return vars;
	}

	private HashMap<String, String> createViewsMbrixVars() {
		HashMap<String, String> MbrixVars = new HashMap<String, String>();

		if (txtViewsOptInText.getText().length() > 0)
			MbrixVars.put("optinbuttonText", txtViewsOptInText.getText() + "");
		if (txtViewsEntice.getText().length() > 0)
			MbrixVars.put("enticeText", txtViewsEntice.getText() + "");
		if (txtViewsRescueTitle.getText().length() > 0)
			MbrixVars.put("rescueTitle", txtViewsRescueTitle.getText() + "");
		if (txtViewsRescueText.getText().length() > 0)
			MbrixVars.put("rescueText", txtViewsRescueText.getText() + "");
		if (txtViewsRewardText.getText().length() > 0)
			MbrixVars.put("rewardText", txtViewsRewardText.getText() + "");
		if (txtViewsRewardItem.getText().length() > 0)
			MbrixVars.put("rewardIcon", txtViewsRewardItem.getText() + "");
		return MbrixVars;
	}

	private HashMap<String, String> createRewardsMbrixVars() {
		HashMap<String, String> vars = new HashMap<String, String>();
		if (txtRewardsReward.getText().length() > 0)
			vars.put("rewardText", txtRewardsReward.getText() + "");
		if (txtRewardsRewardItem.getText().length() > 0)
			vars.put("rewardIcon", txtRewardsRewardItem.getText() + "");
		if (txtRewardsAchieve.getText().length() > 0)
			vars.put("achievementText", txtRewardsAchieve.getText() + "");
		return vars;
	}

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		Log.d("MainActivity", "onCreate");
		setContentView(R.layout.activity_main);

		labelFlexStatus = (TextView) findViewById(R.id.labelFlexStatus);
		labelViewsStatus = (TextView) findViewById(R.id.labelViewsStatus);
		labelRewardsStatus = (TextView) findViewById(R.id.labelRewardsStatus);
		labelMBStatus = (TextView) findViewById(R.id.labelMBStatus);

		txtFlexTitle = (EditText) findViewById(R.id.txtTitle);
		txtFlexLoading = (EditText) findViewById(R.id.txtLoadingText);
		txtRewardsReward = (EditText) findViewById(R.id.txtReward);
		txtRewardsRewardItem = (EditText) findViewById(R.id.txtRewardItem);
		txtRewardsAchieve = (EditText) findViewById(R.id.txtAchieve);
		txtViewsEntice = (EditText) findViewById(R.id.txtEntice);
		txtViewsRescueTitle = (EditText) findViewById(R.id.txtRescueTitle);
		txtViewsRescueText = (EditText) findViewById(R.id.txtRescueText);
		txtViewsRewardText = (EditText) findViewById(R.id.txtRewardText);
		txtViewsRewardItem = (EditText) findViewById(R.id.txtRewardImage);
		txtViewsOptInText = (EditText) findViewById(R.id.txtOptIn);

		buttonFlexLoad = (Button) findViewById(R.id.buttonFlexLoad);
		buttonViewsLoad = (Button) findViewById(R.id.buttonViewsLoad);
		buttonRewardLoad = (Button) findViewById(R.id.buttonRewardLoad);

		buttonFlexStart = (Button) findViewById(R.id.buttonFlexStart);
		buttonViewsStart = (Button) findViewById(R.id.buttonViewsStart);
		buttonRewardStart = (Button) findViewById(R.id.buttonRewardStart);

		MediabrixAPI.getInstance().initialize(MainActivity.this, BASE_URL, APP_ID, this);
		manifestTime = System.currentTimeMillis();
		labelMBStatus.setText("Device Init...");

		// Hide keyboard on load
		getWindow().setSoftInputMode(
				WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_HIDDEN);

		buttonFlexStart.setEnabled(false);
		buttonViewsStart.setEnabled(false);
		buttonRewardStart.setEnabled(false);

		buttonFlexLoad.setEnabled(false);
		buttonViewsLoad.setEnabled(false);
		buttonRewardLoad.setEnabled(false);

		buttonFlexLoad.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				HashMap<String, String> vars = createFlexMbrixVars();
				MediabrixAPI.getInstance().load(MainActivity.this, AD_TARGET_FLEX, vars);
				labelFlexStatus.setText("Flex: Loading...");
				flexTime = System.currentTimeMillis();
				buttonFlexStart.setEnabled(false);
			}
		});

		buttonViewsLoad.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				HashMap<String, String> vars = createViewsMbrixVars();
				MediabrixAPI.getInstance().load(MainActivity.this, AD_TARGET_VIEWS, vars);
				labelViewsStatus.setText("Views: Loading...");
				viewsTime = System.currentTimeMillis();
				buttonViewsStart.setEnabled(false);
			}
		});

		buttonRewardLoad.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				HashMap<String, String> vars = createRewardsMbrixVars();
				MediabrixAPI.getInstance().load(MainActivity.this, AD_TARGET_REWARD, vars);
				labelRewardsStatus.setText("Rewards: Loading...");
				rewardsTime = System.currentTimeMillis();
				buttonRewardStart.setEnabled(false);
			}
		});

		buttonFlexStart.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				MediabrixAPI.getInstance().show(MainActivity.this, AD_TARGET_FLEX);
				labelFlexStatus.setText("Flex: Ad Showing");
			}

		});

		buttonViewsStart.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				viewsRewarded = false;
				MediabrixAPI.getInstance().show(MainActivity.this, AD_TARGET_VIEWS);
				labelViewsStatus.setText("Views: Ad Showing");
			}
		});

		buttonRewardStart.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				rewardsRewarded = false;
				MediabrixAPI.getInstance().show(MainActivity.this, AD_TARGET_REWARD);
				labelRewardsStatus.setText("Rewards: Ad Showing");
			}

		});

	}
	
	//Activity Life Cycle Events

	@Override
	protected void onPause() {
		Log.d("MainActivity", "onPause()");
		MediabrixAPI.getInstance().onPause(this);
		super.onPause();
	}

	@Override
	protected void onResume() {
		Log.d("MainActivity", "onResume()");
		MediabrixAPI.getInstance().onResume(this);
		super.onResume();
	}

	@Override
	public void onDestroy() {
		Log.d("MainActivity", "onDestroy()");
		MediabrixAPI.getInstance().onDestroy(this);
		super.onDestroy();
	}
	
	//MediaBrix IAdEventsListener Callbacks

	@Override
	public void onStarted(String status) {
		Log.d("MainActivity", "onServiceStarted()");
		labelMBStatus.setText("Service Started (" + (System.currentTimeMillis() - manifestTime) / 1000f + " seconds)");
		manifestTime = null;
		buttonFlexLoad.setEnabled(true);
		buttonViewsLoad.setEnabled(true);
		buttonRewardLoad.setEnabled(true);
	}

	@Override
	public void onAdReady(String target) {
		Log.d("MainActivity", "onAdReady(" + target + ")");
		if (AD_TARGET_FLEX.equals(target)) {
			labelFlexStatus.setText("Flex: Ready To Show (" + (System.currentTimeMillis() - flexTime) / 1000f + " seconds)");
			flexTime = null;
			buttonFlexStart.setEnabled(true);
		} else if (AD_TARGET_VIEWS.equals(target)) {
			labelViewsStatus.setText("Views: Ready To Show (" + (System.currentTimeMillis() - viewsTime) / 1000f + " seconds)");
			viewsTime = null;
			buttonViewsStart.setEnabled(true);
		} else if (AD_TARGET_REWARD.equals(target)) {
			labelRewardsStatus.setText("Rewards: Ready To Show ("	+ (System.currentTimeMillis() - rewardsTime) / 1000f + " seconds)");
			rewardsTime = null;
			buttonRewardStart.setEnabled(true);
		}
	}

	@Override
	public void onAdRewardConfirmation(String target) {
		Log.d("MainActivity", "onAdRewardConfirmation(" + target + ")");
		if (AD_TARGET_VIEWS.equals(target)) {
			viewsRewarded = true;
		} else if (AD_TARGET_REWARD.equals(target)) {
			rewardsRewarded = true;
		}
	}

	@Override
	public void onAdClosed(String target) {
		Log.d("MainActivity", "onAdClosed(" + target + ")");
		if (AD_TARGET_FLEX.equals(target)) {
			labelFlexStatus.setText("Flex: Closed");
			buttonFlexStart.setEnabled(false);
		} else if (AD_TARGET_VIEWS.equals(target)) {
			if (viewsRewarded == true)
				labelViewsStatus.setText("Views: Closed & Rewarded");
			else
				labelViewsStatus.setText("Views: Closed");
			buttonViewsStart.setEnabled(false);
		} else if (AD_TARGET_REWARD.equals(target)) {
			if (rewardsRewarded == true)
				labelRewardsStatus.setText("Rewards: Closed & Rewarded");
			else
				labelRewardsStatus.setText("Rewards: Closed");
			buttonRewardStart.setEnabled(false);
		}
	}

	@Override
	public void onAdUnavailable(String target) {
		Log.d("MainActivity", "onAdUnavailable(" + target + ")");
		if (AD_TARGET_FLEX.equals(target)) {
			labelFlexStatus.setText("Flex: Failed To Load");
			buttonFlexStart.setEnabled(false);
		} else if (AD_TARGET_VIEWS.equals(target)) {
			labelViewsStatus.setText("Views: Failed To Load");
			buttonViewsStart.setEnabled(false);
		} else if (AD_TARGET_REWARD.equals(target)) {
			labelRewardsStatus.setText("Rewards: Failed To Load");
			buttonRewardStart.setEnabled(false);
		}
	}

}