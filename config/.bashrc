# Fix "MESA: error: ZINK: failed to choose pdev"
export LIBGL_ALWAYS_SOFTWARE=1

# Set base directory for XDG files
export XDG_RUNTIME_DIR='/config'

# Fix spurious Gtk error messages about accessibility bus
export NO_AT_BRIDGE=1
export OPAMROOT=/opt/opam
# Current opam switch man dir
MANPATH="$MANPATH":'/opt/opam/default/man'; export MANPATH;
# Binary dir for opam switch default
PATH="$PATH":'/opt/opam/default/bin'; export PATH;
export PATH="$HOME/.local/bin:$PATH"
