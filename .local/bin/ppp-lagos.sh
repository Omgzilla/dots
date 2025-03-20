#!/bin/bash
ip route del default dev ppp0
ip route add 192.168.161.0/24 dev ppp0
ip route add 192.168.162.0/24 dev ppp0
ip route add 192.168.163.0/24 dev ppp0
