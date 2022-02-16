function __ros_tools_ros_ip_mode_prompt
    set --local master_host (echo $ROS_MASTER_URI | cut -d\/ -f3 | cut -d\: -f1)
    if [ $master_host = "localhost" ]
    else if [ $master_host != "" ]
        set --local ros_prompt "[$ROS_MASTER_URI][$ROS_IP]"
        set_color red
        echo -n "$ros_prompt"
        set_color normal
    end
end
