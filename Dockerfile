FROM squidfunk/mkdocs-material

ARG VERSION

LABEL "org.opencontainers.image.description"="Documentation that simply works"
LABEL "org.opencontainers.image.version"="${VERSION}"

# Set working directory
WORKDIR /docs

RUN pip install --no-cache-dir --upgrade pip \
&& \
  pip install neoteroi-mkdocs \
&& \
  if [ -e user-requirements.txt ]; then \
    pip install -U -r user-requirements.txt; \
  fi \
&& \
  rm -rf /tmp/* /root/.cache \
&& \
  find ${PACKAGES} \
    -type f \
    -path "*/__pycache__/*" \
    -exec rm -f {} \;

# Expose MkDocs development server port
EXPOSE 8000

# Start development server by default
ENTRYPOINT ["/sbin/tini", "--", "mkdocs"]
CMD ["serve", "--dev-addr=0.0.0.0:8000"]
