native.setProperty( "windowMode", "maximized" )
native.setProperty( "mouseCursor", "pointingHand" )

local composer = require ("composer")
math.randomseed (os.time())
display.setStatusBar (display.HiddenStatusBar)

audio.reserveChannels (1, 2, 3, 4, 5, 6, 7, 8)
audio.setVolume (0.05, {channel=1})
audio.setVolume (0.1, {channel=2})
audio.setVolume (0.2, {channel=3})
audio.setVolume (0.3, {channel=4})
audio.setVolume (0.4, {channel=5})
audio.setVolume (0.5, {channel=6})
audio.setVolume (0.15, {channel=7})
audio.setVolume (0.6, {channel=8})

composer.gotoScene ("logo", {time=800, effect="crossFade"})