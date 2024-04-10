#!/bin/bash

## Set the hostname of the server
hostnamectl hostname ${hostname}

## Ensure that the server is up to date with all the current packges
DEBIAN_FRONTEND=noninteractive sudo apt update -y
DEBIAN_FRONTEND=noninteractive sudo apt upgrade -y

## Enable IP Forwarding on the router to ensure that packets will flow as required
echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
sudo sysctl -p /etc/sysctl.d/99-tailscale.conf

## Install Tailscale from the source
curl -fsSL https://tailscale.com/install.sh | sh

## Start Tailscale with the authorisation key to add it to the network
sudo tailscale up --authkey=${ts_authkey} --advertise-routes=${local_cidrs} --accept-routes