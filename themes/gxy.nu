let black_fg = (prompt-make-utils color-to-ansi 0 0 0 "fg" "30")
let black_bg = (prompt-make-utils color-to-ansi 0 0 0 "bg" "40")
let blue_fg = (prompt-make-utils color-to-ansi 129 169 254 "fg" "94")
let blue_bg = (prompt-make-utils color-to-ansi 129 169 254 "bg" "104")
let dark_blue_fg = (prompt-make-utils color-to-ansi 59 66 97 "fg" "34")
let dark_blue_bg = (prompt-make-utils color-to-ansi 59 66 97 "bg" "44")
let pink_fg = (prompt-make-utils color-to-ansi 197 134 192 "fg" "95")
let bold = "\e[1m"
let reset = "\e[0m"

let user_name = get-prompt-info user-name
let host_name = get-prompt-info host-name -l $" @ "
let user_host = $"($user_name)($host_name)"

def create-prompt [] {
    let path = get-prompt-info path "  " -d $blue_fg -s $black_fg -l $"($dark_blue_bg)($blue_fg) " -r $" ($reset)($dark_blue_fg)" -ku
    let git_info = get-prompt-info git
    let shells_info = get-prompt-info shells -Dl $" ($dark_blue_bg + $blue_fg) №"
    let exit_code = get-prompt-info exit-code
    let execution_time = get-prompt-info exec-time | $in + "sec"

    mut prompt = $"($reset)┌ "
    $prompt += $"($blue_fg)($reset)"
    $prompt += $"($blue_bg)($black_fg) (get-prompt-info system-icon -r ' ▕ ')($user_host)($shells_info) ($reset)"
    $prompt += $"(if $shells_info != "" { $dark_blue_fg } else { $blue_fg })($reset)"
    $prompt += $"($dark_blue_fg)($path)($reset)"

    mut extra_info_list = []
    if $git_info != "" { $extra_info_list ++= [$"($pink_fg) ($git_info)($reset)"] }
    if (get-prompt-info exec-time | into float) > 0.5 { $extra_info_list ++= [$"($bold + $dark_blue_fg)($execution_time)($reset)"] }
    if $exit_code != "0" { $extra_info_list ++= [$"($bold + $dark_blue_fg)($exit_code)($reset)"] }
    let extra_info = ($extra_info_list | str join $" ($reset) ")
    if not ($extra_info_list | is-empty) { $prompt += $" ($extra_info) " }

    $prompt += $"($blue_fg)($reset)"
    $prompt += "\n└ "
    return $prompt
}

def transient-create-left-prompt [] {
    let path = get-prompt-info path "  " -d $blue_fg -s $black_fg -l $"($reset)($dark_blue_bg + $blue_fg) " -r $" ($reset)($dark_blue_fg)" -ku

    mut prompt = ""
    $prompt += $"($dark_blue_fg)($path)($reset)"

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
$env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = $env.PROMPT_MULTILINE_INDICATOR
$env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = " "
$env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = " "
