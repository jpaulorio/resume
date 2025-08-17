# Fast, small base
FROM debian:bookworm-slim

# Avoid tz/locale prompts and reduce layer size
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Etc/UTC

# Install: pandoc, LaTeX (luatex + extras), and emoji/standard fonts
# Also install fontconfig so fc-cache is available
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      pandoc \
      texlive-luatex \
      texlive-latex-extra \
      texlive-fonts-recommended \
      texlive-fonts-extra \
      fonts-noto-color-emoji \
      fonts-dejavu \
      fontconfig \
      ca-certificates && \
    fc-cache -f && \
    # Show versions (useful in build logs)
    pandoc --version | head -n 2 && \
    # Clean up apt caches to keep image small
    rm -rf /var/lib/apt/lists/*

# Default working directory inside the container
WORKDIR /work
