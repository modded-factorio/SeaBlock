#!/bin/sh
FACTORIO=~/factorio18
mkdir -p graphics/technology
convert $FACTORIO/data/base/graphics/item-group/signals.png \
  -adaptive-resize 128x128 -unsharp 0x0.75+0.75+0.008 -modulate 100,100,35 \
  graphics/technology/basic-circuit-board.png
convert $FACTORIO/data/base/graphics/entity/iron-ore/hr-iron-ore.png \
  -crop 128x128+0+0 graphics/technology/ore.png
convert $FACTORIO/data/base/graphics/entity/coal/hr-coal.png \
  -crop 128x128+128+0 -modulate 160,0,0 graphics/technology/coal.png
convert $FACTORIO/data/base/graphics/entity/lab/hr-lab.png \
  -crop 194x174+194+0 -resize 128x128 -gravity center -background transparent -extent 128x128 \
  graphics/technology/lab.png
