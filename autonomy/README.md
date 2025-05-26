This app should take in thrust and rudder angle 
This app should output position and heading (x,y and lat,lon)

To do this, we need to convert thrust and rudder to speed and heading,
based not just on the current speed and heading, but on the additional vectors
of current/wind as well as any dampening on the surface of the water

Let's start with thrust to speed. 
Simply put, speed is how fast you are going, plus how much faster you will go with an added thrust vector.

# basically as thrust and rudder are coming in,
# the current position of the vessel will be added to
# the current 