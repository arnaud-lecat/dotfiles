if status is-interactive
    # Commands to run in interactive sessions can go here
end
set -gx CUDA_HOME /opt/cuda
set -gx LV_BRANCH release-1.4/neovim-0.9
set -gx LD_LIBRARY_PATH $CUDA_HOME/lib64 $LD_LIBRARY_PATH
set -gx PIP_REQUIRE_VIRTUALENV true
set -gx PATH ~/.npm-global/bin $PATH

alias lvim='/home/alecat/.local/bin/lvim'
alias vim=lvim
alias vi=lvim

# pnpm
set -gx PNPM_HOME "/home/alecat/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

if not contains "$HOME/.local/bin" $PATH
	set -gx PATH "$HOME/.local/bin" $PATH
end
