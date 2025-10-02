cat - >> /init-config/.bashrc << "==END=="
export OPAMROOT=/opt/opam
# Current opam switch man dir
MANPATH="$MANPATH":'/opt/opam/default/man'; export MANPATH;
# Binary dir for opam switch default
PATH="$PATH":'/opt/opam/default/bin'; export PATH;
==END==
chmod +x /init-config/.bashrc
