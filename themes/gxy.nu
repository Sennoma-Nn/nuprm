let black_fg = (color2ansi 0 0 0 fg 30)
let black_bg = (color2ansi 0 0 0 bg 40)
let blue_fg = (color2ansi 129 169 254 fg 94)
let blue_bg = (color2ansi 129 169 254 bg 104)
let dark_blue_fg = (color2ansi 59 66 97 fg 34)
let dark_blue_bg = (color2ansi 59 66 97 bg 44)
let pink_fg = (color2ansi 197 134 192 fg 95)
let bold = "\e[1m"
let reset = "\e[0m"

let user_name = get-user-name
let host_name = get-host -l $" @ "
let user_host = $"($user_name)($host_name)"

def create-prompt [] {
    let path = $env.PWD | format-path "  " -d $blue_fg -s $black_fg -ku
    let git_info = get-git-info
    let shells_info = get-where-shells -dl $" ($dark_blue_bg + $blue_fg) №"

    mut prompt = $"($reset)┌ "
    $prompt += $"($blue_fg)($reset)"
    $prompt += $"($blue_bg)($black_fg) (get-system-icon -r ' ▕ ')($user_host)($shells_info) ($reset)"
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
