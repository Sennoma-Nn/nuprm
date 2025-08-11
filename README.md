> [!WARNING] 
> This English version of `README.md` is machine-translated. If there are any translation issues, ambiguities, or discrepancies, the [original Chinese version (README-CN.md)](./README-CN.md) shall prevail.

# Nushell Prompt Manager (nuprm)

### Overview
**nuprm** is a Nushell prompt theme manager. It allows you to easily switch between different prompt themes, customize the appearance of your Nushell prompt, and manage prompt configurations through simple commands.

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
1. Enable nuprm
    ```nu
    nuprm true
    ```
    Your prompt will change:
    ```nu
    ~> nuprm true
    laism ~ ❯ 
    ```
    To disable nuprm, set it to `false`

2. Select and set themes
    ```nu
    nuprm theme list
    ```
    Lists available themes:
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
    laism ~ ❯ 
    ```
    Default theme is simple-minimal. Set a theme with `nuprm theme set`:
    ```nu
    ❯ nuprm theme set azure
    laism [ ~ ]$ 
    ```

3. Personalized prompt display configurations

    #### Enable full name display
    ```nu
    $ nuprm full-name set true
    La-Ysm [ ~ ]$ 
    ```
    Disable with `false`:
    ```nu
    $ nuprm full-name set false
    laism [ ~ ]$ 
    ```
    > Note: Only works on non-Android Unix/Unix-Like systems

    #### Directory abbreviation
    Default behavior: `~/.test/aaa/bbb/ccc/ddd/eee/fff/ggg` becomes `~/.t/a/b/c/d/e/fff/ggg`
    
    Toggle abbreviation:
    ```nu
    $ pwd
    /home/laism/.test/aaa/bbb/ccc/ddd/eee/fff/ggg
    $ nuprm abbr set false
    laism [ /home/laism/.test/aaa/bbb/ccc/ddd/eee/fff/ggg ]$ 
    ```
    Set where abbreviation starts (from end). Default=3:
    ```nu
    $ nuprm abbr end set 5
    laism [ ~/.t/a/b/c/ddd/eee/fff/ggg ]$ 
    ```
    Disable by setting to 0:
    ```nu
    $ nuprm abbr end set 0
    laism [ ~/.test/aaa/bbb/ccc/ddd/eee/fff/ggg ]$ 
    ```
    Effect preview:
    |Value|Display|
    |-|-|
    |0|`~/.test/aaa/bbb/ccc/ddd/eee/fff/ggg`|
    |1|`~/.t/a/b/c/d/e/f/g`|
    |2|`~/.t/a/b/c/d/e/f/ggg`|
    |3|`~/.t/a/b/c/d/e/fff/ggg`|
    |4|`~/.t/a/b/c/d/eee/fff/ggg`|
    |5|`~/.t/a/b/c/ddd/eee/fff/ggg`|

    Set displayed character count (default=1):
    ```nu
    $ pwd
    /home/laism/.test/123456/demo/path
    $ nuprm abbr chars set 3
    laism [ ~/.tes/123/demo/path ]$ 
    ```

    Toggle home directory abbreviation (default=`true`):
    ```nu
    $ cd ~
    $ nuprm abbr home set false
    laism [ /home/laism ]$ 
    ```

    Add custom directory abbreviations:
    ```nu
    $ nuprm abbr specific add ~/Documents 📄
     ~/Documents   📄
    $ cd Documents
    laism [ 📄 ]$ 
    ```
    Customize home directory symbol:
    ```nu
    $ cd ~
    $ nuprm abbr home set false
    $ nuprm abbr specific add ~ 🏠
     ~/Documents   📄
     ~             🏠
    laism [ 🏠 ]$ 
    ```
    > Note: Must disable home abbreviation before customizing home symbol

    Remove custom abbreviation:
    ```nu
    $ nuprm abbr specific remove ~/Documents
     ~   🏠
    $ cd Documents
    laism [ 🏠/Documents ]$ 
    ```

    List current abbreviations:
    ```nu
    $ nuprm abbr specific list
     ~   🏠
    laism [ 🏠/Documents ]$ 
    ```

    > Example for Android path:
    > ```nu
    > $ nuprm abbr specific add /storage/emulated/0/ EM0
    >  /storage/emulated/0/   EM0
    > $ cd /storage/emulated/0/
    > u0_a220 [ EM0 ]$ 
    > ```

    #### System icon display
    Some themes display system icons (typically those with the Power Line tag). Toggle this with `nuprm system-icon set` (default=`true`). Set to `false` to disable.

    > **Important about icon support**: 
    > This feature hasn't been fully tested as we can't test all operating systems and Linux distributions. 
    > - If you're on Linux and see a penguin icon (generic Linux icon) instead of your distro's specific icon
    > - If you're on other OS and see no icon at all
    > ...this means we don't yet support your distro/OS. 
    > 
    > Please submit an issue with the output of the `sys host` command. 
    > We'll add support for your system and greatly appreciate your contribution!
