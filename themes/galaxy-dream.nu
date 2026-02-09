export module nuprm-theme {
    def get-color [color] {
        let colors = {
            purple: (prompt-make-utils color-to-ansi 180 100 255 "fg" "35"),
            pink: (prompt-make-utils color-to-ansi 255 100 200 "fg" "95"),
            star: (prompt-make-utils color-to-ansi 255 255 150 "fg" "33"),
            reset: (ansi reset)
        }
        
        let return_color = $colors | get -o $color | default ""
        return $return_color
    }

    export def get-prompt-command-left [] {
        let user_name = get-prompt-info user-name -l $"✨ (get-color purple)🚀 (get-color pink)"
        let host_name = get-prompt-info host-name -l $"(get-color purple) at (get-color pink)"
        let user_host = $"($user_name)($host_name) (get-color purple)✨"
        let path_seg = $"(get-color pink)🪐 " + (get-prompt-info path (if (get-prompt-info path-mode) == "DOS" { "\\" } else { "/" }) -d $"(get-color purple)" -s $"(get-color pink)" -r "\e[0m" -u)
        let git_info = (get-prompt-info git -l " (" -r ")")
        let git_status = if ($git_info | str length) > 0 { $" (get-color pink)🌟(get-color star)($git_info)" } else { "" }
        let exit_status = if (get-prompt-info exit-code) != "0" { $" (get-color pink)💥(get-color purple) (get-prompt-info exit-code)" } else { "" }
        let execution_time = if (get-prompt-info exec-time | into float) > 0.5 { $" (get-color pink)⌛(get-color purple) (get-prompt-info exec-time)sec" } else { "" }
        return $"($user_host)\n($path_seg)($git_status)($exit_status)($execution_time)\n"
    }

    export def get-prompt-command-right [] {
        let shells_index = get-prompt-info shells -dl $"№" -r $" "
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

    export def get-prompt-indicator-vi-normal [] {
        let indicator = get-prompt-indicator
        return $indicator
    }

    export def get-transient-prompt-command [] {
        let prompt = get-prompt-command-left
        return $prompt
    }

    export def get-transient-prompt-command-right [] { }

    export def get-transient-prompt-indicator [] {
        let indicator = get-prompt-indicator
        return $indicator
    }

    export def get-transient-prompt-multiline-indicator [] {
        let indicator = get-prompt-multiline-indicator
        return $indicator
    }

    export def get-transient-prompt-indicator-vi-insert [] {
        let indicator = get-prompt-indicator-vi-insert
        return $indicator
    }

    export def get-transient-prompt-indicator-vi-normal [] {
        let indicator = get-prompt-indicator
        return $indicator
    }
}