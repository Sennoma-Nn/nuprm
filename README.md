> [!WARNING] 
> This English version of `README.md` is machine-translated. If there are any translation issues, ambiguities, or discrepancies, the [original Chinese version (README-CN.md)](./README-CN.md) shall prevail.

# Nushell Prompt Manager (nuprm)

### Overview
**nuprm** is a Nushell prompt theme manager. It allows you to easily switch between different prompt themes, customize the appearance of your Nushell prompt, and manage prompt configurations through environment variables.

### Installation
1. Clone this repository to your .config directory:
    ```nu
    git clone https://github.com/Sennoma-Nn/nuprm.git ~/.config/nuprm
    ```

2. Add the following line to your Nushell configuration file (`~/.config/nushell/config.nu`):
    ```nu
    source ~/.config/nuprm/nuprm.nu
    ```

3. Restart your Nushell session:
    ```nu
    exec $nu.current-exe
    ```

### Configuring nuprm
nuprm is now configured through environment variables. You need to add configuration to your Nushell environment file (`~/.config/nushell/env.nu`).

#### Basic Configuration Structure
```nu
# You can use this Nuprm configuration as a template
$env.NUPRMCONFIG = {
    "enable": "on",
    "use_full_name": "no",
    "disable_system_icon": "yes",
    "true_color": "yes",
    "directory_abbreviation": {
        "enable": "yes",
        "start_from_end": 3,
        "display_chars": 1,
        "home": "yes",
        "specific": {}
    },
    "show_info": {
        "host": "yes",
        "git": "yes",
        "shells": "yes"
    }
}

const nuprm_theme = "~/.config/nuprm/themes/simple-minimal.nu"
```

#### Configuration Options Explanation

**Enable nuprm**
- `"enable": "on"` - Enable nuprm
- `"enable": "off"` - Disable nuprm

**Display full name**
- `"use_full_name": "yes"` - Display user's full name
- `"use_full_name": "no"` - Display username

**Directory abbreviation configuration**
nuprm supports intelligent directory abbreviation to make long paths more readable.

- `"directory_abbreviation.enable": "yes"` - Enable directory abbreviation
- `"directory_abbreviation.enable": "no"` - Disable directory abbreviation

- `"directory_abbreviation.start_from_end": 3` - Start abbreviation from the Nth directory from the end
  - Set to `0` to disable abbreviation from the end, showing full path
  - Example: `~/.test/aaa/bbb/ccc/ddd/eee/fff/ggg` display effects with different settings:
    - 0: `~/.test/aaa/bbb/ccc/ddd/eee/fff/ggg`
    - 1: `~/.t/a/b/c/d/e/f/g`
    - 2: `~/.t/a/b/c/d/e/f/ggg`
    - 3: `~/.t/a/b/c/d/e/fff/ggg`
    - 4: `~/.t/a/b/c/d/eee/fff/ggg`
    - 5: `~/.t/a/b/c/ddd/eee/fff/ggg`

- `"directory_abbreviation.display_chars": 1` - Number of characters to display after abbreviation
  - For example, set to 3: `/home/laism/.test/123456/demo/path` will display as `~/.tes/123/demo/path`

- `"directory_abbreviation.home": "yes"` - Enable home directory abbreviation to `~`
- `"directory_abbreviation.home": "no"` - Disable home directory abbreviation

- `"directory_abbreviation.specific": {}` - Custom special directory abbreviations
  - You can add custom directory abbreviations, for example set `~/Documents` to `📄`, set home directory to `🏠`
  > If you want to customize the home directory abbreviation display, you must disable `directory_abbreviation.home`

**System icon display**
- `"disable_system_icon": "yes"` - Disable system icon display
- `"disable_system_icon": "no"` - Enable system icon display

**True color support**
- `"true_color": "yes"` - Enable true color support
- `"true_color": "no"` - Disable true color support

**Information display configuration**
- `"show_info.host": "yes"` - Display hostname
- `"show_info.git": "yes"` - Display Git repository information
- `"show_info.shells": "yes"` - Display Shells information

#### Theme Management
You can use the `nuprm theme list` command to view available themes:

```nu
❯ nuprm theme list
 #        name                   tag
─────────────────────────────────────────────────
 0   azure            Minimalist
 1   circuit          Multiple Lines
 2   galaxy-dream     Emoji, Multiple Lines
 3   gxy              Power Line, Multiple Lines
 4   neon-night       Multiple Lines
 5   power-blocks     Power Line
 6   retro-console    Retro
 7   simple-minimal   Minimalist
 8   sunset-ocean     Power Line, Multiple Lines
```

To set a theme, configure the `nuprm_theme` constant in your environment file:

```nu
# Set theme
const nuprm_theme = "~/.config/nuprm/themes/theme-name.nu"
```

After modifying the configuration, restart your Nushell session or re-enter to apply changes:

```nu
exec $nu.current-exe
