#Shake!

## Description

Shake! is a re-write of Apple's AccelerometerGraph App that includes additional features:

* Apple's GraphView, GraphViewSegment and GraphTextView classes have been split out into separate files, made more size independent, and the traces re-configured to suit Shake!'s requirement.
* Each accelerometer axis now has its own graph.  These graphs display 4 distinct traces:
  * The raw signal
  * The filtered signal
  * The RMS value of the filtered signal
  * Indication that the RMS level has exceeded a trigger level.
* The raw signal for each axis can be independently selected from:
  * The hardware acclerometer for that axis
  * A Sine Wave of variable frequency and amplitude
  * A Step
  * An Impulse.
* The filtering of each axis can be independently selected from:
  * No filtering (Pass Through)
  * Apple's 5 Hz 1st order Low Pass filter
  * Apple's 5 Hz 1st order High Pass filter
  * Butterworth 2nd order, 5 Hz Low Pass filter
  * Butterworth 2nd order, 5 Hz High Pass filter
  * Butterworth 2nd order, 1 Hz to 3 Hz Band Pass filter
  * Butterworth 2nd order, 2.5 Hz to 5 Hz Band Pass filter
* The RMS level detection calculates the RMS value of the filtered signal over a rolling sample window, and detects a trigger event if that value exceeds a fixed value for a contiguous number of samples.  This calculation is independently defined for each axis.
* In addition to independently configuring each axis, the configuration of all the axes can be set at one time through an "All Axes" configuration option.

## License

This application is released under a BSD-3 license. So you are basically free to do what ever you want as long as you acknowledge me and keep the copyright notices intact. 

## Versions supported

iOS Versions supported: 4 5 and 6
iPod/iPhones supported: 3.5 and 4 inch screens
iPad Supported:         Yes, but not really designed for the iPad (I will be working on that)


## Screen shots


![Main screen](http://github.com/JoalahDesigns/Shake/raw/master/Shake_1_Main.png) &nbsp; ![Setup Overview](http://github.com/JoalahDesigns/Shake/raw/master/Shake_2_Setup.png)

![Axis Setup](http://github.com/JoalahDesigns/Shake/raw/master/Shake_3_Setup.png) &nbsp; ![Signal Source](http://github.com/JoalahDesigns/Shake/raw/master/Shake_4_Setup.png)

![Filter Setup](http://github.com/JoalahDesigns/Shake/raw/master/Shake_5_Setup.png) &nbsp; ![Level Detection](http://github.com/JoalahDesigns/Shake/raw/master/Shake_6_Setup.png)

![Credits screen](http://github.com/JoalahDesigns/Shake/raw/master/Shake_7_Credits.png)
