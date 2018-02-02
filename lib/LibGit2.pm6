use NativeCall;
use Git::Error;
use Git::Repository;
use Git::Config;
use Git::Tree;
use Git::Object;
use Git::Message;

my package EXPORT::DEFAULT {}
BEGIN for <
    GIT_CONFIG_LEVEL_PROGRAMDATA
    GIT_CONFIG_LEVEL_SYSTEM
    GIT_CONFIG_LEVEL_XDG
    GIT_CONFIG_LEVEL_GLOBAL
    GIT_CONFIG_LEVEL_LOCAL
    GIT_CONFIG_LEVEL_APP
    GIT_CONFIG_HIGHEST_LEVEL

    GIT_FILEMODE_UNREADABLE
    GIT_FILEMODE_TREE
    GIT_FILEMODE_BLOB
    GIT_FILEMODE_BLOB_EXECUTABLE
    GIT_FILEMODE_LINK
    GIT_FILEMODE_COMMIT

    GIT_OBJ_ANY
    GIT_OBJ_BAD
    GIT_OBJ_COMMIT
    GIT_OBJ_TREE
    GIT_OBJ_BLOB
    GIT_OBJ_TAG
    GIT_OBJ_OFS_DELTA
    GIT_OBJ_REF_DELTA
> { EXPORT::DEFAULT::{$_} = ::($_) }

sub git_libgit2_init(--> int32) is native('git2') {}
sub git_libgit2_shutdown(--> int32) is native('git2') {}

INIT git_libgit2_init;
END git_libgit2_shutdown;

enum Git::Feature (
    GIT_FEATURE_THREADS => 1 +< 0,
    GIT_FEATURE_HTTPS   => 1 +< 1,
    GIT_FEATURE_SSH     => 1 +< 2,
    GIT_FEATURE_NSEC    => 1 +< 3,
);

class LibGit2
{
    sub git_libgit2_version(int32 is rw, int32 is rw, int32 is rw)
        is native('git2') {}

    sub git_libgit2_features(--> int32)
        is native('git2') {}

    method version
    {
        my int32 $major;
        my int32 $minor;
        my int32 $rev;
        git_libgit2_version($major, $minor, $rev);
        "$major.$minor.$rev"
    }

    method features
    {
        my $features = git_libgit2_features;
        set do for Git::Feature.enums { .key if $features +& .value }
    }
}
