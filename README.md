# Zsh plugin template

A very compliant seed to grow your ZSH plugin project, whether it be a daisy 🌼
or a tree 🌲.

## Using

Fork this repository, replace instances of `plugin-template` with your project
name.
For example, if your project is named `my-awesome-plugin` you could replace file
names and symbols like so:

* `plugin-template` → `my-awesome-plugin`
* `plugin_template` → `my_awesome_plugin`
* `PLUGIN_TEMPLATE` → `MY_AWESOME_PLUGIN`

You can place your custom functions into `functions/` directory and they will
automatically be added to autoload.
The `bin/` directory will be added to `$PATH` automatically.
Any custom data you need can be placed in the `data/` directory, your plugin can
reference it like `${Plugins[MY_AWESOME_PLUGIN_DATA_DIR]}/my-data.txt`.

You can read more about the Zsh plugin standard and best practices here:
[Zsh Plugin Standard](https://dev.to/sso/zsh-plugin-standard-1gpk)

## License

Copyright © 2022 Isabelle COWAN-BERGMAN ﴾ izziαizzette܂com ﴿
This work is free. You can redistribute it and/or modify it under the
terms of the Do What The Fuck You Want To Public License, Version 2,
as published by Sam Hocevar. See the COPYING file for more details.
<a href="http://www.wtfpl.net/">
  <img
    src="http://www.wtfpl.net/wp-content/uploads/2012/12/wtfpl-badge-4.png"
    width="80" height="15" alt="WTFPL"/>
</a>
