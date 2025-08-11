# Nushell Prompt Manager (nuprm)

### 概述
**nuprm** 是一个 Nushell 提示符主题管理器。它让您可以轻松地在不同的提示符主题之间切换，自定义 Nushell 提示符的外观，并通过简单的命令管理提示符配置。

### 安装
1. 将此仓库克隆到您的 .config 目录：
    ```nu
    git clone https://github.com/Sennoma-Nn/nuprm.git ~/.config/nuprm
    ```

2. 在您的 Nushell 配置文件（`~/.config/nushell/config.nu`）中添加以下行：
    ```nu
    source ~/.config/nuprm/nuprm.nu
    ```

3. 重启您的 Nushell 会话。
    ```nu
    exec $nu.current-exe
    ```

### 配置 nuprm
1. 启用 nuprm

    ```nu
    nuprm true
    ```

    此时您的提示符会发生变化
    ```nu
    ~> nuprm true
    laism ~ ❯ 
    ```

    如果您想要停用 nuprm 您可以将它设置为 `false`

2. 选择并设置主题

   ```nu
   nuprm theme list
   ```

   这会列出目前可用的主题
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

    默认的提示符主题是 simple-minimal，您可以使用 `nuprm theme set` 来设置提示符，比如您想要设置或者预览 azure 主题
    ```nu
    ❯ nuprm theme set azure
    laism [ ~ ]$ 
    ```

    这样可以将您的提示符主题切换到 azure 主题上

3. 一些个性化的提示符的显示配置

    nuprm 设置了一些个性化的显示配置

    #### 启用显示全名
    您可以使用 `nuprm full-name set` 来让 nuprm 显示全名
    ```nu
    $ nuprm full-name set true
    La-Ysm [ ~ ]$ 
    ```

    如果您想要停用全名显示您可以设置它为 `false`
    ```nu
    $ nuprm full-name set false
    laism [ ~ ]$ 
    ```

    > 注：这仅在非安卓的 Unix / Unix-Like 中系统有效

    #### 目录缩写
    nuprm 默认会使用目录缩写，比如 `~/.test/aaa/bbb/ccc/ddd/eee/fff/ggg` 在默认配置下会被缩写为 `~/.t/a/b/c/d/e/fff/ggg`

    您可以使用 `nuprm abbr set` 启用关闭缩写
    ```nu
    $ pwd
    /home/laism/.test/aaa/bbb/ccc/ddd/eee/fff/ggg
    $ nuprm abbr set false
    laism [ /home/laism/.test/aaa/bbb/ccc/ddd/eee/fff/ggg ]$ 
    ```

    您也可以重新设置为 `true` 来启用缩写
    ```nu
    $ pwd
    /home/laism/.test/aaa/bbb/ccc/ddd/eee/fff/ggg
    $ nuprm abbr set true
    laism [ ~/.t/a/b/c/d/e/fff/ggg ]$ 
    ```

    您可以使用 `nuprm abbr end set` 来设置从**倒数**第几个目录**开始**缩写，其默认值是 3，比如您想设置从倒数第 5 个目录开始缩写
    ```nu
    $ nuprm abbr end set 5
    laism [ ~/.t/a/b/c/ddd/eee/fff/ggg ]$ 
    ```

    现在完整显示的目录是最后 4 个，如果您想要禁用从倒数第几个开始缩写您可以把它的值设置为 `0`
    ```nu
    $ nuprm abbr end set 0
    laism [ ~/.test/aaa/bbb/ccc/ddd/eee/fff/ggg ]$ 
    ```

    您可以参考下表来预览各个值的效果

    |数量|显示|
    |-|-|
    |0|`~/.test/aaa/bbb/ccc/ddd/eee/fff/ggg`|
    |1|`~/.t/a/b/c/d/e/f/g`|
    |2|`~/.t/a/b/c/d/e/f/ggg`|
    |3|`~/.t/a/b/c/d/e/fff/ggg`|
    |4|`~/.t/a/b/c/d/eee/fff/ggg`|
    |5|`~/.t/a/b/c/ddd/eee/fff/ggg`|

    您可以使用 `nuprm abbr chars set` 来设置缩写后显示几个字符，其默认值是 1（`.` 开头的目录会不算第一个 `.` 的长度），比如您想设置缩写后显示 3 个字符
    ```nu
    $ pwd
    /home/laism/.test/123456/demo/path
    $ nuprm abbr chars set 3
    laism [ ~/.tes/123/demo/path ]$ 
    ```

    可以看到目录 `123456/` 被显示为了 `123/`

    您可以使用 `nuprm abbr home set` 来启用关闭**家目录**的缩写（其默认是 `true` 也就是开启），比如您想要关闭家目录的缩写
    ```nu
    $ cd ~
    $ nuprm abbr home set false
    laism [ /home/laism ]$ 
    ```

    现在家目录就不会被缩写为 `~` 了，如果您想要重新启用可以把它重新设置为 `true`
    ```nu
    $ cd ~
    $ nuprm abbr home set true
    laism [ ~ ]$
    ```

    您可以使用 `nuprm abbr specific add` 添加自定义特殊目录缩写，其行为类似家目录被缩写为 `~`，您可以自定义您想把某个目录缩写为某个特定的字符，比如您想把文档目录设置为 `📄` Emoji，您可以使用
    ```nu
    $ nuprm abbr specific add ~/Documents 📄
     ~/Documents   📄
    $ cd Documents
    laism [ 📄 ]$ 
    ```

    您也可以重新设置您的家目录为 Emoji 的 `🏠`，您可以使用
    ```
    $ cd ~
    $ nuprm abbr home set false
    $ nuprm abbr specific add ~ 🏠
     ~/Documents   📄
     ~             🏠
    laism [ 🏠 ]$ 
    ```

    > 请注意，如果您想要重设家目录的显示符号必须关闭家目录的缩写然后自定义特殊目录的缩写，否则家目录仍然会被显示为 `~`

    如果您想要移除一个自定义特殊目录的缩写，您可以使用 `nuprm abbr specific remove` 命令来移除，比如想要移除刚刚设置的 `Documents` 目录的缩写，您可以使用
    ```nu
    $ nuprm abbr specific remove ~/Documents
     ~   🏠
    $ cd Documents
    laism [ 🏠/Documents ]$ 
    ```

    这样就可以把刚刚设置的 `Documents` 目录的缩写移除掉

    如果您想要查看您现在设置了什么目录的缩写您可以使用 `nuprm abbr specific list` 命令来查看
    ```nu
    $ nuprm abbr specific list
     ~   🏠
    laism [ 🏠/Documents ]$ 
    ```

    这会列出现在设置的缩写

    > 当然除了设置为 Emoji 您也可以设置为一个单词或者字母，比如您想把 `/storage/emulated/0/` 设置为 `EM0`
    > ```nu
    > $ nuprm abbr specific add /storage/emulated/0/ EM0
    >  /storage/emulated/0/   EM0
    > $ cd /storage/emulated/0/
    > u0_a220 [ EM0 ]$ 
    > ```

    #### 系统图标显示
    部分主题会显示系统图标，这些主题通常是带有 Power Line 标签的主题，您可以使用 `nuprm system-icon set` 命令启用或禁用该设置（其默认值为 `true`）如果您想要关闭您可以设置为 `false`

    > **关于图标支持的重要信息**  
    > 该图标功能并未完全测试完成，因为我们目前无法测试全部的操作系统以及全部的 Linux 发行版  
    > - 如果您在使用 Linux 操作系统，您发现在显示系统图标的位置显示为 Liunx 的企鹅图标而不是您的发行版的图标，或者您是其他操作系统，您发现在显示系统图标的位置完全不显示图标  
    > - 这意味着我们的程序未支持您的发行版或者操作系统  
    > 
    > 如果可以的话您可以给我们提 issue 并附带上 `sys host` 命令的输出给我们  
    > 我们会将它加到我们的程序中并且感谢您的