let colors = {
    black_fg: (prompt-make-utils color-to-ansi 0 0 0 "fg" "30"),
    white_fg: (prompt-make-utils color-to-ansi 255 255 255 "fg" "37"),
    color1_fg: (prompt-make-utils color-to-ansi 253 172 65 "fg" "33"),
    color1_bg: (prompt-make-utils color-to-ansi 253 172 65 "bg" "43"),
    color2_fg: (prompt-make-utils color-to-ansi 245 114 46 "fg" "31"),
    color2_bg: (prompt-make-utils color-to-ansi 245 114 46 "bg" "41"),
    color3_fg: (prompt-make-utils color-to-ansi 135 188 215 "fg" "94"),
    color3_bg: (prompt-make-utils color-to-ansi 135 188 215 "bg" "104"),
    color4_fg: (prompt-make-utils color-to-ansi 51 102 137 "fg" "34"),
    color4_bg: (prompt-make-utils color-to-ansi 51 102 137 "bg" "44"),
    color5_fg: (prompt-make-utils color-to-ansi 35 70 94 "fg" "36"),
    color5_bg: (prompt-make-utils color-to-ansi 35 70 94 "bg" "46"),
    grey_fg: (prompt-make-utils color-to-ansi  64 64 64 "fg" "90"),

    power_line1: (prompt-make-utils power-line-char "right_hard_divider") # 
    power_line2: (prompt-make-utils power-line-char "left_hard_divider") # 
    power_line3: (prompt-make-utils power-line-char "right_soft_divider") # 
    power_line4: (prompt-make-utils power-line-char "left_soft_divider") # 
    power_line5: (prompt-make-utils power-line-char "left_half_circle_thick") # 
    power_line6: (prompt-make-utils power-line-char "right_half_circle_thick") # 

    reset_bg: "\e[49m",
    bold: "\e[1m",
    italic: "\e[3m",
    reset: "\e[0m"
}


def create-prompt-left [] {
    let shells_index = get-prompt-info shells -Dl $"($colors.black_fg)#" -r $" : "
    let path = (get-prompt-info path (if (get-prompt-info path-mode) == "DOS" { "\\" } else { "/" }) -u -d $colors.black_fg -s $colors.grey_fg)
    let host_name = get-prompt-info host-name -l " @ "
    let user_name = get-prompt-info user-name
    let user_host = $"($user_name)($host_name)"

    let prompt_list = [
        $colors.color1_fg, $"($colors.power_line5)", $colors.reset,
        $colors.color1_bg, $colors.black_fg, " ", $colors.italic, $user_host, " ", $colors.reset,
        $colors.color2_bg, $colors.color1_fg, $"($colors.power_line2)",
        $colors.color2_bg, " ", $shells_index, $path, " ", $colors.reset,
        $colors.color2_fg, $"($colors.power_line2)($colors.power_line4)",
        $colors.reset, "\n"
    ]
    let prompt = ($prompt_list | str join "")
    return $prompt
}

def create-prompt-right [] {
    let git_info = (get-prompt-info git -l "  " -r " ") | if $in != "" { $"($in)" }
    let execution_time = if (get-prompt-info exec-time | into float) > 0.5 { $" (get-prompt-info exec-time)sec " } else { "" }
    let status_symbol = (
        if (get-prompt-info exit-code) != "0" {
            [$colors.color5_fg, " ", (get-prompt-info exit-code)] | str join ""
        } else {
            [$colors.color5_fg, ""] | str join ""
        }
    )

    let prompt_list = [
        $colors.color3_fg, $"($colors.power_line3)($colors.power_line1)", $colors.reset, $colors.color3_bg, " ", $status_symbol, " ", $colors.reset, $colors.color3_fg, $colors.color3_bg,
        $colors.color4_fg, $"($colors.power_line1)", $colors.reset, $colors.color4_bg, $colors.white_fg, $git_info, $colors.reset, $colors.color4_fg, $colors.color4_bg,
        $colors.color5_fg, $"($colors.power_line1)", $colors.color5_bg, $colors.white_fg, $execution_time, $colors.reset, $colors.color5_fg, $colors.color5_bg,
        $colors.reset_bg, $"($colors.power_line6)", $colors.reset
    ]

    let prompt = ($prompt_list | str join "")
    return $prompt
}

$env.PROMPT_COMMAND = {|| create-prompt-left }
$env.PROMPT_COMMAND_RIGHT = {|| create-prompt-right}
$env.PROMPT_INDICATOR = $"($colors.color2_fg)(if not (is-admin) { "❯" } else { $"($colors.bold)#" }) ($colors.reset)"
$env.PROMPT_MULTILINE_INDICATOR = $env.PROMPT_INDICATOR
$env.PROMPT_INDICATOR_VI_INSERT = $"($colors.color2_fg)($colors.bold): ($colors.reset)"
$env.PROMPT_INDICATOR_VI_NORMAL = $env.PROMPT_INDICATOR
$env.TRANSIENT_PROMPT_COMMAND = {||}
$env.TRANSIENT_PROMPT_COMMAND_RIGHT = ""
$env.TRANSIENT_PROMPT_INDICATOR = $env.PROMPT_INDICATOR
$env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = $env.PROMPT_MULTILINE_INDICATOR
$env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = $env.PROMPT_INDICATOR_VI_INSERT
$env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = $env.PROMPT_INDICATOR_VI_NORMAL
