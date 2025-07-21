# Nushell Prompt Manager (nupm)

[English](#english) | [中文](#中文)

---

## English

### Overview

**nupm** (Nushell Prompt Manager) is a powerful and flexible prompt theme manager for Nushell. It allows you to easily switch between different prompt themes, customize your terminal appearance, and manage prompt configurations with simple commands.

### Features

- 🎨 **Multiple Themes**: Choose from 7 beautiful pre-built themes
- 🔧 **Easy Management**: Simple commands to enable, disable, and switch themes
- ⚡ **Fast Switching**: Instant theme switching with automatic shell restart
- 📝 **Theme Descriptions**: View detailed information about each theme
- 🛠️ **Utility Functions**: Built-in helper functions for prompt customization

### Installation

1. Clone this repository to your Nushell configuration directory:
```bash
git clone https://github.com/Sennoma-Nn/nupm.git ~/.config/nupm
```

2. Add the following line to your Nushell configuration file (`~/.config/nushell/config.nu`):
```nushell
source ~/.config/nupm/nupm.nu
```

3. Restart your Nushell session.

### Available Themes

| Theme Name | Author | Style |
|------------|--------|-------|
| `azure` | Sennoma-Nn | Minimalist |
| `power-blocks` | Sennoma-Nn | Power Line |
| `gxy` | Sennoma-Nn | Power Line, Multiple Lines |
| `neon-night` | Sennoma-Nn | Multiple Lines |
| `retro-console` | Sennoma-Nn | Retro |
| `simple-minimal` | Sennoma-Nn | Minimalist |
| `galaxy-dream` | Sennoma-Nn | Emoji, Multiple Lines |

### Usage

#### Basic Commands

```nushell
# Show help information
nupm

# List all available themes
nupm list

# Set a specific theme
nupm set <theme_name>

# Enable prompt themes
nupm on

# Disable prompt themes
nupm off
```

#### Examples

```nushell
# Switch to the neon-night theme
nupm set neon-night

# Enable prompt theming
nupm on

# View all available themes
nupm list

# Disable prompt theming (use default)
nupm off
```

### Configuration

The configuration file is automatically created at `~/.config/nupm/config.yml` with the following structure:

```yaml
enable: "off"  # "on" or "off"
theme: "simple-minimal"  # default theme
```

### Utility Functions

The package includes several utility functions in `utils/prompt-utils.nu`:

- `home-to-tilde`: Convert home directory paths to tilde notation
- `get-git-info`: Retrieve current git branch information
- `get-where-shells`: Get current shell index information
- `color2ansi`: Convert RGB values to ANSI color codes
- `is-windows`: Check if running on Windows
- `get-user-name`: Get current username

### Contributing

Contributions are welcome! Feel free to:
- Submit bug reports
- Request new themes
- Contribute new theme designs
- Improve documentation

---

## 中文

### 概述

**nupm**（Nushell 提示符管理器）是一个强大而灵活的 Nushell 提示符主题管理器。它让您可以轻松地在不同的提示符主题之间切换，自定义终端外观，并通过简单的命令管理提示符配置。

### 特性

- 🎨 **多种主题**: 从 7 个精美的预制主题中选择
- 🔧 **简易管理**: 使用简单命令启用、禁用和切换主题
- ⚡ **快速切换**: 即时主题切换，自动重启 shell
- 📝 **主题描述**: 查看每个主题的详细信息
- 🛠️ **实用函数**: 内置的提示符自定义辅助函数

### 安装

1. 将此仓库克隆到您的 Nushell 配置目录：
```bash
git clone https://github.com/Sennoma-Nn/nupm.git ~/.config/nupm
```

2. 在您的 Nushell 配置文件（`~/.config/nushell/config.nu`）中添加以下行：
```nushell
source ~/.config/nupm/nupm.nu
```

3. 重启您的 Nushell 会话。

### 可用主题

| 主题名称 | 作者 | 风格 |
|----------|------|------|
| `azure` | Sennoma-Nn | 极简主义 |
| `power-blocks` | Sennoma-Nn | Power Line |
| `gxy` | Sennoma-Nn | Power Line, 多行 |
| `neon-night` | Sennoma-Nn | 多行 |
| `retro-console` | Sennoma-Nn | 复古 |
| `simple-minimal` | Sennoma-Nn | 极简主义 |
| `galaxy-dream` | Sennoma-Nn | 表情符号, 多行 |

### 使用方法

#### 基本命令

```nushell
# 显示帮助信息
nupm

# 列出所有可用主题
nupm list

# 设置特定主题
nupm set <主题名称>

# 启用提示符主题
nupm on

# 禁用提示符主题
nupm off
```

#### 示例

```nushell
# 切换到 neon-night 主题
nupm set neon-night

# 启用提示符主题
nupm on

# 查看所有可用主题
nupm list

# 禁用提示符主题（使用默认）
nupm off
```

### 配置

配置文件会自动创建在 `~/.config/nupm/config.yml`，结构如下：

```yaml
enable: "off"  # "on" 或 "off"
theme: "simple-minimal"  # 默认主题
```

### 实用函数

该包在 `utils/prompt-utils.nu` 中包含了几个实用函数：

- `home-to-tilde`: 将家目录路径转换为波浪号表示法
- `get-git-info`: 获取当前 git 分支信息
- `get-where-shells`: 获取当前 shell 索引信息
- `color2ansi`: 将 RGB 值转换为 ANSI 颜色代码
- `is-windows`: 检查是否在 Windows 上运行
- `get-user-name`: 获取当前用户名

### 贡献

欢迎贡献！您可以：
- 提交错误报告
- 请求新主题
- 贡献新的主题设计
- 改进文档

---

## Repository

🔗 **GitHub**: [https://github.com/Sennoma-Nn/nupm](https://github.com/Sennoma-Nn/nupm)

---

*Made with ❤️ for the Nushell community*
