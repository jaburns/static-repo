# static-repo

Converts all the source files in a git repo in to code-highlighted html files,
and builds a docker image to host a file browser for them.

```
vi build.sh # Configure the repo and style at the top of this script
./build.sh
docker run -itd -p 8080:8080 static-repo
```
