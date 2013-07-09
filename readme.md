### Day One Quick Look Plug-in

This is a fork of Brett Terpstra's [MultiMarkdown Quick Look with Style][mmdqlws], which is a fork of Fletcher Penney's [MMD QuickLook project][mmdql]. 

This Quick Look Plug-in is for Day One entry files (`.doentry`). It does not replace other Markdown Quick Look plug-ins. It uses the same styling as Day One uses, as referenced from the [company's github][bloom]. If you want to add customize styling to the Quick Look plug-in, add `.dayoneqlstyle.css` to your home directory with your own styling.

### Install

To install, [download the zip][dl], unarchive and place the `Day One QuickLook.qlgenerator` file in `~/Library/QuickLook/`. To make sure the Quick Look generator list reloads with the new file, you can run `qlmanage -r` on the command line.

### Uninstall

To uninstall the plug-in, remove the the `Day One QuickLook.qlgenerator` file in `~/Library/QuickLook/`. You might need to restart Quick Look for this to take effect. This can be done using the same command as above, `qlmanage -r`

### Why Make a Quick Look Plug-in for Day One?

Good question. Not sure. I just felt like doing it. I found myself annoyed by the fact that a huge ribbon would show up every time I tried to quick look at a Day One entry. Since Day One uses Markdown, I figured it would be easy to create.

[mmdql]: https://github.com/fletcher/MMD-QuickLook
[mmdqlws]: https://github.com/ttscoff/MMD-QuickLook
[dl]: http://www.cs.utah.edu/~philipbl/Day%20One%20QuickLook.qlgenerator.zip
[bloom]: https://github.com/bloom/DOMarkdown
