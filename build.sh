#!/usr/bin/env bash

REPO=git@github.com:jaburns/static-repo
STYLE=autumn

if [[ "$1" == '--inner' ]]; then
    echo '<style>' > /tmp/css
    pygmentize -S "$STYLE" -f html >> /tmp/css
    echo '</style>' >> /tmp/css

    cd repo

    find . | while read path; do
        [[ -d "$path" ]] && continue

        if pygmentize -f html "$path" >/tmp/html; then
            cat /tmp/css /tmp/html >"$path".html
        else
            cp "$path" "$path".txt
        fi

        rm "$path"
    done
else
    [[ ! -d repo ]] && git clone "$REPO" repo
    docker build -t static-repo .
fi
