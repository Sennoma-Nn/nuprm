let colors = {
    purple: (prompt-make-utils color-to-ansi 180 100 255 "fg" "35"),
    pink: (prompt-make-utils color-to-ansi 255 100 200 "fg" "95"),
    star: (prompt-make-utils color-to-ansi 255 255 150 "fg" "33"),
    reset: (ansi reset)
}

def create-left-prompt [] {
    let user_name = get-prompt-info user-name -l $"✨ ($colors.purple)🚀 ($colors.pink)"
    let host_name = get-prompt-info host-name -l $"($colors.purple) at ($colors.pink)"
    let user_host = $"($user_name)($host_name) ($colors.purple)✨"
    let path_seg = $"($colors.pink)🪐 " + (get-prompt-info path (if (get-prompt-info path-mode) == "DOS" { "\\" } else { "/" }) -d $"($colors.purple)" -s $"($colors.pink)" -r "\e[0m" -u)
    let git_info = (get-prompt-info git -l " (" -r ")")
    let git_status = if ($git_info | str length) > 0 { $" ($colors.pink)🌟($colors.star)($git_info)" } else { "" }
    let exit_status = if (get-prompt-info exit-code) != "0" { $" ($colors.pink)💥($colors.purple) (get-prompt-info exit-code)" } else { "" }
    let execution_time = if (get-prompt-info exec-time | into float) > 0.5 { $" ($colors.pink)⌛($colors.purple) (get-prompt-info exec-time)sec" } else { "" }
    return $"($user_host)\n($path_seg)($git_status)($exit_status)($execution_time)\n"
}

def create-right-prompt [] {
    let shells_index = get-prompt-info shells -Dl $"№" -r $" "
    return $"($colors.purple)($shells_index)($colors.pink)⏰ ($colors.purple)(date now | format date '%H:%M')"
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
