module Fanotify

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
    __val::NTuple{2,Cint}
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

const int8_t = __int8_t

const int16_t = __int16_t

const int32_t = __int32_t

const int64_t = __int64_t

const uint8_t = __uint8_t

const uint16_t = __uint16_t

const uint32_t = __uint32_t

const uint64_t = __uint64_t

const int_least8_t = __int_least8_t

const int_least16_t = __int_least16_t

const int_least32_t = __int_least32_t

const int_least64_t = __int_least64_t

const uint_least8_t = __uint_least8_t

const uint_least16_t = __uint_least16_t

const uint_least32_t = __uint_least32_t

const uint_least64_t = __uint_least64_t

const int_fast8_t = Int8

const int_fast16_t = Clong

const int_fast32_t = Clong

const int_fast64_t = Clong

const uint_fast8_t = Cuchar

const uint_fast16_t = Culong

const uint_fast32_t = Culong

const uint_fast64_t = Culong

const intptr_t = Clong

const uintptr_t = Culong

const intmax_t = __intmax_t

const uintmax_t = __uintmax_t

const __s8 = Int8

const __u8 = Cuchar

const __s16 = Cshort

const __u16 = Cushort

const __s32 = Cint

const __u32 = Cuint

const __s64 = Clonglong

const __u64 = Culonglong

struct __kernel_fd_set
    fds_bits::NTuple{16,Culong}
end

# typedef void ( * __kernel_sighandler_t ) ( int )
const __kernel_sighandler_t = Ptr{Cvoid}

const __kernel_key_t = Cint

const __kernel_mqd_t = Cint

const __kernel_old_gid_t = Cushort

const __kernel_long_t = Clong

const __kernel_ulong_t = Culong

const __kernel_ino_t = __kernel_ulong_t

const __kernel_mode_t = Cuint

const __kernel_pid_t = Cint

const __kernel_ipc_pid_t = Cint

const __kernel_uid_t = Cuint

const __kernel_gid_t = Cuint

const __kernel_suseconds_t = __kernel_long_t

const __kernel_daddr_t = Cint

const __kernel_uid32_t = Cuint

const __kernel_gid32_t = Cuint

const __kernel_size_t = __kernel_ulong_t

const __kernel_ssize_t = __kernel_long_t

const __kernel_ptrdiff_t = __kernel_long_t

struct __kernel_fsid_t
    val::NTuple{2,Cint}
end

const __kernel_off_t = __kernel_long_t

const __kernel_loff_t = Clonglong

const __kernel_old_time_t = __kernel_long_t

const __kernel_time_t = __kernel_long_t

const __kernel_time64_t = Clonglong

const __kernel_clock_t = __kernel_long_t

const __kernel_timer_t = Cint

const __kernel_clockid_t = Cint

const __kernel_caddr_t = Ptr{Cchar}

const __kernel_uid16_t = Cushort

const __kernel_gid16_t = Cushort

const __le16 = __u16

const __be16 = __u16

const __le32 = __u32

const __be32 = __u32

const __le64 = __u64

const __be64 = __u64

const __sum16 = __u16

const __wsum = __u32

const __poll_t = Cuint

struct fanotify_event_metadata
    data::NTuple{24,UInt8}
end

function Base.getproperty(x::Ptr{fanotify_event_metadata}, f::Symbol)
    f === :event_len && return Ptr{__u32}(x + 0)
    f === :vers && return Ptr{__u8}(x + 4)
    f === :reserved && return Ptr{__u8}(x + 5)
    f === :metadata_len && return Ptr{__u16}(x + 6)
    f === :mask && return Ptr{__u64}(x + 8)
    f === :fd && return Ptr{__s32}(x + 16)
    f === :pid && return Ptr{__s32}(x + 20)
    return getfield(x, f)
end

function Base.getproperty(x::fanotify_event_metadata, f::Symbol)
    r = Ref{fanotify_event_metadata}(x)
    ptr = Base.unsafe_convert(Ptr{fanotify_event_metadata}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

function Base.setproperty!(x::Ptr{fanotify_event_metadata}, f::Symbol, v)
    return unsafe_store!(getproperty(x, f), v)
end

struct fanotify_event_info_header
    info_type::__u8
    pad::__u8
    len::__u16
end

struct fanotify_event_info_fid
    hdr::fanotify_event_info_header
    fsid::__kernel_fsid_t
    handle::NTuple{0,Cuchar}
end

struct fanotify_response
    fd::__s32
    response::__u32
end

function fanotify_init(__flags, __event_f_flags)
    return ccall(
        (:fanotify_init, "libc.so.6"), Cint, (Cuint, Cuint), __flags, __event_f_flags
    )
end

function fanotify_mark(__fanotify_fd, __flags, __mask, __dfd, __pathname)
    return ccall(
        (:fanotify_mark, "libc.so.6"),
        Cint,
        (Cint, Cuint, uint64_t, Cint, Ptr{Cchar}),
        __fanotify_fd,
        __flags,
        __mask,
        __dfd,
        __pathname,
    )
end

struct flock
    l_type::Cshort
    l_whence::Cshort
    l_start::__off_t
    l_len::__off_t
    l_pid::__pid_t
end

const mode_t = __mode_t

const off_t = __off_t

const pid_t = __pid_t

struct timespec
    tv_sec::__time_t
    tv_nsec::__syscall_slong_t
end

struct stat
    st_dev::__dev_t
    st_ino::__ino_t
    st_nlink::__nlink_t
    st_mode::__mode_t
    st_uid::__uid_t
    st_gid::__gid_t
    __pad0::Cint
    st_rdev::__dev_t
    st_size::__off_t
    st_blksize::__blksize_t
    st_blocks::__blkcnt_t
    st_atim::timespec
    st_mtim::timespec
    st_ctim::timespec
    __glibc_reserved::NTuple{3,__syscall_slong_t}
end

function creat(__file, __mode)
    return ccall((:creat, "libc.so.6"), Cint, (Ptr{Cchar}, mode_t), __file, __mode)
end

function lockf(__fd, __cmd, __len)
    return ccall((:lockf, "libc.so.6"), Cint, (Cint, Cint, off_t), __fd, __cmd, __len)
end

function posix_fadvise(__fd, __offset, __len, __advise)
    return ccall(
        (:posix_fadvise, "libc.so.6"),
        Cint,
        (Cint, off_t, off_t, Cint),
        __fd,
        __offset,
        __len,
        __advise,
    )
end

function posix_fallocate(__fd, __offset, __len)
    return ccall(
        (:posix_fallocate, "libc.so.6"), Cint, (Cint, off_t, off_t), __fd, __offset, __len
    )
end

const _DEFAULT_SOURCE = 1

const __GLIBC_USE_ISOC2X = 0

const __USE_ISOC11 = 1

const __USE_ISOC99 = 1

const __USE_ISOC95 = 1

const __USE_POSIX_IMPLICITLY = 1

const _POSIX_SOURCE = 1

const _POSIX_C_SOURCE = Clong(200809)

const __USE_POSIX = 1

const __USE_POSIX2 = 1

const __USE_POSIX199309 = 1

const __USE_POSIX199506 = 1

const __USE_XOPEN2K = 1

const __USE_XOPEN2K8 = 1

const _ATFILE_SOURCE = 1

const __USE_MISC = 1

const __USE_ATFILE = 1

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

# Skipping MacroDefinition: __extern_always_inline extern __always_inline __attribute__ ( ( __gnu_inline__ ) )

const __WORDSIZE = 64

const __WORDSIZE_TIME64_COMPAT32 = 1

const __SYSCALL_WORDSIZE = 64

const __LDOUBLE_REDIRECTS_TO_FLOAT128_ABI = 0

const __HAVE_GENERIC_SELECTION = 1

const __GLIBC_USE_LIB_EXT2 = 0

const __GLIBC_USE_IEC_60559_BFP_EXT = 0

const __GLIBC_USE_IEC_60559_BFP_EXT_C2X = 0

const __GLIBC_USE_IEC_60559_FUNCS_EXT = 0

const __GLIBC_USE_IEC_60559_FUNCS_EXT_C2X = 0

const __GLIBC_USE_IEC_60559_TYPES_EXT = 0

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

const INT8_MIN = -128

const INT16_MIN = -32767 - 1

const INT32_MIN = -2147483647 - 1

const INT8_MAX = 127

const INT16_MAX = 32767

const INT32_MAX = 2147483647

const UINT8_MAX = 255

const UINT16_MAX = 65535

const UINT32_MAX = Cuint(4294967295)

const INT_LEAST8_MIN = -128

const INT_LEAST16_MIN = -32767 - 1

const INT_LEAST32_MIN = -2147483647 - 1

const INT_LEAST8_MAX = 127

const INT_LEAST16_MAX = 32767

const INT_LEAST32_MAX = 2147483647

const UINT_LEAST8_MAX = 255

const UINT_LEAST16_MAX = 65535

const UINT_LEAST32_MAX = Cuint(4294967295)

const INT_FAST8_MIN = -128

const INT_FAST16_MIN = -(Clong(9223372036854775807)) - 1

const INT_FAST32_MIN = -(Clong(9223372036854775807)) - 1

const INT_FAST8_MAX = 127

const INT_FAST16_MAX = Clong(9223372036854775807)

const INT_FAST32_MAX = Clong(9223372036854775807)

const UINT_FAST8_MAX = 255

const UINT_FAST16_MAX = Culong(18446744073709551615)

const UINT_FAST32_MAX = Culong(18446744073709551615)

const INTPTR_MIN = -(Clong(9223372036854775807)) - 1

const INTPTR_MAX = Clong(9223372036854775807)

const UINTPTR_MAX = Culong(18446744073709551615)

const PTRDIFF_MIN = -(Clong(9223372036854775807)) - 1

const PTRDIFF_MAX = Clong(9223372036854775807)

const SIG_ATOMIC_MIN = -2147483647 - 1

const SIG_ATOMIC_MAX = 2147483647

const SIZE_MAX = Culong(18446744073709551615)

const WINT_MIN = Cuint(0)

const WINT_MAX = Cuint(4294967295)

const __BITS_PER_LONG = 64

# Skipping MacroDefinition: __aligned_u64 __u64 __attribute__ ( ( aligned ( 8 ) ) )

# Skipping MacroDefinition: __aligned_be64 __be64 __attribute__ ( ( aligned ( 8 ) ) )

# Skipping MacroDefinition: __aligned_le64 __le64 __attribute__ ( ( aligned ( 8 ) ) )

const FAN_ACCESS = 0x00000001

const FAN_MODIFY = 0x00000002

const FAN_ATTRIB = 0x00000004

const FAN_CLOSE_WRITE = 0x00000008

const FAN_CLOSE_NOWRITE = 0x00000010

const FAN_OPEN = 0x00000020

const FAN_MOVED_FROM = 0x00000040

const FAN_MOVED_TO = 0x00000080

const FAN_CREATE = 0x00000100

const FAN_DELETE = 0x00000200

const FAN_DELETE_SELF = 0x00000400

const FAN_MOVE_SELF = 0x00000800

const FAN_OPEN_EXEC = 0x00001000

const FAN_Q_OVERFLOW = 0x00004000

const FAN_OPEN_PERM = 0x00010000

const FAN_ACCESS_PERM = 0x00020000

const FAN_OPEN_EXEC_PERM = 0x00040000

const FAN_EVENT_ON_CHILD = 0x08000000

const FAN_ONDIR = 0x40000000

const FAN_CLOSE = FAN_CLOSE_WRITE | FAN_CLOSE_NOWRITE

const FAN_MOVE = FAN_MOVED_FROM | FAN_MOVED_TO

const FAN_CLOEXEC = 0x00000001

const FAN_NONBLOCK = 0x00000002

const FAN_CLASS_NOTIF = 0x00000000

const FAN_CLASS_CONTENT = 0x00000004

const FAN_CLASS_PRE_CONTENT = 0x00000008

const FAN_ALL_CLASS_BITS = (FAN_CLASS_NOTIF | FAN_CLASS_CONTENT) | FAN_CLASS_PRE_CONTENT

const FAN_UNLIMITED_QUEUE = 0x00000010

const FAN_UNLIMITED_MARKS = 0x00000020

const FAN_ENABLE_AUDIT = 0x00000040

const FAN_REPORT_TID = 0x00000100

const FAN_REPORT_FID = 0x00000200

const FAN_REPORT_DIR_FID = 0x00000400

const FAN_REPORT_NAME = 0x00000800

const FAN_REPORT_DFID_NAME = FAN_REPORT_DIR_FID | FAN_REPORT_NAME

const FAN_ALL_INIT_FLAGS =
    (((FAN_CLOEXEC | FAN_NONBLOCK) | FAN_ALL_CLASS_BITS) | FAN_UNLIMITED_QUEUE) |
    FAN_UNLIMITED_MARKS

const FAN_MARK_ADD = 0x00000001

const FAN_MARK_REMOVE = 0x00000002

const FAN_MARK_DONT_FOLLOW = 0x00000004

const FAN_MARK_ONLYDIR = 0x00000008

const FAN_MARK_IGNORED_MASK = 0x00000020

const FAN_MARK_IGNORED_SURV_MODIFY = 0x00000040

const FAN_MARK_FLUSH = 0x00000080

const FAN_MARK_INODE = 0x00000000

const FAN_MARK_MOUNT = 0x00000010

const FAN_MARK_FILESYSTEM = 0x00000100

const FAN_ALL_MARK_FLAGS =
    (
        (
            (
                (
                    ((FAN_MARK_ADD | FAN_MARK_REMOVE) | FAN_MARK_DONT_FOLLOW) |
                    FAN_MARK_ONLYDIR
                ) | FAN_MARK_MOUNT
            ) | FAN_MARK_IGNORED_MASK
        ) | FAN_MARK_IGNORED_SURV_MODIFY
    ) | FAN_MARK_FLUSH

const FAN_ALL_EVENTS = ((FAN_ACCESS | FAN_MODIFY) | FAN_CLOSE) | FAN_OPEN

const FAN_ALL_PERM_EVENTS = FAN_OPEN_PERM | FAN_ACCESS_PERM

const FAN_ALL_OUTGOING_EVENTS = (FAN_ALL_EVENTS | FAN_ALL_PERM_EVENTS) | FAN_Q_OVERFLOW

const FANOTIFY_METADATA_VERSION = 3

const FAN_EVENT_INFO_TYPE_FID = 1

const FAN_EVENT_INFO_TYPE_DFID_NAME = 2

const FAN_EVENT_INFO_TYPE_DFID = 3

const FAN_ALLOW = 0x01

const FAN_DENY = 0x02

const FAN_AUDIT = 0x10

const FAN_NOFD = -1

# Skipping MacroDefinition: FAN_EVENT_METADATA_LEN ( sizeof ( struct fanotify_event_metadata ) )

const __O_LARGEFILE = 0

const F_GETLK64 = 5

const F_SETLK64 = 6

const F_SETLKW64 = 7

const O_ACCMODE = 0x0003

const O_RDONLY = 0x00

const O_WRONLY = 0x01

const O_RDWR = 0x02

const O_CREAT = 0x0040

const O_EXCL = 0x0080

const O_NOCTTY = 0x0100

const O_TRUNC = 0x0200

const O_APPEND = 0x0400

const O_NONBLOCK = 0x0800

const O_NDELAY = O_NONBLOCK

const O_SYNC = 0x00101000

const O_FSYNC = O_SYNC

const O_ASYNC = 0x2000

const __O_DIRECTORY = 0x00010000

const __O_NOFOLLOW = 0x00020000

const __O_CLOEXEC = 0x00080000

const __O_DIRECT = 0x4000

const __O_NOATIME = 0x00040000

const __O_PATH = 0x00200000

const __O_DSYNC = 0x1000

const __O_TMPFILE = 0x00400000 | __O_DIRECTORY

const F_GETLK = 5

const F_SETLK = 6

const F_SETLKW = 7

const O_DIRECTORY = __O_DIRECTORY

const O_NOFOLLOW = __O_NOFOLLOW

const O_CLOEXEC = __O_CLOEXEC

const O_DSYNC = __O_DSYNC

const O_RSYNC = O_SYNC

const F_DUPFD = 0

const F_GETFD = 1

const F_SETFD = 2

const F_GETFL = 3

const F_SETFL = 4

const __F_SETOWN = 8

const __F_GETOWN = 9

const F_SETOWN = __F_SETOWN

const F_GETOWN = __F_GETOWN

const __F_SETSIG = 10

const __F_GETSIG = 11

const __F_SETOWN_EX = 15

const __F_GETOWN_EX = 16

const F_DUPFD_CLOEXEC = 1030

const FD_CLOEXEC = 1

const F_RDLCK = 0

const F_WRLCK = 1

const F_UNLCK = 2

const F_EXLCK = 4

const F_SHLCK = 8

const LOCK_SH = 1

const LOCK_EX = 2

const LOCK_NB = 4

const LOCK_UN = 8

const FAPPEND = O_APPEND

const FFSYNC = O_FSYNC

const FASYNC = O_ASYNC

const FNONBLOCK = O_NONBLOCK

const FNDELAY = O_NDELAY

const __POSIX_FADV_DONTNEED = 4

const __POSIX_FADV_NOREUSE = 5

const POSIX_FADV_NORMAL = 0

const POSIX_FADV_RANDOM = 1

const POSIX_FADV_SEQUENTIAL = 2

const POSIX_FADV_WILLNEED = 3

const POSIX_FADV_DONTNEED = __POSIX_FADV_DONTNEED

const POSIX_FADV_NOREUSE = __POSIX_FADV_NOREUSE

const AT_FDCWD = -100

const AT_SYMLINK_NOFOLLOW = 0x0100

const AT_REMOVEDIR = 0x0200

const AT_SYMLINK_FOLLOW = 0x0400

const AT_EACCESS = 0x0200

const _STRUCT_TIMESPEC = 1

const __LITTLE_ENDIAN = 1234

const __BIG_ENDIAN = 4321

const __PDP_ENDIAN = 3412

const __BYTE_ORDER = __LITTLE_ENDIAN

const __FLOAT_WORD_ORDER = __BYTE_ORDER

const _STAT_VER_KERNEL = 0

const _STAT_VER_LINUX = 1

const _MKNOD_VER_LINUX = 0

const _STAT_VER = _STAT_VER_LINUX

# Skipping MacroDefinition: st_atime st_atim . tv_sec

# Skipping MacroDefinition: st_mtime st_mtim . tv_sec

# Skipping MacroDefinition: st_ctime st_ctim . tv_sec

const __S_IFMT = 0x0000f000

const __S_IFDIR = 0x00004000

const __S_IFCHR = 0x00002000

const __S_IFBLK = 0x00006000

const __S_IFREG = 0x00008000

const __S_IFIFO = 0x00001000

const __S_IFLNK = 0x0000a000

const __S_IFSOCK = 0x0000c000

const __S_ISUID = 0x0800

const __S_ISGID = 0x0400

const __S_ISVTX = 0x0200

const __S_IREAD = 0x0100

const __S_IWRITE = 0x0080

const __S_IEXEC = 0x0040

const UTIME_NOW = Clong(1) << 30 - Clong(1)

const UTIME_OMIT = Clong(1) << 30 - Clong(2)

const S_IFMT = __S_IFMT

const S_IFDIR = __S_IFDIR

const S_IFCHR = __S_IFCHR

const S_IFBLK = __S_IFBLK

const S_IFREG = __S_IFREG

const S_IFIFO = __S_IFIFO

const S_IFLNK = __S_IFLNK

const S_IFSOCK = __S_IFSOCK

const S_ISUID = __S_ISUID

const S_ISGID = __S_ISGID

const S_ISVTX = __S_ISVTX

const S_IRUSR = __S_IREAD

const S_IWUSR = __S_IWRITE

const S_IXUSR = __S_IEXEC

const S_IRWXU = (__S_IREAD | __S_IWRITE) | __S_IEXEC

const S_IRGRP = S_IRUSR >> 3

const S_IWGRP = S_IWUSR >> 3

const S_IXGRP = S_IXUSR >> 3

const S_IRWXG = S_IRWXU >> 3

const S_IROTH = S_IRGRP >> 3

const S_IWOTH = S_IWGRP >> 3

const S_IXOTH = S_IXGRP >> 3

const S_IRWXO = S_IRWXG >> 3

const R_OK = 4

const W_OK = 2

const X_OK = 1

const F_OK = 0

const SEEK_SET = 0

const SEEK_CUR = 1

const SEEK_END = 2

const F_ULOCK = 0

const F_LOCK = 1

const F_TLOCK = 2

const F_TEST = 3

# exports
const PREFIXES = ["CX", "clang_"]
for name in names(@__MODULE__; all=true), prefix in PREFIXES
    if startswith(string(name), prefix)
        @eval export $name
    end
end

end # module
