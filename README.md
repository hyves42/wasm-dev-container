# wasm-dev-container
A Docker container for Rust Wasm development

This simple container and helper scripts simplify the installation of the various tools needed for rust-wasm development.
They can be used to set up a standardised dev environment across several development/build/test machines, regardless of the tool versions provided by the host distribution packages.


All tools reside in the container and can be invoked from the host development workspace.

The development workspace on the host is mounted as a volume when the container is launched.


## Usage :

### Installation :
Prequisite : a Linux host with [Docker Engine](https://docs.docker.com/engine/install/). Current user is in 'docker' group and can run docker commands without root privilege.

To build the container, run :

```
wasm-dev-container$ ./build.sh
```

### Usage :
From the root directory of the project to build, set up the environment by sourcing the setenv.sh script.


```
user@pc:~/wasm-project$ source /path/to/setenv.sh
```

Note: It is important to use the source command because we want to add environment variables and aliases to the current shell. 
If we just run the script as ./setenv.sh, all these environment variables will be lost after script execution.


Notice how the prompt has changed :

```
☻ [user@pc:wasm-project:. (master)]$
```

Development tools can now be invoked using the 'denv' prefix

```
☻ [user@pc:wasm-project:. (master)]$ denv wasm-pack --version
wasm-pack 0.9.1
☻ [user@pc:wasm-project:. (master)]$ denv npm --version
6.14.4
☻ [user@pc:wasm-project:. (master)]$ denv cargo --version
cargo 1.45.0 (744bd1fbb 2020-06-15)
```

### Installed tools in the container :
nodejs npm rust wasm-pack wabt binaryen

### Network :
Port 3000 of the container is exposed to the host. If you plan to run devpack-web-server from the container, here is the network configuration to use :

```
  devServer: {
    port: 3000,
    host: '0.0.0.0'
  }, 
```

### Limitations :
#### User permissions
Container is designed to be used by a single user on the host. 
The build user ID in the container is hardcoded to the ID of the user who built the image on the host.

#### Filesystem sharing
Container can only access directories below the diretory that was used when sourding the setenv script.
If your build structure references other directories (for instance if npm build references ../pkg/), make sure to source the setenv script from a directory that contains all the source to be accessed by the containter.

#### Dev tool versions
Right now all the latest tool versions are downloaded when building the container. It would make sense to use fixed versions to get exactly the same build environment across all machines.

## Enjoy
Feel free to modify these scripts to fit your needs