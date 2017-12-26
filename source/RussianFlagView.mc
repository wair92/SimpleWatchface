using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Application as App;
using Toybox.Time.Gregorian as Gregorian;
using Toybox.Time as Time;
using Toybox.ActivityMonitor as Am;
using Toybox.Activity as Act;

var model;

const SCREEN_MIDDLE = Sys.getDeviceSettings().screenHeight/2;

var isBatteryLessThanBorder = false;
var lettersColor =  Gfx.COLOR_WHITE;
var showSecondTime = false;
var timeString2 = "";


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
    	if($.model.userSettings_.secureGet(name, "number", 1) == ELEVATION)
    	{
    	 	text = $.model.elevation;
    	 	fieldType = ELEVATION;
    	}
    	else
    	{
    		if($.model.userSettings_.secureGet(name, "number", 1) == STEPS)
	    	{
	    	 	text = $.model.steps;
	    	 	fieldType = STEPS;
	    	}
	    	else
	    	{
	    		if($.model.userSettings_.secureGet(name, "number", 1) == NOTIFICATION)
		    	{
		    	 	text = $.model.notification;
		    	 	fieldType = NOTIFICATION;
		    	}
		    	else
		    	{
		    		if($.model.userSettings_.secureGet(name, "number", 1) == ALARM)
			    	{
			    	 	text = $.model.alarm;
			    	 	fieldType = ALARM;
			    	}
			    	else
			    	{
			    		if($.model.userSettings_.secureGet(name, "number", 1) == NONE)
				    	{
				    	 	text = $.model.none;
				    	 	fieldType = NONE;
				    	}
				    	else
				    	{
				    		if($.model.userSettings_.secureGet(name, "number", 1) == BATTERY)
					    	{
					    	 	text = $.model.battery;
					    	 	fieldType = BATTERY;
					    	}
					    	else
					    	{
					    		if($.model.userSettings_.secureGet(name, "number", 1) == DATE)
						    	{
						    	 	text = $.model.date;
						    	 	fieldType = DATE;
						    	}
						    	else
						    	{
						    		if($.model.userSettings_.secureGet(name, "number", 1) == WEEKDAY)
							    	{
							    	 	text = $.model.weekday;
							    	 	fieldType = WEEKDAY;
							    	}
							    	else
							    	{
							    		if($.model.userSettings_.secureGet(name, "number", 1) == AMPM)
								    	{
								    	 	text = $.model.amorpm1;
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
	        	if($.model.amInfo.steps >= $.model.amInfo.stepGoal)
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
		if($.model.amInfo.steps >= $.model.amInfo.stepGoal)
		{
			return $.model.userSettings_.steps100;
		}
		else
		{
			if($.model.amInfo.steps < $.model.amInfo.stepGoal*0.2 && $.model.amInfo.steps >= 0)
			{
				return $.model.userSettings_.steps20;
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
        $.model = new AplicationModel();
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
		$.model.update();
        var amorpm1 = Conversions.ampm($.model.hours);
        var timeString = Conversions.formatTime($.model.hours, $.model.minutes);
  
        //	var hours2 = $.model.hours.toNumber() + $.model.userSettings_.hoursShift.toNumber();
        //hours2 = hours2.toNumber()+24;//to be sure it is positive
        //hours2 = hours2%24;
        var hours2 = 0;
        
	    var amorpm2 = Conversions.ampm(hours2);
	    var timeString2 = Conversions.formatTime(hours2, $.model.minutes);
        

		//steps = Conversions.formatSteps($.model.userSettings_.showSecondTime, $.model.amInfo);
		var steps = "33";

		var delimiter = ":";
        var grInfoTime = Gregorian.info( Time.now(), Time.FORMAT_SHORT);
		
		date = Conversions.formatUserDate($.model.userSettings_.userDateFormat, grInfoTime);
       
        var batteryTmp = 10;
        if (batteryTmp <= batteryBorder)
        {
        		isBatteryLessThanBorder = true;
        }
        else
        {
        		isBatteryLessThanBorder = false;
        }
        if(batteryTmp <= $.model.userSettings_.batteryShowLimit )
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

		if($.model.userSettings_.bckgColor == 1)
		{
			backGround = Gfx.COLOR_BLACK;
			lettersColor =  Gfx.COLOR_WHITE;
		}
		if($.model.userSettings_.bckgColor == 2)
		{
			backGround = Gfx.COLOR_WHITE;
			lettersColor = Gfx.COLOR_BLACK;
		}
		if($.model.userSettings_.bckgColor == 3)
		{
			backGround = Gfx.COLOR_RED;
			lettersColor = Gfx.COLOR_WHITE;
		}


        dc.setColor( Gfx.COLOR_TRANSPARENT, backGround );
        dc.clear();
        dc.setColor( lettersColor, Gfx.COLOR_TRANSPARENT );
        
		elevation = Conversions.formatElevation( model.elevation );
            
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
		if($.model.userSettings_.showLine == 1)
		{
			if(backGround == COLORS[$.model.userSettings_.lineColor])
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
				dc.setColor(COLORS[$.model.userSettings_.lineColor], Gfx.COLOR_TRANSPARENT);
			}
			dc.drawLine(SCREEN_MIDDLE - 79, 150, SCREEN_MIDDLE*2 -30, 150);
			dc.drawLine(SCREEN_MIDDLE - 79, 151, SCREEN_MIDDLE*2 -30, 151);
			dc.setColor(lettersColor, Gfx.COLOR_TRANSPARENT);
		}
        dc.setColor(lettersColor, Gfx.COLOR_TRANSPARENT);
		var threeMiddle = 15;
		
		
		var timeColor = setColorAccordingSteps();
		
		if(timeColor != DEFAULT_COLOR)
		{
			dc.setColor(COLORS[timeColor], Gfx.COLOR_TRANSPARENT);
		}
		var timeSize = 12;
		if($.model.userSettings_.timeInText == 1)
		{
			if($.model.userSettings_.showDelimiter == 1)
			{
				padding = 5;
				//if(showLeadingZero == true)
				//{
					dc.drawText( SCREEN_MIDDLE, 	TIME_Y, 	17, 			delimiter, 		Gfx.TEXT_JUSTIFY_CENTER );
				//}
				//else 
				//{
				//	dc.drawText( SCREEN_MIDDLE - threeMiddle , 	TIME_Y, 	17, 			delimiter, 		Gfx.TEXT_JUSTIFY_CENTER );
				//}
			}
			else
			{
				if($.model.userSettings_.showDelimiter == 2)
				{
					padding = 0;
				}
			}
			
			dc.setColor(lettersColor, Gfx.COLOR_TRANSPARENT);
			
			if(timeColor != DEFAULT_COLOR)
			{
				dc.setColor(COLORS[timeColor], Gfx.COLOR_TRANSPARENT);
			}
			//if(showLeadingZero == true)
			//{
				dc.drawText( SCREEN_MIDDLE-padding, TIME_Y, 17, $.model.hours, 	Gfx.TEXT_JUSTIFY_RIGHT );
			//}
			//else
			//{
			//	dc.drawText( SCREEN_MIDDLE-padding - threeMiddle, TIME_Y, 17, hours, 	Gfx.TEXT_JUSTIFY_RIGHT );
			//}
			for( var i = 1; i < 9; i++ ) 
			{
				if($.model.userSettings_.userColor==i)
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
					//if(showLeadingZero == true)
					//{
						dc.drawText( SCREEN_MIDDLE+padding,  TIME_Y, 17, $.model.minutes, Gfx.TEXT_JUSTIFY_LEFT );
					//}
					//else
					//{
					//	dc.drawText( SCREEN_MIDDLE+padding - threeMiddle,  TIME_Y, 17, minutes, Gfx.TEXT_JUSTIFY_LEFT );
					//}
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
			formatTimeInTextFormat($.model.hours, $.model.minutes, SCREEN_MIDDLE, TIME_Y, TIME_Y2 );	
		}
		var f1 = new Field(FIELD_COORDINATES[0][X], FIELD_COORDINATES[0][Y], Gfx.FONT_MEDIUM, "Field1",  Gfx.TEXT_JUSTIFY_CENTER );
		f1.setText();
		f1.draw(dc);
		
		var f2 = new Field(FIELD_COORDINATES[1][X], FIELD_COORDINATES[1][Y], Gfx.FONT_MEDIUM, "Field2",  Gfx.TEXT_JUSTIFY_CENTER );
		f2.setText();
		f2.draw(dc);
		
		if( $.model.userSettings_.timeInText == 2)
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
		 
		if( $.model.userSettings_.donateMe != 38425614 )
		{
			if($.model.minutes.toNumber()%2 == 0)
			{
				dc.drawText(FIELD_COORDINATES[6][X], FIELD_COORDINATES[6][Y], 10, "martin.bednar@hotmail.sk" , Gfx.TEXT_JUSTIFY_CENTER );
				dc.drawText(FIELD_COORDINATES[7][X], FIELD_COORDINATES[7][Y], 10, "Donate me :)" , Gfx.TEXT_JUSTIFY_CENTER );
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
