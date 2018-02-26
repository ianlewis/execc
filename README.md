# execc

execc is a simple example of a container runtime. It simply runs
a command in a container. It uses the cgcreate, cgexec, cgset, cgdelete,
unshare, and chroot commands to initialize the container.

The uuidgen, and bc commands are also required.

A newer version of unshare that supports --fork, --user, --pid and --mount-proc
is recommended.

## Prerequisites

The following are required.

- bash
- unshare
- cgcreate
- cgexec
- cgset
- cgdelete
- uuidgen
- bc

Most of these other than 'bc' and 'libcgroup-tools' are installed already on most systems. Install them like so:

    $ sudo apt-get install libcgroup-tools bc

## Usage

```
$ ./execc --help
Usage: execc [OPTION]... [COMMAND]
Execute COMMAND in a container. COMMAND is executed in it's
own set of namespaces and given a cgroup if limit options
are specified.
Example: execc -c 100 -m 100000000 /bin/sh

WARNING: This runtime is not stable and should not be used
in anything resembling a production environment.

Cgroup options:
 -c, --cpu=MILLICORES      CPU limit for the container in
                           number of milli-cores.
 -m, --memory=BYTES        Memory limit for the container
                           in bytes.

Namespace options:
 --rootfs=PATH             Run the container with it's root set
                           to specified root filesystem path.
                           If the specified path is a tar
                           archive, it will be unpacked to
                           a temporary directory and that
                           will be used as the root filesystem.
                           Default: /
 --mount=(true|false)      Run the container in its own mounts
                           namespace. Default: true
 --ipc=(true|false)        Run the container in its own IPC
                           namespace. Default: true
 --uts=(true|false)        Run the container in its own UTS
                           namespace. Default: true
 --net=(true|false)        Run the container in its own network
                           namespace. Default: true
```

## Examples

Run a shell in a busybox container limited to 100 milli-cores and 1 megabyte of memory.

```
$ mkdir rootfs
$ docker export $(docker create busybox) | gzip -c > busybox.tar.gz
$ sudo execc -c 100 -m 1000000 --rootfs busybox.tar.gz /bin/sh
/ # echo "Hello from inside a container!"
Hello from inside a container!
#
```

## Similar projects

- [bocker](https://github.com/p8952/bocker) - Docker in ~100 lines of bash

## Disclaimer

This is not an official Google product.
