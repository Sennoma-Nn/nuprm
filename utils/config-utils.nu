const enable_vel = ["yes", true]
const disenable_vel = ["no", false]

export def get-config [
    item: cell-path
    default?: any
]: nothing -> any {
    let user_config = $env.NUPRMCONFIG?
    return ($user_config | get $item -o | default $default)
}

export def is-config-bool [
    item: cell-path
    --null-allowed (-n)
]: nothing -> bool {
    let bool_vel = $enable_vel ++ $disenable_vel ++ if $null_allowed { [null] } else { [] }
    let config_vel = get-config $item
    return ($config_vel in $bool_vel)
}

export def is-config-enable [
    item: cell-path
    default: bool
]: nothing -> bool {
    let config_vel = get-config $item $default
    return ($config_vel in $enable_vel)
}
