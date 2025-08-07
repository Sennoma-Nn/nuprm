const prompt_utils_path = (["~" ".config" "nuprm" "utils" "prompt-utils.nu"] | path join | path expand)
use $prompt_utils_path nu_prompt_const

do --env {
    use $prompt_utils_path *
    if not ($nu_prompt_const.config_path | path exists) {
        touch $nu_prompt_const.config_path
        let config = {
            enable: "off"
            theme: "simple-minimal"
            use_full_name: "no"
            disable_system_icon: "no"
            directory_abbreviation: {
                enable: "yes"
                home: "yes"
                start_from_end: 3
                display_chars: 1
            }
        }
        $config | to yaml | save $nu_prompt_const.config_path -f
    }

    let config_table = (open $nu_prompt_const.config_path)
    let is_enable = ($config_table | get "enable")
    let theme_name = ($config_table | get "theme")

    let theme_path = ([$nu_prompt_const.exe_path "themes" $"($theme_name).nu"] | path join)
    $"source ($theme_path)" | save $nu_prompt_const.load_path -f
    if $is_enable == "on" {
        source $nu_prompt_const.load_path
    }
}

# Set the prompt theme to specified theme name
def "nuprm set theme" [
    theme_name: string # Name of theme to set (e.g. "simple-minimal", "retro-console")
] {
    mut config = (open $nu_prompt_const.config_path)
    $config.theme = $theme_name
    
    let theme_path = ([$nu_prompt_const.exe_path "themes" $"($theme_name).nu"] | path join)
    if ($theme_path | path exists) {
        $config | to yaml | save $nu_prompt_const.config_path -f
        $"source ($theme_path)" | save $nu_prompt_const.load_path -f
        exec $nu.current-exe
    } else {
        print "\e[31mThe Theme File Is Not Exists."
    }
}

# List all available prompt themes
def "nuprm list" [] {
    let description_path = ([$nu_prompt_const.exe_path "themes" ".description.yml"] | path join)
    open $description_path | each { |item| $item | reject "by" } | sort-by "name"
}

# Toggle showing full directory path in prompt
def "nuprm set full-name" [
    enable: bool # `true` to show full path, `false` for abbreviated path
] {
    mut config = (open $nu_prompt_const.config_path)
    $config.use_full_name = if $enable { "yes" } else { "no" }
    $config | to yaml | save $nu_prompt_const.config_path -f
}

# Toggle display of system icons in prompt
def "nuprm set system-icon" [
    enable: bool # `true` to show system icons, `false` to hide them
] {
    mut config = (open $nu_prompt_const.config_path)
    $config.disable_system_icon = if not $enable { "yes" } else { "no" }
    $config | to yaml | save $nu_prompt_const.config_path -f
}

# Toggle directory path abbreviation in prompt
def "nuprm set abbr" [
    enable: bool # `true` to enable path abbreviation, `false` to disable
] {
    mut config = (open $nu_prompt_const.config_path)
    $config.directory_abbreviation.enable = if $enable { "yes" } else { "no" }
    $config | to yaml | save $nu_prompt_const.config_path -f
}

# Toggle home directory (~) abbreviation in prompt
def "nuprm set abbr home" [
    enable: bool # `true` to abbreviate home as ~, `false` to show full path
] {
    mut config = (open $nu_prompt_const.config_path)
    $config.directory_abbreviation.home = if $enable { "yes" } else { "no" }
    $config | to yaml | save $nu_prompt_const.config_path -f
}

# Set number of directory segments to show from path end
def "nuprm set abbr end" [
    num: int # Number of path segments to show from end (e.g. 3 shows last 3 parts)
] {
    mut config = (open $nu_prompt_const.config_path)
    $config.directory_abbreviation.start_from_end = $num
    $config | to yaml | save $nu_prompt_const.config_path -f
}

# Set number of characters to show for each directory name
def "nuprm set abbr chars" [
    num: int # Number of chars to show per directory (e.g. 1 shows first letter)
] {
    mut config = (open $nu_prompt_const.config_path)
    $config.directory_abbreviation.display_chars = $num
    $config | to yaml | save $nu_prompt_const.config_path -f
}

# Enable/disable the nuprm prompt system
def nuprm [
    enable: bool # `true` to enable nuprm prompt, `false` to disable
] {
    mut config = (open $nu_prompt_const.config_path)
    $config.enable = if $enable { "on" } else { "off" }
    $config | to yaml | save $nu_prompt_const.config_path -f

    exec $nu.current-exe
}
