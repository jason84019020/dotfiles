# ~/.config/zsh/install.zsh

## --------------------------------------------------------------------------
## 開發環境自動化安裝腳本
## --------------------------------------------------------------------------
INSTALLED_FLAG="$HOME/.cache/.zsh_installed"

# 檢查是否已初始化，避免重複掃描
[[ -f "$INSTALLED_FLAG" ]] && return

# 定義訊息顏色與圖示
readonly MSG_INFO="%F{33}[→]%f"    # 藍色：進行中
readonly MSG_SUCCESS="%F{34}[✓]%f" # 綠色：成功
readonly MSG_ERROR="%F{160}[✘]%f"  # 紅色：失敗
readonly MSG_WARN="%F{220}[!]%f"   # 黃色：警告

## --------------------------------------------------------------------------
## 1. 安裝 zinit 外掛管理器
## --------------------------------------------------------------------------
ZINIT_HOME="$HOME/.local/share/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME/.git" ]; then
  print -P "${MSG_INFO} 正在安裝 zinit..."
  command mkdir -p "$(dirname $ZINIT_HOME)"
  command chmod g-rwX $ZINIT_HOME
  command git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME" && \
    { print -P "${MSG_SUCCESS} zinit 安裝成功"; } || \
    { print -P "${MSG_ERROR} zinit 安裝失敗"; return 1; }
fi

## --------------------------------------------------------------------------
## 2. 安裝 Oh My Posh (提示字元)
## --------------------------------------------------------------------------
if ! command -v oh-my-posh &> /dev/null; then
  print -P "${MSG_INFO} 正在安裝 oh-my-posh..."
  command mkdir -p "$HOME/.local/bin"
  command curl -s https://ohmyposh.dev/install.sh | bash -s -- -d $HOME/.local/bin && \
    { print -P "${MSG_SUCCESS} oh-my-posh 安裝成功"; } || \
    { print -P "${MSG_ERROR} oh-my-posh 安裝失敗"; return 1; }
fi

## --------------------------------------------------------------------------
## 3. 安裝 Oh My Tmux (終端機配置)
## --------------------------------------------------------------------------
TMUX_HOME="$HOME/.local/share/oh-my-tmux/oh-my-tmux.git"
TMUX_CONFIG_DIR="$HOME/.config/tmux"
if [[ ! -d "$TMUX_HOME/.git" ]]; then
  print -P "${MSG_INFO} 正在安裝 oh-my-tmux..."
  command mkdir -p "$(dirname $TMUX_HOME)"
  command mkdir -p "$TMUX_CONFIG_DIR"
  command git clone --single-branch https://github.com/gpakosz/.tmux.git "$TMUX_HOME" && \
    { print -P "${MSG_SUCCESS} oh-my-tmux 安裝成功"; } || \
    { print -P "${MSG_ERROR} oh-my-tmux 安裝失敗"; return 1; }
  command ln -sf "$TMUX_HOME/.tmux.conf" "$TMUX_CONFIG_DIR/tmux.conf"
  # command cp "$TMUX_HOME/.tmux.conf.local" "$TMUX_CONFIG_DIR/tmux.conf.local"
fi

## --------------------------------------------------------------------------
## 4. 完成初始化標記
## --------------------------------------------------------------------------
command mkdir -p "$(dirname "$INSTALLED_FLAG")"
touch "$INSTALLED_FLAG"
print -P "${MSG_SUCCESS} 開發環境初始化完成！"
