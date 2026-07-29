export module nuprm-theme {
    def get-prompt-chars [color] {
        alias color-to-ansi = prompt-make-utils color-to-ansi
        alias dividers-char = prompt-make-utils power-line dividers-char

        let prompt_chars = {
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

            power_line1: (dividers-char "right_hard_divider"), # 
            power_line2: (dividers-char "left_hard_divider"), # 
            power_line3: (dividers-char "right_soft_divider"), # 
            power_line4: (dividers-char "left_soft_divider"), # 
            power_line5: (dividers-char "left_half_circle_thick"), # 
            power_line6: (dividers-char "right_half_circle_thick"), # 

            reset_bg: "\e[49m",
            bold: "\e[1m",
            italic: "\e[3m",
            reset: (ansi reset)
        }
        
        let return_prompt_chars = $prompt_chars | get -o $color | default ""
        return $return_prompt_chars
    }

    alias make-block = prompt-make-utils power-line make-block

    export def get-prompt-command-left [] {
        alias surround = prompt-make-utils surround

        let system_icon = surround (get-prompt-info system-icon) -r " "
        let shells_index = surround (get-prompt-info shells -d) -l $"((get-prompt-chars black_fg))#" -r $" : "
        let path_sep = if (get-prompt-info path-mode) == "DOS" { "\\" } else { "/" }
        let path = (get-prompt-info pwd $path_sep -u -d (get-prompt-chars black_fg) -s (get-prompt-chars grey_fg))
        let host_name = surround (get-prompt-info host-name) -l " @ "
        let user_name = get-prompt-info user-name
        let user_host = $"($user_name)($host_name)"

        let prompt = [
            (
                make-block
                    -s (get-prompt-chars power_line5)
                    -e (get-prompt-chars power_line2)
                    -E (get-prompt-chars color2_bg)
                    -i $"((get-prompt-chars italic))($system_icon)"
                    (get-prompt-chars color1_fg)
                    (get-prompt-chars color1_bg)
                    $user_host
                    (get-prompt-chars black_fg)
            )
            (
                make-block
                    -e $"((get-prompt-chars power_line2))((get-prompt-chars power_line4))"
                    (get-prompt-chars color2_fg)
                    (get-prompt-chars color2_bg)
                    $"($shells_index)($path)"
                    (get-prompt-chars black_fg)
            )
            "\n\r"
        ] | str join ""
        return $prompt
    }

    export def get-prompt-command-right [] {
        alias surround = prompt-make-utils surround

        let git_info = (surround (get-prompt-info git) -l "󰊢 ")
        let exec_time = get-prompt-info exec-time
        let execution_time = $"($exec_time)sec"
        let exit_code = get-prompt-info exit-code
        let status_symbol = (
            if $exit_code != 0 {
                $"(get-prompt-chars color5_fg) ($exit_code)"
            } else {
                $"(get-prompt-chars color5_fg)󰄬"
            }
        )

        let prompt = [
            (
                make-block
                    -s $"((get-prompt-chars power_line3))((get-prompt-chars power_line1))"
                    -E (get-prompt-chars color4_bg)
                    (get-prompt-chars color3_fg)
                    (get-prompt-chars color3_bg)
                    $status_symbol
                    (get-prompt-chars color4_fg)
            )
            (
                make-block
                    --display_if ($git_info != "")
                    --force_display_dividers
                    -s (get-prompt-chars power_line1)
                    -S (get-prompt-chars color3_bg)
                    -E (get-prompt-chars color5_bg)
                    (get-prompt-chars color4_fg)
                    (get-prompt-chars color4_bg)
                    $git_info
                    (get-prompt-chars white_fg)
            )
            (
                make-block
                    --display_if ($exec_time > 0.5)
                    --force_display_dividers
                    -s (get-prompt-chars power_line1)
                    -e (get-prompt-chars power_line6)
                    -S (get-prompt-chars color4_bg)
                    -E (get-prompt-chars reset_bg)
                    (get-prompt-chars color5_fg)
                    (get-prompt-chars color5_bg)
                    $execution_time
                    (get-prompt-chars white_fg)
            )
        ] | str join ""
        return $prompt
    }

    export def get-prompt-indicator [] {
        return $"((get-prompt-chars color2_fg))(if not (is-admin) { "❯" } else { $"((get-prompt-chars bold))#" }) ((get-prompt-chars reset))"
    }

    export def get-prompt-multiline-indicator [] {
        let indicator = get-prompt-indicator
        return $indicator
    }

    export def get-prompt-indicator-vi-insert [] {
        return $"((get-prompt-chars color2_fg))((get-prompt-chars bold)): ((get-prompt-chars reset))"
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
