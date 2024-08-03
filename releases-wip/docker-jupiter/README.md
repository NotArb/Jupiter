## NotArb Jupiter Management Server

_Download the platform-specific package, which includes everything needed to run the NotArb Jupiter Management Server, from: https://download.notarb.org/_

**Important:** To ensure files persist between Docker and your system, place any file you want to keep updated in the mount folder. For example, storing `jupiter-config.toml` in the mount folder allows you to apply configuration changes dynamically without rebuilding the Docker image.

**Before continuing**, edit the `mount/jupiter-config.toml` file to your liking.

### Build Guide

**Unix:** Run the `build.sh` file.
**Windows:** Run the `run.bat` file. (COMING SOON)

After successfully building the docker image, you can now use docker commands. Here's a list of useful commands:

- `docker start jupiter` - Start the container.
- `docker stop jupiter` - Stop the container.
- `docker restart jupiter` - Restart the container.
- `docker logs --follow jupiter` - View the container logs in real-time.
- `docker update --cpus="123456" jupiter` - Update the CPU allocation for the container.
