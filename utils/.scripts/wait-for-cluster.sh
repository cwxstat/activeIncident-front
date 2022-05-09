#!/bin/bash
while [ $(kubectl get po -A|grep 'Running'|wc -l) -lt 9 ];do sleep 2;kubectl get po -A; done
