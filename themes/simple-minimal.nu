# Simple Minimal Theme
let colors = {
    green: (color2ansi 100 200 100 fg),
    white: (color2ansi 240 240 240 fg),
    reset: (ansi reset)
}

def create-left-prompt [] {
    let user_info = $"($colors.green)(get-user-name)($colors.reset)"
    let path_info = $"($colors.white)(home-to-tilde $env.PWD)($colors.reset)"

    let git_info = (get-git-info -l " (" -r ")") | if $in != "" {
        $"($colors.green)($in)"
    }

    let exit_code = if $env.LAST_EXIT_CODE != 0 {
        $" ($colors.green)[($env.LAST_EXIT_CODE)]"
    } else { "" }

    return $"($user_info) ($path_info)($git_info)($exit_code) "
}

$env.PROMPT_COMMAND = {|| create-left-prompt }
$env.PROMPT_COMMAND_RIGHT = {||}
$env.PROMPT_INDICATOR = $"($colors.green)❯ ($colors.reset)"
$env.PROMPT_MULTILINE_INDICATOR = $"($colors.green)::: ($colors.reset)"
$env.TRANSIENT_PROMPT_COMMAND = {||}
$env.TRANSIENT_PROMPT_INDICATOR = $env.PROMPT_INDICATOR
$env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = $env.PROMPT_MULTILINE_INDICATOR
