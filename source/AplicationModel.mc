using Toybox.ActivityMonitor as Am;
using Toybox.Activity as Act;
using Toybox.System as Sys;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Gregorian;


class AplicationModel
{
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
	var amInfo = "";
	var userSettings_;
	
	var notificationCount = "";
	var phoneConnected = "";
	hidden var deviceSettings;
	var numberOfAlarms;
	hidden var weekDayTmp;
	var grInfoTime;
	hidden var clockTime;
    var hours;
    var minutes;
	
	function initialize()
	{
		userSettings_ = new UserSettings();
		update();
	}
	function update()
	{
		elevation = Act.getActivityInfo().altitude;
		amInfo = Am.getInfo();
		steps = amInfo.steps;
		deviceSettings = Sys.getDeviceSettings();
		notificationCount = deviceSettings.notificationCount;
		phoneConnected = deviceSettings.phoneConnected;
		battery = Sys.getSystemStats().battery.toNumber();
		deviceSettings = Sys.getDeviceSettings();
		numberOfAlarms = deviceSettings.alarmCount;
		//grInfoTime = Gregorian.info(timeTmp, Time.FORMAT_SHORT);
		//weekdayTmp = grInfoTime.day_of_week;
		clockTime =  Sys.getClockTime();
        hours = clockTime.hour;
        minutes = clockTime.min;
	}
}
   