# Entry File
for config_file in ${ZDOTDIR:-$HOME}/conf.d/*.zsh(N); do
	source "$config_file"
done
