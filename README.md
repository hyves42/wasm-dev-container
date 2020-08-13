# wasm-dev-container
A Docker container for Rust Wasm development

This simple container and helper scripts simplify the installation of the various tools needed for rust-wasm development.
This environment can be use to set up a standardised dev environment across several dev and build machines


All tools reside in the container can be invoked from the host development workspace.
The development workspace on the host is mounted as a volume when the container is run


## Usage :

### Installation :
Prequisite :  a Linux host with [Docker Engine](https://docs.docker.com/engine/install/)

To build the container, run :

  wasm-dev-container$ ./build.sh


### Usage :
From the root directory of the project to build, set up the environment by sourcing the setenv.sh script.
It is important to use the source command because we want to add environment variables and aliases to the current shell. 
If we just run the script all these environment variables will be lost after script ecxecution

  user@pc:~/wasm-project$ source /path/to/setenv.sh

Notice how the prompt has changed :

  ☻ [user@pc:wasm-project:. (master)]$

Development tools can now be invoked using the 'denv' prefix

  ☻ [yves@laptop:rust_js_in_docker:. (master)]$ denv wasm-pack --version
  wasm-pack 0.9.1
  ☻ [yves@laptop:rust_js_in_docker:. (master)]$ denv npm --version
  6.14.4
  ☻ [yves@laptop:rust_js_in_docker:. (master)]$ denv cargo --version
  cargo 1.45.0 (744bd1fbb 2020-06-15)

### Installed tools :
nodejs npm rust wasm-pack wabt binaryen