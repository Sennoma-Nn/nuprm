let black_fg = "\e[30m"
let black_bg = "\e[40m"
let blue_fg = "\e[38;2;129;169;254m"
let blue_bg = "\e[48;2;129;169;254m"
let dark_blue_fg = "\e[38;2;59;66;97m"
let dark_blue_bg = "\e[48;2;59;66;97m"
let pink_fg = "\e[38;2;197;134;192m"
let bold = "\e[1m"
let reset = "\e[0m"

let user = (get-user-name)

def create-prompt [] {
    let path = $env.PWD | format-path "  " -d $blue_fg -s $black_fg -ku
    let git_info = (get-git-info)
    let shells_info = (get-where-shells -dl $" ($dark_blue_bg + $blue_fg) №")

    mut prompt = $"($reset)┌ "
    $prompt += $"($blue_fg)($reset)"
    $prompt += $"($blue_bg)($black_fg) (get-system-icon -r ' ▕ ')($user)($shells_info) ($reset)"
    $prompt += $"(if $shells_info != "" { $dark_blue_fg } else { $blue_fg })($reset)"
    $prompt += $"($dark_blue_fg)"
    $prompt += $"($dark_blue_bg)($blue_fg) ($path) ($reset)"
    $prompt += $"($dark_blue_fg)($reset)"

    if $git_info != "" {
        $prompt += $" ($pink_fg) ($git_info)($reset)"
        if $env.LAST_EXIT_CODE == 0 {
            $prompt += " "
        }
    }

    if $env.LAST_EXIT_CODE != 0 {
        $prompt += $"($bold + $dark_blue_fg) ($env.LAST_EXIT_CODE) ($reset)"
    }

    $prompt += $"($blue_fg)($reset)"

    $prompt += "\n└ "
    return $prompt
}

def transient-create-left-prompt [] {
    let path = $env.PWD | format-path "  " -d $blue_fg -s $black_fg -ku

    mut prompt = ""
    $prompt += $"($dark_blue_bg + $blue_fg) ($path) ($reset)"
    $prompt += $"($dark_blue_fg)($reset)"

    $prompt += $"($blue_fg)($reset)"
    return $prompt
}

$env.PROMPT_COMMAND = { create-prompt }
$env.PROMPT_COMMAND_RIGHT = ""
$env.PROMPT_INDICATOR = $reset + "> "
$env.PROMPT_MULTILINE_INDICATOR = "┆ - "
$env.PROMPT_INDICATOR_VI_INSERT = $reset + ": "
$env.PROMPT_INDICATOR_VI_NORMAL = $env.PROMPT_INDICATOR
$env.TRANSIENT_PROMPT_COMMAND = {|| transient-create-left-prompt}
$env.TRANSIENT_PROMPT_COMMAND_RIGHT = ""
$env.TRANSIENT_PROMPT_INDICATOR = " "
$env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = " "
$env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = " "
$env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = " "
