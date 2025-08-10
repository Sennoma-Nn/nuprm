let prompt_colors = {
    gunjyou: ("\e[38;2;82;139;255m")
    white: ("\e[38;2;255;255;255m")
}

let using_colors = [$prompt_colors.gunjyou, $prompt_colors.white]

def create-left-prompt [
    --colors: list (-c) = ["\e[0m", "\e[0m"]
] {
    let user = ((get-user-name) + " ")
    let shells_index = (get-where-shells -dl "№" -r " ")

    let path_segment = $env.PWD | format-path (if (is-windows) { "\\" } else { "/" }) -d $"\e[0;1m($colors.1)" -s "\e[0;2m" -r "\e[0m" -u
    let git_info = (get-git-info -l $"($colors.1) in ($colors.0)" -r " ")
    let exit_code = if $env.LAST_EXIT_CODE != 0 { $"($env.LAST_EXIT_CODE)($colors.1) | " } else { "" }

    return $"($colors.0)($exit_code)($colors.0)($user)\e[1m[ ($shells_index)\e[0;1m($colors.1)($path_segment)($colors.0) \e[1m]($git_info)(ansi reset)"
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
$env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = {||}
$env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = $env.PROMPT_INDICATOR_VI_INSERT
$env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = $env.PROMPT_INDICATOR_VI_NORMAL
