-- Hide status bar
display.setStatusBar(display.HiddenStatusBar)

-- Load Composer scene manager
local composer = require("composer")

-- Start first scene (menu)
composer.gotoScene("scenes.scene_menu")