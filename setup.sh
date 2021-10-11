REPO=https://github.com/JerryGreen/setup.sh
RAW_REPO=https://raw.github.com/JerryGreen/setup.sh/master
MSG="### Automatically generated file. Instead of editing, add changes to either ~/.bashrc, or into repository:\n### $REPO\n"
set -e

# Initial Check

case "$OSTYPE" in
linux-gnu*)
  echo "Warning: Linux is not really supported! Feel free to adapt the script:"
  echo $REPO
  echo
  echo "Setting up 'linux' bash environment..."
  ;;
darwin*)
  echo "Setting up 'macos' bash environment..."
  ;;
msys*)
  echo "Setting up 'windows' bash environment..."
  ;;
esac

# Common Pre-Installation

mkdir -p ~/.rc
if [ -f ~/.bashrc ]; then
  RC_FILE=~/.bashrc
elif [ -f ~/.zshrc ]; then
  RC_FILE=~/.zshrc
elif [ command -v zsh 2>/dev/null && echo $? ]; then
  touch ~/.zshrc
  RC_FILE=~/.zshrc
elif [ command -v bash 2>/dev/null && echo $? ]; then
  touch ~/.bashrc
  RC_FILE=~/.bashrc
else
  echo "You don't have either zsh or bash (how did that come up?), exiting..." >&2
  exit 1
fi

cat <(echo -e $MSG) <(curl -sL $RAW_REPO/.rc/common.sh) >~/.rc/common.sh

# OS-specific Pre-Installation

case "$OSTYPE" in
linux-gnu*) ;;
darwin*)
  cat <(echo -e $MSG) <(curl -sL $RAW_REPO/.rc/macos.sh) >~/.rc/macos.sh
  ;;
msys*)
  cat <(echo -e $MSG) <(curl -sL $RAW_REPO/.rc/windows.sh) >~/.rc/windows.sh
  ;;
esac

# Common Post-Installation

mkdir -p ~/.completions
COMMAND='[[ -d ~/.rc && -n $(ls -A ~/.rc) ]] && . <(cat ~/.rc/*)'
if [[ -z $(cat $RC_FILE | grep -F "$COMMAND") ]]; then
  echo "$COMMAND" >>$RC_FILE
fi

# .netrc

# TODO:
# Setup .netrc
# cat <<EOF
# machine   raw.githubusercontent.com
# login     $GITHUB_KEY
# password  x-oauth-basic

# machine   api.github.com
# login     $GITHUB_KEY
# password  x-oauth-basic

# EOF

source $RC_FILE
echo "Setup complete!"
