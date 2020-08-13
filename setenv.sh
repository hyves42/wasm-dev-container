#!/bin/sh
echo "usage : source setenv.sh"
local_cargo_dir=$HOME/.cargod

mkdir -p $local_cargo_dir
mkdir -p $local_cargo_dir/git
mkdir -p $local_cargo_dir/registry

export project_root=`pwd`
export root_name=$(basename $project_root)
echo "using $project_root as root"

alias reldir='realpath --relative-to=$project_root .'

path_in_prj(){
	case "`reldir`" in 
		*".."*) echo "Not in $project_root"; return 1;; 
		*) return 0;; 
	esac
}
export -f path_in_prj

alias testou='path_in_prj && echo cbon $(reldir)'

alias denv='path_in_prj && docker run -i -t -a STDIN -a STDOUT -a STDERR\
	--volume $project_root:/home/devuser/w\
	--volume $local_cargo_dir/git:/home/devuser/.cargo/git\
	--volume $local_cargo_dir/registry:/home/devuser/.cargo/registry\
	--workdir /home/devuser/w/$(reldir)\
	-p 3000:3000 ubuntu:dev'

alias °="denv"
export PS1="\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;33m\]☻ [\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]$root_name\[\033[00m\]:\[\033[01;34m\]\$(reldir)\[\033[00m\]\$(__git_ps1)\[\033[01;33m\]]\[\033[00m\]\$ "