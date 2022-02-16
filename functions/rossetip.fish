function rossetip
    set --local device (__ros_tools_set_or_default $argv[1] '(eth|wl|en|lo)[0-9]*')
    string match -rq '^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\\.|$)){4}$' $device
    if test $status -eq 0
        set -gx ROS_IP $device
    else
        set -gx ROS_IP ""
        set --local master_host (echo $ROS_MASTER_URI | cut -d\/ -f3 | cut -d\: -f1)
        if [ $master_host != "localhost" ]
            __ros_tools_rossetip_addr $master_host
        end
        if [ -z $ROS_IP ]
            __ros_tools_rossetip_dev $device
        end
    end
    set -gx ROS_HOSTNAME $ROS_IP
    if [ -z $ROS_IP ]
        set --erase ROS_IP
        set --erase ROS_HOSTNAME
        echo -e "\e[1;31munable to set ROS_IP and ROS_HOSTNAME\e[m" >&2
        return 1
    else
        echo -e "\e[1;31mset ROS_IP and ROS_HOSTNAME to $ROS_IP\e[m"
    end
    function fish_mode_prompt
        __ros_tools_ros_ip_mode_prompt
    end
end
