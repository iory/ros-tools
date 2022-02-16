# fish plugin for ROS

## Install

```
fisher install iory/ros-tools
```

## Quick Start

Set ROS_IP.

```
$ rossetip
set ROS_IP and ROS_HOSTNAME to 192.168.97.37
$ echo $ROS_IP
192.168.97.37
```

Set ROS_MASTER_URI.

```
$ rossetmaster 192.168.97.37
set ROS_MASTER_URI to http://192.168.97.37:11311
$ echo $ROS_MASTER_URI
http://192.168.97.37:11311
```
