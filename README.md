# Praktikum zur intelligenten Robotermanipulation

Update `init-system-helpers`
```
wget http://ftp.kr.debian.org/debian/pool/main/i/init-system-helpers/init-system-helpers_1.60_all.deb
sudo apt install ~/Downloads/init-system-helpers_1.60_all.deb
```
Install docker
```
wget https://desktop.docker.com/linux/main/amd64/docker-desktop-4.14.1-amd64.deb
sudo apt install ~/Downloads/docker-desktop-4.14.1-amd64.deb
```
## If your PC has an NVIDIA GPU
Run the scripts for nvidia drivers
```
bash nvidia-scripts.sh
```

Build the docker image
```
docker build -t tiago https://raw.githubusercontent.com/Alonso94/Tiago_project/master/Dockerfile_nvidia
```

Start a terminal inside docker
```
docker run -it --net=host --gpus all \
    --privileged \
    --env="NVIDIA_DRIVER_CAPABILITIES=all" \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --name="tiago_project"\
    tiago \
    bash
```

## If you PC does not have NVIDIA

Build the docker image
```
docker build -t tiago https://raw.githubusercontent.com/Alonso94/Tiago_project/master/Dockerfile_no_GPU
```

Start a terminal inside docker
```
docker run -it --net=hos \
    --privileged \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    --name="tiago_project"\
    tiago \
    bash
```