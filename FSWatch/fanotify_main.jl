module M

include("./src/fanotify.jl")
using .Fanotify
using .Fanotify: fanotify_init, FAN_CLASS_NOTIF, O_RDONLY

function init()
    ret = fanotify_init(FAN_CLASS_NOTIF, O_RDONLY)
    if ret == -1 
        # errno = Base.Libc.errno()
        errno = Base.Libc.strerror()
        error("fanotify_init failed with exit code: $errno")
    else
        return ret
    end
end

end

M.init()
