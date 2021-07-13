module Mman

using CEnum

const __u_char = Cuchar

const __u_short = Cushort

const __u_int = Cuint

const __u_long = Culong

const __int8_t = Int8

const __uint8_t = Cuchar

const __int16_t = Cshort

const __uint16_t = Cushort

const __int32_t = Cint

const __uint32_t = Cuint

const __int64_t = Clong

const __uint64_t = Culong

const __int_least8_t = __int8_t

const __uint_least8_t = __uint8_t

const __int_least16_t = __int16_t

const __uint_least16_t = __uint16_t

const __int_least32_t = __int32_t

const __uint_least32_t = __uint32_t

const __int_least64_t = __int64_t

const __uint_least64_t = __uint64_t

const __quad_t = Clong

const __u_quad_t = Culong

const __intmax_t = Clong

const __uintmax_t = Culong

const __dev_t = Culong

const __uid_t = Cuint

const __gid_t = Cuint

const __ino_t = Culong

const __ino64_t = Culong

const __mode_t = Cuint

const __nlink_t = Culong

const __off_t = Clong

const __off64_t = Clong

const __pid_t = Cint

struct __fsid_t
    __val::NTuple{2, Cint}
end

const __clock_t = Clong

const __rlim_t = Culong

const __rlim64_t = Culong

const __id_t = Cuint

const __time_t = Clong

const __useconds_t = Cuint

const __suseconds_t = Clong

const __suseconds64_t = Clong

const __daddr_t = Cint

const __key_t = Cint

const __clockid_t = Cint

const __timer_t = Ptr{Cvoid}

const __blksize_t = Clong

const __blkcnt_t = Clong

const __blkcnt64_t = Clong

const __fsblkcnt_t = Culong

const __fsblkcnt64_t = Culong

const __fsfilcnt_t = Culong

const __fsfilcnt64_t = Culong

const __fsword_t = Clong

const __ssize_t = Clong

const __syscall_slong_t = Clong

const __syscall_ulong_t = Culong

const __loff_t = __off64_t

const __caddr_t = Ptr{Cchar}

const __intptr_t = Clong

const __socklen_t = Cuint

const __sig_atomic_t = Cint

const size_t = Culong

const off_t = __off_t

const mode_t = __mode_t

function memfd_create(__name, __flags)
    ccall((:memfd_create, "libc.so.6"), Cint, (Ptr{Cchar}, Cuint), __name, __flags)
end

function mlock2(__addr, __length, __flags)
    ccall((:mlock2, "libc.so.6"), Cint, (Ptr{Cvoid}, size_t, Cuint), __addr, __length, __flags)
end

function pkey_alloc(__flags, __access_rights)
    ccall((:pkey_alloc, "libc.so.6"), Cint, (Cuint, Cuint), __flags, __access_rights)
end

function pkey_set(__key, __access_rights)
    ccall((:pkey_set, "libc.so.6"), Cint, (Cint, Cuint), __key, __access_rights)
end

function pkey_get(__key)
    ccall((:pkey_get, "libc.so.6"), Cint, (Cint,), __key)
end

function pkey_free(__key)
    ccall((:pkey_free, "libc.so.6"), Cint, (Cint,), __key)
end

function pkey_mprotect(__addr, __len, __prot, __pkey)
    ccall((:pkey_mprotect, "libc.so.6"), Cint, (Ptr{Cvoid}, size_t, Cint, Cint), __addr, __len, __prot, __pkey)
end

function mmap(__addr, __len, __prot, __flags, __fd, __offset)
    ccall((:mmap, "libc.so.6"), Ptr{Cvoid}, (Ptr{Cvoid}, size_t, Cint, Cint, Cint, __off_t), __addr, __len, __prot, __flags, __fd, __offset)
end

function mmap64(__addr, __len, __prot, __flags, __fd, __offset)
    ccall((:mmap64, "libc.so.6"), Ptr{Cvoid}, (Ptr{Cvoid}, size_t, Cint, Cint, Cint, __off64_t), __addr, __len, __prot, __flags, __fd, __offset)
end

function munmap(__addr, __len)
    ccall((:munmap, "libc.so.6"), Cint, (Ptr{Cvoid}, size_t), __addr, __len)
end

function mprotect(__addr, __len, __prot)
    ccall((:mprotect, "libc.so.6"), Cint, (Ptr{Cvoid}, size_t, Cint), __addr, __len, __prot)
end

function msync(__addr, __len, __flags)
    ccall((:msync, "libc.so.6"), Cint, (Ptr{Cvoid}, size_t, Cint), __addr, __len, __flags)
end

function madvise(__addr, __len, __advice)
    ccall((:madvise, "libc.so.6"), Cint, (Ptr{Cvoid}, size_t, Cint), __addr, __len, __advice)
end

function posix_madvise(__addr, __len, __advice)
    ccall((:posix_madvise, "libc.so.6"), Cint, (Ptr{Cvoid}, size_t, Cint), __addr, __len, __advice)
end

function mlock(__addr, __len)
    ccall((:mlock, "libc.so.6"), Cint, (Ptr{Cvoid}, size_t), __addr, __len)
end

function munlock(__addr, __len)
    ccall((:munlock, "libc.so.6"), Cint, (Ptr{Cvoid}, size_t), __addr, __len)
end

function mlockall(__flags)
    ccall((:mlockall, "libc.so.6"), Cint, (Cint,), __flags)
end

function munlockall()
    ccall((:munlockall, "libc.so.6"), Cint, ())
end

function mincore(__start, __len, __vec)
    ccall((:mincore, "libc.so.6"), Cint, (Ptr{Cvoid}, size_t, Ptr{Cuchar}), __start, __len, __vec)
end

function remap_file_pages(__start, __size, __prot, __pgoff, __flags)
    ccall((:remap_file_pages, "libc.so.6"), Cint, (Ptr{Cvoid}, size_t, Cint, size_t, Cint), __start, __size, __prot, __pgoff, __flags)
end

function shm_open(__name, __oflag, __mode)
    ccall((:shm_open, "libc.so.6"), Cint, (Ptr{Cchar}, Cint, mode_t), __name, __oflag, __mode)
end

function shm_unlink(__name)
    ccall((:shm_unlink, "libc.so.6"), Cint, (Ptr{Cchar},), __name)
end

const _ISOC95_SOURCE = 1

const _ISOC99_SOURCE = 1

const _ISOC11_SOURCE = 1

const _ISOC2X_SOURCE = 1

const _POSIX_SOURCE = 1

const _POSIX_C_SOURCE = Clong(200809)

const _XOPEN_SOURCE = 700

const _XOPEN_SOURCE_EXTENDED = 1

const _LARGEFILE64_SOURCE = 1

const _DEFAULT_SOURCE = 1

const _ATFILE_SOURCE = 1

const __GLIBC_USE_ISOC2X = 1

const __USE_ISOC11 = 1

const __USE_ISOC99 = 1

const __USE_ISOC95 = 1

const __USE_POSIX = 1

const __USE_POSIX2 = 1

const __USE_POSIX199309 = 1

const __USE_POSIX199506 = 1

const __USE_XOPEN2K = 1

const __USE_XOPEN2K8 = 1

const __USE_XOPEN = 1

const __USE_XOPEN_EXTENDED = 1

const __USE_UNIX98 = 1

const _LARGEFILE_SOURCE = 1

const __USE_XOPEN2K8XSI = 1

const __USE_XOPEN2KXSI = 1

const __USE_LARGEFILE = 1

const __USE_LARGEFILE64 = 1

const __USE_MISC = 1

const __USE_ATFILE = 1

const __USE_GNU = 1

const __USE_FORTIFY_LEVEL = 0

const __GLIBC_USE_DEPRECATED_GETS = 0

const __GLIBC_USE_DEPRECATED_SCANF = 0

const __STDC_IEC_559__ = 1

const __STDC_IEC_559_COMPLEX__ = 1

const __STDC_ISO_10646__ = Clong(201706)

const __GNU_LIBRARY__ = 6

const __GLIBC__ = 2

const __GLIBC_MINOR__ = 32

# Skipping MacroDefinition: __THROW __attribute__ ( ( __nothrow__ __LEAF ) )

# Skipping MacroDefinition: __THROWNL __attribute__ ( ( __nothrow__ ) )

const __flexarr = []

const __glibc_c99_flexarr_available = 1

# Skipping MacroDefinition: __attribute_malloc__ __attribute__ ( ( __malloc__ ) )

# Skipping MacroDefinition: __attribute_pure__ __attribute__ ( ( __pure__ ) )

# Skipping MacroDefinition: __attribute_const__ __attribute__ ( ( __const__ ) )

# Skipping MacroDefinition: __attribute_used__ __attribute__ ( ( __used__ ) )

# Skipping MacroDefinition: __attribute_noinline__ __attribute__ ( ( __noinline__ ) )

# Skipping MacroDefinition: __attribute_deprecated__ __attribute__ ( ( __deprecated__ ) )

# Skipping MacroDefinition: __attribute_warn_unused_result__ __attribute__ ( ( __warn_unused_result__ ) )

# Skipping MacroDefinition: __always_inline __inline __attribute__ ( ( __always_inline__ ) )

# Skipping MacroDefinition: __extern_inline extern __inline __attribute__ ( ( __gnu_inline__ ) )

const __WORDSIZE = 64

const __WORDSIZE_TIME64_COMPAT32 = 1

const __SYSCALL_WORDSIZE = 64

const __LDOUBLE_REDIRECTS_TO_FLOAT128_ABI = 0

const __HAVE_GENERIC_SELECTION = 1

const __TIMESIZE = __WORDSIZE

# Skipping MacroDefinition: __S16_TYPE short int

# Skipping MacroDefinition: __U16_TYPE unsigned short int

const __S32_TYPE = Cint

const __U32_TYPE = Cuint

# Skipping MacroDefinition: __SLONGWORD_TYPE long int

# Skipping MacroDefinition: __ULONGWORD_TYPE unsigned long int

# Skipping MacroDefinition: __SQUAD_TYPE long int

# Skipping MacroDefinition: __UQUAD_TYPE unsigned long int

# Skipping MacroDefinition: __SWORD_TYPE long int

# Skipping MacroDefinition: __UWORD_TYPE unsigned long int

const __SLONG32_TYPE = Cint

const __ULONG32_TYPE = Cuint

# Skipping MacroDefinition: __S64_TYPE long int

# Skipping MacroDefinition: __U64_TYPE unsigned long int

# Skipping MacroDefinition: __STD_TYPE typedef

const __UID_T_TYPE = __U32_TYPE

const __GID_T_TYPE = __U32_TYPE

const __MODE_T_TYPE = __U32_TYPE

const __PID_T_TYPE = __S32_TYPE

const __ID_T_TYPE = __U32_TYPE

const __USECONDS_T_TYPE = __U32_TYPE

const __DADDR_T_TYPE = __S32_TYPE

const __KEY_T_TYPE = __S32_TYPE

const __CLOCKID_T_TYPE = __S32_TYPE

# Skipping MacroDefinition: __FSID_T_TYPE struct { int __val [ 2 ] ; }

const __OFF_T_MATCHES_OFF64_T = 1

const __INO_T_MATCHES_INO64_T = 1

const __RLIM_T_MATCHES_RLIM64_T = 1

const __STATFS_MATCHES_STATFS64 = 1

const __KERNEL_OLD_TIMEVAL_MATCHES_TIMEVAL64 = 1

const __FD_SETSIZE = 1024

const MAP_32BIT = 0x40

const MAP_GROWSDOWN = 0x00000100

const MAP_DENYWRITE = 0x00000800

const MAP_EXECUTABLE = 0x00001000

const MAP_LOCKED = 0x00002000

const MAP_NORESERVE = 0x00004000

const MAP_POPULATE = 0x00008000

const MAP_NONBLOCK = 0x00010000

const MAP_STACK = 0x00020000

const MAP_HUGETLB = 0x00040000

const MAP_SYNC = 0x00080000

const MAP_FIXED_NOREPLACE = 0x00100000

const PROT_READ = 0x01

const PROT_WRITE = 0x02

const PROT_EXEC = 0x04

const PROT_NONE = 0x00

const PROT_GROWSDOWN = 0x01000000

const PROT_GROWSUP = 0x02000000

const MAP_SHARED = 0x01

const MAP_PRIVATE = 0x02

const MAP_SHARED_VALIDATE = 0x03

const MAP_TYPE = 0x0f

const MAP_FIXED = 0x10

const MAP_FILE = 0

const MAP_ANONYMOUS = 0x20

const MAP_ANON = MAP_ANONYMOUS

const MAP_HUGE_SHIFT = 26

const MAP_HUGE_MASK = 0x3f

const MS_ASYNC = 1

const MS_SYNC = 4

const MS_INVALIDATE = 2

const MADV_NORMAL = 0

const MADV_RANDOM = 1

const MADV_SEQUENTIAL = 2

const MADV_WILLNEED = 3

const MADV_DONTNEED = 4

const MADV_FREE = 8

const MADV_REMOVE = 9

const MADV_DONTFORK = 10

const MADV_DOFORK = 11

const MADV_MERGEABLE = 12

const MADV_UNMERGEABLE = 13

const MADV_HUGEPAGE = 14

const MADV_NOHUGEPAGE = 15

const MADV_DONTDUMP = 16

const MADV_DODUMP = 17

const MADV_WIPEONFORK = 18

const MADV_KEEPONFORK = 19

const MADV_COLD = 20

const MADV_PAGEOUT = 21

const MADV_HWPOISON = 100

const POSIX_MADV_NORMAL = 0

const POSIX_MADV_RANDOM = 1

const POSIX_MADV_SEQUENTIAL = 2

const POSIX_MADV_WILLNEED = 3

const POSIX_MADV_DONTNEED = 4

const MCL_CURRENT = 1

const MCL_FUTURE = 2

const MCL_ONFAULT = 4

const MREMAP_MAYMOVE = 1

const MREMAP_FIXED = 2

const MREMAP_DONTUNMAP = 4

const MFD_CLOEXEC = Cuint(1)

const MFD_ALLOW_SEALING = Cuint(2)

const MFD_HUGETLB = Cuint(4)

const MLOCK_ONFAULT = Cuint(1)

const PKEY_DISABLE_ACCESS = 0x01

const PKEY_DISABLE_WRITE = 0x02

# Skipping MacroDefinition: MAP_FAILED ( ( void * ) - 1 )

end # module
