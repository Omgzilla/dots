#!/bin/bash
ip route del default dev ppp0
ip route del 10.0.0.0/24 dev wlp9s0
ip route add 10.0.0.0/22 dev ppp0
ip route add 10.99.0.0/24 dev ppp0
