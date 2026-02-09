export module nuprm-theme {
    def get-prompt-chars [color] {
        let prompt_chars = {
            right_char: "󰄬"
            wrong_char: ""
            root_icon: ""
            italic: "\e[3m"
            reset: "\e[0m"
            power_line1: (prompt-make-utils power-line-char "lower_right_triangle") # 
            power_line2: (prompt-make-utils power-line-char "upper_left_triangle") # 
            power_line3: (prompt-make-utils power-line-char "left_hard_divider") # 
            power_line4: (prompt-make-utils power-line-char "left_hard_divider_inverse") # 
            white_fg: (prompt-make-utils color-to-ansi 255 255 255 "fg" "37")
            black_fg: (prompt-make-utils color-to-ansi 0 0 0 "fg" "30")
            name_fg: (prompt-make-utils color-to-ansi 255 146 72 "fg" "33")
            name_bg: (prompt-make-utils color-to-ansi 255 146 72 "bg" "43")
            path_fg: (prompt-make-utils color-to-ansi 52 100 164 "fg" "34")
            path_bg: (prompt-make-utils color-to-ansi 52 100 164 "bg" "44")
            git_fg: (prompt-make-utils color-to-ansi 196 110 170 "fg" "95")
            git_bg: (prompt-make-utils color-to-ansi 196 110 170 "bg" "105")
            status_fg: (prompt-make-utils color-to-ansi 46 149 153 "fg" "36")
            status_bg: (prompt-make-utils color-to-ansi 46 149 153 "bg" "46")
            status_err_fg: (prompt-make-utils color-to-ansi 240 83 80 "fg" "31")
            status_err_bg: (prompt-make-utils color-to-ansi 240 83 80 "bg" "41")
            shells_fg: (prompt-make-utils color-to-ansi 122 64 152 "fg" "35")
            shells_bg: (prompt-make-utils color-to-ansi 122 64 152 "bg" "45")
            time_fg: (prompt-make-utils color-to-ansi 78 144 61 "fg" "32")
            time_bg: (prompt-make-utils color-to-ansi 78 144 61 "bg" "42")
            root_fg: (prompt-make-utils color-to-ansi 248 102 122 "fg" "91")
            root_bg: (prompt-make-utils color-to-ansi 248 102 122 "bg" "101")
            vi_fg: (prompt-make-utils color-to-ansi 78 144 61 "fg" "32")
            vi_bg: (prompt-make-utils color-to-ansi 78 144 61 "bg" "42")
        }
        
        let return_prompt_chars = $prompt_chars | get -o $color | default ""
        return $return_prompt_chars
    }

    def prompt-block [
        start_char: string
        end_char: string
        block_fg: string
        block_bg: string
        block_text: string
        text_fg: string
        icon: string
    ] {
        return (
            [
                (get-prompt-chars reset)
                $block_fg
                $start_char
                (get-prompt-chars reset)
                $block_bg
                $text_fg
                $" ($icon)($block_text) "
                (get-prompt-chars reset)
                $block_fg
                $end_char
                (get-prompt-chars reset)
            ] | str join ""
        )
    }

    export def get-prompt-command-left [] {
        let status = {
            icon: (get-prompt-info system-icon -r " ")
            user: (get-prompt-info user-name)
            host: (get-prompt-info host-name -l $" @ ")
            path: (get-prompt-info path (if (get-prompt-info path-mode) == "DOS" { "\\" } else { "/" }) -d $"\e[0;1m(get-prompt-chars white_fg)(get-prompt-chars path_bg)" -s $"\e[0;2m(get-prompt-chars path_bg)" -u)
            git: (get-prompt-info git)
            exit: (get-prompt-info exit-code)
            admin: (is-admin)
            shells: (get-prompt-info shells -dl "#")
            time: (get-prompt-info exec-time | into float)
        }
        return (
            [
                (prompt-block "" (get-prompt-chars power_line2) (get-prompt-chars name_fg) (get-prompt-chars name_bg) $"($status.user)($status.host)" (get-prompt-chars black_fg) $status.icon)
                (prompt-block (get-prompt-chars power_line1) (get-prompt-chars power_line2) (get-prompt-chars path_fg) (get-prompt-chars path_bg) $status.path (get-prompt-chars white_fg) " ")
                (
                    if $status.git != "" {
                        prompt-block (get-prompt-chars power_line1) (get-prompt-chars power_line2) (get-prompt-chars git_fg) (get-prompt-chars git_bg) $status.git (get-prompt-chars white_fg) " "
                    } else { "" }
                )
                (
                    if $status.time > 0.5 {
                        prompt-block (get-prompt-chars power_line1) (get-prompt-chars power_line2) (get-prompt-chars time_fg) (get-prompt-chars time_bg) $"($status.time)s" (get-prompt-chars white_fg) " "
                    } else { "" }
                )
                (
                    if $status.exit == "0" {
                        prompt-block (get-prompt-chars power_line1) (get-prompt-chars power_line3) (get-prompt-chars status_fg) (get-prompt-chars status_bg) (get-prompt-chars right_char) (get-prompt-chars white_fg) ""
                    } else {
                        prompt-block (get-prompt-chars power_line1) (get-prompt-chars power_line3) (get-prompt-chars status_err_fg) (get-prompt-chars status_err_bg) $"(get-prompt-chars wrong_char) ($status.exit)" (get-prompt-chars white_fg) ""
                    }
                )
                (
                    if $status.shells != "" {
                        prompt-block (get-prompt-chars power_line4) (get-prompt-chars power_line3) (get-prompt-chars shells_fg) (get-prompt-chars shells_bg) $status.shells (get-prompt-chars white_fg) " "
                    } else { "" }
                )
                (
                    if $status.admin {
                        prompt-block (get-prompt-chars power_line4) (get-prompt-chars power_line3) (get-prompt-chars root_fg) (get-prompt-chars root_bg) (get-prompt-chars root_icon) (get-prompt-chars white_fg) ""
                    } else { "" }
                )
                " "
            ] | str join ""
        )
    }

    export def get-prompt-command-right [] { }

    export def get-prompt-indicator [] { }

    export def get-prompt-multiline-indicator [] {
        return $"(get-prompt-chars name_fg)➥ "
    }

    export def get-prompt-indicator-vi-insert [] {
        let prompt = (prompt-block $"\b(get-prompt-chars power_line4)" $"(get-prompt-chars power_line3) " (get-prompt-chars vi_fg) (get-prompt-chars vi_bg) "I" (get-prompt-chars white_fg) " ")

        return $prompt
    }

    export def get-prompt-indicator-vi-normal [] {
        let prompt = (prompt-block $"\b(get-prompt-chars power_line4)" $"(get-prompt-chars power_line3) " (get-prompt-chars vi_fg) (get-prompt-chars vi_bg) "N" (get-prompt-chars white_fg) " ")

        return $prompt
    }

    export def get-transient-prompt-command [] {
        let path = (get-prompt-info last-path -u)
        
        return (
            prompt-block "" $"(get-prompt-chars power_line3) " (get-prompt-chars path_fg) (get-prompt-chars path_bg) $path (get-prompt-chars white_fg) " "
        )
    }

    export def get-transient-prompt-command-right [] { }

    export def get-transient-prompt-indicator [] { }

    export def get-transient-prompt-multiline-indicator [] {
        return $"(get-prompt-chars path_fg)➥ "
    }

    export def get-transient-prompt-indicator-vi-insert [] { }

    export def get-transient-prompt-indicator-vi-normal [] { }
}