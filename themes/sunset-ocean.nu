export module nuprm-theme {
    def get-color [color] {
        alias color-to-ansi = prompt-make-utils color-to-ansi
        alias power-line-char = prompt-make-utils power-line-char

        let colors = {
            black_fg: (color-to-ansi 0 0 0 "fg" "30"),
            white_fg: (color-to-ansi 255 255 255 "fg" "37"),
            color1_fg: (color-to-ansi 253 172 65 "fg" "33"),
            color1_bg: (color-to-ansi 253 172 65 "bg" "43"),
            color2_fg: (color-to-ansi 245 114 46 "fg" "31"),
            color2_bg: (color-to-ansi 245 114 46 "bg" "41"),
            color3_fg: (color-to-ansi 135 188 215 "fg" "94"),
            color3_bg: (color-to-ansi 135 188 215 "bg" "104"),
            color4_fg: (color-to-ansi 51 102 137 "fg" "34"),
            color4_bg: (color-to-ansi 51 102 137 "bg" "44"),
            color5_fg: (color-to-ansi 35 70 94 "fg" "36"),
            color5_bg: (color-to-ansi 35 70 94 "bg" "46"),
            grey_fg: (color-to-ansi  64 64 64 "fg" "90"),

            power_line1: (power-line-char "right_hard_divider"), # 
            power_line2: (power-line-char "left_hard_divider"), # 
            power_line3: (power-line-char "right_soft_divider"), # 
            power_line4: (power-line-char "left_soft_divider"), # 
            power_line5: (power-line-char "left_half_circle_thick"), # 
            power_line6: (power-line-char "right_half_circle_thick"), # 

            reset_bg: "\e[49m",
            bold: "\e[1m",
            italic: "\e[3m",
            reset: "\e[0m"
        }
        
        let return_color = $colors | get -o $color | default ""
        return $return_color
    }

    export def get-prompt-command-left [] {
        alias surround = prompt-make-utils surround

        let system_icon = surround (get-prompt-info system-icon) -r " "
        let shells_index = surround (get-prompt-info shells -d) -l $"((get-color black_fg))#" -r $" : "
        let path_sep = if (get-prompt-info path-mode) == "DOS" { "\\" } else { "/" }
        let path = (get-prompt-info pwd $path_sep -u -d (get-color black_fg) -s (get-color grey_fg))
        let host_name = surround (get-prompt-info host-name) -l " @ "
        let user_name = get-prompt-info user-name
        let user_host = $"($user_name)($host_name)"

        let prompt_list = [
            (get-color color1_fg), $"((get-color power_line5))", (get-color reset),
            (get-color color1_bg), (get-color black_fg), " ", (get-color italic), $system_icon, $user_host, " ", (get-color reset),
            (get-color color2_bg), (get-color color1_fg), $"((get-color power_line2))",
            (get-color color2_bg), " ", $shells_index, $path, " ", (get-color reset),
            (get-color color2_fg), $"((get-color power_line2))((get-color power_line4))",
            (get-color reset), "\n"
        ]
        let prompt = ($prompt_list | str join "")
        return $prompt
    }

    export def get-prompt-command-right [] {
        alias surround = prompt-make-utils surround

        let git_info = (surround (get-prompt-info git) -l " 󰊢 " -r " ") | if $in != "" { $"($in)" }
        let execution_time = if (get-prompt-info exec-time) > 0.5 { $" (get-prompt-info exec-time)sec " } else { "" }
        let status_symbol = (
            if (get-prompt-info exit-code) != 0 {
                [(get-color color5_fg), " ", (get-prompt-info exit-code)] | str join ""
            } else {
                [(get-color color5_fg), "󰄬"] | str join ""
            }
        )

        let prompt_list = [
            (get-color color3_fg), $"((get-color power_line3))((get-color power_line1))", (get-color reset), (get-color color3_bg), " ", $status_symbol, " ", (get-color reset), (get-color color3_fg), (get-color color3_bg),
            (get-color color4_fg), $"((get-color power_line1))", (get-color reset), (get-color color4_bg), (get-color white_fg), $git_info, (get-color reset), (get-color color4_fg), (get-color color4_bg),
            (get-color color5_fg), $"((get-color power_line1))", (get-color color5_bg), (get-color white_fg), $execution_time, (get-color reset), (get-color color5_fg), (get-color color5_bg),
            (get-color reset_bg), $"((get-color power_line6))", (get-color reset)
        ]

        let prompt = ($prompt_list | str join "")
        return $prompt
    }

    export def get-prompt-indicator [] {
        return $"((get-color color2_fg))(if not (is-admin) { "❯" } else { $"((get-color bold))#" }) ((get-color reset))"
    }

    export def get-prompt-multiline-indicator [] {
        let indicator = get-prompt-indicator
        return $indicator
    }

    export def get-prompt-indicator-vi-insert [] {
        return $"((get-color color2_fg))((get-color bold)): ((get-color reset))"
    }

    export def get-prompt-indicator-vi-normal [] {
        let indicator = get-prompt-indicator
        return $indicator
    }

    export def get-transient-prompt-command [] { }

    export def get-transient-prompt-command-right [] { }

    export alias get-transient-prompt-indicator = get-prompt-indicator

    export def get-transient-prompt-multiline-indicator [] {
        let indicator = get-prompt-multiline-indicator
        return $indicator
    }

    export alias get-transient-prompt-indicator-vi-insert = get-prompt-indicator-vi-insert

    export alias get-transient-prompt-indicator-vi-normal = get-prompt-indicator-vi-normal

    export def get-info [] {
        return {
            by: "Sennoma-Nn",
            tags: [
                "Power Line",
                "Multiple Lines"
            ]
        }
    }
}
