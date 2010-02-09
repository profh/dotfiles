source ~/.bash/bash_aliases
source ~/.bash/bash_config
# source ~/.bash/bash_rvm

export PATH=/usr/local/git/bin:/usr/local/bin/src:/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:~/bin:$PATH

# for rvm
# to help rvm install of ruby 1.9.1-p243
export ARCHFLAGS="-arch i386 -arch x86_64" 
# instructed by rvm-install (no return at end of line)
if [[ -s /usr/local/rvm/scripts/rvm ]] ; then source /usr/local/rvm/scripts/rvm ; fi