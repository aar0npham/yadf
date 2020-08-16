FROM debian:latest

ARG USERNAME=anotheruser
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && apt-get update \
    && apt-get install -y sudo make stow zsh git curl wget tmux\
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*
USER root
WORKDIR /dotfiles
COPY . .
RUN sudo make install
RUN cd pkg/ && for dir in "alacritty fonts git python starship tmux vim zsh"; do sudo stow $dir -t /root;done

CMD ["zsh"]
