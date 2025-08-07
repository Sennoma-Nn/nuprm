let colors = {
    white: (ansi -e '0;37m'),
    green: (ansi -e '0;32m'),
    red: (ansi -e '0;31m'),
    reset: (ansi reset)
}

def create-left-prompt [] {
    let status_color = if $env.LAST_EXIT_CODE == 0 { $colors.green } else { $colors.red }
    let status_mark = if $env.LAST_EXIT_CODE != 0 { $" ($status_color)×($colors.reset) ($env.LAST_EXIT_CODE)" } else { "" }
    
    let user_host = $"($colors.white)(get-user-name) ($status_color)@ ($colors.white)(hostname)"
    let path_info = $"[ ($status_color)(format-path -hu $env.PWD (if (is-windows) { "\\" } else { "/" })) ($colors.white)]"
    let git_info = (get-git-info -l $" in ($status_color)" -r $colors.reset)

    return $"($colors.white)╭── ($user_host) ($path_info)($status_mark)($git_info)\n($colors.white)╰─($colors.reset)"
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
