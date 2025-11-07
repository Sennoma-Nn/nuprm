let colors = {
    white: (color2ansi 255 255 255 "fg" 37),
    green: (color2ansi 80 161 79 "fg" 32),
    red: (color2ansi 228 86 73 "fg" 31),
    reset: (ansi reset)
}

def create-left-prompt [] {
    let exit_code = get-exit-code
    let status_color = if $exit_code == 0 { $colors.green } else { $colors.red }
    let status_mark = if $exit_code != 0 { $" ($status_color)×($colors.reset) ($exit_code)" } else { "" }
    let host_name = get-host -l $"($status_color) @ ($colors.white)"
    let user_name = $"($colors.white)(get-user-name)"
    let user_host = $"($user_name)($host_name)"
    let path_info = $env.PWD | format-path -u (if (is-windows) { "\\" } else { "/" }) -d $"($status_color)" -s $"($colors.white)" -r "\e[0m" -u
    let path_show = $"[ ($path_info) ($colors.white)]"
    let git_info = (get-git-info -l $" in ($status_color)" -r $colors.reset)
    let execution_time = if (get-execution-time-s) > 0.5 { $" ($status_color)- ($colors.white)(get-execution-time-s)sec" } else { "" }

    return $"($colors.white)╭── ($user_host) ($path_show)($status_mark)($git_info)($execution_time)\n($colors.white)╰─($colors.reset)"
}

$env.PROMPT_COMMAND = {|| create-left-prompt }
$env.PROMPT_COMMAND_RIGHT = {||}
$env.PROMPT_INDICATOR = $"($colors.white)○ ($colors.reset)"
$env.PROMPT_MULTILINE_INDICATOR = $"($colors.white)──◇ ($colors.reset)"
$env.PROMPT_INDICATOR_VI_INSERT = $"($colors.white)◉ ($colors.reset)"
$env.PROMPT_INDICATOR_VI_NORMAL = $env.PROMPT_INDICATOR
$env.TRANSIENT_PROMPT_COMMAND = {||}
$env.TRANSIENT_PROMPT_COMMAND_RIGHT = ""
$env.TRANSIENT_PROMPT_INDICATOR = $env.PROMPT_INDICATOR
$env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = $"($colors.white)◇ ($colors.reset)"
$env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = $env.PROMPT_INDICATOR_VI_INSERT
$env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = $env.PROMPT_INDICATOR_VI_NORMAL
