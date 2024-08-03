## NotArb Jupiter Management Docker Server

_Download the platform-specific package, which includes everything needed to run the NotArb Jupiter Management Docker Server, from: https://download.notarb.org/_

To ensure files **persist** between Docker and your system, any file you want to keep updated must be placed in the `mount` folder.
>_Docker containers cannot access system files directly unless those files are mounted. We have configured the `mount` folder to be automatically mounted for your convenience. This setup allows you to easily share files between your host system and the Docker container, enabling you to apply updates without rebuilding the Docker image. For example, storing `jupiter-config.toml` in the `mount` folder allows you to modify configurations dynamically._

### Build Guide
**Before continuing**, edit the `mount/jupiter-config.toml` file to your liking.

>_To make Jupiter listen on a different port, you must edit the `PORT` value in the build script._

Optionally, you can pass [VM Arguments](https://docs.oracle.com/en/java/javase/22/docs/specs/man/java.html#standard-options-for-java) to the build script. Here are some examples:
>- `-Xms256m` - Set the initial heap size to 256 MB.
>- `-Xmx512m` - Set the maximum heap size to 512 MB.
>- `-XX:MaxPermSize=256m `- Set the maximum size for the permanent generation space.
>- `-XX:+UseG1GC` - Use the G1 garbage collector.
>- `-XX:MaxGCPauseMillis=200` - Set the target maximum pause time for the G1 garbage collector.

Finally, build the docker image based on your platform:

>**Unix** - Run the `build.sh` file.<br>
>**Windows** - Run the `run.bat` file. (COMING SOON)

### Docker Commands
After successfully building the Docker image, you can use various Docker commands. Here are some examples:
>- `docker start jupiter` - Start the container.
>- `docker stop jupiter` - Stop the container.
>- `docker restart jupiter` - Restart the container.
>- `docker inspect jupiter` - Display detailed information about the container.
>- `docker logs --follow jupiter` - View the container logs in real-time.
>- `docker update --cpus="123456" jupiter` - Update the CPU allocation for the container.