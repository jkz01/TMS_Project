#!/bin/bash
apt update -y
apt upgrade -y
apt install software-properties-common -y
add apt-repository ppa:deadsnakes/ppa -y
apt install python3.9 python3-pip -y