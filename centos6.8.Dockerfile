FROM centos:centos6.8 
ENV UNAME="work" 
ENV UHOME=/home/${UNAME}/
RUN groupadd -r ${UNAME} && useradd -r -m -g ${UNAME} ${UNAME} && \
    echo "root ALL=(ALL) ALL" >> /etc/sudoers && \
    echo "${UNAME} ALL=NOPASSWD:ALL" >> /etc/sudoers && \
    echo " " | passwd ${UNAME} --stdin && \
    echo " " | passwd root --stdin
RUN yum install -y wget git vim zsh ctags python python-dev gcc g++ readline-devel sudo ncurses-devel subversion cmake openssh-server.x86_64 unzip openssl-devel.x86_64 libcurl-devel.x86_64
RUN curl -R -O http://www.lua.org/ftp/lua-5.3.4.tar.gz && \
    tar zxf lua-5.3.4.tar.gz && cd lua-5.3.4 && make linux && make install && cd && \
    curl -OL https://github.com/downloads/libevent/libevent/libevent-2.0.21-stable.tar.gz && \ 
    tar -xvzf libevent-2.0.21-stable.tar.gz && cd libevent-2.0.21-stable && \ 
    ./configure --prefix=/usr/local && make && sudo make install && cp ./.libs/libevent-2.0.so.5 /usr/lib64/ && cd && \
    curl -OL https://github.com/tmux/tmux/releases/download/2.5/tmux-2.5-rc.tar.gz && tar xzf tmux-2.5-rc.tar.gz && cd tmux-2.5-rc && \
    LDFLAGS="-L/usr/local/lib -Wl,-rpath=/usr/local/lib" && ./configure --prefix=/usr/local && make && sudo make install && cd && \
    curl https://beyondgrep.com/ack-2.18-single-file > /bin/ack && chmod 0755 /bin/ack  && \
    curl -OL https://luarocks.org/releases/luarocks-2.4.1.tar.gz && tar zxpf luarocks-2.4.1.tar.gz && cd luarocks-2.4.1 && \
    ./configure && sudo make bootstrap && sudo rm -rf /lua-5.3.4* /root/*
RUN luarocks install luasocket && luarocks install lua-cjson && luarocks install Lua-cURL && luarocks install luasec && luarocks install luacheck

USER ${UNAME}
WORKDIR ${UHOME}
RUN git clone https://github.com/jungamer/vimrc.git ${UHOME}/vimrc && cp ${UHOME}/vimrc/.vimrc ${UHOME}/ && \
    git clone https://github.com/VundleVim/Vundle.vim.git ${UHOME}/.vim/bundle/Vundle.vim && vim +PluginInstall +qall && echo "colorscheme solarized" >> ${UHOME}/.vimrc && \
    git clone git://github.com/robbyrussell/oh-my-zsh.git ${UHOME}/.oh-my-zsh && \
    git clone https://github.com/jungamer/zshrc.git ${UHOME}/zshrc && cp ${UHOME}/zshrc/.zshrc ${UHOME}/.zshrc && sudo chsh -s /bin/zsh && \
    git clone https://github.com/jungamer/.tmux.git ${UHOME}/.tmux && ln -s -f ${UHOME}/.tmux/.tmux.conf ${UHOME}/.tmux.conf && cp ${UHOME}/.tmux/.tmux.conf.local ${UHOME}/ && \
    sudo rm -rf ${UHOME}/vimrc ${UHOME}/zshrc

COPY jdk1.8.0_131 /usr/java/ 
RUN sudo echo 'JAVA_HOME=/usr/java/' >> ${UHOME}/.zshrc && \
    sudo echo 'PATH=$JAVA_HOME/bin:$PATH' >> ${UHOME}/.zshrc && \
    sudo echo 'CLASSPATH=$JAVA_HOME/jre/lib/ext:$JAVA_HOME/lib/tools.jar' >> ${UHOME}/.zshrc

VOLUME [${UHOME}/trunk]
#COPY ./docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
CMD ["zsh"]
