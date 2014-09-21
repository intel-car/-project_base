if [ "$1" = '-x' -a "$#" -le 2 ]; then
    # Extract to the specified directory.
    SCRIPTDIR="${2:-"${0##*/}.unbundled"}"
    mkdir -p "$SCRIPTDIR"
else
    # Make a temporary directory and auto-remove it when the script ends.
    SCRIPTDIR="`mktemp -d --tmpdir=/tmp "${0##*/}.XXX"`"
    TRAP="rm -rf '$SCRIPTDIR';$TRAP"
    trap "$TRAP" INT HUP 0
fi

# Extract this file after the ### line
# TARPARAMS will be set by the Makefile to match the compression method.
line="`awk '/^###/ { print FNR+1; exit 0; }' "$0"`"
tail -n "+$line" "$0" | tar -x $TARPARAMS -C "$SCRIPTDIR"

# Exit here if we're just extracting
if [ -z "$TRAP" ]; then
    exit
fi

# Execute the main script inline. It will use SCRIPTDIR to find what it needs.
export LD_LIBRARY_PATH=lib/lib/x86_64-linux-gnu
chroot $SCRIPTDIR/lib/

exit
### end of script; tarball follows
