export module nuprm-theme {
    def get-color [color] {
        let colors = {
            white: (prompt-make-utils color-to-ansi 255 255 255 "fg" "37"),
            green: (prompt-make-utils color-to-ansi 80 161 79 "fg" "32"),
            red: (prompt-make-utils color-to-ansi 228 86 73 "fg" "31"),
            reset: (ansi reset)
        }
        
        let return_color = $colors | get -o $color | default ""
        return $return_color
    }

    export def get-prompt-command-left [] {
        let exit_code = get-prompt-info exit-code
        let status_color = if $exit_code == "0" { get-color green } else { get-color red }
        let status_mark = if $exit_code != "0" { $" ($status_color)×(get-color reset) ($exit_code)" } else { "" }
        let host_name = get-prompt-info host-name -l $"($status_color) @ (get-color white)"
        let user_name = $"(get-color white)(get-prompt-info user-name)"
        let user_host = $"($user_name)($host_name)"
        let path_info = get-prompt-info path -u (if (get-prompt-info path-mode) == "DOS" { "\\" } else { "/" }) -d $"($status_color)" -s $"(get-color white)" -r "\e[0m" -u
        let path_show = $"[ ($path_info) (get-color white)]"
        let git_info = (get-prompt-info git -l $" in ($status_color)" -r (get-color reset))
        let execution_time = if (get-prompt-info exec-time | into float) > 0.5 { $" ($status_color)- (get-color white)(get-prompt-info exec-time)sec" } else { "" }

        return $"(get-color white)╭── ($user_host) ($path_show)($status_mark)($git_info)($execution_time)\n(get-color white)╰─(get-color reset)"
    }

    export def get-prompt-command-right [] {}

    export def get-prompt-indicator [] {
        return $"(get-color white)○ (get-color reset)"
    }

    export def get-prompt-multiline-indicator [] {
        return $"(get-color white)──◇ (get-color reset)"
    }

    export def get-prompt-indicator-vi-insert [] {
        return $"(get-color white)◉ (get-color reset)"
    }

    export def get-prompt-indicator-vi-normal [] {
        let indicator = get-prompt-indicator
        return $indicator
    }

    export def get-transient-prompt-command [] { }

    export def get-transient-prompt-command-right [] { }

    export def get-transient-prompt-indicator [] {
        let indicator = get-prompt-indicator
        return $indicator
    }

    export def get-transient-prompt-multiline-indicator [] {
        return $"(get-color white)◇ (get-color reset)"
    }

    export def get-transient-prompt-indicator-vi-insert [] {
        let indicator = get-prompt-indicator-vi-insert
        return $indicator
    }

    export def get-transient-prompt-indicator-vi-normal [] {
        let indicator = get-prompt-indicator-vi-normal
        return $indicator
    }
}