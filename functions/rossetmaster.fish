function rossetmaster
    # switch (count $argv)
    #     case 0
    #         set -a argv ""
    #         set -a argv ""
    #     case 1
    #         set -a argv ""
    # end
    set --local hname (__ros_tools_set_or_default $argv[1] "localhost")
    set --local rosport (__ros_tools_set_or_default $argv[2] "11311")
    set -gx ROS_MASTER_URI "http://$hname:$rosport"
    function fish_mode_prompt
        __ros_tools_ros_ip_mode_prompt
    end
    set_color red
    echo "set ROS_MASTER_URI to $ROS_MASTER_URI"
    set_color normal
end
