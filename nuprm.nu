const nu_prompt_const = {
    prompt_utils_path: (["~" ".config" "nuprm" "utils" "prompt-utils.nu"] | path join | path expand)
    exe_path: (["~" ".config" "nuprm"] | path join | path expand)
    load_path: (["~" ".config" "nuprm" "load.nu"] | path join | path expand)
}

use $nu_prompt_const.prompt_utils_path *

do --env {
    try {
        let config_table = $env.NUPRMCONFIG? | default {}
        let is_enable = ($config_table | get -o "enabled" | default "no")

        if ($config_table | get -o "use_full_name" | default "no") == "yes" {
            if ($env.FULLNAME? == null) {
                $env.FULLNAME = get-prompt-info full-name
            }
        }

        if $is_enable == "yes" {
            source $nuprm_theme
        }
    } catch { |e|
        print "\e[31mERROR! CAN'T LOAD PROMPT!"
        print "\e[0m"
        print $e

        $env.PROMPT_COMMAND = {|| $env.pwd}
        $env.PROMPT_COMMAND_RIGHT = ""
        $env.PROMPT_INDICATOR = "> "
        $env.PROMPT_MULTILINE_INDICATOR = "::: "
        $env.PROMPT_INDICATOR_VI_INSERT = ": "
        $env.PROMPT_INDICATOR_VI_NORMAL = "> "

        $env.TRANSIENT_PROMPT_COMMAND = $env.PROMPT_COMMAND
        $env.TRANSIENT_PROMPT_COMMAND_RIGHT = $env.PROMPT_COMMAND_RIGHT
        $env.TRANSIENT_PROMPT_INDICATOR = $env.PROMPT_INDICATOR
        $env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = $env.PROMPT_MULTILINE_INDICATOR
        $env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = $env.PROMPT_INDICATOR_VI_INSERT
        $env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = $env.PROMPT_INDICATOR_VI_NORMAL
    }
}

# List all available prompt themes
def "nuprm theme list" [] {
    let description_path = ([$nu_prompt_const.exe_path "themes" ".description.yml"] | path join)
    open $description_path | each { |item| $item | reject "by" } | sort-by "name"
}
