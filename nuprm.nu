
do --env -i {
    use (($nuprm_path | path split) ++ ["utils" "prompt-utils.nu"] | path join | path expand) *

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
        print "\e[31mNuPrm ERROR!\e[0m\n" $e
    }
}

# List all available prompt themes
def "nuprm theme list" [
    --preview (-p)
] {
    use (($nuprm_path | path split) ++ ["theme-list.nu"] | path join | path expand) theme_info

    let theme_name_list = $theme_info | sort-by "name"
    $theme_name_list | each {|i|
        let theme_name = $i.name
        let theme_tags = $i.tag
        let theme_path = (($nuprm_path | path split) ++ ["themes", $theme_name] | path join | path expand)
        let utils_path = (($nuprm_path | path split) ++ ["utils" "prompt-utils.nu"] | path join | path expand)
        let config_json = $env.NUPRMCONFIG | to json
        let preview_prompt = if $preview {
            try {
                ^$nu.current-exe --no-config-file -c $"
                    $env.NUPRMCONFIG = '($config_json)' | from json
                    use ($utils_path) *
                    use ($theme_path) nuprm-theme
                    let command_l = do {|| nuprm-theme get-prompt-command-left } | default ""
                    let command_r = do {|| nuprm-theme get-prompt-command-right } | default ""
                    let indicator = do {|| nuprm-theme get-prompt-indicator } | default ""
                    let multiline = do {|| nuprm-theme get-prompt-multiline-indicator } | default ""
                    let preview_json = {
                        command_l: $command_l,
                        indicator: $indicator
                        multiline: $multiline
                        command_r: $command_r
                    } | to json

                    print $preview_json
                " | complete | get -o "stdout"
            }
        } else { null }
        
        let preview_command_l = if $preview { $preview_prompt | from json | get -o "command_l" | default "" } else { null }
        let preview_indicator = if $preview { $preview_prompt | from json | get -o "indicator" | default "" } else { null }
        let preview_multiline = if $preview { $preview_prompt | from json | get -o "multiline" | default "" } else { null }
        let preview_command_r = if $preview { $preview_prompt | from json | get -o "command_r" | default "" } else { null }
        let preview_record = if $preview {
            {
                left: $"($preview_command_l)($preview_indicator)",
                right: $preview_command_r
            }
        } else {
            {
                # empty record
            }
        }

        let list =  {
            tags: $theme_tags
            ...$preview_record
        } | table --theme thin

        return {
            name: $theme_name,
            information: $list
        }
    }
}