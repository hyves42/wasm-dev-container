#!/bin/sh
echo "usage : source setenv.sh"

export project_root=`pwd`
export root_name=$(basename $project_root)
echo "using $project_root as root directory"

local_cargo_dir=$project_root/.cargo-in-docker
if [[ ! -d $local_cargo_dir ]]
then
	echo "Initialising local cargo cache in $local_cargo_dir"
	mkdir -p $local_cargo_dir
	docker cp $(docker create ubuntu_wasm_dev):/home/devuser/.cargo/ $local_cargo_dir
	mv $local_cargo_dir/.cargo/* $local_cargo_dir
	mv $local_cargo_dir/.cargo/.crates2.json $local_cargo_dir
	mv $local_cargo_dir/.cargo/.crates.toml $local_cargo_dir
	mv $local_cargo_dir/.cargo/.package-cache $local_cargo_dir

	rmdir $local_cargo_dir/.cargo
fi


alias reldir='realpath --relative-to=$project_root .'

path_in_prj(){
	case "`reldir`" in 
		*".."*) echo "Not in $project_root"; return 1;; 
		*) return 0;; 
	esac
}
export -f path_in_prj

alias denv='path_in_prj && docker run -i -t -a STDIN -a STDOUT -a STDERR\
	--volume $project_root:/home/devuser/w\
	--volume $local_cargo_dir:/home/devuser/.cargo\
	--workdir /home/devuser/w/$(reldir)\
	-p 3000:3000 ubuntu_wasm_dev'

alias °="denv"
export PS1="\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;33m\]☻ [\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]$root_name\[\033[00m\]:\[\033[01;34m\]\$(reldir)\[\033[00m\]\$(__git_ps1)\[\033[01;33m\]]\[\033[00m\]\$ "