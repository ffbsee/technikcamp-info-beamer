#!/bin/bash

export INFOBEAMER_BLANK_MODE=layer

/home/info/info-beamer-pi/info-beamer /home/info/cosin/cosin_2019 &

/home/info/cosin/cosin_2019/service &

make -B -C /home/info/cosin/cosin_2019/ all
