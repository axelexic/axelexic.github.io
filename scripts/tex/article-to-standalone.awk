#!/usr/bin/awk -f

BEGIN {
    if (fontsize == "")
        fontsize = "18pt"
}

/^[[:space:]]*\\documentclass(\[[^]]*\])?[[:space:]]*\{article\}/ {
    print "\\documentclass[border=10pt, fontsize=" fontsize \
          ", class=scrreprt]{standalone}"
    print ""
    print "\\usepackage{newcomputermodern}"
    print "\\setmainfont{PT Serif}"
    print ""
    print "\\def\\pgfsysdriver{pgfsys-dvisvgm.def}"
    next
}

/^[[:space:]]*\\(title|author|date)[[:space:]]*\{/ { next }
/^[[:space:]]*\\maketitle[[:space:]]*$/ { next }

{ print }