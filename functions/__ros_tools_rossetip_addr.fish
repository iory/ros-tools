function __ros_tools_rossetip_addr
    set --local target_host (__ros_tools_set_or_default $argv[1] '(eth|wl|en|lo)[0-9]*' "127.0.0.1")
    # Check if target_host looks like ip address or not
    if [ (echo $target_host | sed -e 's/[0-9\.]//g') != "" ]
        set --local target_host_ip (timeout 0.05 getent hosts $target_host | cut -f 1 -d ' ')
        if [ -z $target_host_ip ]
            echo -e "\e[1;31mCould not resolve ip from address. Subnet may be different\e[m"
            __ros_tools_rossetip_dev
            return 0
        end
        set --local target_host $target_host_ip
        set -gx ROS_IP (ip -o -4 route get $target_host | sed -e 's/^.*src \([0-9.]\+\).*$/\1/g')
    else
        set -gx ROS_IP (ip -o -4 route get $target_host | sed -e 's/^.*src \([0-9.]\+\).*$/\1/g')
    end
    set -gx ROS_HOSTNAME $ROS_IP
end
