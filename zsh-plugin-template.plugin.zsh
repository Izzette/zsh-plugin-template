# Make $0 point to this plugin file.
# See: https://dev.to/sso/zsh-plugin-standard-1gpk#:~:text=a%20Zsh%20plugin.-,1.%20Standardized%20%240%20Handling,-%5B%20zero%2Dhandling%20%5D
0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# Limit variable polution.
# See: https://dev.to/sso/zsh-plugin-standard-1gpk#:~:text=order%20to%20it.-,Standard%20Plugins%20Hash,-The%20plugin%20often
typeset -gA Plugins
Plugins[PLUGIN_TEMPLATE_DIR]="${0:h}"
Plugins[PLUGIN_TEMPLATE_BIN_DIR]="${0:h}/bin"
Plugins[PLUGIN_TEMPLATE_DATA_DIR]="${0:h}/data"
Plugins[PLUGIN_TEMPLATE_FUNC_DIR]="${0:h}/functions"

# Add to path the bin/ directory.
# https://dev.to/sso/zsh-plugin-standard-1gpk#:~:text=%2C%20Zgenom.-,3.%20Binaries%20Directory,-%5B%20binaries%2Ddirectory%20%5D
if [[ $PMSPEC != *b* &&
      -z "${path[(r)${Plugins[PLUGIN_TEMPLATE_BIN_DIR]}]}" ]]; then
  path+=("${Plugins[PLUGIN_TEMPLATE_BIN_DIR]}")
fi

# Load functions from the functions/ directory.
# See: https://dev.to/sso/zsh-plugin-standard-1gpk#:~:text=Plugins%3A%20GitHub%20search-,2.%20Functions%20Directory,-%5B%20functions%2Ddirectory%20%5D
if [[ "${zsh_loaded_plugins[-1]}" != */plugin-template &&
      -z "${fpath[(r)${Plugins[PLUGIN_TEMPLATE_FUNC_DIR]}]}" ]]; then
  fpath+=("${Plugins[PLUGIN_TEMPLATE_FUNC_DIR]}")
fi

typeset -ga __plugin_template_autoload_funcs=()

# Find autoload function names from source file names.
.plugin-template_discover_autoload_funcs() {
  emulate -L zsh
  setopt extended_glob warn_create_global typeset_silent no_short_loops \
         rc_quotes no_auto_pushd
  typeset MATCH REPLY
  typeset -i MBEGIN MEND
  typeset -a match mbegin mend reply

  typeset autoload_func_file
  # List all regular files, including dotfiles.
  for autoload_func_file in ${Plugins[PLUGIN_TEMPLATE_FUNC_DIR]}/*(D.); do
    typeset autoload_func="${autoload_func_file:t}"
    __plugin_template_autoload_funcs+=("$autoload_func")
  done
}

.plugin-template_discover_autoload_funcs
autoload -Uz -- "${__plugin_template_autoload_funcs[@]}"

# Executed in the plugin’s directory (possibly in a subshell) after
# downloading any new commits to the repository.
.plugin-template_plugin_update() {
  emulate -L zsh
  setopt extended_glob warn_create_global typeset_silent no_short_loops \
         rc_quotes no_auto_pushd
  typeset MATCH REPLY
  typeset -i MBEGIN MEND
  typeset -a match mbegin mend reply
  
  typeset prefix
  # Supports the ZPFX global parameter.
  # See: https://dev.to/sso/zsh-plugin-standard-1gpk#:~:text=Plugins%3A%20GitHub%20search-,8.%20Global%20Parameter%20With%20PREFIX%20For%20Make%2C%20Configure%2C%20Etc,-%5B%20global%2Dparameter%2Dwith
  if [[ $PMSPEC == *P* ]]; then
    prefix="$ZPFX"
  else
    prefix="${Plugin[PLUGIN_TEMPLATE_DIR]}"
  fi

  # Install software ...
  #./configure --prefix="$prefix"
  #cmake -DCMAKE_INSTALL_PREFIX="$prefix" .
  #make PREFIX="$prefix" install
}

# Unload plugin support
# See: https://dev.to/sso/zsh-plugin-standard-1gpk#:~:text=ZGENOM_AUTO_ADD_BIN%3D1).-,4.%20Unload%20Function,-%5B%20unload%2Dfunction%20%5D
plugin-template_plugin_unload() {
  emulate -L zsh
  setopt extended_glob warn_create_global typeset_silent no_short_loops \
         rc_quotes no_auto_pushd
  typeset MATCH REPLY
  typeset -i MBEGIN MEND
  typeset -a match mbegin mend reply

  # Remove autoload functions
  fpath=("${(@)fpath:#${0:A:h}}")
  typeset autoload_func
  for autoload_func in "${__plugin_template_autoload_funcs[@]}"; do
    if command -v "$autoload_func" &> /dev/null; then
      unset -f -- "$autoload_func"
    fi
  done
  unset -v __plugin_template_autoload_funcs

  # Unset all variables
  for k in ${(k)Plugins[(I)PLUGIN_TEMPLATE_*]}; do
    # TODO: Doesn't work for plugin variables with weird names that need escaping ...
    unset -v -- "Plugins[$k]"
  done
  
  unset -f -- .plugin-template_discover_autoload_funcs .plugin-template_plugin_update "$0"
}

# PMSPEC contains information about the supported plugin manager capabilities.
# See: https://dev.to/sso/zsh-plugin-standard-1gpk#:~:text=%2C%20Zgenom.-,9.%20Global%20Parameter%20holding%20the%20plugin%20manager%E2%80%99s%20capabilities,-%5B%20global%2Dparameter%2Dwith
if [[ $PMSPEC != *s* ]]; then
  echo 'WARN[plugin-template]: non-compliant plugin manager detected!' >&2
fi

# Does not support *plugin_unload function but supports @zsh-plugin-run-on-unload.
if [[ $PMSPEC != *u* && $PMSPEC == *U* ]]; then
  # See: https://dev.to/sso/zsh-plugin-standard-1gpk#:~:text=unload%20the%20plugin.-,5.%20%40zsh%2Dplugin%2Drun%2Don%2Dunload%20Call,-%5B%20run%2Don%2Dunload
  @zsh-plugin-run-on-unload 'plugin-template_plugin_unload'
fi

# Supports @zsh-plugin-run-on-update.
if [[ $PMSPEC == *p* ]]; then
  # See: https://dev.to/sso/zsh-plugin-standard-1gpk#:~:text=%2C%20Zinit.-,6.%20%40zsh%2Dplugin%2Drun%2Don%2Dupdate%20Call,-%5B%20run%2Don%2Dupdate
  @zsh-plugin-run-on-update ".plugin-template_plugin_update"
fi

# vim: set ft=zsh:
