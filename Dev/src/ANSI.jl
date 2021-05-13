module  ANSI

using ..Dev: @exportall

# See https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797

cursor_enable() = "\e[?25h"
cursor_disable() = "\e[?25l"
cursor_up(n::Int=1) = string("\e[", n, "A")
cursor_down(n::Int=1) = string("\e[", n, "B")
cursor_move_col(n::Int=1) = string("\e[", n, "G")

scroll_up(n::Int=1) = string("\e[", n, "S")
scroll_down(n::Int=1) = string("\e[", n, "T")

clearline() = "\e[2K"

@exportall

end
