FROM nvidia/cuda:11.6.1-devel-ubuntu20.04

RUN mkdir -p /app
WORKDIR /app

RUN apt-get update && \
	apt-get install -y wget libfreetype6 libglu1-mesa-dev libxi6 libxrender1 bzip2 && \
	rm -rf /var/cache/apt/archives /var/lib/apt/lists/*

RUN wget https://download.blender.org/release/Blender2.78/blender-2.78c-linux-glibc219-x86_64.tar.bz2 && \
	tar -xjvf blender-2.78c-linux-glibc219-x86_64.tar.bz2 && \
	rm blender-2.78c-linux-glibc219-x86_64.tar.bz2

COPY . clevr-dataset-gen

RUN echo $PWD/clevr-dataset-gen/image_generation >> blender-2.78c-linux-glibc219-x86_64/2.78/python/lib/python3.5/site-packages/clevr.pth

WORKDIR /app/clevr-dataset-gen/image_generation

ENTRYPOINT [ \
	"/app/blender-2.78c-linux-glibc219-x86_64/blender", \
	"--background", \
	"-noaudio", \
	"--python", \
	"render_images.py", \ 
	"--" \
]
