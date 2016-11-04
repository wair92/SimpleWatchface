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
	
	const FIELD_COORDINATES = [[SCREEN_MIDDLE, 10],[SCREEN_MIDDLE, 35],[20,75],[20,115],[192,75],[192,115],[SCREEN_MIDDLE,150],[SCREEN_MIDDLE,180]];
	
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
        
        hours = hours.format("%02d");
        minutes = minutes.format("%02d");
        var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);
        
        
        var steps = Am.getInfo().steps + " " + Ui.loadResource(Rez.Strings.steps);
        var elevation = "-- m";
        var timeTmp = Time.now();
		
		//var minutes =  Gregorian.info(timeTmp, Time.FORMAT_SHORT).minutes;
		//var hours = Gregorian.info(timeTmp, Time.FORMAT_SHORT).minutes;
		var delimiter = ":";
        
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

        //dc.drawBitmap(0, 0, flag);
        dc.setColor(0xFFFFFF, 0x000000);
        //dc.drawText( SCREEN_MIDDLE, 	62, 	16, 			timeString, 		Gfx.TEXT_JUSTIFY_CENTER );
		var showDelimiter = App.getApp().getProperty("ShowDelimiter");
		System.println(showDelimiter);
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
		
		dc.drawText( SCREEN_MIDDLE-padding, 	45, 	17, 			hours, 		Gfx.TEXT_JUSTIFY_RIGHT );
		
		var userColor = App.getApp().getProperty("MinuteColor");
		if(userColor == 1)
		{
			dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
			dc.drawText( SCREEN_MIDDLE+padding, 	45, 	17, 			minutes, 		Gfx.TEXT_JUSTIFY_LEFT );
		}
		else
		{
			if(userColor == 2)
			{
				dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
				dc.drawText( SCREEN_MIDDLE+padding, 	45, 	17, 			minutes, 		Gfx.TEXT_JUSTIFY_LEFT );
				dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
			}
			else
			{
				if(userColor == 3)
				{
					dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
					dc.drawText( SCREEN_MIDDLE+padding, 	45, 	17, 			minutes, 		Gfx.TEXT_JUSTIFY_LEFT );
					dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
				}
				else
				{
					if(userColor == 4)
					{
						dc.setColor(Gfx.COLOR_BLUE, Gfx.COLOR_TRANSPARENT);
						dc.drawText( SCREEN_MIDDLE+padding, 	45, 	17, 			minutes, 		Gfx.TEXT_JUSTIFY_LEFT );
						dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
					}
					else
					{
						if(userColor == 5)
						{
							dc.setColor(Gfx.COLOR_ORANGE, Gfx.COLOR_TRANSPARENT);
							dc.drawText( SCREEN_MIDDLE+padding, 	45, 	17, 			minutes, 		Gfx.TEXT_JUSTIFY_LEFT );
							dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
						}
						else
						{
							if(userColor == 6)
							{
								dc.setColor(Gfx.COLOR_PURPLE, Gfx.COLOR_TRANSPARENT);
								dc.drawText( SCREEN_MIDDLE+padding, 	45, 	17, 			minutes, 		Gfx.TEXT_JUSTIFY_LEFT );
								dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
							}
							else
							{
								if(userColor == 7)
								{
									dc.setColor(Gfx.COLOR_YELLOW, Gfx.COLOR_TRANSPARENT);
									dc.drawText( SCREEN_MIDDLE+padding, 	45, 	17, 			minutes, 		Gfx.TEXT_JUSTIFY_LEFT );
									dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
								}
							
								else
								{
									dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
									dc.drawText( SCREEN_MIDDLE+padding, 	45, 	17, 			minutes, 		Gfx.TEXT_JUSTIFY_LEFT );
								}
							}
						}
					}
				}
			}
		}
		
        
        // 1. Field
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        var field1 = App.getApp().getProperty("Field1");
        if( field1 == ELEVATION)
        {
        	dc.drawText( FIELD_COORDINATES[0][X], FIELD_COORDINATES[0][Y], Gfx.FONT_MEDIUM, elevation, Gfx.TEXT_JUSTIFY_CENTER );
        }
        else
        {
	        if( field1 == STEPS)
	        {
	         if(Am.getInfo().steps >= Am.getInfo().stepGoal)
	        {
	        	dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
	        }
	        	dc.drawText( FIELD_COORDINATES[0][X], FIELD_COORDINATES[0][Y], steps, 		Gfx.TEXT_JUSTIFY_CENTER );
	        	dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
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
        var field2 = App.getApp().getProperty("Field2");
		dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        
        if( field2 == STEPS)
        {
        	if(Am.getInfo().steps >= Am.getInfo().stepGoal)
	        {
	        	dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
	        }
        	dc.drawText( FIELD_COORDINATES[1][X], FIELD_COORDINATES[1][Y], 	Gfx.FONT_MEDIUM, steps, 			Gfx.TEXT_JUSTIFY_CENTER );
        	dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
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

        var field7 = App.getApp().getProperty("Field7");
		//dc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
 
        if( field7 == STEPS)
        {
        	if(Am.getInfo().steps >= Am.getInfo().stepGoal)
	        {
	        	dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
	        }
        	dc.drawText( FIELD_COORDINATES[6][X], FIELD_COORDINATES[6][Y], 	Gfx.FONT_MEDIUM, steps, 			Gfx.TEXT_JUSTIFY_CENTER );
        	dc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
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
        var field6 = App.getApp().getProperty("Field6");

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
        
        var field3 = App.getApp().getProperty("Field3");
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
        var field4 = App.getApp().getProperty("Field4");
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
        
        var field8 = App.getApp().getProperty("Field8");
        
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
	    System.println(field1);
    }
    
    function onHide() {
    }

    function onExitSleep() {
    }

    function onEnterSleep() {
    }

}
