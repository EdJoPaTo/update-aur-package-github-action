FROM docker.io/library/archlinux:base-devel
RUN pacman -Syu --needed --noconfirm git openssh pacman-contrib

RUN useradd --create-home builder \
	&& echo 'builder ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/010_builder

COPY entrypoint.sh /usr/local/bin/entrypoint
COPY known_hosts /etc/ssh/ssh_known_hosts

WORKDIR /home/builder
ENV PAGER=cat
USER builder

RUN mkdir -p ~/.ssh \
	&& printf "Host aur.archlinux.org\n\tIdentityFile ~/.ssh/aur\n\tUser aur" >> ~/.ssh/config \
	&& git config --global init.defaultBranch master \
	&& git config --global user.name "GitHub Actions" \
	&& git config --global user.email "41898282+github-actions[bot]@users.noreply.github.com"

CMD ["/usr/local/bin/entrypoint"]
