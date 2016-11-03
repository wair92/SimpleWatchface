using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application as App;
using Toybox.Time.Gregorian as Gregorian;
using Toybox.Time as Time;
using Toybox.ActivityMonitor as Am;
using Toybox.Activity as Act;


class RussianFlagView extends Ui.WatchFace {


	var flag;
	
	//consts
	const SCREEN_MIDDLE = 109;
	const ELEVATION = 1;
	const STEPS = 2;
	const NOTIFICATION = 3;
	const ALARM = 4;
	const NONE = 99;
	const BATTERY = 6;
	const DATE = 7;
	const WEEKDAY = 8;
	
    function initialize() {
        WatchFace.initialize();
        flag = Ui.loadResource(Rez.Drawables.Flagg);
        
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        // Get and show the current time
        var batteryShowLimit = App.getApp().getProperty("ShowwBattery");
    	var batteryBorder = 25;
    	
    	//flags 
    	var isBatteryLessThanBorder = false;
        
        // Get the current time and format it correctly
        var timeFormat = "$1$:$2$";
        var clockTime = Sys.getClockTime();
        var hours = clockTime.hour;
        var minutes = clockTime.min;
        if (!Sys.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        } else {
            if (App.getApp().getProperty("UseMilitaryFormat")) {
                timeFormat = "$1$$2$";
                hours = hours.format("%02d");
            }
        }
        var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);
        
        
        var steps = Am.getInfo().steps + " " + Ui.loadResource(Rez.Strings.steps);
        var elevation = "-- m";
        var timeTmp = Time.now();
        
        var date = "";
        var userDateFormat = App.getApp().getProperty("DateFormat");

        if(userDateFormat == 1)
        {
        	date = Gregorian.info(timeTmp, Time.FORMAT_SHORT).day + "." +  Gregorian.info(timeTmp, Time.FORMAT_SHORT).month + "." + Gregorian.info(timeTmp, Time.FORMAT_SHORT).year;
        }
        else
        {
        	if(userDateFormat == 2)
	        {
	        	date = Gregorian.info(timeTmp, Time.FORMAT_SHORT).month + "/" +  Gregorian.info(timeTmp, Time.FORMAT_SHORT).day + "/" + Gregorian.info(timeTmp, Time.FORMAT_SHORT).year;
	        }
	        else
	        {
	        	if(userDateFormat == 3)
		        {
		        	date = Gregorian.info(timeTmp, Time.FORMAT_SHORT).year + "-" +  Gregorian.info(timeTmp, Time.FORMAT_SHORT).month + "-" + Gregorian.info(timeTmp, Time.FORMAT_SHORT).day;
		        }
	        }
        }
        var batteryTmp = Sys.getSystemStats().battery.toNumber();
        if (batteryTmp <= batteryBorder)
        {
        	isBatteryLessThanBorder = true;
        }
        else
        {
        	isBatteryLessThanBorder = false;
        }
        var battery = "";
        if(batteryTmp <= batteryShowLimit)
        {
        	battery = batteryTmp + " %";
        }
        else
        {
        	battery = "";
        }

        
        var notification = "";
		var bluetooth = "";
		var alarm = "";
		
		
		var deviceSettings = Sys.getDeviceSettings();
		var numberOfAlarms = deviceSettings.alarmCount;
		if(numberOfAlarms == 0)
		{
			alarm = "";
		}
		else
		{
			alarm = numberOfAlarms + "A";
		}
		
		var numberOfNotifications = deviceSettings.notificationCount;
		var phoneIsConnected = deviceSettings.phoneConnected;

		
		if(numberOfNotifications > 0)
		{
			notification = numberOfNotifications + "N";
		}
		else
		{
			if(phoneIsConnected == true)
			{
				notification = "BT";
			}
			else
			{
				notification = "";
			}
		}
		
        // Update the view
        var view = View.findDrawableById("TimeLabel");
        view.setColor(App.getApp().getProperty("ForegroundColor"));
        view.setText(timeString);


        dc.setColor( Gfx.COLOR_TRANSPARENT, Gfx.COLOR_BLACK );
        dc.clear();
        dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );
        

		elevation = Act.getActivityInfo().altitude;
		
		if(deviceSettings.elevationUnits == Sys.UNIT_METRIC)
        {
        	elevation = elevation.toNumber();
        	elevation = elevation + " m";
        	
        }
        if(deviceSettings.elevationUnits == Sys.UNIT_STATUTE)
        {
        	elevation = elevation.toNumber();
        	elevation = elevation + " f";

        }
            

         var weekdayTmp = Gregorian.info(timeTmp, Time.FORMAT_SHORT).day_of_week;
         var weekday = "";
		 if(weekdayTmp == 1)
		 {
		 	weekday = Ui.loadResource(Rez.Strings.Sunday);
		 }
		 else
		 {
		 	if(weekdayTmp == 2)
		 	{
		 		weekday = Ui.loadResource(Rez.Strings.Monday);
		 	}
		 	else
		 	{
		 		if(weekdayTmp == 3)
		 		{
		 			weekday = Ui.loadResource(Rez.Strings.Tuesday);
		 		}
		 		else
		 		{
		 			if(weekdayTmp == 4)
		 			{
		 				weekday = Ui.loadResource(Rez.Strings.Wednesday);
		 			}
		 			else
		 			{
		 				if(weekdayTmp == 5)
			 			{
			 				weekday = Ui.loadResource(Rez.Strings.Thursday);
			 			}
			 			else
			 			{
			 				if(weekdayTmp == 6)
				 			{
				 				weekday = Ui.loadResource(Rez.Strings.Friday);
				 			}
				 			else
				 			{
				 				weekday = Ui.loadResource(Rez.Strings.Saturday);
				 			}
			 			}
		 			}
		 		}
		 	}
		 }
                
        // DRAWING

        dc.drawBitmap(0, 0, flag);
        dc.setColor(0xFFFFFF, Gfx.COLOR_TRANSPARENT);
        dc.drawText( SCREEN_MIDDLE, 	62, 	16, 			timeString, 		Gfx.TEXT_JUSTIFY_CENTER );
        
        // 1. Field
        dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        var field1 = App.getApp().getProperty("Field1");
        var lala = "jedna: " + field1;
        System.println(lala);
        if( field1 == ELEVATION)
        {
        	dc.drawText( SCREEN_MIDDLE, 	10, 	Gfx.FONT_MEDIUM, elevation, 		Gfx.TEXT_JUSTIFY_CENTER );
        }
        else
        {
	        if( field1 == STEPS)
	        {
	        	dc.drawText( SCREEN_MIDDLE, 	10, 	Gfx.FONT_MEDIUM, steps, 		Gfx.TEXT_JUSTIFY_CENTER );
	        }
	        else
	        {
	        	if( field1 == NONE)
		        {
		        	dc.drawText( SCREEN_MIDDLE, 	10, 	Gfx.FONT_MEDIUM, "", 		Gfx.TEXT_JUSTIFY_CENTER );
		        }
	        }
	    }
        
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        
        //2. Field
        var field2 = App.getApp().getProperty("Field2");
		dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
        
        if( field2 == STEPS)
        {
        	dc.drawText( SCREEN_MIDDLE, 	35, 	Gfx.FONT_MEDIUM, steps, 			Gfx.TEXT_JUSTIFY_CENTER );
        }
        else
        {
	        if( field2 == ELEVATION)
	        {
	        	dc.drawText( SCREEN_MIDDLE, 	35, 	Gfx.FONT_MEDIUM, elevation, 			Gfx.TEXT_JUSTIFY_CENTER );
	        }
	        else
	        {
	        	if( field2 == WEEKDAY)
		        {
		        	dc.drawText( SCREEN_MIDDLE, 	35, 	Gfx.FONT_MEDIUM, weekday, 		Gfx.TEXT_JUSTIFY_CENTER );
		        }
		        else
		        {
		        	if( field2 == DATE)
			        {
			        	dc.drawText( SCREEN_MIDDLE, 	35, 	Gfx.FONT_MEDIUM, date, 		Gfx.TEXT_JUSTIFY_CENTER );
			        }
			        else
			        {
			        	if( field2 == NONE)
			        {
			        	dc.drawText( SCREEN_MIDDLE, 	35, 	Gfx.FONT_MEDIUM, "", 		Gfx.TEXT_JUSTIFY_CENTER );
			        }
			        }
		        }
	        }
	    }
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        
        //7. Field

        var field7 = App.getApp().getProperty("Field7");
		//dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
 
        if( field7 == STEPS)
        {
        	dc.drawText( SCREEN_MIDDLE, 	150, 	Gfx.FONT_MEDIUM, steps, 			Gfx.TEXT_JUSTIFY_CENTER );
        }
        else
        {
	        if( field7 == ELEVATION)
	        {
	        	dc.drawText( SCREEN_MIDDLE, 	150, 	Gfx.FONT_MEDIUM, elevation, 			Gfx.TEXT_JUSTIFY_CENTER );
	        }
	        else
	        {
	        	if( field7 == WEEKDAY)
		        {
		        	dc.drawText( SCREEN_MIDDLE, 	150, 	Gfx.FONT_MEDIUM, weekday, 		Gfx.TEXT_JUSTIFY_CENTER );
		        }
		        else
		        {
		        	if( field7 == DATE)
			        {
			        	dc.drawText( SCREEN_MIDDLE, 	150, 	Gfx.FONT_MEDIUM, date, 		Gfx.TEXT_JUSTIFY_CENTER );
			        }
			        else
			        {
			        	if( field7 == NONE)
				        {
				        	dc.drawText( SCREEN_MIDDLE, 	150, 	Gfx.FONT_MEDIUM, "", 		Gfx.TEXT_JUSTIFY_CENTER );
				        }
			        }
		        }
	        }
	    }
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);

        //6. Field
        var field6 = App.getApp().getProperty("Field6");
        var lalala = "6 : " + field6;
        System.println(lalala);
        
        if( field6 == BATTERY)
        {
        	if(isBatteryLessThanBorder)
	        {
	        	dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
	        }
	        else
	        {
	        	dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
	        }
	        dc.drawText( SCREEN_MIDDLE,	115, 	Gfx.FONT_MEDIUM, battery, 			Gfx.TEXT_JUSTIFY_CENTER );
	        
	        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
	        }
        else
        {
	        if( field6 == NONE)
	        {
	        	dc.drawText( SCREEN_MIDDLE,	115, 	Gfx.FONT_TINY, "", 			Gfx.TEXT_JUSTIFY_CENTER );
	        	dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
	        }
	     }
	     
	    var field5 = App.getApp().getProperty("Field5");
        if( field5 == BATTERY)
        {
        	if(isBatteryLessThanBorder)
	        {
	        	dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
	        }
	        else
	        {
	        	dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
	        }
	        dc.drawText( 195,	75, 	Gfx.FONT_TINY, battery, 			Gfx.TEXT_JUSTIFY_CENTER );
	        
	        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
	        }
        else
        {
	        if( field5 == NONE)
	        {
	        	dc.drawText( 195,	75, 	Gfx.FONT_TINY, "", 			Gfx.TEXT_JUSTIFY_CENTER );
	        	dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
	        }
	     }

        //3. Field
        
        var field3 = App.getApp().getProperty("Field3");
        if( field3 == NOTIFICATION)
        {
        	dc.drawText( 20, 	75, 	Gfx.FONT_MEDIUM, notification, 		Gfx.TEXT_JUSTIFY_CENTER );
        }
        else
        {
	        if( field3 == ALARM)
	        {
	        	dc.drawText( 20, 	75, 	Gfx.FONT_MEDIUM, alarm, 		Gfx.TEXT_JUSTIFY_CENTER );
	        }
	        else
	        {
	        	if( field3 == NONE)
		        {
		        	dc.drawText( 20, 	75, 	Gfx.FONT_MEDIUM, "", 		Gfx.TEXT_JUSTIFY_CENTER );
		        }
	        }
	    }
        
        //4. Field
        var field4 = App.getApp().getProperty("Field4");
        if( field4 == NOTIFICATION)
        {
        	dc.drawText( 20, 	115, 	Gfx.FONT_MEDIUM, notification, 		Gfx.TEXT_JUSTIFY_CENTER );
        }
        else
        {
	        if( field4 == ALARM)
	        {
	        	dc.drawText( 20, 	115, 	Gfx.FONT_MEDIUM, alarm, 		Gfx.TEXT_JUSTIFY_CENTER );
	        }
	        else
	        {
	        	if( field4 == NONE)
		        {
		        	dc.drawText( 20, 	115, 	Gfx.FONT_MEDIUM, "", 		Gfx.TEXT_JUSTIFY_CENTER );
		        }
	        }
	    }

        //8. Field
        
        var field8 = App.getApp().getProperty("Field8");
        
        if( field8 == STEPS)
        {
        	dc.drawText( SCREEN_MIDDLE, 	180, 	Gfx.FONT_MEDIUM, steps, 			Gfx.TEXT_JUSTIFY_CENTER );
        }
        else
        {
	        if( field8 == ELEVATION)
	        {
	        	dc.drawText( SCREEN_MIDDLE, 	180, 	Gfx.FONT_MEDIUM, elevation, 			Gfx.TEXT_JUSTIFY_CENTER );
	        }
	        else
	        {
	        	if( field8 == WEEKDAY)
		        {
		        	dc.drawText( SCREEN_MIDDLE, 	180, 	Gfx.FONT_MEDIUM, weekday, 		Gfx.TEXT_JUSTIFY_CENTER );
		        }
		        else
		        {
		        	if( field8 == DATE)
			        {
			        	dc.drawText( SCREEN_MIDDLE, 	180, 	Gfx.FONT_MEDIUM, date, 		Gfx.TEXT_JUSTIFY_CENTER );
			        }
			        else
			        {
			        	if( field8 == NONE)
			        {
			        	dc.drawText( SCREEN_MIDDLE, 	180, 	Gfx.FONT_MEDIUM, "", 		Gfx.TEXT_JUSTIFY_CENTER );
			        }
			        }
		        }
	        }
	    } 
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

}
