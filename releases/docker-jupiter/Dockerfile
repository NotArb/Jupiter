# This is the same image from the Jupiter Dockerfile example, it shouldn't have any issues running Jupiter.
FROM --platform=linux/amd64 debian:bookworm-slim

# Since jupiter linux is only built for x64, this whole file needs to also use x64 dependencies
ARG JUPITER_URL="https://github.com/jup-ag/jupiter-swap-api/releases/download/v6.0.25/jupiter-swap-api-x86_64-unknown-linux-gnu.zip"
ARG JDK_URL="https://download.java.net/java/GA/jdk22.0.2/c9ecb94cd31b495da20a27d4581645e8/9/GPL/openjdk-22.0.2_linux-x64_bin.tar.gz"

# Install curl, unzip, and tini to download required files and handle init process
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    tini \
    && rm -rf /var/lib/apt/lists/*

# Assign workdir
WORKDIR /jupiter

# Create a temporary directory (shouldn't have to, just in case)
RUN mkdir -p /tmp && chmod 1777 /tmp

# Copy NotArb files to /tmp
COPY notarb-* /tmp/

# Filter and move the latest NotArb file, remove any remaining
RUN latest_file=$(ls -v /tmp/notarb-* | tail -n 1) && \
    mv "$latest_file" /jupiter/notarb && \
    rm -rf /tmp/notarb-*

# Download Jupiter and mark the file as executable
RUN echo "Downloading Jupiter: ${JUPITER_URL}" && \
    curl -L ${JUPITER_URL} -o /tmp/jupiter-release.zip && \
    unzip /tmp/jupiter-release.zip -d /jupiter && \
    rm /tmp/jupiter-release.zip && \
    chmod +x /jupiter/jupiter-swap-api

# Download and install the x64 JDK
RUN echo "Downloading JDK: ${JDK_URL}" && \
    curl -L ${JDK_URL} -o /tmp/openjdk.tar.gz && \
    mkdir -p /usr/local/notarb-jdk && \
    tar -xzf /tmp/openjdk.tar.gz -C /usr/local/notarb-jdk --strip-components=1 && \
    rm /tmp/openjdk.tar.gz

# Set environment variables for Java
ENV JAVA_HOME=/usr/local/notarb-jdk
ENV PATH=$JAVA_HOME/bin:$PATH

# Add Tini as the entrypoint with exec form
ENTRYPOINT ["/usr/bin/tini", "--"]

# Passed from docker build command as --build-arg
ARG VM_ARGS

# Set VM_ARGS to env to allow passing to command below.
ENV VM_ARGS=$VM_ARGS

# Run NotArb Jupiter Server Manager
CMD ["sh", "-c", "exec java $VM_ARGS -cp /jupiter/notarb org.notarb.launcher.Main --jupiter-config-path=/jupiter/mount/jupiter-config.toml"]