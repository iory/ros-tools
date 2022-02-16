function rossetlocal
    set --local rosport (__ros_tools_set_or_default $argv[1] "11311")
    rossetmaster localhost $rosport
    function fish_mode_prompt
        __ros_tools_ros_ip_mode_prompt
    end
end
