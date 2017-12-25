using Toybox.System as Sys;
using Toybox.WatchUi as Ui;
using Toybox.Lang as Lang;

class Conversions
{
	static var deviceSettings = Sys.getDeviceSettings();
	
	static function formatElevation(elevation)
	{
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
        return elevation;
	}
	
	static function ampm(hour24)
	{
		if (!Sys.getDeviceSettings().is24Hour)
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
		else
		{
			return "";
		}
	}
	
	static function formatUserDate(userDateFormat, grInfoTime)
	{
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
        return date;
	}
	
	static function formatTime(hours, minutes)
	{
		var showLeadingZero = true;
		if (!Sys.getDeviceSettings().is24Hour) 
        {
	        	amorpm1 = Conversions.ampm(hours);
	        if (hours > 12) 
	        {
	        		showLeadingZero = false;
	            	hours = hours - 12;
	        }
        }
        var minutesShift = 0;
        
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
        var timeFormat = "$1$:$2$";
        var timeString = Lang.format(timeFormat, [hours, minutes]);
      	return timeString;
	}
	
	static function formatSteps(showSecondTime, amInfo)
	{
		if(showSecondTime == 1)
        {
        		steps = amInfo.steps; // second time zone will be added 
        }
        else
        {
        		steps = amInfo.steps + " " + Ui.loadResource(Rez.Strings.steps);
        }
        return steps;
	}
	
	static function formatTimeInTextFormat(hour, minutes, SCREEN_MIDDLE, TIME_Y, TIME_Y2 )
	{
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
}
   