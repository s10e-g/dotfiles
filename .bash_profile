# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs
PATH=${PATH}:${HOME}/.local/bin:${HOME}/bin:${HOME}/.local/share/go/bin:/usr/lib64/openmpi/bin:/usr/local/cuda/bin
export PATH
# . "$HOME/.cargo/env"

LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/cuda/lib64:/usr/local/lib64:/usr/local/lib
export LD_LIBRARY_PATH

export EDITOR="/usr/bin/vimx"
export SYSTEMD_EDITOR="/usr/bin/vimx"

export OptiX_INSTALL_DIR="/usr/local/NVIDIA-OptiX-SDK"
#export TCNN_CUDA_ARCHITECTURES=86
#export CUDA_VISIBLE_DEVICES=0
