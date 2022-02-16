function __ros_tools_rossetip_dev
    set --local device (__ros_tools_set_or_default $argv[1] '(eth|wl|en|lo)[0-9]*')
    set -gx ROS_IP (LANG=C ip -o -4 a | grep -E "^[0-9]+: $device" | tail -n1 | sed -e 's@^.*inet *\([0-9\.]*\).*$@\1@g')
    set -gx ROS_HOSTNAME $ROS_IP
end
