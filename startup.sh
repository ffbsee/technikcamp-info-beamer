#!/bin/bash

export INFOBEAMER_BLANK_MODE=layer

/home/info/info-beamer-pi/info-beamer /home/info/content/content &

/home/info/content/service &

make -B -C /home/info/content/ all
