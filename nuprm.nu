const prompt_utils_path = (["~" ".config" "nuprm" "utils" "prompt-utils.nu"] | path join | path expand)
use $prompt_utils_path nu_prompt_const

$env.nuprm = {}

do --env {
    try {
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
                    start_from_end: 3
                    display_chars: 1
                    home: "yes"
                    specific: {
                    }
                }
            }
            $config | to yaml | save $nu_prompt_const.config_path -f
        }

        let config_table = (open $nu_prompt_const.config_path)
        let is_enable = ($config_table | get "enable")
        let theme_name = ($config_table | get "theme")

        if ($config_table | get -i "use_full_name" | default "no") == "yes" {
            if ($env.FULLNAME? == null) {
                $env.FULLNAME = get-full-name
            }
        }

        let theme_path = ([$nu_prompt_const.exe_path "themes" $"($theme_name).nu"] | path join)
        $"source ($theme_path)" | save $nu_prompt_const.load_path -f
        if $is_enable == "on" {
            source $nu_prompt_const.load_path
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

# Set the prompt theme to specified theme name
def "nuprm theme set" [
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
def "nuprm theme list" [] {
    let description_path = ([$nu_prompt_const.exe_path "themes" ".description.yml"] | path join)
    open $description_path | each { |item| $item | reject "by" } | sort-by "name"
}

# Toggle showing full directory path in prompt
def --env "nuprm full-name set" [
    enable: bool # `true` to show full path, `false` for abbreviated path
] {
    mut config = (open $nu_prompt_const.config_path)
    $config.use_full_name = if $enable { "yes" } else { "no" }
    $config | to yaml | save $nu_prompt_const.config_path -f
    if $enable and ($env.FULLNAME? == null) {
        use $prompt_utils_path "get-full-name"
        $env.FULLNAME = get-full-name
    }
}

# Toggle display of system icons in prompt
def "nuprm system-icon set" [
    enable: bool # `true` to show system icons, `false` to hide them
] {
    mut config = (open $nu_prompt_const.config_path)
    $config.disable_system_icon = if not $enable { "yes" } else { "no" }
    $config | to yaml | save $nu_prompt_const.config_path -f
}

# Toggle directory path abbreviation in prompt
def "nuprm abbr set" [
    enable: bool # `true` to enable path abbreviation, `false` to disable
] {
    mut config = (open $nu_prompt_const.config_path)
    $config.directory_abbreviation.enable = if $enable { "yes" } else { "no" }
    $config | to yaml | save $nu_prompt_const.config_path -f
}

# Toggle home directory (~) abbreviation in prompt
def "nuprm abbr home set" [
    enable: bool # `true` to abbreviate home as ~, `false` to show full path
] {
    mut config = (open $nu_prompt_const.config_path)
    $config.directory_abbreviation.home = if $enable { "yes" } else { "no" }
    $config | to yaml | save $nu_prompt_const.config_path -f
}

# Set how many directories from the end should start being abbreviated
def "nuprm abbr end set" [
    num: int # Number of directories from the end to start abbreviating (e.g., 3 = abbreviate starting from the 3rd last, full display for last 2)
] {
    if $num >= 0 {
        mut config = (open $nu_prompt_const.config_path)
        $config.directory_abbreviation.start_from_end = $num
        $config | to yaml | save $nu_prompt_const.config_path -f
    } else {
        print "\e[31mThe value must be >= 0."
    }
}

# Set number of characters to show for each directory name
def "nuprm abbr chars set" [
    num: int # Number of chars to show per directory (e.g. 1 shows first letter)
] {
    if $num >= 1 {
        mut config = (open $nu_prompt_const.config_path)
        $config.directory_abbreviation.display_chars = $num
        $config | to yaml | save $nu_prompt_const.config_path -f
    } else {
        print "\e[31mThe value must be >= 1."
    }
}

# Add custom path abbreviation to prompt configuration
def "nuprm abbr specific add" [
    path: string    # Absolute path to abbreviate (e.g. '/home/user/.config')
    display: string # Display text to show instead (e.g. '🛠️')
] {
    mut config = (open $nu_prompt_const.config_path)
    if not ($path in $config.directory_abbreviation.specific) {
        $config.directory_abbreviation.specific = $config.directory_abbreviation.specific | merge {($path): $display}
        $config | to yaml | save $nu_prompt_const.config_path -f
    }
    nuprm abbr specific list
}

# Removes a custom path abbreviation from prompt configuration
def "nuprm abbr specific remove" [
    path: string # Absolute path to remove from abbreviations
] {
    mut config = (open $nu_prompt_const.config_path)
    if $path in $config.directory_abbreviation.specific {
        $config.directory_abbreviation.specific = $config.directory_abbreviation.specific | reject $path
        $config | to yaml | save $nu_prompt_const.config_path -f
    }
    nuprm abbr specific list
}

# Lists all custom path abbreviations in prompt configuration
def "nuprm abbr specific list" [] {
    let config = (open $nu_prompt_const.config_path)
    print $config.directory_abbreviation.specific
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
