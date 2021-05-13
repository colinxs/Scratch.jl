# watch_folder only works if trailing slash?
function sanitize_path(path::String)
    @assert path != ""
    path = normpath(abspath(rstrip(path, '/')))
    while contains(path, "//")
        path = replace(path, "//" => '/')
    end
    return isdir(path) ? path * '/' : path
end

function recursive_children(parent::String)
    parent = sanitize_path(parent)
    return (
        sanitize_path(joinpath(parent, r, d)) for (r, ds, fs) in walkdir(parent) for d in ds
    )
end

function children(parent::String)
    parent = sanitize_path(parent)
    return (sanitize_path(p) for p in readdir(parent; join=true, sort=false) if isdir(p))
end

function issubpath(path::String, parent::String)
    return startswith(sanitize_path(path), sanitize_path(parent))
end

function watch_folder(path::String, timeout::Int=-1)
    path = sanitize_path(path)
    evpath, ev = FileWatching.watch_folder(path, timeout)
    evpath = evpath == "" ? path : sanitize_path(joinpath(path, evpath))
    kind = isdir(evpath) ? :dir : :file
    return TreeEvent(kind, evpath, ev.changed, ev.renamed, ev.timedout)
end

macro catchall(expr)
    quote
        try
            $(esc(expr))
        catch
        end
    end
end

clip(x, mi, ma) = max(mi, min(ma, x))
