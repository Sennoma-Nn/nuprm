export def get-config [
    cfg_path: cell-path
    default?: any
]: nothing -> any {
    let user_config = $env.NUPRMCONFIG?
    return ($user_config | do -i { get $cfg_path -o } | default $default)
}

export def check-config-type [
    cfg_path: cell-path,
    expected: list<string>,
    --null-allowed (-n)
] {
    let allow_vel = $expected ++ if $null_allowed { ["nothing"] } else { [] }
    return (get-config $cfg_path | describe -d | get "type" | $in in $allow_vel)
}

export def find-config-type-error [
    cfg_path_list: list<cell-path>,
    expected: list<string>
    --null-allowed (-n)
] {
    let list = $cfg_path_list | each {|cfg_path|
        if not (check-config-type --null-allowed=$null_allowed $cfg_path $expected) {
            return $cfg_path
        }
    }
    return $list
}

export def is-config-enable [
    cfg_path: cell-path
    default: bool
]: nothing -> bool {
    let config_vel = get-config $cfg_path $default
    return ($config_vel == true)
}
