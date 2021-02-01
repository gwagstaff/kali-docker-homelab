```

                        ##         .
                  ## ## ##        ==
               ## ## ## ## ##    ===
           /"""""""""""""""""\___/ ===
      ~~~ {~~ ~~~~ ~~~ ~~~~ ~~~ ~ /  ===- ~~~
           \______ o           __/
             \    \         __/
              \____\_______/

 ___   _  _______  ___      ___     ______   _______  _______  ___   _  _______  ______
|   | | ||   _   ||   |    |   |   |      | |       ||       ||   | | ||       ||    _ |
|   |_| ||  |_|  ||   |    |   |   |  _    ||   _   ||       ||   |_| ||    ___||   | ||
|      _||       ||   |    |   |   | | |   ||  | |  ||       ||      _||   |___ |   |_||_
|     |_ |       ||   |___ |   |   | |_|   ||  |_|  ||      _||     |_ |    ___||    __  |
|    _  ||   _   ||       ||   |   |       ||       ||     |_ |    _  ||   |___ |   |  | |
|___| |_||__| |__||_______||___|   |______| |_______||_______||___| |_||_______||___|  |_|
```

## Fork infos

This is my fork of [mikeflynn/kali-docker](https://github.com/mikeflynn/kali-docker). Feel free to fork the original or this version for yourself.
Make does not open a shell inside the docker-container properly for me, so I rewrote the Makefile to a shell script with pretty much the same functionality.
To be able to start gui programs within the docker-container I added the X11 volume mapping (unix only).

# Original (commands updated)

I wasn't satisfied with any of the existing Kali Docker setups, so I made my own that has a more efficient Dockerfile and a custom set of software.

If there are cool apps that make sense to add to this, please submit a pull request so we can have the best possible subset of apps for people to spin up and use via Docker.

## Prerequisites

1. Docker.
2. The knowledge of what to do with Kali.

## How to Start

```bash
> cd ./kali-docker
> ./kali.sh up
...
> ./kali.sh shell
```

Once the container is built and running you will see the following new directories that are mapped in to the container:

## Help

```bash
> ./kali.sh help
help     Show this help message
shell    Open shell in kali container
up:      Start kali container
build:   Build kali image and start container
stop:    Stop kali container
clean:   Stop and remove kali containers
```

## How to Add Apps

Once in the Kali shell you can add them as you normally would with `apt install ...`, but if you want the apps already in place upon rebuild you can edit line 9 of the Dockerfile to include whatever app you'd like. If you would like to add libraries that aren't available via `apt`, they can be copied in to the `./kali-root` directory and they will be instantly available in the container.
