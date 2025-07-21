let colors = {
    purple: (color2ansi 180 100 255 fg),
    blue: (color2ansi 100 150 255 fg),
    pink: (color2ansi 255 100 200 fg),
    star: (color2ansi 255 255 150 fg),
    reset: (ansi reset)
}

def create-left-prompt [] {
    let user = $"✨ ($colors.purple)🚀 ($colors.pink)(get-user-name) ✨"
    let path_seg = $"($colors.blue)🪐 ($colors.purple)(home-to-tilde $env.PWD)"
    let git_info = (get-git-info -l " (" -r ")")
    let git_status = if ($git_info | str length) > 0 {
        $" ($colors.star)🌟($git_info)"
    } else { "" }
    let exit_status = if $env.LAST_EXIT_CODE != 0 {
        $" ($colors.pink)💥 [($env.LAST_EXIT_CODE)]"
    } else { "" }
    return $"($user)\n($path_seg)($git_status)($exit_status)\n"
}

def create-right-prompt [] {
    return $"($colors.blue)⌛ (date now | format date '%H:%M')"
}

$env.PROMPT_COMMAND = {|| create-left-prompt }
$env.PROMPT_COMMAND_RIGHT = {|| create-right-prompt } 
$env.PROMPT_INDICATOR = $"($colors.pink)➜ ($colors.reset)"
$env.PROMPT_MULTILINE_INDICATOR = $"($colors.purple)· ($colors.reset)"
$env.TRANSIENT_PROMPT_COMMAND = $env.PROMPT_COMMAND
$env.TRANSIENT_PROMPT_INDICATOR = $env.PROMPT_INDICATOR
$env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = $env.PROMPT_MULTILINE_INDICATOR
