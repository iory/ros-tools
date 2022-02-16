function set_or_default
    set --local tmp $argv[1]
    test -z $tmp; and set tmp $argv[2]
    echo $tmp
end


function unset
    set --erase $argv
end


function ros_mode_prompt
    set --local master_host (echo $ROS_MASTER_URI | cut -d\/ -f3 | cut -d\: -f1)
    if [ $master_host = "localhost" ]
    else if [ $master_host != "" ]
        set --local ros_prompt "[$ROS_MASTER_URI][$ROS_IP]"
        set_color red
        echo -n "$ros_prompt"
        set_color normal
    end
end


function rossetip_dev
    set --local device (set_or_default $argv[1] '(eth|wl|en|lo)[0-9]*')
    set -gx ROS_IP (LANG=C ip -o -4 a | grep -E "^[0-9]+: $device" | tail -n1 | sed -e 's@^.*inet *\([0-9\.]*\).*$@\1@g')
    set -gx ROS_HOSTNAME $ROS_IP
end


function rossetip_addr
    set --local target_host (set_or_default $argv[1] '(eth|wl|en|lo)[0-9]*' "127.0.0.1")
    # Check if target_host looks like ip address or not
    if [ (echo $target_host | sed -e 's/[0-9\.]//g') != "" ]
        set --local target_host_ip (timeout 0.01 getent hosts $target_host | cut -f 1 -d ' ')
        if [ "$target_host_ip" = "" ]
            echo -e "\e[1;31mCould not resolve ip from address. Subnet may be different\e[m"
            rossetip_dev
            return 0
        end
        set --local target_host $target_host_ip
    end
    set -gx ROS_IP (ip -o -4 route get $target_host | sed -e 's/^.*src \([0-9.]\+\).*$/\1/g')
    set -gx ROS_HOSTNAME $ROS_IP
end


function rossetip
    set --local device (set_or_default $argv[1] '(eth|wl|en|lo)[0-9]*')
    string match -rq '^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\\.|$)){4}$'
    if test $status -eq 0
        set -gx ROS_IP "$device"
    else
        set -gx ROS_IP ""
        set --local master_host (echo $ROS_MASTER_URI | cut -d\/ -f3 | cut -d\: -f1)
        if [ $master_host != "localhost" ]
            rossetip_addr $master_host
        end
        if [ $ROS_IP = "" ]
            rossetip_dev $device
        end
    end
    set -gx ROS_HOSTNAME $ROS_IP
    if [ $ROS_IP = "" ]
        unset ROS_IP
        unset ROS_HOSTNAME
        echo -e "\e[1;31munable to set ROS_IP and ROS_HOSTNAME\e[m" >&2
        return 1
    else
        echo -e "\e[1;31mset ROS_IP and ROS_HOSTNAME to $ROS_IP\e[m"
    end
    function fish_mode_prompt
        ros_mode_prompt
    end
end


function rossetmaster
    switch (count $argv)
        case 0
            set -a argv ""
            set -a argv ""
        case 1
            set -a argv ""
    end
    set --local hname (set_or_default $argv[1] "localhost")
    set --local rosport (set_or_default $argv[2] "11311")
    set -gx ROS_MASTER_URI "http://$hname:$rosport"
    function fish_mode_prompt
        ros_mode_prompt
    end
    set_color red
    echo "set ROS_MASTER_URI to $ROS_MASTER_URI"
    set_color normal
end


function rossetlocal
    set --local rosport (set_or_default $argv[1] "11311")
    rossetmaster localhost $rosport
    function fish_mode_prompt
        ros_mode_prompt
    end
end
