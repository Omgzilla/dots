#!/bin/bash
ip route del default dev ppp0
#ip route add 192.168.96.0/24 dev ppp0
ip route add 192.168.100.0/24 dev ppp0
