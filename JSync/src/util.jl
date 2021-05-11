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
    childpath, ev = FileWatching.watch_folder(path, timeout)
    path = childpath == "" ? childpath : sanitize_path(joinpath(path, childpath))
    kind = isdir(path) ? :dir : :file
    return TreeEvent(kind, path, ev.changed, ev.renamed, ev.timedout)
end
