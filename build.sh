#!/usr/bin/env bash

REPO=git@github.com:jaburns/static-repo
STYLE=autumn

if [[ "$1" != '--inner' ]]; then
    [[ ! -d repo ]] && git clone "$REPO" repo
    docker build -t static-repo .
    exit 0
fi

echo '<style>' > /tmp/css
pygmentize -S "$STYLE" -f html >> /tmp/css
echo '</style>' >> /tmp/css

cd repo

find . > /tmp/tree

cat /tmp/tree | while read path; do
    [[ -d "$path" ]] && continue

    if pygmentize -f html "$path" >/tmp/html; then
        cat /tmp/css /tmp/html >"$path".html_gen
    else
        cp "$path" "$path".txt_gen
    fi
done

cat /tmp/tree | while read path; do
    [[ -d "$path" ]] || continue

    echo '<ul><li><a href="..">..</a></li>' >"$path"/index.html_gen

    find "$path" -maxdepth 1 | grep -v '_gen$' > /tmp/inner

    tail -n+2 /tmp/inner | while read item; do
        item_show="$(printf $item | sed 's/^\.//')"

        if [[ -d "$item" ]]; then
            item_href="$item_show"
        elif [[ -f "$item".html_gen ]]; then
            item_href="$item_show".html
        else
            item_href="$item_show".txt
        fi

        echo "<li><a href=\"$item_href\">$item_show</a></li>" >>"$path"/index.html_gen
    done

    echo '</ul>' >>"$path"/index.html_gen
done

find . > /tmp/tree

cat /tmp/tree | while read path; do
    [[ -d "$path" ]] && continue

    if [[ "$path" == *_gen ]]; then
        mv "$path" "$(printf "$path" | sed 's/_gen$//')"
    else
        rm "$path"
    fi
done
