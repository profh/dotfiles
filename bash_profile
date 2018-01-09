# if [[ -s ~/.rvm/scripts/rvm ]] ; then
# 	source /Users/profh/.rvm/scripts/completion ;
# fi
export PATH=/usr/local/git/bin:/usr/local/bin/src:/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:$PATH

# ============
# Additional files to add to .bash_profile
source ~/.bash/bash_aliases
source ~/.bash/bash_config
# source ~/.bash/bash_rvm

# Setting PATH for Python 3.4
# The orginal version is saved in .bash_profile.pysave
# PATH="/Library/Frameworks/Python.framework/Versions/3.4/bin:${PATH}"
# export PATH

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

# Setting PATH for Python 3.5
# The original version is saved in .bash_profile.pysave
# PATH="/Library/Frameworks/Python.framework/Versions/3.5/bin:${PATH}"
# export PATH

# Setting PATH for Python 3.6
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.6/bin:${PATH}"
export PATH