using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application as App;
using Toybox.Time.Gregorian as Gregorian;
using Toybox.Time as Time;
using Toybox.ActivityMonitor as Am;
using Toybox.Activity as Act;

function secureGet(property, type , defaultVal )
{
	var data = App.getApp().getProperty(property);
    if(data == null)
    {
    	data = defaultVal;
    }
    if(type == "number")
    {
    	data = userDateFormat.toNumber();
    }
	return data;
}
class RussianFlagView extends Ui.WatchFace {


	//var flag;
	
	//consts
	const batteryBorder = 25;
	const SCREEN_MIDDLE = 109;
	const ELEVATION = 1;
	const STEPS = 2;
	const NOTIFICATION = 3;
	const ALARM = 4;
	const NONE = 99;
	const BATTERY = 6;
	const DATE = 7;
	const WEEKDAY = 8;
	
	const X = 0;
	const Y = 1;
	
	var padding = 3; // padding between hours and minutes
	
	const FIELD_COORDINATES = [[SCREEN_MIDDLE, 10],[SCREEN_MIDDLE, 35],[20,75],[20,115],[194,75],[194,115],[SCREEN_MIDDLE,150],[SCREEN_MIDDLE,180]];
	const COLORS = [Gfx.COLOR_BLACK,Gfx.COLOR_WHITE, Gfx.COLOR_RED, Gfx.COLOR_GREEN,Gfx.COLOR_BLUE, Gfx.COLOR_ORANGE,Gfx.COLOR_PURPLE,Gfx.COLOR_YELLOW,Gfx.COLOR_WHITE];
    function initialize() {
        WatchFace.initialize();
        //flag = Ui.loadResource(Rez.Drawables.Flagg);
        
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

        var batteryShowLimit = secureGet("ShowwBattery", "number", 100);
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
        }
        var timeTmp = Time.now();
        var minutesShift = 0;
        var hoursShift =secureGet("TimeZonee", "number", 5);
        hoursShift = hoursShift - 13;
        
        
        var hours2 = Gregorian.info(timeTmp,Time.FORMAT_SHORT).hour + hoursShift;
        hours2 = hours2.toNumber();
        hours2 = hours2%24;
        Sys.println("Hours: " + hours2);
        var minutes2 = minutes + minutesShift;
        hours = hours.format("%02d");
        minutes = minutes.format("%02d");
        hours2 = hours2.format("%02d");
        minutes2 = minutes2.format("%02d");
        var timeString2 = hours2 + ":" + minutes2; 
        var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);
        
        var showSecondTime = secureGet("ShowSecondTimee", "number", 1);

        var steps = "";
        if(showSecondTime == 1)
        {
        	steps = Am.getInfo().steps;
        }
        else
        {
        	steps = Am.getInfo().steps + " " + Ui.loadResource(Rez.Strings.steps);
        }
        var elevation = "-- m";
        
		
		//var minutes =  Gregorian.info(timeTmp, Time.FORMAT_SHORT).minutes;
		//var hours = Gregorian.info(timeTmp, Time.FORMAT_SHORT).minutes;
		var delimiter = ":";
        
        var date = "";
        var userDateFormat = secureGet("DateFormat", "number", "1");
        var grInfoTime = Gregorian.info(timeTmp, Time.FORMAT_SHORT);

        if(userDateFormat == 1)
        {
        	date = grInfoTime.day + "." +  grInfoTime.month + "." + grInfoTime.year;
        }
        else
        {
        	if(userDateFormat == 2)
	        {
	        	date = grInfoTime.month + "/" +  grInfoTime.day + "/" + grInfoTime.year;
	        }
	        else
	        {
	        	if(userDateFormat == 3)
		        {
		        	date = grInfoTime.year + "-" +  grInfoTime.month + "-" + grInfoTime.day;
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
        //var view = View.findDrawableById("TimeLabel");
        //view.setColor(App.getApp().getProperty("ForegroundColor"));
        //view.setText(timeString);


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
            
         var weekdayTmp = grInfoTime.day_of_week;
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

        dc.setColor(0xFFFFFF, 0x000000);
		var showDelimiter = secureGet("ShowDelimiter", "number", 1);

		if(showDelimiter == 1)
		{
			padding = 5;
			dc.drawText( SCREEN_MIDDLE, 	45, 	17, 			delimiter, 		Gfx.TEXT_JUSTIFY_CENTER );
		}
		else
		{
			if(showDelimiter == 2)
			{
				padding = 0;
			}
		}
		
		dc.drawText( SCREEN_MIDDLE-padding, 45, 17, hours, 	Gfx.TEXT_JUSTIFY_RIGHT );
		
		var userColor = secureGet("MinuteColor", "number", 1 );
		for( var i = 1; i < 8; i++ ) 
		{
			if(userColor==i)
			{
				dc.setColor(COLORS[i], Gfx.COLOR_TRANSPARENT);
				dc.drawText( SCREEN_MIDDLE+padding, 45, 17, minutes, Gfx.TEXT_JUSTIFY_LEFT );
				dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
				break;
			}
		}
		
        // 1. Field
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        var field1 = secureGet("Field1", "number", steps);
        if( field1 == ELEVATION)
        {
        	dc.drawText( FIELD_COORDINATES[0][X], FIELD_COORDINATES[0][Y], Gfx.FONT_MEDIUM, elevation, Gfx.TEXT_JUSTIFY_CENTER );
        }
        else
        {
	        if( field1 == STEPS)
        	{
        	if(showSecondTime == 1)
	        	{
					dc.drawText( FIELD_COORDINATES[1][X], FIELD_COORDINATES[1][Y], 	Gfx.FONT_MEDIUM, "||", 			Gfx.TEXT_JUSTIFY_CENTER );
	        	
	        		if(Am.getInfo().steps >= Am.getInfo().stepGoal)
			        {
			        	dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
			        }
		        	dc.drawText( FIELD_COORDINATES[1][X]-10, FIELD_COORDINATES[1][Y], 	Gfx.FONT_MEDIUM, steps, 			Gfx.TEXT_JUSTIFY_RIGHT );
		        	dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
		        	dc.drawText( FIELD_COORDINATES[1][X]+10, FIELD_COORDINATES[1][Y], 	Gfx.FONT_MEDIUM, timeString2, 			Gfx.TEXT_JUSTIFY_LEFT );
	        	}
	        	else
	        	{
		        	if(Am.getInfo().steps >= Am.getInfo().stepGoal)
			        {
			        	dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
			        }
		        	dc.drawText( FIELD_COORDINATES[1][X], FIELD_COORDINATES[1][Y], 	Gfx.FONT_MEDIUM, steps, 			Gfx.TEXT_JUSTIFY_CENTER );
		        	dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
		        }
	        	
        }
	        else
	        {
	        	if( field1 == NONE)
		        {
		        	dc.drawText( FIELD_COORDINATES[0][X], FIELD_COORDINATES[0][Y], 	Gfx.FONT_MEDIUM, "", Gfx.TEXT_JUSTIFY_CENTER );
		        }
	        }
	    }
        
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        
        //2. Field
        var field2 = secureGet("Field2", "number", STEPS);
        
		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        
        if( field2 == STEPS)
        {
        	if(showSecondTime == 1)
        	{
        		dc.drawText( FIELD_COORDINATES[1][X], FIELD_COORDINATES[1][Y], 	Gfx.FONT_MEDIUM, "||", 			Gfx.TEXT_JUSTIFY_CENTER );
        		if(Am.getInfo().steps >= Am.getInfo().stepGoal)
		        {
		        	dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
		        }
		        
	        	dc.drawText( FIELD_COORDINATES[1][X]-10, FIELD_COORDINATES[1][Y], 	Gfx.FONT_MEDIUM, steps, 			Gfx.TEXT_JUSTIFY_RIGHT );
	        	dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
	        	dc.drawText( FIELD_COORDINATES[1][X]+10, FIELD_COORDINATES[1][Y], 	Gfx.FONT_MEDIUM, timeString2, 			Gfx.TEXT_JUSTIFY_LEFT );
        	}
        	else
        	{
	        	if(Am.getInfo().steps >= Am.getInfo().stepGoal)
		        {
		        	dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
		        }
	        	dc.drawText( FIELD_COORDINATES[1][X], FIELD_COORDINATES[1][Y], 	Gfx.FONT_MEDIUM, steps, 			Gfx.TEXT_JUSTIFY_CENTER );
	        	dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
	        }
        }
        else
        {
	        if( field2 == ELEVATION)
	        {
	        	dc.drawText( FIELD_COORDINATES[1][X], FIELD_COORDINATES[1][Y], 	Gfx.FONT_MEDIUM, elevation, 			Gfx.TEXT_JUSTIFY_CENTER );
	        }
	        else
	        {
	        	if( field2 == WEEKDAY)
		        {
		        	dc.drawText( FIELD_COORDINATES[1][X], FIELD_COORDINATES[1][Y], 	Gfx.FONT_MEDIUM, weekday, 		Gfx.TEXT_JUSTIFY_CENTER );
		        }
		        else
		        {
		        	if( field2 == DATE)
			        {
			        	dc.drawText( FIELD_COORDINATES[1][X], FIELD_COORDINATES[1][Y], 	Gfx.FONT_MEDIUM, date, 		Gfx.TEXT_JUSTIFY_CENTER );
			        }
			        else
			        {
			        	if( field2 == NONE)
				        {
				        	dc.drawText( FIELD_COORDINATES[1][X], FIELD_COORDINATES[1][Y], 	Gfx.FONT_MEDIUM, "", 		Gfx.TEXT_JUSTIFY_CENTER );
				        }
			        }
		        }
	        }
	    }
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        
        //7. Field

        var field7 = secureGet("Field7", "number", DATE);
		//dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
 
        if( field7 == STEPS)
        {
        	if(showSecondTime == 1)
        	{
        		dc.drawText( FIELD_COORDINATES[1][X], FIELD_COORDINATES[1][Y], 	Gfx.FONT_MEDIUM, "||", 			Gfx.TEXT_JUSTIFY_CENTER );
        	
        		if(Am.getInfo().steps >= Am.getInfo().stepGoal)
		        {
		        	dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
		        }
	        	dc.drawText( FIELD_COORDINATES[1][X]-10, FIELD_COORDINATES[1][Y], 	Gfx.FONT_MEDIUM, steps, 			Gfx.TEXT_JUSTIFY_RIGHT );
	        	dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
	        	dc.drawText( FIELD_COORDINATES[1][X]+10, FIELD_COORDINATES[1][Y], 	Gfx.FONT_MEDIUM, timeString2, 			Gfx.TEXT_JUSTIFY_LEFT );
        	}
        	else
        	{
	        	if(Am.getInfo().steps >= Am.getInfo().stepGoal)
		        {
		        	dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
		        }
	        	dc.drawText( FIELD_COORDINATES[1][X], FIELD_COORDINATES[1][Y], 	Gfx.FONT_MEDIUM, steps, 			Gfx.TEXT_JUSTIFY_CENTER );
	        	dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
	        }
        }
        else
        {
	        if( field7 == ELEVATION)
	        {
	        	dc.drawText( FIELD_COORDINATES[6][X], FIELD_COORDINATES[6][Y], 	Gfx.FONT_MEDIUM, elevation, 			Gfx.TEXT_JUSTIFY_CENTER );
	        }
	        else
	        {
	        	if( field7 == WEEKDAY)
		        {
		        	dc.drawText( FIELD_COORDINATES[6][X], FIELD_COORDINATES[6][Y], 	Gfx.FONT_MEDIUM, weekday, 		Gfx.TEXT_JUSTIFY_CENTER );
		        }
		        else
		        {
		        	if( field7 == DATE)
			        {
			        	dc.drawText( FIELD_COORDINATES[6][X], FIELD_COORDINATES[6][Y], 	Gfx.FONT_MEDIUM, date, 		Gfx.TEXT_JUSTIFY_CENTER );
			        }
			        else
			        {
			        	if( field7 == NONE)
				        {
				        	dc.drawText( FIELD_COORDINATES[6][X], FIELD_COORDINATES[6][Y], 	Gfx.FONT_MEDIUM, "", 		Gfx.TEXT_JUSTIFY_CENTER );
				        }
			        }
		        }
	        }
	    }
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);

        //6. Field
        var field6 = secureGet("Field6", "number", BATTERY);

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
	        dc.drawText( FIELD_COORDINATES[5][X], FIELD_COORDINATES[5][Y], 	Gfx.FONT_TINY, battery, 			Gfx.TEXT_JUSTIFY_CENTER );
	        
	        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
	        }
        else
        {
	        if( field6 == NONE)
	        {
	        	dc.drawText( FIELD_COORDINATES[5][X], FIELD_COORDINATES[5][Y], 	Gfx.FONT_TINY, "", 			Gfx.TEXT_JUSTIFY_CENTER );
	        	dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
	        }
	     }
	     
	    var field5 = secureGet("Field5", "number", BATTERY);
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
	        dc.drawText( FIELD_COORDINATES[4][X], FIELD_COORDINATES[4][Y], 	Gfx.FONT_TINY, battery, 			Gfx.TEXT_JUSTIFY_CENTER );
	        
	        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
	        }
        else
        {
	        if( field5 == NONE)
	        {
	        	dc.drawText( FIELD_COORDINATES[4][X], FIELD_COORDINATES[4][Y], 	Gfx.FONT_TINY, "", 			Gfx.TEXT_JUSTIFY_CENTER );
	        	dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
	        }
	     }

        //3. Field
        
        var field3 = secureGet("Field3", "number", NOTIFICATION);
        
        if( field3 == NOTIFICATION)
        {
        	dc.drawText( FIELD_COORDINATES[2][X], FIELD_COORDINATES[2][Y], 	Gfx.FONT_MEDIUM, notification, 		Gfx.TEXT_JUSTIFY_CENTER );
        }
        else
        {
	        if( field3 == ALARM)
	        {
	        	dc.drawText( FIELD_COORDINATES[2][X], FIELD_COORDINATES[2][Y], 	Gfx.FONT_MEDIUM, alarm, 		Gfx.TEXT_JUSTIFY_CENTER );
	        }
	        else
	        {
	        	if( field3 == NONE)
		        {
		        	dc.drawText( FIELD_COORDINATES[2][X], FIELD_COORDINATES[2][Y], 	Gfx.FONT_MEDIUM, "", 		Gfx.TEXT_JUSTIFY_CENTER );
		        }
	        }
	    }
        
        //4. Field
        var field4 = secureGet("Field4", "number", NOTIFICATION);
        
        if( field4 == NOTIFICATION)
        {
        	dc.drawText( FIELD_COORDINATES[3][X], FIELD_COORDINATES[3][Y], 	Gfx.FONT_MEDIUM, notification, 		Gfx.TEXT_JUSTIFY_CENTER );
        }
        else
        {
	        if( field4 == ALARM)
	        {
	        	dc.drawText( FIELD_COORDINATES[3][X], FIELD_COORDINATES[3][Y], 	Gfx.FONT_MEDIUM, alarm, 		Gfx.TEXT_JUSTIFY_CENTER );
	        }
	        else
	        {
	        	if( field4 == NONE)
		        {
		        	dc.drawText( FIELD_COORDINATES[3][X], FIELD_COORDINATES[3][Y], 	Gfx.FONT_MEDIUM, "", 		Gfx.TEXT_JUSTIFY_CENTER );
		        }
	        }
	    }

        //8. Field
        
        var field8 = secureGet("Field8", "number", DATE);
        
        if( field8 == STEPS)
        {
        	if(Am.getInfo().steps >= Am.getInfo().stepGoal)
	        {
	        	dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
	        }
        	dc.drawText( FIELD_COORDINATES[7][X], FIELD_COORDINATES[7][Y], 	Gfx.FONT_MEDIUM, steps, 			Gfx.TEXT_JUSTIFY_CENTER );
        	dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        }
        else
        {
	        if( field8 == ELEVATION)
	        {
	        	dc.drawText( FIELD_COORDINATES[7][X], FIELD_COORDINATES[7][Y], 	Gfx.FONT_MEDIUM, elevation, 			Gfx.TEXT_JUSTIFY_CENTER );
	        }
	        else
	        {
	        	if( field8 == WEEKDAY)
		        {
		        	dc.drawText( FIELD_COORDINATES[7][X], FIELD_COORDINATES[7][Y], 	Gfx.FONT_MEDIUM, weekday, 		Gfx.TEXT_JUSTIFY_CENTER );
		        }
		        else
		        {
		        	if( field8 == DATE)
			        {
			        	dc.drawText( FIELD_COORDINATES[7][X], FIELD_COORDINATES[7][Y], 	Gfx.FONT_MEDIUM, date, 		Gfx.TEXT_JUSTIFY_CENTER );
			        }
			        else
			        {
			        	if( field8 == NONE)
			        {
			        	dc.drawText( FIELD_COORDINATES[7][X], FIELD_COORDINATES[7][Y], 	Gfx.FONT_MEDIUM, "", 		Gfx.TEXT_JUSTIFY_CENTER );
			        }
			        }
		        }
	        }
	    } 

    }
    
    function onHide() {
    }

    function onExitSleep() {
    }

    function onEnterSleep() {
    }

}
