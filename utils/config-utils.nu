export def get-config [
    cfg_path: cell-path
    default?: any
]: nothing -> any {
    let user_config = $env.NUPRMCONFIG?
    return ($user_config | get $cfg_path -o | default $default)
}

export def check-type [
    cfg_path: cell-path,
    expected: list<string>,
    --null-allowed (-n)
] {
    let allow_vel = $expected ++ if $null_allowed { ["nothing"] } else { [] }
    return (get-config $cfg_path | describe -d | get "type" | $in in $allow_vel)
}

export def is-config-enable [
    cfg_path: cell-path
    default: bool
]: nothing -> bool {
    let config_vel = get-config $cfg_path $default
    return ($config_vel == true)
}
