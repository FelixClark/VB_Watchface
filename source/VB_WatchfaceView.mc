using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Time.Gregorian as Calendar;

class VB_WatchfaceView extends WatchUi.WatchFace {

    function initialize() 
    {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) 
    {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() 
    {
    
    }

    // Update the view
    function onUpdate(dc) 
    {
        var timeView = View.findDrawableById("TimeLabel");
        var topRedView = View.findDrawableById("TopRedLabel");
        var bottomRedView = View.findDrawableById("BottomRedLabel");
        var leftView = View.findDrawableById("LeftLabel");
       	var rightView = View.findDrawableById("RightLabel"); 
       	
        // Get the current time and format it correctly
        var timeFormat = "$1$:$2$";
        var clockTime = System.getClockTime();
        var hours = clockTime.hour;
        if (!System.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        } else {
            if (Application.getApp().getProperty("UseMilitaryFormat")) {
                timeFormat = "$1$$2$";
                hours = hours.format("%02d");
            }
        }
        
        var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);
        timeView.setText(timeString);

		var info = Calendar.info(Time.now(), Time.FORMAT_LONG);
		var dateString = Lang.format("$1$ $2$", [info.month, info.day]);
		topRedView.setText(dateString);		
		
		
		//Steps
		var activityInfo = ActivityMonitor.getInfo();
		var steps = activityInfo.steps;
		var calories = activityInfo.calories;
		bottomRedView.setText("S"+steps.toString());

		
		//Battery		
		var stats = System.getSystemStats();
		var pwr = stats.battery;
		var batStr = Lang.format( "$1$", [ pwr.format( "%2d" ) ] );
		leftView.setText(batStr);
		
		var heartRate = GetHeartRate();
		rightView.setText(heartRate);
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }
    
    function GetHeartRate() 
    {
		var ret="--";
		var hr=Activity.getActivityInfo().currentHeartRate;
		if(hr!= null) 
		{
			ret=hr.toString();
		} 
		else 
		{
			var hrI = ActivityMonitor.getHeartRateHistory(1, true);
			var hrs = hrI.next().heartRate;
			if(hrs!=null && hrs!=ActivityMonitor.INVALID_HR_SAMPLE) 
			{
				ret=hrs.toString();
			}
		}
		return ret;
	}

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() 
    {
    
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() 
    {
    
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() 
    {
    
    }

}
