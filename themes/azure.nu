let prompt_colors = {
    gunjyou: (color2ansi 82 139 255 fg 34)
    white: (color2ansi 255 255 255 fg 37)
}

let using_colors = [$prompt_colors.gunjyou, $prompt_colors.white]

def create-left-prompt [
    --colors: list (-c) = ["\e[0m", "\e[0m"]
] {
    let user_name = get-user-name
    let host_name = get-host -l $"($colors.1) at ($colors.0)"
    let user_host = $"($user_name)($host_name) "
    let shells_index = get-where-shells -dl $"($colors.1)№" -r $"($colors.0) : "
    let path_segment = $env.PWD | format-path (if (is-windows) { "\\" } else { "/" }) -d $"\e[0;1m($colors.1)" -s "\e[0;2m" -r "\e[0m" -u
    let execution_time = if (get-execution-time-s) > 0.5 { $" ($colors.1)(get-execution-time-s)sec " } else { "" }
    let git_info = get-git-info -l $"($colors.1) in ($colors.0)" -r (if ($execution_time | is-empty) { " " } else { "" })
    let exit_code = if (get-exit-code) != 0 { $"(get-exit-code)($colors.1) | " } else { "" }

    return $"($colors.0)($exit_code)($colors.0)($user_host)\e[1m[ ($shells_index)\e[0;1m($colors.1)($path_segment)($colors.0) \e[1m]($git_info)($execution_time)(ansi reset)"
}

$env.PROMPT_COMMAND = {|| create-left-prompt -c $using_colors }
$env.PROMPT_COMMAND_RIGHT = {||}
$env.PROMPT_INDICATOR = $"($using_colors.0)(if (is-admin) { "#" } else { "$" }) (ansi reset)"
$env.PROMPT_MULTILINE_INDICATOR = $"($using_colors.0)>>> (ansi reset)"
$env.PROMPT_INDICATOR_VI_INSERT = $"($using_colors.0): (ansi reset)"
$env.PROMPT_INDICATOR_VI_NORMAL = $env.PROMPT_INDICATOR
$env.TRANSIENT_PROMPT_COMMAND = {||}
$env.TRANSIENT_PROMPT_COMMAND_RIGHT = ""
$env.TRANSIENT_PROMPT_INDICATOR = $env.PROMPT_INDICATOR
$env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = $"($using_colors.0)> (ansi reset)"
$env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = $env.PROMPT_INDICATOR_VI_INSERT
$env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = $env.PROMPT_INDICATOR_VI_NORMAL
