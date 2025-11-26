import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Math;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.ActivityMonitor; // Added for Move Bar

class MondaineFaceView extends WatchUi.WatchFace {

    var screenWidth;
    var screenHeight;
    var centerX;
    var centerY;
    var isAwake = true;

    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc as Dc) as Void {
        screenWidth = dc.getWidth();
        screenHeight = dc.getHeight();
        centerX = screenWidth / 2;
        centerY = screenHeight / 2;
    }

    function onUpdate(dc as Dc) as Void {
        // 1. Clear Background to WHITE
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        dc.clear();

        // 2. Draw Ticks
        drawTicks(dc);

        // 3. Draw Branding Text
        //drawBranding(dc);

        // 4. Draw Movement Alert (New!)
        // Check Move Bar level (0-5)
        var info = ActivityMonitor.getInfo();
        if (info.moveBarLevel != null && info.moveBarLevel > 0) {
            drawMoveAlert(dc, info.moveBarLevel);
        }

        // 5. Get Current Time
        var clockTime = System.getClockTime();
        var hour = clockTime.hour;
        var min = clockTime.min;
        var sec = clockTime.sec;

        // 6. Draw Hands (Hour -> Minute -> Second)
        
        // Hour Hand
        var hourAngle = (hour % 12) * 30 + (min / 2.0); 
        drawHourHand(dc, hourAngle, 60, 14, Graphics.COLOR_BLACK); 

        // Minute Hand
        var minAngle = min * 6;
        drawMinuteHand(dc, minAngle, 90, 10, Graphics.COLOR_BLACK); 
        // Second Hand (Red) - Hidden in sleep mode
        if (isAwake) {
            var secAngle = sec * 6;
            drawSecondHand(dc, secAngle);
        }
    }

    // --- Helper Functions ---

    function drawBranding(dc) {
        // Draw the text slightly higher to make room for move bar below
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, centerY - 65, Graphics.FONT_SYSTEM_XTINY, "MONDAINE", Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        dc.drawText(centerX, centerY - 50, Graphics.FONT_SYSTEM_XTINY, "SBB CFF FFS", Graphics.TEXT_JUSTIFY_CENTER);
    }

    function drawMoveAlert(dc, level) {
        // Draws red blocks in the bottom half
        // Level 1 = 1 Hour inactive. Level 2-5 = +15 mins each.
        
        var blockWidth = 12;
        var blockHeight = 8;
        var gap = 4;
        
        // Calculate total width to center them
        var totalWidth = (level * blockWidth) + ((level - 1) * gap);
        var startX = centerX - (totalWidth / 2);
        var startY = centerY + 55; // Positioned in the bottom half

        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        
        for (var i = 0; i < level; i++) {
            var x = startX + (i * (blockWidth + gap));
            // Fill rectangle for the block
            dc.fillRectangle(x, startY, blockWidth, blockHeight);
        }
    }

    function drawTicks(dc) {
        var radius = (screenWidth / 2) - 15; 
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);

        for (var i = 0; i < 60; i++) {
            var angle = i * 6 * Math.PI / 180;
            var cos = Math.cos(angle);
            var sin = Math.sin(angle);

            var x1 = centerX + radius * sin;
            var y1 = centerY - radius * cos;

            var tickLength;
            var tickWidth;

            if (i % 5 == 0) {
                tickLength = 35;
                tickWidth = 10;
            } else {
                tickLength = 15;
                tickWidth = 4;
            }

            var x2 = centerX + (radius - tickLength) * sin;
            var y2 = centerY - (radius - tickLength) * cos;

            dc.setPenWidth(tickWidth);
            dc.drawLine(x1, y1, x2, y2);
        }
    }

    function drawHourHand(dc, angleDeg, lengthPercent, width, color) {
        var angleRad = angleDeg * Math.PI / 180;
        var handLen = (screenWidth / 2) * (lengthPercent / 100.0);
        var tailLen = 15; 

        var x1 = centerX + handLen * Math.sin(angleRad);
        var y1 = centerY - handLen * Math.cos(angleRad);
        var x2 = centerX - tailLen * Math.sin(angleRad);
        var y2 = centerY + tailLen * Math.cos(angleRad);

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(width);
        dc.drawLine(x2, y2, x1, y1);
        dc.fillCircle(centerX, centerY, width / 2);
    }

    function drawMinuteHand(dc, angleDeg, lengthPercent, width, color) {
        var angleRad = angleDeg * Math.PI / 180;
        var handLen = (screenWidth / 2) * (lengthPercent / 100.0);
        var tailLen = 15; 

        var x1 = centerX + handLen * Math.sin(angleRad);
        var y1 = centerY - handLen * Math.cos(angleRad);
        var x2 = centerX - tailLen * Math.sin(angleRad);
        var y2 = centerY + tailLen * Math.cos(angleRad);

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(width);
        dc.drawLine(x2, y2, x1, y1);
        dc.fillCircle(centerX, centerY, width / 2);
    }

    function drawSecondHand(dc, angleDeg) {
        var angleRad = angleDeg * Math.PI / 180;
        var handLen = (screenWidth / 2) * 0.70;
        var tailLen = 40;

        var xStart = centerX - tailLen * Math.sin(angleRad);
        var yStart = centerY + tailLen * Math.cos(angleRad);
        var xEnd = centerX + handLen * Math.sin(angleRad);
        var yEnd = centerY - handLen * Math.cos(angleRad);

        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        
        dc.setPenWidth(5);
        dc.drawLine(xStart, yStart, xEnd, yEnd);

        var circleRadius = 14;
        var paddleX = centerX + (handLen + circleRadius - 4) * Math.sin(angleRad);
        var paddleY = centerY - (handLen + circleRadius - 4) * Math.cos(angleRad);
        
        dc.fillCircle(paddleX, paddleY, circleRadius);
        dc.fillCircle(centerX, centerY, 6);
    }

    function onExitSleep() {
        isAwake = true;
        WatchUi.requestUpdate();
    }

    function onEnterSleep() {
        isAwake = false;
        WatchUi.requestUpdate();
    }
}