export module nuprm-theme {
    def get-color [color] {
        let colors = {
            blue: (prompt-make-utils color-to-ansi 82 139 255 "fg" "34")
            white: (prompt-make-utils color-to-ansi 255 255 255 "fg" "37")
        }
        
        let return_color = $colors | get -o $color | default ""
        return $return_color
    }

    export def get-prompt-command-left [] {
        let colors = [(get-color blue), (get-color white)]

        let user_name = get-prompt-info user-name
        let host_name = get-prompt-info host-name -l $"($colors.1) at ($colors.0)"
        let user_host = $"($user_name)($host_name) "
        let shells_index = get-prompt-info shells -dl $"($colors.1)№" -r $"($colors.0) : "
        let path_segment = get-prompt-info path (if (get-prompt-info path-mode) == "DOS" { "\\" } else { "/" }) -d $"\e[0;1m($colors.1)" -s "\e[0;2m" -r "\e[0m" -u
        let execution_time = if (get-prompt-info exec-time | into float) > 0.5 { $" ($colors.1)(get-prompt-info exec-time)sec " } else { "" }
        let git_info = get-prompt-info git -l $"($colors.1) in ($colors.0)" -r (if ($execution_time | is-empty) { " " } else { "" })
        let exit_code = if (get-prompt-info exit-code) != "0" { $"(get-prompt-info exit-code)($colors.1) | " } else { "" }

        return $"($colors.0)($exit_code)($colors.0)($user_host)\e[1m[ ($shells_index)\e[0;1m($colors.1)($path_segment)($colors.0) \e[1m]\e[0m($git_info)($execution_time)(ansi reset)"
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

    export def get-prompt-indicator-vi-normal [] {
        let indicator = get-prompt-command-left
        return $indicator
    }

    export def get-transient-prompt-command [] { }

    export def get-transient-prompt-command-right [] { }

    export def get-transient-prompt-indicator [] {
        let indicator = get-prompt-indicator
        return $indicator
    }

    export def get-transient-prompt-multiline-indicator [] {
        return $"(get-color blue)> (ansi reset)"
    }

    export def get-transient-prompt-indicator-vi-insert [] {
        let indicator = get-prompt-indicator-vi-insert
        return $indicator
    }

    export def get-transient-prompt-indicator-vi-normal [] {
        let indicator = get-prompt-command-left
        return $indicator
    }
}