export module nuprm-theme {
    def get-color [color] {
        alias color-to-ansi = prompt-make-utils color-to-ansi
        alias power-line-char = prompt-make-utils power-line-char

        let colors = {
            blue: (color-to-ansi 82 139 255 "fg" "34")
            white: (color-to-ansi 255 255 255 "fg" "37")
        }
        
        let return_color = $colors | get -o $color | default ""
        return $return_color
    }

    export def get-prompt-command-left [] {
        alias surround = prompt-make-utils surround

        let colors = [(get-color blue), (get-color white)]

        let system_icon = surround (get-prompt-info system-icon) -l $colors.1 -r " "
        let user_name = get-prompt-info user-name
        let host_name = surround (get-prompt-info host-name) -l $"($colors.1) at ($colors.0)"
        let user_host = $"($user_name)($host_name) "
        let shells_index = surround (get-prompt-info shells -d) -l $"($colors.1)№" -r $"($colors.0) : "
        let path_sep = if (get-prompt-info path-mode) == "DOS" { "\\" } else { "/" }
        let path_segment = surround (get-prompt-info pwd $path_sep -d $"\e[0;1m($colors.1)" -s "\e[0;2m" -u) -r "\e[0m"
        let execution_time = if (get-prompt-info exec-time) > 0.5 { $" ($colors.1)(get-prompt-info exec-time)sec " } else { "" }
        let git_info = surround (get-prompt-info git -d $"($colors.1)*" -s $"($colors.1)+") -l $"($colors.1) in ($colors.0)" -r (if ($execution_time | is-empty) { " " } else { "" })
        let exit_code = if (get-prompt-info exit-code) != 0 { surround (get-prompt-info exit-code) -l $colors.0 -r $"($colors.1) | " } else { "" }

        return $"($system_icon)($exit_code)($colors.0)($user_host)\e[1m[ ($shells_index)\e[0;1m($colors.1)($path_segment)($colors.0) \e[1m]\e[0m($git_info)($execution_time)(ansi reset)"
    }

    export def get-prompt-command-right [] { }

    export def get-prompt-indicator [] {
        let indicator_char = if (is-admin) { "#" } else { "$" }
        let indicator = $"(get-color blue)($indicator_char) (ansi reset)"
        return $indicator
    }

    export def get-prompt-multiline-indicator [] {
        return $"(get-color blue)>>> (ansi reset)"
    }

    export def get-prompt-indicator-vi-insert [] {
        return $"(get-color blue): (ansi reset)"
    }

    export alias get-prompt-indicator-vi-normal = get-prompt-indicator

    export def get-transient-prompt-command [] { }

    export def get-transient-prompt-command-right [] { }

    export alias get-transient-prompt-indicator = get-prompt-indicator

    export def get-transient-prompt-multiline-indicator [] {
        return $"(get-color blue)> (ansi reset)"
    }

    export alias get-transient-prompt-indicator-vi-insert = get-prompt-indicator-vi-insert

    export alias get-transient-prompt-indicator-vi-normal = get-prompt-indicator-vi-normal

    export def get-info [] {
        return {
            by: "Sennoma-Nn",
            tags: [
                "Minimalist"
            ]
        }
    }
}
