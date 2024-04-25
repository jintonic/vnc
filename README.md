## Getting Started

```sh
# log into the login node
ssh login.node.hpc
# create ~/.vnc/passwd
vncpasswd
# download settings from github
cd .vnc
git init
git remote add origin https://github.com/jintonic/vnc
git pull origin main
# map remote & local branches for `git pull` to work in the future
git branch --set-upstream-to=origin/main main
# launch vnc server in a worker node
sbatch vnc.slurm
```

