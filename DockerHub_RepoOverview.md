
# docker-webtop-framac

## Why

This image provides a linux with a GUI running either on a local docker or on MyDocker, with Frama-C and provers already installed. 
It is based on [WebTop image from LinuxServer.io](https://github.com/linuxserver/docker-webtop) 
which is maintained and quite often updated.

This image uses Ubuntu 24.04 and the [XFCE](https://www.xfce.org/) desktop environment.

It is available on [Docker hub](https://hub.docker.com/r/fredblgr/docker-webtop-framac)
and on [GitHub](https://github.com/Frederic-Boulanger-UPS/docker-webtop-framac)

## Installed software
- [Frama-C](https://frama-c.com/) 31.0 with MetAcsl 0.9
- [Why 3](https://www.why3.org/) 1.8.1
- [Isabelle/HOL](https://isabelle.in.tum.de/) 2022 (last version supported by Why3)
- [CoqIDE](https://rocq-prover.org/doc/V8.18.0/refman/practical-tools/coqide.html)
- Several automatic provers ([Alt-Ergo](https://alt-ergo.ocamlpro.com/), z3, cvc4, cvc5)

## Details

- The exposed ports are 3000 (HTTP/VNC) and 3001 (HTTPS/VNC).
- The user folder is `/config`.
- the user is `abc`, its password also, sudo is without password.
- if docker is installed on your computer, you can run (amd64 or arm64 architecture) this 
  image, assuming you are in a specific folder containing a "config" subfolder that will 
  be shared with the container at `/config`, with:
  
  `docker run --rm --detach \
  						--publish 3000:3000 \
  						--publish 3001:3001 \
  						--volume "$(pwd)/config:/config:rw" \
    			fredblgr/docker-webtop-framac:2025`

You may also use the scripts [start-3asl.sh](https://github.com/Frederic-Boulanger-UPS/docker-webtop-3asl/blob/main/start-3asl.sh) or [start-3asl.ps1](https://github.com/Frederic-Boulanger-UPS/docker-webtop-3asl/blob/main/start-3asl.ps1).

You browser should display an Ubuntu desktop. Else, check the console for errors and point your web browser at [http://localhost:3000](http://localhost3000)

The start-3asl.ps1 script can be used after allowing the execution of scripts with the command ```Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser```.

## License
Apache License Version 2.0, January 2004 <http://www.apache.org/licenses/LICENSE-2.0>
