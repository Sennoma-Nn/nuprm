export module nuprm-theme {
    def get-color [color] {
        alias color-to-ansi = prompt-make-utils color-to-ansi
        alias dividers-char = prompt-make-utils power-line dividers-char

        let colors = {
            purple: (color-to-ansi 180 100 255 "fg" "35"),
            pink: (color-to-ansi 255 100 200 "fg" "95"),
            star: (color-to-ansi 255 255 150 "fg" "33"),
            reset: (ansi reset)
        }
        
        let return_color = $colors | get -o $color | default ""
        return $return_color
    }

    export def get-prompt-command-left [] {
        alias surround = prompt-make-utils surround

        let system_icon = surround (get-prompt-info system-icon) -l $"(get-color purple)" -r " "
        let user_name = surround (get-prompt-info user-name) -l $"✨ (get-color purple)🚀 ($system_icon)(get-color pink)"
        let host_name = surround (get-prompt-info host-name) -l $"(get-color purple) at (get-color pink)"
        let user_host = $"($user_name)($host_name) (get-color purple)✨"
        let path_sep = if (get-prompt-info path-mode) == "DOS" { "\\" } else { "/" }
        let path_seg = $"(get-color pink)🪐 " + (surround (get-prompt-info pwd $path_sep -d $"(get-color purple)" -s $"(get-color pink)" -u) -r (get-color reset))
        let git_info = surround (get-prompt-info git) -l " (" -r ")"
        let git_status = if ($git_info | str length) > 0 { $" (get-color pink)🌟(get-color star)($git_info)" } else { "" }
        let exit_status = if (get-prompt-info exit-code) != 0 { $" (get-color pink)💥(get-color purple) (get-prompt-info exit-code)" } else { "" }
        let execution_time = if (get-prompt-info exec-time) > 0.5 { $" (get-color pink)⌛(get-color purple) (get-prompt-info exec-time)sec" } else { "" }
        return $"($user_host)\n($path_seg)($git_status)($exit_status)($execution_time)\n"
    }

    export def get-prompt-command-right [] {
        alias surround = prompt-make-utils surround

        let shells_index = surround (get-prompt-info shells -d) -l $"№" -r $" "
        return $"(get-color purple)($shells_index)(get-color pink)⏰ (get-color purple)(date now | format date '%H:%M')"
    }

    export def get-prompt-indicator [] {
        return $"(get-color pink)➜ (get-color reset)"
    }

    export def get-prompt-multiline-indicator [] {
        return $"(get-color purple)· (get-color reset)"
    }

    export def get-prompt-indicator-vi-insert [] {
        return $"(get-color pink): (get-color reset)"
    }

    export alias get-prompt-indicator-vi-normal = get-prompt-indicator

    export alias get-transient-prompt-command = get-prompt-command-left

    export def get-transient-prompt-command-right [] { }

    export alias get-transient-prompt-indicator = get-prompt-indicator

    export alias get-transient-prompt-multiline-indicator = get-prompt-multiline-indicator

    export alias get-transient-prompt-indicator-vi-insert = get-prompt-indicator-vi-insert

    export alias get-transient-prompt-indicator-vi-normal = get-prompt-indicator

    export def get-info [] {
        return {
            by: "Sennoma-Nn",
            tags: [
                "Emoji",
                "Multiple Lines"
            ]
        }
    }
}
