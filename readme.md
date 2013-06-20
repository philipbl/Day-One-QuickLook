### Day One Quick Look Plugin

This is a fork of Brett Terpstra's [MultiMarkdown Quick Look with Style][mmdqlws], which is a fork of Fletcher Penney's [MMD Quicklook project][mmdql]. 

This Quick Look Plugin is for Day One entry files (`.doentry`). It does not replace other Markdown Quick Look plugins.

### Why Make a Quick Look Plugin for Day One?

Good question. Not sure. I just felt like doing it. I also found myself annoyed by the fact that a huge ribbon would show up every time I tried to quick look at a Day One entry. Since Day One uses Markdown, I figured it would be easy to create.

### Install

To install, [download the zip][dl], unarchive and place the `Day One QuickLook.qlgenerator` file in `~/Library/QuickLook/`. To make sure the Quick Look generator list reloads with the new file, you can run `qlmanage -r` on the command line.

[mmdql]: https://github.com/fletcher/MMD-QuickLook
[mmdqlws]: https://github.com/ttscoff/MMD-QuickLook
[dl]: http://www.cs.utah.edu/~philipbl/Day%20One%20QuickLook.qlgenerator.zip
