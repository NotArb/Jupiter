## NotArb Jupiter Management Server

_Download the platform-specific package, which includes everything needed to run the NotArb Jupiter Management Server, from: https://download.notarb.org/_

**Important:** To ensure files persist between Docker and your system, place any file you want to keep updated in the mount folder. For example, storing `jupiter-config.toml` in the mount folder allows you to apply configuration changes dynamically without rebuilding the Docker image.

### Build Guide
**Before continuing**, edit the `mount/jupiter-config.toml` file to your liking.

To make Jupiter listen on a different port, you must edit the `PORT` value in the build script.

Optionally, you can pass VM arguments to the build script. Here are some examples:

`-Xmx512m` - Set the maximum heap size to 512 MB.
`-Xms256m` - Set the initial heap size to 256 MB.
`-XX:MaxPermSize=256m `- Set the maximum size for the permanent generation space.
`-XX:+UseG1GC` - Use the G1 garbage collector.
`-XX:MaxGCPauseMillis=200` - Set the target maximum pause time for the G1 garbage collector.
`-Dproperty=value` - Set a system property.
Read more about VM arguments [here](https://docs.oracle.com/en/java/javase/22/docs/specs/man/java.html#standard-options-for-java).

#### Unix
Run the `build.sh` file.

#### Windows
Run the `run.bat` file. (COMING SOON)

### Docker Commands
After successfully building the Docker image, you can use the following Docker commands:

markdown
Copy code
- `docker start jupiter` - Start the container.
- `docker stop jupiter` - Stop the container.
- `docker restart jupiter` - Restart the container.
- `docker logs --follow jupiter` - View the container logs in real-time.
- `docker update --cpus="123456" jupiter` - Update the CPU allocation for the container.
- `docker inspect jupiter` - Display detailed information about the container.