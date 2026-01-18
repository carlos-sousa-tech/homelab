#!/bin/bash
if [ "$SETUP_DEVELOPMENT" != true ]; then
    echo "${SKIPPING_PRE_TEXT} nodejs: SETUP_DEVELOPMENT is not true"
    return 0
fi

if [ -z "$MAIN_USER" ]; then
    echo "${SKIPPING_PRE_TEXT} nodejs: MAIN_USER is not set"
    return 0
fi

# Download and install nvm:
sudo -u "$MAIN_USER" bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash'

# Get user's home directory correctly
USER_HOME=$(sudo -u "$MAIN_USER" bash -c 'echo $HOME')

# Ensure the following changes are applied to the intended user's environment
# Load nvm and install Node.js
sudo -u "$MAIN_USER" bash -c "export NVM_DIR='$USER_HOME/.nvm'; \
  [ -s \"\$NVM_DIR/nvm.sh\" ] && \. \"\$NVM_DIR/nvm.sh\"; \
  nvm install 22; \
  node -v; nvm current; npm -v"

# Confirmation message for successful installation
echo "Node.js and NVM installed for user $MAIN_USER."
