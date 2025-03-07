# vis-modeline-options - modeline support for vis

A plugin for [vis](https://github.com/martanne/vis) to read modelines and set
`vis.win.options` (and `vis.win.syntax`, to be pedantic).

### Installation

Clone this repository to where you install your plugins. (If this is your first
plugin, running `git clone https://github.com/milhnl/vis-modeline-options` in
`~/.config/vis/` will probably work).

Then, add `require('vis-modeline-options')` to your `visrc`.

#### Note on vis versions before 0.9

This plugin uses the `options` table, introduced in version 0.9. This version
has been released, but your distribution may not have the package yet. In that
case, you will also need
[vis-options-backport](https://github.com/milhnl/vis-options-backport). This
will 'polyfill' the `options` table for older versions.

### Usage

Nothing. The plugin will find modelines in the first and last 5 lines in the
file, using the first one it sees. It maps vi(m) options in the following way:

- `colorcolumn`, `cc`: forwarded.
- `expandtab`, `et`: forwarded.
- `filetype`, `ft`: forwarded to `win.syntax`. We'll probably need some
  mappings for this.
- `number`, `nu`: forwarded to `numbers`.
- `tabstop`, `shiftwidth`, `ts`, `sw`: sets `tabwidth`.

### Alternatives

There is also [vis-modelines](https://github.com/lutobler/vis-modelines), which
seems to be a bit outdated, as it only runs on the START event and thus will
not find modelines in opened files after editor start. The reason I built this
is mostly because I like writing plugins, fixing the other one would be easy.
This one also does not have LPEG as a dependency.
