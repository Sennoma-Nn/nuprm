const enable_vel = ["yes", true]

export def get-config [
    item: cell-path
    default: any
]: nothing -> any {
    let user_config = $env.NUPRMCONFIG
    return ($user_config | get $item -o | default $default)
}

export def is-config-enable [
    item: cell-path
    default: bool
]: nothing -> bool {
    let config_vel = get-config $item $default
    return ($config_vel in $enable_vel)
}