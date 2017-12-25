using Toybox.Application as App;

class UserSettings
{
	var steps20;
	var steps100;
	var batteryShowLimit;
	var userDateFormat;
	var hoursShift;
	var showSecondTime;
	var showDelimiter;
	var bckgColor;
	var showLine;
	var lineColor;
	var timeInText;
	var userColor;
	var donateMe;
	
	function initialize()
	{
		steps20 = secureGet("TimeeeColor20", "number", 9);
		steps100 = secureGet("TimeeeColor100", "number", 9);
		batteryShowLimit = secureGet("ShowwBattery", "number", 100);
		userDateFormat = secureGet("DateFormattt", "number", 1);
		hoursShift = secureGet("TimeZoneee", "number", 5);
		hoursShift = hoursShift - 24;
		showSecondTime = secureGet("ShowSecondTimeee", "number", 1);
		bckgColor = secureGet("BckgColor","number",1);
		showLine = secureGet("ShowLine","number",1);
		lineColor = secureGet("LineColor","number",1);
		showDelimiter = secureGet("ShowDelimiter", "number", 1);
		timeInText = secureGet("TimeInText", "number", 1 );
		userColor = secureGet("MinuteColor", "number", 1 );
		donateMe = secureGet("DonateMee", "number", 1 );
	}
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
}
   