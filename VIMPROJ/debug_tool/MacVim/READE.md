### How to generate a debug log

Go through the following steps to generate a debug log and store it in a file
called `macvim.log`.  Be sure to type each command carefully or it will not work
(I suggest you copy and paste each line in order to avoid typos).

1.  Quit MacVim (hit &#8984;Q)

2.  Open Terminal and type

        $ defaults write org.vim.MacVim MMLogLevel 7
        $ defaults write org.vim.MacVim MMLogToStdErr 1
        $ /Applications/MacVim.app/Contents/MacOS/Vim -g -f 2> macvim.log

    (The last step assumes that you have put MacVim in your `/Applications`
    folder; adjust the last path if you have put it somewhere else.  If you have
    changed your shell then you may need to change the `2>` to whatever command
    is used to redirect to stderr with your shell.)

3.  Interact with MacVim (e.g. do what you have to in order to recreate a bug)
    and then quit (&#8984;Q).  The debug log is now saved in a file called
    `macvim.log`.  Open it up and check that it is not empty (if it is the you
    have most likely misspelled something in step 2, or forgot to quit MacVim).

4.  Go back to Terminal and type

        $ defaults delete org.vim.MacVim MMLogLevel
        $ defaults delete org.vim.MacVim MMLogToStdErr

    in order to disable debug logging.

