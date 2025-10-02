cat - > /usr/share/applications/Isabelle.desktop << "==END=="
[Desktop Entry]
Version=1.0
Name=Isabelle
GenericName=Proof assistant
Exec=/usr/local/IsabelleLatest/bin/isabelle jedit %F
StartupNotify=true
Terminal=false
Icon=/usr/local/IsabelleLatest/lib/icons/isabelle.xpm
Type=Application
Categories=Proof;Development;Science;Math
MimeType=text/text;
==END==

cat - > /init-config/.why3.conf << "==END=="
[main]
default_editor = "xdg-open %f"
magic = 14
memlimit = 1000
running_provers_max = 2
timelimit = 5.000000

[partial_prover]
name = "Alt-Ergo"
path = "/opt/opam/default/bin/alt-ergo"
version = "2.6.0"

[partial_prover]
name = "CVC4"
path = "/usr/bin/cvc4"
version = "1.8"

[partial_prover]
name = "CVC5"
path = "/usr/local/bin/cvc5"
version = "1.3.0"

[partial_prover]
name = "Coq"
path = "/usr/bin/coqtop"
version = "8.18.0"

[partial_prover]
name = "Isabelle"
path = "/usr/local/bin/isabelle"
version = "2022"

[partial_prover]
name = "Z3"
path = "/usr/bin/z3"
version = "4.8.12"
==END==
