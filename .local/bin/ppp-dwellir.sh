#!/bin/bash
ip route del default dev ppp0
ip route add 192.168.113.0/24 dev ppp0
ip route add 192.168.213.0/24 dev ppp0
ip route add 192.168.111.0/24 dev ppp0
ip route add 192.168.211.0/24 dev ppp0
ip route add 192.168.151.0/24 dev ppp0
ip route add 192.168.152.0/24 dev ppp0
ip route add 192.168.153.0/24 dev ppp0
