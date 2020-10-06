# alpine-static-dig

This is a Alpine image with dig command.

The dig command is a widely used dns lookup command.
On Alpine Linux, the dig command is included in the bind-tools package.
However, installing the bind-tools package with the apk command increases the size of the Docker image by more than 10 megabytes.
So, for users who only want to use the dig command, only the dig command is installed in this image.
