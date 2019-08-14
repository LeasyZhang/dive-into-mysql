#!/bin/sh

#http_load -parallel 1 -seconds 10 urls.txt

#http_load -parallel 5 -seconds 10 urls.txt

http_load -rate 5 -seconds 10 urls.txt