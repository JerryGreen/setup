# my typicall zoxide configuration: use "cd" without arguments for interactive change directory
source ~/.zoxide.nu
def --env __zoxide_z2 [...rest:string] {
  if (($rest | length) == 0) {
    __zoxide_zi
  } else {
    let arg0 = ($rest | append '~').0
    let path = if (($rest | length) <= 1) and ($arg0 == '-' or ($arg0 | path expand | path type) == dir) {
      $arg0
      } else {
      (zoxide query --exclude $env.PWD -- ...$rest | str trim -r -c "\n")
    }
    cd $path
  }
}
alias cd = __zoxide_z2
alias cdi = __zoxide_zi

# Fix "Dock" menu: disable bouncing (which is annoying):
# defaults write com.apple.dock no-bouncing -bool TRUE
