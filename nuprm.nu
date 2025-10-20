const prompt_utils_path = (["~" ".config" "nuprm" "utils" "prompt-utils.nu"] | path join | path expand)
use $prompt_utils_path nu_prompt_const

$env.nuprm = {}

do --env {
    try {
        use $prompt_utils_path *

        let config_table = $env.NUPRMCONFIG
        let is_enable = ($config_table | get "enable")

        if ($config_table | get -o "use_full_name" | default "no") == "yes" {
            if ($env.FULLNAME? == null) {
                $env.FULLNAME = get-full-name
            }
        }

        if $is_enable == "on" {
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
