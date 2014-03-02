pdk7105-tdt
===========

tdt for pdk7105 - NextVOD

Build Environment
=================

1. install docker (kernel 3.8 or above. Archlinux lxc package 1.0.0 will cause error, use 0.9.0-6 version) https://www.docker.io/gettingstarted/
2. git clone https://github.com/dlintw/mydocker 
3. cd mydocker/ubuntu/duckbox
4. edit build.sh for the settings which you want
5. sudo ./run.sh build
6. The root file system will put in /Archive/YYYYMMDD.txz
7. The make log put on /tdt/tdt/cvs/cdk/make.*.log

Git Source
==========

use git_remote.sh to add upstream repositories.

* https://github.com/suzuke/pdk7105-tdt pdk7105 branch (patch for NextVOD)
* https://gitorious.org/open-duckbox-project-sh4/max-tdt (Original upstream)
