let colors = {
    purple: (color2ansi 180 100 255 fg 35),
    blue: (color2ansi 100 150 255 fg 34),
    pink: (color2ansi 255 100 200 fg 95),
    star: (color2ansi 255 255 150 fg 33),
    reset: (ansi reset)
}

def create-left-prompt [] {
    let user_name = $"✨ ($colors.purple)🚀 ($colors.pink)(get-user-name)"
    let host_name = get-host -l $"($colors.purple) at ($colors.pink)"
    let user_host = $"($user_name)($host_name) ✨"
    let path_seg = $"($colors.blue)🪐 " + ($env.PWD | format-path (if (is-windows) { "\\" } else { "/" }) -d $"($colors.purple)" -s $"($colors.pink)" -r "\e[0m" -u)
    let git_info = (get-git-info -l " (" -r ")")
    let git_status = if ($git_info | str length) > 0 {
        $" ($colors.star)🌟($git_info)"
    } else { "" }
    let exit_status = if $env.LAST_EXIT_CODE != 0 {
        $" ($colors.pink)💥 [($env.LAST_EXIT_CODE)]"
    } else { "" }
    return $"($user_host)\n($path_seg)($git_status)($exit_status)\n"
}

def create-right-prompt [] {
    let shells_index = get-where-shells -dl $"№" -r $" "
    return $"($colors.blue)($shells_index)⌛ (date now | format date '%H:%M')"
}

$env.PROMPT_COMMAND = {|| create-left-prompt }
$env.PROMPT_COMMAND_RIGHT = {|| create-right-prompt } 
$env.PROMPT_INDICATOR = $"($colors.pink)➜ ($colors.reset)"
$env.PROMPT_MULTILINE_INDICATOR = $"($colors.purple)· ($colors.reset)"
$env.PROMPT_INDICATOR_VI_INSERT = $"($colors.pink): ($colors.reset)"
$env.PROMPT_INDICATOR_VI_NORMAL = $env.PROMPT_INDICATOR
$env.TRANSIENT_PROMPT_COMMAND = $env.PROMPT_COMMAND
$env.TRANSIENT_PROMPT_COMMAND_RIGHT = ""
$env.TRANSIENT_PROMPT_INDICATOR = $env.PROMPT_INDICATOR
$env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = $env.PROMPT_MULTILINE_INDICATOR
$env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = $env.PROMPT_INDICATOR_VI_INSERT
$env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = $env.PROMPT_INDICATOR_VI_NORMAL
