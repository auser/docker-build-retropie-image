#### Build Image
```
docker-compose build
```

#### Run Image with Defaults
```
docker-compose run retro
```

#### Run Image with Specific Version
```
docker-compose run -e RETROPIEVERSION=4.1 retro
```

#### Run Image with Specific Version and Image Size
```
docker-compose run -e RETROPIEVERSION=4.1 -e IMAGE_SIZE_IN_GB=10 retro
```

#### Interactive Bash Mode
```
docker-compose run --entrypoint=/bin/bash retro
```

#### Check Environment Variables
```
docker-compose run --entrypoint "/bin/bash" retro -c env
```

## Once the image has booted

BE SURE TO RUN:

```bash
sudo apt-get update -yq && sudo apt-get upgrade -y && sudo apt-get dist-upgrade -y
```
