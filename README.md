# Introduction #

This project provides a simple implementation of the [Pomodoro][pomodoro] technique that interfaces with [libnotify][libnotify].

# Getting Started #

The implementation of this timer is very simple. It is implemented in terms of [Bash][bash] and is less than 150 lines long. You
will need to install [libnotify][libnotify] and have the `notify-send` binary on the `PATH` for the script to run.

The script runs in a infinite loop moving from one state to the next until terminated. Typically you will just terminate it with
the interrupt signal via Ctrl-C on the command line.

[pomodoro]: https://en.wikipedia.org/wiki/Pomodoro_Technique "Pomodoro"

[libnotify]: https://developer.gnome.org/notification-spec/ "libnotify"

[bash]: http://www.gnu.org/software/bash/bash.html "Bash"
