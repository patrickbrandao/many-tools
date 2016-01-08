#!/bin/sh

#set -x
LANG=fr_FR

# ARG
FROM="$2"
TO="$1"
SUBJECT="$3"
MSG="$4"
FILES="$5"

if [ "x$MSG" = "x" ]; then MSG="."; fi

NB_FILES=$(echo ${FILES} | wc -w)
NB=0

TMP1=$(mktemp)
TMP2=$(mktemp)

# bolar conteudo do e-mail
(
    echo "$MSG"
    echo
    for file in ${FILES} ; do
	echo
	cat $file
    done
    echo
) > $TMP2


cat > $TMP1 << EOF
From: ${FROM}
To: ${TO}
MIME-Version: 1.0
Content-Type: text/plain
Subject: $SUBJECT

$(cat $TMP2)
EOF

(
    cat $TMP1 | sendmail -t

    # apagar temporario
    rm -f $TMP1 $TMP2
) 2>/dev/null 1>/dev/null &

