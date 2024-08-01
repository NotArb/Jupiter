# Use build.sh to correctly set build context.
# Otherwise, ensure NotArb file is in the same directory as this Dockerfile.

# This is the same image from the Jupiter Dockerfile example, it shouldn't have any issues running Jupiter.
FROM debian:bookworm-slim

# Args need to come after FROM
ARG JUPITER_URL="https://github.com/jup-ag/jupiter-swap-api/releases/download/v6.0.24/jupiter-swap-api-x86_64-unknown-linux-gnu.zip"
ARG JDK_AARCH64_URL="https://download.java.net/java/GA/jdk22.0.2/c9ecb94cd31b495da20a27d4581645e8/9/GPL/openjdk-22.0.2_linux-aarch64_bin.tar.gz"
ARG JDK_X64_URL="https://download.java.net/java/GA/jdk22.0.2/c9ecb94cd31b495da20a27d4581645e8/9/GPL/openjdk-22.0.2_linux-x64_bin.tar.gz"

# Install curl, unzip, and tini to download required files and handle init process
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    tini \
    && rm -rf /var/lib/apt/lists/*

# Assign workdir
WORKDIR /jupiter

# Create a temporary directory (shouldn't have to, just in case)
RUN mkdir -p /tmp

# Copy NotArb files to /tmp
COPY NotArb-* /tmp/

# Filter and move the latest NotArb file, remove any remaining
RUN latest_file=$(ls -v /tmp/NotArb-* | tail -n 1) && \
    mv "$latest_file" /jupiter/NotArb && \
    rm -rf /tmp/NotArb-*

# Download Jupiter and mark file as executable
RUN echo "Downloading Jupiter: {$JUPITER_URL}" && \
    curl -L ${JUPITER_URL} -o /tmp/jupiter-release.zip && \
    unzip /tmp/jupiter-release.zip -d /jupiter && \
    rm /tmp/jupiter-release.zip && \
    chmod +x /jupiter/jupiter-swap-api

# Download JDK based on TARGETPLATFORM
ARG TARGETPLATFORM
RUN if [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
      JDK_URL="${JDK_AARCH64_URL}"; \
    else \
      JDK_URL="${JDK_X64_URL}"; \
    fi && \
    echo "Downloading JDK: $JDK_URL" && \
    curl -L $JDK_URL -o /tmp/openjdk.tar.gz && \
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
ENV VM_ARGS=${VM_ARGS}

# Run NotArb Jupiter Server Manager
CMD ["sh", "-c", "exec java $VM_ARGS -cp /jupiter/NotArb org.notarb.launcher.Main --jupiter-server"]