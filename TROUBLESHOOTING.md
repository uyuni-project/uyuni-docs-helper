# podman

## ERRO[0000] cannot find UID/GID for user

If you see the following error:

```
ERRO[0000] cannot find UID/GID for user pat: no subuid ranges found for user "MYUSER" in /etc/subuid - check rootless mode in man pages.
```

This means your current user does not allow creating rootless containers (containers that run as a non-root user), because a requirement is missing: subuid and subguid ranges for the user.

Most recent operating systems will do this for you, but if your user was created on a old version of such operating system, and then you kept upgrading, it is possible subh subuid and subguid are missing.

How to fix this problem is [documented](https://github.com/containers/podman/blob/main/docs/tutorials/rootless_tutorial.md#etcsubuid-and-etcsubgid-configuration)

Assuming there are no ranges assigned (check `/etc/subuid` and `/etc/subguid`), you can fix the issue by running the following command (replace `MYUSER` with your username):

```
sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 MYUSER
```
