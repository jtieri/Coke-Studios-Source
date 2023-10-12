property DEFAULT_SCENE_LOC, DEFAULT_SCENE_WIDTH, DEFAULT_SCENE_HEIGHT, DEFAULT_MAX_HEIGHT, DEFAULT_MAX_HEIGHT_OFFSET, DEFAULT_HEIGHT, DEFAULT_ROW, DEFAULT_COL, DEFAULT_LAYOUT_TYPE, DEFAULT_LG_LAYOUT_TYPE, DEFAULT_LG_XOFF, DEFAULT_LG_YOFF, DEFAULT_SQSIZE, DEFAULT_LG_SQSIZE, DEFAULT_ROWS, DEFAULT_COLS, DEFAULT_LG_ROWS, DEFAULT_LG_COLS, DEFAULT_YROT, DEFAULT_XROT, DEFAULT_XOFF, DEFAULT_YOFF, DEFAULT_GRID_DEPTH, DEFAULT_BACKGROUND_DEPTH, DEFAULT_HOTSPOT_DEPTH, DEFAULT_START_DEPTH, DEFAULT_DEPTH_OFF, aLayerMap, DEFAULT_LAYERS, DEFAULT_LAYER, DEFAULT_SPRITE_COUNTER, DEFAULT_SPRITE_COUNTER_MAX, DEFAULT_FPS, DEFAULT_SEQUENCE_RATE, BURNED_CD, TELEPORTER, GOLD_RECORD, PLATINUM_RECORD, DEFAULT_MAX_ITEMS

on new me
  me.DEFAULT_MAX_ITEMS = 100
  me.DEFAULT_SCENE_LOC = point(0, 0)
  me.DEFAULT_SCENE_WIDTH = 760
  me.DEFAULT_SCENE_HEIGHT = 470
  me.DEFAULT_MAX_HEIGHT = 20
  me.DEFAULT_MAX_HEIGHT_OFFSET = 100
  me.DEFAULT_HEIGHT = 0
  me.DEFAULT_ROW = 0
  me.DEFAULT_COL = 0
  me.DEFAULT_LAYOUT_TYPE = 1
  me.DEFAULT_SQSIZE = 34
  me.DEFAULT_ROWS = 30
  me.DEFAULT_COLS = 30
  me.DEFAULT_XOFF = 380
  me.DEFAULT_YOFF = -11
  me.DEFAULT_LG_LAYOUT_TYPE = 2
  me.DEFAULT_LG_SQSIZE = 51
  me.DEFAULT_LG_ROWS = 15
  me.DEFAULT_LG_COLS = 15
  me.DEFAULT_LG_XOFF = 380
  me.DEFAULT_LG_YOFF = -35
  me.DEFAULT_YROT = 45
  me.DEFAULT_XROT = 30
  me.DEFAULT_GRID_DEPTH = 5
  me.DEFAULT_BACKGROUND_DEPTH = 6
  me.DEFAULT_HOTSPOT_DEPTH = 7
  me.DEFAULT_START_DEPTH = 10
  me.DEFAULT_DEPTH_OFF = 10
  me.aLayerMap = [:]
  me.aLayerMap.addProp("Base", 1)
  me.aLayerMap.addProp("00", 2)
  me.aLayerMap.addProp("sd", 3)
  me.aLayerMap.addProp("a", 4)
  me.aLayerMap.addProp("a2", 5)
  me.aLayerMap.addProp("avsd", 6)
  me.aLayerMap.addProp("av", 7)
  me.aLayerMap.addProp("00", 8)
  me.aLayerMap.addProp("b", 9)
  me.aLayerMap.addProp("c", 10)
  me.aLayerMap.addProp("d", 11)
  me.aLayerMap.addProp("e", 12)
  me.aLayerMap.addProp("f", 13)
  me.aLayerMap.addProp("g", 14)
  me.aLayerMap.addProp("h", 15)
  me.aLayerMap.addProp("00", 16)
  me.aLayerMap.addProp("00", 17)
  me.aLayerMap.addProp("00", 18)
  me.aLayerMap.addProp("00", 19)
  me.aLayerMap.addProp("00", 20)
  me.DEFAULT_LAYERS = me.aLayerMap.count * (me.DEFAULT_MAX_HEIGHT + 1)
  me.DEFAULT_LAYER = 1
  me.DEFAULT_SPRITE_COUNTER = 50
  me.DEFAULT_SPRITE_COUNTER_MAX = 750
  me.DEFAULT_FPS = 60
  me.DEFAULT_SEQUENCE_RATE = 600
  me.BURNED_CD = 89
  me.TELEPORTER = 61
  me.GOLD_RECORD = 82
  me.PLATINUM_RECORD = 83
  set the floatPrecision to 2
  return me
end
