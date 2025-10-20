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
nuprm 现在通过环境变量进行配置。您需要在您的 Nushell 环境配置文件（`~/.config/nushell/env.nu`）中添加配置。

#### 基本配置结构
```nu
# 你可以使用这个 Nuprm 配置作为模板
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

#### 配置选项说明

**启用 nuprm**
- `"enable": "on"` - 启用 nuprm
- `"enable": "off"` - 禁用 nuprm

**显示全名**
- `"use_full_name": "yes"` - 显示用户全名
- `"use_full_name": "no"` - 显示用户名

**目录缩写配置**
nuprm 支持智能目录缩写功能，让长路径显示更加短。

- `"directory_abbreviation.enable": "yes"` - 启用目录缩写
- `"directory_abbreviation.enable": "no"` - 禁用目录缩写

- `"directory_abbreviation.start_from_end": 3` - 从倒数第几个目录开始缩写
  - 设置为 `0` 禁用从倒数开始缩写，显示完整路径
  - 例如：`~/.test/aaa/bbb/ccc/ddd/eee/fff/ggg` 在不同设置下的显示效果：
    - 0: `~/.test/aaa/bbb/ccc/ddd/eee/fff/ggg`
    - 1: `~/.t/a/b/c/d/e/f/g`
    - 2: `~/.t/a/b/c/d/e/f/ggg`
    - 3: `~/.t/a/b/c/d/e/fff/ggg`
    - 4: `~/.t/a/b/c/d/eee/fff/ggg`
    - 5: `~/.t/a/b/c/ddd/eee/fff/ggg`

- `"directory_abbreviation.display_chars": 1` - 缩写后显示几个字符
  - 例如设置为 3：`/home/laism/.test/123456/demo/path` 会显示为 `~/.tes/123/demo/path`

- `"directory_abbreviation.home": "yes"` - 启用家目录缩写为 `~`
- `"directory_abbreviation.home": "no"` - 禁用家目录缩写

- `"directory_abbreviation.specific": {}` - 自定义特殊目录缩写
  - 您可以添加自定义目录缩写，例如将 `~/Documents` 设置为 `📄`，将家目录设置为 `🏠`
  > 如果你想要把家目录重新设置缩写显示，你必须禁用 `directory_abbreviation.home`

**系统图标显示**
- `"disable_system_icon": "yes"` - 禁用系统图标显示
- `"disable_system_icon": "no"` - 启用系统图标显示

**真彩色支持**
- `"true_color": "yes"` - 启用真彩色支持
- `"true_color": "no"` - 禁用真彩色支持

**信息显示配置**
- `"show_info.host": "yes"` - 显示主机名
- `"show_info.git": "yes"` - 显示 Git 仓库信息
- `"show_info.shells": "yes"` - 显示 Shells 信息

#### 主题管理
您可以使用 `nuprm theme list` 命令来查看可用的主题：

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

要设置主题，在您的环境配置文件中设置 `nuprm_theme` 常量：

```nu
# 设置主题
const nuprm_theme = "~/.config/nuprm/themes/主题名称.nu"
```

修改配置后，重启 Nushell 会话或重新进入以使更改生效：

```nu
exec $nu.current-exe
```
