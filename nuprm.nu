use (($nuprm_path | path split) ++ ["utils" "prompt-utils.nu"] | path join | path expand) *
use (($nuprm_path | path split) ++ ["theme-list.nu"] | path join | path expand) theme_info

do --env -i {
    try {
        let config_table = $env.NUPRMCONFIG? | default {}
        let is_enable = ($config_table | get -o "enabled" | default "no")

        if ($config_table | get -o "use_full_name" | default "no") == "yes" {
            if ($env.FULLNAME? == null) {
                $env.FULLNAME = get-prompt-info full-name
            }
        }

        if $is_enable == "yes" {
            use $nuprm_theme nuprm-theme

            $env.PROMPT_COMMAND = {|| nuprm-theme get-prompt-command-left }
            $env.PROMPT_COMMAND_RIGHT = {|| nuprm-theme get-prompt-command-right }
            $env.PROMPT_INDICATOR = {|| nuprm-theme get-prompt-indicator }
            $env.PROMPT_MULTILINE_INDICATOR = {|| nuprm-theme get-prompt-multiline-indicator }
            $env.PROMPT_INDICATOR_VI_INSERT = {|| nuprm-theme get-prompt-indicator-vi-insert }
            $env.PROMPT_INDICATOR_VI_NORMAL = {|| nuprm-theme get-prompt-indicator-vi-normal }
            $env.TRANSIENT_PROMPT_COMMAND = {|| nuprm-theme get-transient-prompt-command }
            $env.TRANSIENT_PROMPT_COMMAND_RIGHT = {|| nuprm-theme get-transient-prompt-command-right }
            $env.TRANSIENT_PROMPT_INDICATOR = {|| nuprm-theme get-transient-prompt-indicator }
            $env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = {|| nuprm-theme get-transient-prompt-multiline-indicator }
            $env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = {|| nuprm-theme get-transient-prompt-indicator-vi-insert }
            $env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = {|| nuprm-theme get-transient-prompt-indicator-vi-normal }
        }
    } catch {|e|
        print "\e[31mERROR!\e[0m\n" $e
    }
}

# List all available prompt themes
def "nuprm theme list" [] {
    $theme_info | each {|item| $item | reject by } | sort-by name
}

def "nuprm theme preview" [] {
    let theme_name_list = $theme_info | get "name" | sort
    $theme_name_list | each {|i|
        let theme_path = (($nuprm_path | path split) ++ ["themes", $i] | path join | path expand)
        let utils_path = (($nuprm_path | path split) ++ ["utils" "prompt-utils.nu"] | path join | path expand)
        let config_json = $env.NUPRMCONFIG | to json
        let preview = ^$nu.current-exe --no-config-file -c $"
            $env.NUPRMCONFIG = '($config_json)' | from json
            use ($utils_path) *
            use ($theme_path) nuprm-theme
            let command = do {|| nuprm-theme get-prompt-command-left }
            let command_r = do {|| nuprm-theme get-prompt-command-right } | default ""
            let indicator = do {|| nuprm-theme get-prompt-indicator }
            let preview = {left: $"\($command\)\($indicator\)", right: $command_r} | to json

            print $preview
        "
        
        let preview_l = $preview | from json | get -o "left" | default ""
        let preview_r = $preview | from json | get -o "right" | default ""

        return {
            name: $i
            left: ($preview_l + "\e[5m▂\e[0m" + "\n")
            right: ($preview_r + "\n")
        }
    }
}