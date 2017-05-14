FROM centos:centos6.8
ENV UNAME="work" UHOME=/home/${UNAME}/
RUN groupadd -r ${UNAME} && useradd -r -m -g ${UNAME} ${UNAME} && \
    echo "root ALL=(ALL) ALL" >> /etc/sudoers && \
    echo "${UNAME} ALL=NOPASSWD:ALL" >> /etc/sudoers && \
    echo " " | passwd ${UNAME} --stdin && \
    echo " " | passwd root --stdin
RUN yum install -y wget git vim zsh ctags python python-dev gcc g++ readline-devel sudo ncurses-devel
RUN curl -R -O http://www.lua.org/ftp/lua-5.3.4.tar.gz && \
    tar zxf lua-5.3.4.tar.gz && cd lua-5.3.4 && make linux && make install && cd && \
    curl -OL https://github.com/downloads/libevent/libevent/libevent-2.0.21-stable.tar.gz && \
    tar -xvzf libevent-2.0.21-stable.tar.gz && cd libevent-2.0.21-stable && \
    ./configure --prefix=/usr/local && make && sudo make install && cp ./.libs/libevent-2.0.so.5 /usr/lib64/ && cd && \
    curl -OL https://github.com/tmux/tmux/releases/download/2.5/tmux-2.5-rc.tar.gz && tar xzf tmux-2.5-rc.tar.gz && cd tmux-2.5-rc && \
    LDFLAGS="-L/usr/local/lib -Wl,-rpath=/usr/local/lib" && ./configure --prefix=/usr/local && make && sudo make install && cd

USER ${UNAME}
WORKDIR ${UHOME}
RUN git clone https://github.com/jungamer/vimrc.git ~/vimrc && cp ~/vimrc/.vimrc ~/ && \
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim && vim +PluginInstall +qall && echo "colorscheme solarized" >> ~/.vimrc && \
    sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" && \
    git clone https://github.com/jungamer/.tmux.git ~/.tmux && ln -s -f ~/.tmux/.tmux.conf ~/.tmux.conf && cp ~/.tmux/.tmux.conf.local ~/
