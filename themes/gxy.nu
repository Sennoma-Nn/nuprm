export module nuprm-theme {
    def get-color [color] {
        let colors = {
            black_fg: (prompt-make-utils color-to-ansi 0 0 0 "fg" "30")
            black_bg: (prompt-make-utils color-to-ansi 0 0 0 "bg" "40")
            blue_fg: (prompt-make-utils color-to-ansi 129 169 254 "fg" "94")
            blue_bg: (prompt-make-utils color-to-ansi 129 169 254 "bg" "104")
            dark_blue_fg: (prompt-make-utils color-to-ansi 59 66 97 "fg" "34")
            dark_blue_bg: (prompt-make-utils color-to-ansi 59 66 97 "bg" "44")
            pink_fg: (prompt-make-utils color-to-ansi 197 134 192 "fg" "95")
            power_line1: (prompt-make-utils power-line-char "right_hard_divider") # 
            power_line2: (prompt-make-utils power-line-char "left_hard_divider") # 
            power_line3: (prompt-make-utils power-line-char "left_soft_divider") # 
            power_line4: (prompt-make-utils power-line-char "left_hard_divider_inverse") # 
            power_line5: (prompt-make-utils power-line-char "upper_left_triangle") # 
            bold: "\e[1m"
            reset: "\e[0m"
            faint: "\e[2m"
        }

        let return_color = $colors | get -o $color | default ""
        return $return_color
    }

    export def get-prompt-command-left [] {
        let user_name = get-prompt-info user-name
        let host_name = get-prompt-info host-name -l $" @ "
        let user_host = $"($user_name)($host_name)"
        let path = get-prompt-info path $" (get-color power_line3) " -d (get-color blue_fg) -s (get-color black_fg) -l $"(get-color power_line4)(get-color dark_blue_bg)(get-color blue_fg) " -r $" (get-color reset)(get-color dark_blue_fg)(get-color power_line2)" -ku
        let git_info = get-prompt-info git
        let shells_info = get-prompt-info shells -dl $" ((get-color dark_blue_bg) + (get-color blue_fg))(get-color power_line5) №"
        let exit_code = get-prompt-info exit-code
        let execution_time = get-prompt-info exec-time | $in + "sec"

        mut prompt = $"(get-color reset)┌ "
        $prompt += $"(get-color blue_fg)(get-color power_line1)(get-color reset)"
        $prompt += $"(get-color blue_bg)(get-color black_fg) (get-prompt-info system-icon -r ' ▕ ')($user_host)($shells_info) (get-color reset)"
        $prompt += $"(if $shells_info != "" { (get-color dark_blue_fg) } else { (get-color blue_fg) })(get-color power_line2)(get-color reset)"
        $prompt += $"(get-color dark_blue_fg)($path)(get-color reset)"

        mut extra_info_list = []
        if $git_info != "" { $extra_info_list ++= [$"(get-color pink_fg) ($git_info)(get-color reset)"] }
        if (get-prompt-info exec-time | into float) > 0.5 { $extra_info_list ++= [$"((get-color bold) + (get-color dark_blue_fg))($execution_time)(get-color reset)"] }
        if $exit_code != "0" { $extra_info_list ++= [$"((get-color bold) + (get-color dark_blue_fg))($exit_code)(get-color reset)"] }
        let extra_info = ($extra_info_list | str join $" (get-color reset) ")
        if not ($extra_info_list | is-empty) { $prompt += $" ($extra_info) " }

        $prompt += $"(get-color blue_fg)(get-color power_line3)(get-color reset)"
        $prompt += "\n└ "

        return $prompt
    }

    export def get-prompt-command-right [] { }

    export def get-prompt-indicator [] {
        return ((get-color reset) + "> ")
    }

    export def get-prompt-multiline-indicator [] {
        return ((get-color dark_blue_fg) + "┆ - " + (get-color reset))
    }

    export def get-prompt-indicator-vi-insert [] {
        return ((get-color reset) + ": ")
    }

    export def get-prompt-indicator-vi-normal [] {
        let indicator = get-prompt-indicator
        return $indicator
    }

    export def get-transient-prompt-command [] {
        let path = get-prompt-info path $" (get-color power_line3) " -d (get-color blue_fg) -s (get-color black_fg) -l $"(get-color power_line1)(get-color reset)((get-color dark_blue_bg) + (get-color blue_fg)) " -r $" (get-color reset)(get-color dark_blue_fg)(get-color power_line2)" -ku

        mut prompt = ""
        $prompt += $"(get-color dark_blue_fg)($path)(get-color reset)"

        $prompt += $"(get-color blue_fg)(get-color power_line3)(get-color reset)"
        return $prompt
    }

    export def get-transient-prompt-command-right [] { }

    export def get-transient-prompt-indicator [] {
        return " "
    }

    export def get-transient-prompt-multiline-indicator [] {
        return ((get-color dark_blue_fg) + (get-color faint) + "┆ - " + (get-color reset))
    }

    export def get-transient-prompt-indicator-vi-insert [] {
        let indicator = get-transient-prompt-indicator
        return $indicator
    }

    export def get-transient-prompt-indicator-vi-normal [] {
        let indicator = get-transient-prompt-indicator
        return $indicator
    }
}