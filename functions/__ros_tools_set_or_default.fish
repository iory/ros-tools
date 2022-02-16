function __ros_tools_set_or_default
    set --local tmp $argv[1]
    test -z $tmp; and set tmp $argv[2]
    echo $tmp
end
