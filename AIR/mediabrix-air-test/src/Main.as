package
{
	import com.mediabrix.air.IAdEventsListener;
	import com.mediabrix.air.MediabrixAirAPI;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageOrientation;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	
	public class Main extends Sprite implements IAdEventsListener
	{
		/** Status */
		private var txtStatus:TextField;
		
		/** Buttons */
		private var buttonContainer:Sprite;
		
		/** MediaBrix Values */
		private var mbAPI:MediabrixAirAPI = MediabrixAirAPI.instance;
		private var mbVars:Object = new Object();
		
<<<<<<< .mine
/*
		private var baseURL : String = "http://mobile15.mediabrix.com/manifest/";
=======
		private var baseURL : String = "http://mobile.mediabrix.com/v2/manifest/";
>>>>>>> .r283
		private var appID : String = "tAefPGlpJKPVtQGoEBpp";

		private var adZoneFlex : String = "Android_Flex";
		private var isReadyFlex : Boolean = false;
		
		private var adZoneViews : String = "Android_Views";
		private var isReadyViews : Boolean = false;
		private var rewardViews : Boolean = false;
		private var rewardViewsCount : int = 0;
		
		private var adZoneRewards : String = "Android_Rewards";
		private var isReadyRewards : Boolean = false;
		private var rewardRewards : Boolean = false;
		private var rewardRewardsCount : int = 0;
*/

	 	private var baseURL : String = "http://staging-mobile-manifest.mediabrix.com/v2/manifest/";
		private var appID : String = "k4L77F6VrC";

		private var adZoneFlex : String = "QA_iOS_Flex";
		private var isReadyFlex : Boolean = false;
		
		private var adZoneViews : String = "QA_iOS_Views";
		private var isReadyViews : Boolean = false;
		private var rewardViews : Boolean = false;
		private var rewardViewsCount : int = 0;
		
		private var adZoneRewards : String = "QA_iOS_Rewards";
		private var isReadyRewards : Boolean = false;
		private var rewardRewards : Boolean = false;
		private var rewardRewardsCount : int = 0;
		
/*
		private var baseURL : String = "http://staging-mobile-manifest.mediabrix.com/v2/manifest/";
		private var appID : String = "vhAQpDKlB4";

		private var adZoneFlex : String = "flex";
		private var isReadyFlex : Boolean = false;
		
		private var adZoneViews : String = "views";
		private var isReadyViews : Boolean = false;
		private var rewardViews : Boolean = false;
		private var rewardViewsCount : int = 0;
		
		private var adZoneRewards : String = "rewards";
		private var isReadyRewards : Boolean = false;
		private var rewardRewards : Boolean = false;
		private var rewardRewardsCount : int = 0;

*/
		private var landscape : Boolean = false;
		private var varsSet : Boolean = false;
		
		
		public function Main()
		{
			super();
			
			stage.align = StageAlign.TOP;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.setOrientation( StageOrientation.DEFAULT );
			
			createUI();
			
			/** Event Listeners for Lifecycle - Android Only*/
			addEventListener(Event.ACTIVATE,onActivate);
			addEventListener(Event.DEACTIVATE,onDeactivate);
			addEventListener(Event.EXITING, onExiting);
			
			
			mbAPI.initialize(baseURL,appID,this);
			
		}
		//Mediabrix Callbacks
		public function onStarted(status:String):void{
			log("onStarted");
		}
		public function onAdReady(zone:String):void{
			log(zone + ":onAdReady");
			if(zone == adZoneFlex)
				isReadyFlex = true;
			else if(zone == adZoneViews)
				isReadyViews = true;
			else if(zone == adZoneRewards)
				isReadyRewards = true;
		}
		
		public function onAdRewardConfirmation(zone:String):void{
			log(zone + ":onAdRewardConfirmation");
			if(zone == adZoneViews){
				rewardViews = true;
				rewardViewsCount++;
			}else if(zone == adZoneRewards){
				rewardRewards = true;
				rewardRewardsCount++;
			}
		}
		
		public function onAdClosed(zone:String):void{
			if(rewardViews == true && zone == adZoneViews){
				log(zone + ":onAdClosed & Rewarded");
				rewardViews = false;
			}
			else if(rewardRewards == true && zone == adZoneRewards){
				log(zone + ":onAdClosed & Rewarded");
				rewardRewards = false;
			}				
			else
				log(zone + ":onAdClosed");
		}
		
		
		public function onAdUnavailable(zone:String):void{
			log(zone + ":onAdUnavailable");
			
			
		}
		
		//UI Buttons		
		public function loadFlex():void
		{
			log(adZoneFlex + ":Loading...");
			mbAPI.load(adZoneFlex,mbVars);
		}
		
		public function showFlex():void
		{
			if(isReadyFlex == true){
				log(adZoneFlex + ":Showing");
				mbAPI.show(adZoneFlex);
				isReadyFlex = false;
			}else{
				log(adZoneFlex + ":Is Not Ready");
			}
		}
		
		public function loadViews():void
		{
			log(adZoneViews + ":Loading...");
			mbAPI.load(adZoneViews,mbVars);
		}
		
		public function showViews():void
		{
			if(isReadyViews == true){
				log(adZoneViews + ":Showing");
				isReadyViews = false;
				rewardViews = false;
				mbAPI.show(adZoneViews);
			}else{
				log(adZoneViews + ":Is Not Ready");
			}
		}
		public function loadRewards():void
		{
			log(adZoneRewards + ":Loading...");
			mbAPI.load(adZoneRewards,mbVars);
		}
		
		public function showRewards():void
		{
			if(isReadyRewards == true){
				log(adZoneRewards + ":Showing");
				isReadyRewards = false;
				rewardRewards = false;
				mbAPI.show(adZoneRewards);
			}else{
				log(adZoneRewards + ":Is Not Ready");
			}
		}
		
		public function setVars():void{
			
			if(varsSet == false){
				
				log("Test Vars Set");
				mbVars.title = "AIR title";
				mbVars.optinbuttonText = "AIR optinbuttonText";
				mbVars.enticeText = "AIR enticeText";
				mbVars.rescueTitle = "AIR rescueTitle";
				mbVars.loadingText = "AIR loadingText";
				mbVars.achievementText = "AIR achievementText";
				mbVars.rewardText = "AIR rewardText";
				mbVars.gameName = "AIR gameName";
				mbVars.useMBbutton = "true";
				varsSet = true;
				
			}else{
				
				mbVars = new Object();
				varsSet = false;
				log("Test Vars Removed");
			}
			
		}
		
		public function changeOrientation():void{
			if(landscape == true){
				
				landscape = false;
				this.stage.setOrientation( StageOrientation.DEFAULT );
			}
			else
			{
				
				landscape = true;
				this.stage.setOrientation( StageOrientation.ROTATED_RIGHT );
			}
			//Orientation is broken on Samsung Tab...added this just to display the right text and keep QA happy =)
			var isPortraitView : Boolean = (stage.fullScreenWidth > stage.fullScreenHeight);
			if (isPortraitView == true){
				log("Portrait");
			}else{
				log("Landscape");
			}
			
		}
		
		//Lifecycle
		/** onPause */
		public function onDeactivate(event:Event):void
		{
			trace("onPause");
			mbAPI.onPause();
			
		}
		
		/** onResume */
		public function onActivate(event:Event):void
		{
			trace("onResume");
			mbAPI.onResume();
			
		}
		
		/** onDestroy */
		public function onExiting(event:Event):void{
			trace("onDestroy");
			mbAPI.onDestroy();
		}
		
		/** Create UI */
		public function createUI():void
		{
			var txtHeader:TextField;
			txtHeader=new TextField();
			txtHeader.defaultTextFormat=new flash.text.TextFormat("Arial",35);
			txtHeader.width=stage.stageWidth;
			txtHeader.y = 50
			txtHeader.height=65;

			txtHeader.text="MediaBrix-AIR v1.6.1 [12.10.14]";
			addChild(txtHeader);
			
			txtStatus=new TextField();
			txtStatus.defaultTextFormat=new flash.text.TextFormat("Arial",30,null,true);
			txtStatus.width=stage.stageWidth;
			txtStatus.y = 100;
			txtStatus.height=75;
			
			txtStatus.text="Init...";
			addChild(txtStatus);
			
			
			if (buttonContainer)
			{
				removeChild(buttonContainer);
				buttonContainer=null;
			}
			
			buttonContainer=new Sprite();
			buttonContainer.y=txtStatus.height;
			addChild(buttonContainer);
			
			var uiRect:Rectangle=new Rectangle(0,100,550,stage.stageHeight);
			var layout:ButtonLayout=new ButtonLayout(uiRect,25);
			layout.addButton(new SimpleButton(new Command("Change Orientation",changeOrientation)));
			layout.addButton(new SimpleButton(new Command("Load Flex",loadFlex)));
			layout.addButton(new SimpleButton(new Command("Show Flex",showFlex)));
			layout.addButton(new SimpleButton(new Command("Load Views",loadViews)));
			layout.addButton(new SimpleButton(new Command("Show Views",showViews)));
			layout.addButton(new SimpleButton(new Command("Load Rewards",loadRewards)));
			layout.addButton(new SimpleButton(new Command("Show Rewards",showRewards)));
			layout.addButton(new SimpleButton(new Command("Set Vars",setVars)));
			layout.attach(buttonContainer);
			layout.layout();        
		}
		
		/** Log */
		
		private function log(msg:String):void
		{
			trace("[MBRIX] Sample App "+msg);
			txtStatus.text=msg + "\nReward Count - Views:" + rewardViewsCount + " - Rewards:" + rewardRewardsCount;
		}        
		
		
	}
}


import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

/** Simple Button */
class SimpleButton extends Sprite
{
	//
	// Instance Variables
	//
	
	/** Command */
	private var cmd:Command;
	
	/** Width */
	private var _width:Number;
	
	/** Label */
	private var txtLabel:TextField;
	
	//
	// Public Methods
	//
	
	/** Create New SimpleButton */
	public function SimpleButton(cmd:Command)
	{
		super();
		this.cmd=cmd;
		
		mouseChildren=false;
		mouseEnabled=buttonMode=useHandCursor=true;
		
		txtLabel=new TextField();
		txtLabel.defaultTextFormat=new TextFormat("Arial",30,0xFFFFFF);
		txtLabel.mouseEnabled=txtLabel.mouseEnabled=txtLabel.selectable=false;
		txtLabel.text=cmd.getLabel();
		txtLabel.autoSize=TextFieldAutoSize.LEFT;
		
		redraw();
		
		addEventListener(MouseEvent.CLICK,onSelect);
	}
	
	/** Set Width */
	override public function set width(val:Number):void
	{
		this._width=val;
		redraw();
	}
	
	
	/** Dispose */
	public function dispose():void
	{
		removeEventListener(MouseEvent.CLICK,onSelect);
	}
	
	//
	// Events
	//
	
	/** On Press */
	private function onSelect(e:MouseEvent):void
	{
		this.cmd.execute();
	}
	
	//
	// Implementation
	//
	
	/** Redraw */
	private function redraw():void
	{                
		txtLabel.text=cmd.getLabel();
		_width=_width||txtLabel.width*1.1;
		
		graphics.clear();
		graphics.beginFill(0x7744BB);
		graphics.lineStyle(2,0);
		graphics.drawRoundRect(0,0,_width,txtLabel.height*1.1,txtLabel.height*.4);
		graphics.endFill();
		
		txtLabel.x=_width/2-(txtLabel.width/2);
		txtLabel.y=txtLabel.height*.05;
		addChild(txtLabel);
	}
}

/** Button Layout */
class ButtonLayout
{
	private var buttons:Array;
	private var rect:Rectangle;
	private var padding:Number;
	private var parent:DisplayObjectContainer;
	
	public function ButtonLayout(rect:Rectangle,padding:Number)
	{
		this.rect=rect;
		this.padding=padding;
		this.buttons=new Array();
	}
	
	public function addButton(btn:SimpleButton):uint
	{
		return buttons.push(btn);
	}
	
	public function attach(parent:DisplayObjectContainer):void
	{
		this.parent=parent;
		for each(var btn:SimpleButton in this.buttons)
		{
			parent.addChild(btn);
		}
	}
	
	public function layout():void
	{
		var btnX:Number=rect.x+padding;
		var btnY:Number=rect.y;
		for each( var btn:SimpleButton in this.buttons)
		{
			btn.width=rect.width-(padding*2);
			btnY+=this.padding;
			btn.x=btnX;
			btn.y=btnY;
			btnY+=btn.height;
		}
	}
}

/** Inline Command */
class Command
{
	/** Callback Method */
	private var fnCallback:Function;
	
	/** Label */
	private var label:String;
	
	//
	// Public Methods
	//
	
	/** Create New Command */
	public function Command(label:String,fnCallback:Function)
	{
		this.fnCallback=fnCallback;
		this.label=label;
	}
	
	//
	// Command Implementation
	//
	
	/** Get Label */
	public function getLabel():String
	{
		return label;
	}
	
	/** Execute */
	public function execute():void
	{
		fnCallback();
	}
}