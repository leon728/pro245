import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Time;
import Toybox.Time.Gregorian;
using Toybox.ActivityMonitor;

class pro245View extends WatchUi.WatchFace {
    const arrWeek = ["", "日", "一", "二", "三", "四", "五", "六"];
    var timeFont;
    var datetime;
    var settings;
    var stats;

    function initialize() {
        WatchFace.initialize();
        timeFont = WatchUi.loadResource(Rez.Fonts.timeFont);
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        // setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // System.println("go");
        datetime = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        settings = System.getDeviceSettings();
        stats = System.getSystemStats();

        // setTimeLabel();
        // setDateLabel();
        // setBatteryLabel();
        // setNotifyLabel();

        // Call the parent onUpdate function to redraw the layout
        // View.onUpdate(dc);

        // var app = getApp();
        // var backgroundColor = app.getProperty("BackgroundColor");

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        var width = dc.getWidth();
        var height = dc.getHeight();
        var xcenter = width/2;
        var ycenter = height/2;

        // dc.drawLine(0, ycenter, width, ycenter); // ---
        // dc.drawLine(xcenter, 0, xcenter, height); //  |

        // dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
        // dc.fillRoundedRectangle(5, 79, 230, 81, 10);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(xcenter, ycenter-75, timeFont, setTimeLabel(), Graphics.TEXT_JUSTIFY_CENTER); // noto:(xcenter,45), bebas:(xcenter,52)
        dc.drawText(xcenter, ycenter-106, Graphics.FONT_SMALL, setNotifyLabel(), Graphics.TEXT_JUSTIFY_CENTER);
        // dc.setPenWidth(3);
        // dc.drawLine(0, 75, width, 75);
        // dc.drawLine(0, 165, width, 165);
        // dc.drawLine(105, 39, 135, 39);
        // dc.drawRoundedRectangle(5, 79, 230, 81, 10);

        // dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        // dc.setColor(Graphics.COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
        // dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
        dc.setColor(0x00ffff, Graphics.COLOR_TRANSPARENT);
        dc.drawText(xcenter, ycenter+50, Graphics.FONT_SMALL, setDateLabel(), Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(xcenter, ycenter-74, Graphics.FONT_SMALL, setBatteryLabel(), Graphics.TEXT_JUSTIFY_CENTER);

        // var info = ActivityMonitor.getInfo();
        // dc.drawText(60, 45, Graphics.FONT_SMALL, info.steps, Graphics.TEXT_JUSTIFY_CENTER);
        // dc.drawText(180, 45, Graphics.FONT_SMALL, info.calories, Graphics.TEXT_JUSTIFY_CENTER);
    }

    function setTimeLabel() {
        // var clockTime = System.getClockTime();
        // var hour = clockTime.hour;
        // var min = clockTime.min;
        var hour = datetime.hour;
        var min = datetime.min;

        // var amLabel = View.findDrawableById("AmLabel");
        // var pmLabel = View.findDrawableById("PmLabel");
        // if(hour < 12) {
        //     amLabel.setText("A");
        //     pmLabel.setText("");
        // }
        // else {
        //     amLabel.setText("");
        //     pmLabel.setText("P");
        // }

        if(!settings.is24Hour) {
            // (12, 1, 2, ..., 11), (12, 1, 2, ... 11)
            // hour %= 12;
            // if(hour == 0) {
            //     hour = 12;
            // }

            // (0, 1, 2, ..., 11), (12, 1, 2, ..., 11)
            if(hour > 12) {
                hour -= 12;
            }
        }
        // var str = Lang.format("$1$:$2$", [hour.format("%02d"), min.format("%02d")]);
        var str = hour.format("%02d") +":"+ min.format("%02d");
        // View.findDrawableById("TimeLabel").setText(str);
        return str;
    }

    function setDateLabel() {
        // var datetime = Gregorian.info(Time.today(), Time.FORMAT_SHORT);
        var str = datetime.month +"/"+ datetime.day +" 週"+ arrWeek[datetime.day_of_week];
        // View.findDrawableById("DateLabel").setText(str);
        return str;
    }

    function setBatteryLabel() {
        var str = "  " + stats.battery.format("%d") + "%";
        // View.findDrawableById("BatteryLabel").setText(str);
        return str;
    }

    function setNotifyLabel() {
        var str;
        if(settings.phoneConnected) {
            var notifyCount = settings.notificationCount;
            if(notifyCount == 0) {
                str = "";
            }
            else if(notifyCount > 9) {
                str = "#9+";
            }
            else {
                str = "#" + notifyCount;
                // str = "3";
                // str = "(3)";
                // str = "/3/";
                // str = "[3]";
                // str = "|3|";

                // str = "# 3";
                // str = "! 3";
            }
        }
        else {
            str = "--";
        }
        // View.findDrawableById("NotifyLabel").setText(str);
        return str;
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

}
