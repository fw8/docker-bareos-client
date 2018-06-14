
# Dockerized bareos client

_Stolen from <https://github.com/barcus/bareos>_

## Usage

### Backup Volumes

Start container from image freinet/bareos-client and add volumes to be included into your backup:

```bash
docker run -d \
  -p 9102:9102 \
  -e BAREOS_FD_PASSWORD=secret_shared_with_director \
  -v <my_volume1>:/volumes/my_volume \
  -v <my_volume2>:/volumes/my_volume2 \
  freinet/bareos-client
```

Create a corresponding fileset in your bareos director:

```config
FileSet {
  Name = "my_fileset"
  Include {
    Options {
      Signature = MD5
      Compression = LZFAST
      One FS = No
    }
    File = /volumes
  }
}
```

### Backup Mysql using bpipe plugin

_Stolen from <https://github.com/Brightside56/bareos-client-docker>_

Start container from image freinet/bareos-client and add the database to be included into your backup by using environment variables:

* `MYSQL_ADMIN_USER` (default is `root`)
* `MYSQL_ADMIN_PASSWORD`
* `MYSQL_HOST` (default is `db`)

```bash
docker run -d \
  -p 9102:9102 \
  -e BAREOS_FD_PASSWORD=secret_shared_with_director \
  -e MYSQL_ADMIN_USER=root \
  -e MYSQL_ADMIN_PASSWORD=secret \
  -e MYSQL_HOST=db \
  freinet/bareos-client
```

Create a corresponding fileset in your bareos director:

```config
FileSet{
  Name = "mysql_stream"
  Include {
    Options {
      Signature = MD5
      Compression = LZFAST
      One FS = No
    }
    Plugin = "\\|/etc/bareos/scripts/backup-db"
  }
}
```

This uses the command plugin which in turn calls the script `/etc/bareos/scripts/backup-db` on the client.
The script then looks up all available databases on the given mysql host and generates bpipe commands for each databse found...

### Restore Mysql using bpipe plugin

There are two ways to restore the backup using the method described.

* Restore direct to the database
* Restore to dump files

By default, the container attempts to recover the data to the given database by first dropping each database and then recreating it from the backup.

If the container was started with the environment variable `MYSQL_RESTORE_PATH` then a compressed dump file for each database is written to the given destination.

Example to write the Dumps directly to your working directory:

```bash
docker run -d \
  -p 9102:9102 \
  -e BAREOS_FD_PASSWORD=secret_shared_with_director \
  -e MYSQL_RESTORE_PATH=`pwd` \
  freinet/bareos-client
```
