using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application as App;
using Toybox.Time.Gregorian as Gregorian;
using Toybox.Time as Time;
using Toybox.ActivityMonitor as Am;
using Toybox.Activity as Act;


var elevation = "";
var steps = "";
var notification = "";
var none = "";
var alarm = "";
var battery = "";
var date = "";
var weekday = "";
var amorpm1 = "";
var amorpm2 = "";
var amInfo;

const SCREEN_MIDDLE = Sys.getDeviceSettings().screenHeight/2;

var isBatteryLessThanBorder = false;
var lettersColor =  Gfx.COLOR_WHITE;
var showSecondTime = false;
var timeString2 = "";

function secureGet(property, type , defaultVal )
{
	var data = App.getApp().getProperty(property);
    if(data == null)
    {
    	data = defaultVal;
    }
    if(type.equals("number") == true)
    {
    	data = data.toNumber();
    }

	return data;
}

function ampm(hour24)
{
	if(hour24 < 12)
	{
		return "a.m.";
	}
	else
	{
		return "p.m.";
	}
}



class MyMath
{
	 static function metersToFeet(meters)
	{
		var feet = (meters / 0.3048).toNumber();
		return feet;
	}
}

class Field
{
    
	hidden var x = 0;
	hidden var y = 0;
	hidden var textSize = 0;
	hidden var text = "";
	hidden var name = "";
	hidden var type = "";
	hidden var center = 0;
	hidden var fieldType = 0;
	
	hidden const ELEVATION = 1;
	hidden const STEPS = 2;
	hidden const NOTIFICATION = 3;
	hidden const ALARM = 4;
	hidden const NONE = 99;
	hidden const BATTERY = 6;
	hidden const DATE = 7;
	hidden const WEEKDAY = 8;
	hidden const AMPM = 9;
	
	
    function initialize( aX, aY, aTextSize, aName,aCenter ) 
	{
	    	x = aX;
	    	y = aY;
	    	textSize = aTextSize;
	    	name = aName;
	    	type = "number";
	    	center = aCenter;
    }
    
    function setText()
    {
    	if(secureGet(name, "number", 1) == ELEVATION)
    	{
    	 	text = $.elevation;
    	 	fieldType = ELEVATION;
    	}
    	else
    	{
    		if(secureGet(name, "number", 1) == STEPS)
	    	{
	    	 	text = $.steps;
	    	 	fieldType = STEPS;
	    	}
	    	else
	    	{
	    		if(secureGet(name, "number", 1) == NOTIFICATION)
		    	{
		    	 	text = $.notification;
		    	 	fieldType = NOTIFICATION;
		    	}
		    	else
		    	{
		    		if(secureGet(name, "number", 1) == ALARM)
			    	{
			    	 	text = $.alarm;
			    	 	fieldType = ALARM;
			    	}
			    	else
			    	{
			    		if(secureGet(name, "number", 1) == NONE)
				    	{
				    	 	text = $.none;
				    	 	fieldType = NONE;
				    	}
				    	else
				    	{
				    		if(secureGet(name, "number", 1) == BATTERY)
					    	{
					    	 	text = $.battery;
					    	 	fieldType = BATTERY;
					    	}
					    	else
					    	{
					    		if(secureGet(name, "number", 1) == DATE)
						    	{
						    	 	text = $.date;
						    	 	fieldType = DATE;
						    	}
						    	else
						    	{
						    		if(secureGet(name, "number", 1) == WEEKDAY)
							    	{
							    	 	text = $.weekday;
							    	 	fieldType = WEEKDAY;
							    	}
							    	else
							    	{
							    		if(secureGet(name, "number", 1) == AMPM)
								    	{
								    	 	text = $.amorpm1;
								    	 	fieldType = AMPM;
								    	}
							    	}
						    	}
					    	}
				    	}
			    	}
		    	}
	    	}
    	}
    }
    
    function draw(aDc)
    {
    	if(fieldType == BATTERY)
    	{
    		
    		if(isBatteryLessThanBorder)
	    {
	        	aDc.setColor(Gfx.COLOR_RED, Gfx.COLOR_TRANSPARENT);
	    }
        else
        {
        		aDc.setColor(lettersColor, Gfx.COLOR_TRANSPARENT);
        }
        aDc.drawText( x, y, textSize, text, center );
		aDc.setColor(lettersColor, Gfx.COLOR_TRANSPARENT);
	        
    	}
    	else
    	{
    		if(fieldType == STEPS)
    		{
    			if($.showSecondTime == 1)
        	{
				aDc.drawText( x, y, textSize, "||", center );        		
				if($.amInfo.steps >= $.amInfo.stepGoal)
		        {
		        		aDc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
		        }
		        aDc.drawText( x -10 , y, textSize, text, Gfx.TEXT_JUSTIFY_RIGHT );
	        		aDc.setColor(lettersColor, Gfx.COLOR_TRANSPARENT);
				aDc.drawText( x + 10 , y, textSize, $.timeString2, Gfx.TEXT_JUSTIFY_LEFT );        	
        			aDc.drawText( x + SCREEN_MIDDLE*(SCREEN_MIDDLE/109.0) - 19 , y+9, textSize-3, $.amorpm2, Gfx.TEXT_JUSTIFY_RIGHT );        	
        	}	
        	else
        	{
	        	if($.amInfo.steps >= $.amInfo.stepGoal)
		        {
		        		aDc.setColor(Gfx.COLOR_GREEN, Gfx.COLOR_TRANSPARENT);
		        }
		        aDc.drawText( x, y, textSize, text, center );
	        	aDc.setColor(lettersColor, Gfx.COLOR_TRANSPARENT);
	        }
    		}
    		else
    		{//everything else
    			aDc.drawText( x, y, textSize, text, center );
    		}
    	}
    	
    }
}

class RussianFlagView extends Ui.WatchFace {


	function setColorAccordingSteps()
	{
		var steps20 = secureGet("TimeeeColor20", "number", 9);
		var steps100 = secureGet("TimeeeColor100", "number", 9);
		
		System.println(steps20);
		System.println(steps100);
		
		if($.amInfo.steps >= $.amInfo.stepGoal)
		{
			return steps100;
		}
		else
		{
			if($.amInfo.steps < $.amInfo.stepGoal*0.2 && $.amInfo.steps >= 0)
			{
				return steps20;
			}
		}
		return 9;
	}
	
	//consts
	const batteryBorder = 25;
	
	const ELEVATION = 1;
	const STEPS = 2;
	const NOTIFICATION = 3;
	const ALARM = 4;
	const NONE = 99;
	const BATTERY = 6;
	const DATE = 7;
	const WEEKDAY = 8;
	const AMPM = 9;
	
	const X = 0;
	const Y = 1;
	
	
	// COLORS
    var backGround =  Gfx.COLOR_BLACK;
	const DEFAULT_COLOR = 9;	
	
	var padding = 3; // padding between hours and minutes
	
	const FIELD_COORDINATES = [[SCREEN_MIDDLE, 10],[SCREEN_MIDDLE, 35],[20,75],[20,115],[SCREEN_MIDDLE+83,75],[SCREEN_MIDDLE+83,115],[SCREEN_MIDDLE,150],[SCREEN_MIDDLE,SCREEN_MIDDLE+69]];
	const COLORS = [Gfx.COLOR_BLACK,lettersColor, Gfx.COLOR_RED, Gfx.COLOR_GREEN,Gfx.COLOR_BLUE, Gfx.COLOR_ORANGE,Gfx.COLOR_PURPLE,Gfx.COLOR_YELLOW,Gfx.COLOR_BLACK];
    
    const TIME_Y = 45*(SCREEN_MIDDLE/109.0)*(SCREEN_MIDDLE/109.0)*(SCREEN_MIDDLE/109.0)*(SCREEN_MIDDLE/109.0)*(SCREEN_MIDDLE/109.0)*(SCREEN_MIDDLE/109.0);
    const TIME_Y_2 = 45*(SCREEN_MIDDLE/109.0)*(SCREEN_MIDDLE/109.0)*(SCREEN_MIDDLE/109.0)*(SCREEN_MIDDLE/109.0)*(SCREEN_MIDDLE/109.0)*(SCREEN_MIDDLE/109.0)+5;
    
    function initialize() 
    {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) 
    {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    function onShow() 
    {
    
    }

    function onUpdate(dc) 
    {

        var batteryShowLimit = secureGet("ShowwBattery", "number", 100);

        var timeFormat = "$1$:$2$";
        var clockTime =  Sys.getClockTime();
        var hours = clockTime.hour;
        
        amorpm2 = "";
        
        var minutes = clockTime.min;
        var showLeadingZero = true;
  
        if (!Sys.getDeviceSettings().is24Hour) 
        {
        	amorpm1 = ampm(hours);
        if (hours > 12) 
        {
        		showLeadingZero = false;
            	hours = hours - 12;
            
        }
            
        }
        var timeTmp = Time.now();
        var minutesShift = 0;
        var hoursShift =secureGet("TimeZoneee", "number", 5);
        hoursShift = hoursShift - 24;
        
        
        var hours2 = Gregorian.info(timeTmp,Time.FORMAT_SHORT).hour + hoursShift;
        hours2 = hours2.toNumber()+24;//to be sure it is positive
        hours2 = hours2%24;
        if (!Sys.getDeviceSettings().is24Hour) {
        	amorpm2 = ampm(hours2);
        if (hours2 > 12) {
        	
            hours2 = hours2 - 12;
        }
        }
        var minutes2 = minutes + minutesShift;
        if(showLeadingZero == true)
        {
        		hours = hours.format("%02d");
        }
        if(!Sys.getDeviceSettings().is24Hour)
        {
	        	if(hours.equals("00") == true)
	        	{
	        		hours = 12;
	        	}
        }
        minutes = minutes.format("%02d");
        if(showLeadingZero == true)
        {
        		hours2 = hours2.format("%02d") ;
        }
        if(!Sys.getDeviceSettings().is24Hour)
        {
	        	if(hours2.equals("00") == true)
	        	{
	        		hours2 = 12;
	        	}
        }
        minutes2 = minutes2.format("%02d");
        
        timeString2 = hours2 + ":" + minutes2; 
        var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);
        
        showSecondTime = secureGet("ShowSecondTimeee", "number", 1);
        amInfo = Am.getInfo();

        if(showSecondTime == 1)
        {
        		steps = amInfo.steps;
        }
        else
        {
        		steps = amInfo.steps + " " + Ui.loadResource(Rez.Strings.steps);
        }

		var delimiter = ":";
        var userDateFormat = secureGet("DateFormattt", "number", 1);
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
				else
				{
					if(userDateFormat == 4)
					{
						date = grInfoTime.day + "." + grInfoTime.month;
					}
					else
					{
						if(userDateFormat == 5)
						{
							date = grInfoTime.month + "/" + grInfoTime.day;
						}
						else
						{
							if(userDateFormat == 6)
							{
								date =  grInfoTime.month + "-" + grInfoTime.day;
							}
						}
					}
				
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
        if(batteryTmp <= batteryShowLimit)
        {
        		battery = batteryTmp + "%";
        }
        else
        {
        		battery = "";
        }

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
        
        var bckgColor = secureGet("BckgColor","number",1);

		if(bckgColor == 1)
		{
			backGround = Gfx.COLOR_BLACK;
			lettersColor =  Gfx.COLOR_WHITE;
		}
		if(bckgColor == 2)
		{
			backGround = Gfx.COLOR_WHITE;
			lettersColor = Gfx.COLOR_BLACK;
		}
		if(bckgColor == 3)
		{
			backGround = Gfx.COLOR_RED;
			lettersColor = Gfx.COLOR_WHITE;
		}


        dc.setColor( Gfx.COLOR_TRANSPARENT, backGround );
        dc.clear();
        dc.setColor( lettersColor, Gfx.COLOR_TRANSPARENT );
        

		elevation = Act.getActivityInfo().altitude;
		
		
		if(deviceSettings.elevationUnits == Sys.UNIT_METRIC)
        {
	        	elevation = elevation.toNumber();
	        	elevation = elevation + " " + Ui.loadResource(Rez.Strings.mm);
        }
        if(deviceSettings.elevationUnits == Sys.UNIT_STATUTE)
        {
	        	elevation = MyMath.metersToFeet(elevation).toNumber();
	        	elevation = elevation + " " + Ui.loadResource(Rez.Strings.ff);
        }
            
         var weekdayTmp = grInfoTime.day_of_week;

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
		var showLine = secureGet("ShowLine","number",1);
		if(showLine == 1)
		{
			var lineColor = secureGet("LineColor","number",1);
			if(backGround == COLORS[lineColor])
			{
				if(backGround == Gfx.COLOR_BLACK)
				{
					dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
				}
				if(backGround == Gfx.COLOR_WHITE)
				{
					dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
				}
			}
			else
			{
				dc.setColor(COLORS[lineColor], Gfx.COLOR_TRANSPARENT);
			}
			dc.drawLine(SCREEN_MIDDLE - 79, 150, SCREEN_MIDDLE*2 -30, 150);
			dc.drawLine(SCREEN_MIDDLE - 79, 151, SCREEN_MIDDLE*2 -30, 151);
			dc.setColor(lettersColor, Gfx.COLOR_TRANSPARENT);
		}
        dc.setColor(lettersColor, Gfx.COLOR_TRANSPARENT);
		var showDelimiter = secureGet("ShowDelimiter", "number", 1);
		var threeMiddle = 15;
		
		
		var timeColor = setColorAccordingSteps();
		System.println(timeColor);
		
		var timeInText = secureGet("TimeInText", "number", 1 );
		if(timeColor != DEFAULT_COLOR)
		{
			dc.setColor(COLORS[timeColor], Gfx.COLOR_TRANSPARENT);
		}
		var timeSize = 12;
		if(timeInText == 1)
		{
			if(showDelimiter == 1)
			{
				padding = 5;
				if(showLeadingZero == true)
				{
					dc.drawText( SCREEN_MIDDLE, 	TIME_Y, 	17, 			delimiter, 		Gfx.TEXT_JUSTIFY_CENTER );
				}
				else 
				{
					dc.drawText( SCREEN_MIDDLE - threeMiddle , 	TIME_Y, 	17, 			delimiter, 		Gfx.TEXT_JUSTIFY_CENTER );
					
				}
			}
			else
			{
				if(showDelimiter == 2)
				{
					padding = 0;
				}
			}
			
			dc.setColor(lettersColor, Gfx.COLOR_TRANSPARENT);
			
			if(timeColor != DEFAULT_COLOR)
			{
				dc.setColor(COLORS[timeColor], Gfx.COLOR_TRANSPARENT);
			}
			if(showLeadingZero == true)
			{
				dc.drawText( SCREEN_MIDDLE-padding, TIME_Y, 17, hours, 	Gfx.TEXT_JUSTIFY_RIGHT );
			}
			else
			{
				dc.drawText( SCREEN_MIDDLE-padding - threeMiddle, TIME_Y, 17, hours, 	Gfx.TEXT_JUSTIFY_RIGHT );
			}
			var userColor = secureGet("MinuteColor", "number", 1 );
			for( var i = 1; i < 9; i++ ) 
			{
				if(userColor==i)
				{
					if(COLORS[i] == backGround)
					{
						if(backGround == Gfx.COLOR_WHITE)
						{
							dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
						}
						if(backGround == Gfx.COLOR_BLACK)
						{
							dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
						}
					}
					else
					{
						dc.setColor(COLORS[i], Gfx.COLOR_TRANSPARENT);
						if(timeColor != DEFAULT_COLOR)
						{
							dc.setColor(COLORS[timeColor], Gfx.COLOR_TRANSPARENT);
						}
					}
					if(showLeadingZero == true)
					{
						dc.drawText( SCREEN_MIDDLE+padding,  TIME_Y, 17, minutes, Gfx.TEXT_JUSTIFY_LEFT );
					}
					else
					{
						dc.drawText( SCREEN_MIDDLE+padding - threeMiddle,  TIME_Y, 17, minutes, Gfx.TEXT_JUSTIFY_LEFT );
					}
					dc.setColor(lettersColor, Gfx.COLOR_TRANSPARENT);
					break;
				}
			}
		}	
		else
		{
			if(timeColor != DEFAULT_COLOR)
			{
				dc.setColor(COLORS[timeColor], Gfx.COLOR_TRANSPARENT);
			}
			hours = hours.toString();
			
			if(hours.equals("00")||hours.equals("0"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y + 25, timeSize+1, Ui.loadResource(Rez.Strings.t0), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(hours.equals("01")||hours.equals("1"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y + 25, timeSize+1, Ui.loadResource(Rez.Strings.t1), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(hours.equals("02")||hours.equals("2"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y + 25, timeSize+1, Ui.loadResource(Rez.Strings.t2), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(hours.equals("03")||hours.equals("3"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y + 25, timeSize+1, Ui.loadResource(Rez.Strings.t3), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(hours.equals("04")||hours.equals("4"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y + 25, timeSize+1, Ui.loadResource(Rez.Strings.t4), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(hours.equals("05")||hours.equals("5"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y + 25, timeSize+1, Ui.loadResource(Rez.Strings.t5), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(hours.equals("06")||hours.equals("6"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y + 25, timeSize+1, Ui.loadResource(Rez.Strings.t6), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(hours.equals("07")||hours.equals("7"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y + 25, timeSize+1, Ui.loadResource(Rez.Strings.t7), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(hours.equals("08")||hours.equals("8"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y + 25, timeSize+1, Ui.loadResource(Rez.Strings.t8), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(hours.equals("09")||hours.equals("9"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y + 25, timeSize+1, Ui.loadResource(Rez.Strings.t9), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(hours.equals("10"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y + 25, timeSize+1, Ui.loadResource(Rez.Strings.t10), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(hours.equals("11"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y + 25, timeSize +1 , Ui.loadResource(Rez.Strings.t11), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(hours.equals("12"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y + 25, timeSize+1, Ui.loadResource(Rez.Strings.t12), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(hours.equals("13"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y + 25, timeSize+1, Ui.loadResource(Rez.Strings.t13), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(hours.equals("14"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y + 25, timeSize +1, Ui.loadResource(Rez.Strings.t14), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(hours.equals("15"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y + 25, timeSize+1, Ui.loadResource(Rez.Strings.t15), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(hours.equals("16"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y + 25, timeSize +1 , Ui.loadResource(Rez.Strings.t16), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(hours.equals("17"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y + 25, timeSize +1, Ui.loadResource(Rez.Strings.t17), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(hours.equals("18"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y + 25, timeSize +1, Ui.loadResource(Rez.Strings.t18), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(hours.equals("19"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y + 25, timeSize +1, Ui.loadResource(Rez.Strings.t19), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(hours.equals("20"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y + 25, timeSize +1 , Ui.loadResource(Rez.Strings.t20), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(hours.equals("21"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y + 25, timeSize +1, Ui.loadResource(Rez.Strings.t21), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(hours.equals("22"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y + 25, timeSize +1 , Ui.loadResource(Rez.Strings.t22), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(hours.equals("23"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y + 25, timeSize +1 , Ui.loadResource(Rez.Strings.t23), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(hours.equals("24"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y + 25, timeSize +1 , Ui.loadResource(Rez.Strings.t24), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			
			if(minutes.equals("00"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 50, timeSize+1, Ui.loadResource(Rez.Strings.t0), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("01"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 50, timeSize+1, Ui.loadResource(Rez.Strings.t1), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("02"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 50, timeSize+1, Ui.loadResource(Rez.Strings.t2), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("03"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 50, timeSize+1, Ui.loadResource(Rez.Strings.t3), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("04"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 50, timeSize+1, Ui.loadResource(Rez.Strings.t4), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("05"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 50, timeSize+1, Ui.loadResource(Rez.Strings.t5), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("06"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 50, timeSize+1, Ui.loadResource(Rez.Strings.t6), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("07"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 50, timeSize+1, Ui.loadResource(Rez.Strings.t7), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("08"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 50, timeSize+1, Ui.loadResource(Rez.Strings.t8), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("09"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 50, timeSize+1, Ui.loadResource(Rez.Strings.t9), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("10"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 50, timeSize+1, Ui.loadResource(Rez.Strings.t10), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("11"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 50, timeSize+1, Ui.loadResource(Rez.Strings.t11), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("12"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 50, timeSize+1, Ui.loadResource(Rez.Strings.t12), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("13"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 60, timeSize, Ui.loadResource(Rez.Strings.t13), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("14"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 60, timeSize, Ui.loadResource(Rez.Strings.t14), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("15"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 50, timeSize+1, Ui.loadResource(Rez.Strings.t15), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("16"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 50, timeSize+1, Ui.loadResource(Rez.Strings.t16), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("17"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 60, timeSize+1, Ui.loadResource(Rez.Strings.t17), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("18"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 60, timeSize+1, Ui.loadResource(Rez.Strings.t18), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			
			if(minutes.equals("19"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 60, timeSize+1, Ui.loadResource(Rez.Strings.t19), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("20"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 50, timeSize+1, Ui.loadResource(Rez.Strings.t20), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("21"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 50, timeSize+1, Ui.loadResource(Rez.Strings.t21), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("22"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 50, timeSize+1, Ui.loadResource(Rez.Strings.t22), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("23"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 50, timeSize+1, Ui.loadResource(Rez.Strings.t23), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("24"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 60, timeSize, Ui.loadResource(Rez.Strings.t24), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("25"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 50, timeSize+1, Ui.loadResource(Rez.Strings.t25), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("26"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 60, timeSize, Ui.loadResource(Rez.Strings.t26), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("27"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 50, timeSize+1, Ui.loadResource(Rez.Strings.t27), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("28"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 60, timeSize, Ui.loadResource(Rez.Strings.t28), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("29"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 60, timeSize, Ui.loadResource(Rez.Strings.t29), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("30"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 50, timeSize+1, Ui.loadResource(Rez.Strings.t30), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("31"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 50, timeSize+1, Ui.loadResource(Rez.Strings.t31), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("32"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 50, timeSize+1, Ui.loadResource(Rez.Strings.t32), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("33"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 50, timeSize+1, Ui.loadResource(Rez.Strings.t33), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("34"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 60, timeSize, Ui.loadResource(Rez.Strings.t34), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("35"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 50, timeSize+1, Ui.loadResource(Rez.Strings.t35), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("36"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 60, timeSize, Ui.loadResource(Rez.Strings.t36), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("37"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 50, timeSize+1, Ui.loadResource(Rez.Strings.t37), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("38"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 60, timeSize, Ui.loadResource(Rez.Strings.t38), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("39"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 60 , timeSize, Ui.loadResource(Rez.Strings.t39), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("40"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 50, timeSize+1, Ui.loadResource(Rez.Strings.t40), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("41"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 50, timeSize+1, Ui.loadResource(Rez.Strings.t41), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("42"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 50 , timeSize +1, Ui.loadResource(Rez.Strings.t42), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("43"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 50, timeSize+1, Ui.loadResource(Rez.Strings.t43), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("44"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 50, timeSize+1, Ui.loadResource(Rez.Strings.t44), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("45"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 50, timeSize+1, Ui.loadResource(Rez.Strings.t45), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("46"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 50, timeSize+1, Ui.loadResource(Rez.Strings.t46), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("47"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 50, timeSize+1, Ui.loadResource(Rez.Strings.t47), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("48"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 50, timeSize+1, Ui.loadResource(Rez.Strings.t48), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("49"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 50, timeSize+1, Ui.loadResource(Rez.Strings.t49), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("50"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 50, timeSize+1, Ui.loadResource(Rez.Strings.t50), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("51"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 60, timeSize, Ui.loadResource(Rez.Strings.t51), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("52"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 60, timeSize, Ui.loadResource(Rez.Strings.t52), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("53"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 60, timeSize, Ui.loadResource(Rez.Strings.t53), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("54"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 60, timeSize, Ui.loadResource(Rez.Strings.t54), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("55"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 60, timeSize, Ui.loadResource(Rez.Strings.t55), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("56"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 60, timeSize, Ui.loadResource(Rez.Strings.t56), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("57"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 60, timeSize, Ui.loadResource(Rez.Strings.t57), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("58"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 60, timeSize, Ui.loadResource(Rez.Strings.t58), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("59"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 60, timeSize, Ui.loadResource(Rez.Strings.t59), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			if(minutes.equals("60"))
			{
				dc.drawText( SCREEN_MIDDLE, TIME_Y_2 + 60, timeSize, Ui.loadResource(Rez.Strings.t60), 	Gfx.TEXT_JUSTIFY_CENTER );
			}
			
			
			
		}
		var f1 = new Field(FIELD_COORDINATES[0][X], FIELD_COORDINATES[0][Y], Gfx.FONT_MEDIUM, "Field1",  Gfx.TEXT_JUSTIFY_CENTER );
		f1.setText();
		f1.draw(dc);
		
		var f2 = new Field(FIELD_COORDINATES[1][X], FIELD_COORDINATES[1][Y], Gfx.FONT_MEDIUM, "Field2",  Gfx.TEXT_JUSTIFY_CENTER );
		f2.setText();
		f2.draw(dc);
		
		if(secureGet("TimeInText", "number", 1 ) == 2)
		{
		
		}
		else
		{
		
			var f3 = new Field(FIELD_COORDINATES[2][X], FIELD_COORDINATES[2][Y], Gfx.FONT_MEDIUM, "Field3", Gfx.TEXT_JUSTIFY_CENTER );
			f3.setText();
			f3.draw(dc);
			
			var f4 = new Field(FIELD_COORDINATES[3][X], FIELD_COORDINATES[3][Y], Gfx.FONT_MEDIUM, "Field4",  Gfx.TEXT_JUSTIFY_CENTER );
			f4.setText();
			f4.draw(dc);
			
			var f5 = new Field(FIELD_COORDINATES[4][X], FIELD_COORDINATES[4][Y], Gfx.FONT_MEDIUM, "Field5",  Gfx.TEXT_JUSTIFY_CENTER );
			f5.setText();
			f5.draw(dc);
			
			var f6 = new Field(FIELD_COORDINATES[5][X], FIELD_COORDINATES[5][Y], Gfx.FONT_MEDIUM, "Field6",  Gfx.TEXT_JUSTIFY_CENTER );
			f6.setText();
			f6.draw(dc);
		}
		
		if(!secureGet("DonateMe", "String", 1 ).equals("38425614"))
		{
			if(minutes.toNumber()%2 == 0)
			{
				dc.drawText(FIELD_COORDINATES[6][X], FIELD_COORDINATES[6][Y], 10, "martin.bednar@hotmail.sk" , Gfx.TEXT_JUSTIFY_CENTER );
				dc.drawText(FIELD_COORDINATES[7][X], FIELD_COORDINATES[7][Y], 10, "Donate me :)" , Gfx.TEXT_JUSTIFY_CENTER );
			}
		}
		else
		{
			var f7 = new Field(FIELD_COORDINATES[6][X], FIELD_COORDINATES[6][Y], Gfx.FONT_MEDIUM, "Field7",  Gfx.TEXT_JUSTIFY_CENTER );
			f7.setText();
			f7.draw(dc);
			
			var f8 = new Field(FIELD_COORDINATES[7][X], FIELD_COORDINATES[7][Y], Gfx.FONT_MEDIUM, "Field8",  Gfx.TEXT_JUSTIFY_CENTER );
			f8.setText();
			f8.draw(dc);
		}
		
		
		
		
    } 

    
    
    function onHide() 
    {
    }

    function onExitSleep() 
    {
    }

    function onEnterSleep() 
    {
    }

}
