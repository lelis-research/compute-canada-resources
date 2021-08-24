# Compute Canada Resources

This guide is intended to help Alberta Machine Intelligence Institute (AMII) associated researchers at University of Alberta to get started with Compute Canada(CC).

## Getting Started

Once you have created account on CC, generate an SSH key pair and add your public key to your CC account. Once you are done you can use the following command in your terminal to ssh to CC.

```sh
ssh -Y <username>@<node_name>.computecanada.ca
```

Replace `<username>` with your username and `<node_name>` with the node name you want to connect to. For instance, `beluga`, `graham`, and `cedar` are some of the nodes which are available to Amii. You can find the username in your account.

## Submiting your first job

By default you are at your `$HOME` dir when you ssh into CC. CC is based on Slurm, which is a job schedular that allows you to submit jobs. In your home directoy, usually your scripts are saved. It's a good practise to always use a version control like `git` to keep track of your scripts.

Inside your home dir, you should clone any repository containing the script that you want to run. For instance, you can clone this repo, it contains a script `sampels/script.sh` that you can run. To run the script, do not forget to change the line `#SBATCH --account=<def-someuser>` in the script. Replace `<def-someuser>` with your group name. You can find the group name in your CC account.

After cloning the repo, in order to run the script, you need to `cd` into the directory where the script is located. Then you can use the following command to run the script.

```sh
salloc script.sh
```

That's it! You have submitted your first job. You will see a `HELLO WORLD` message in your terminal. You can either use `salloc` or `sbatch` to submit the jobs.

### `sbatch` vs `salloc`

`salloc` allows you to submit job in an interactive mode. You can see all the outputs in your terminal as they occur. `sbatch` is also used to submit jobs but not in an interactive mode. In case of `sbatch`, you can set specify where you want to save the output. You can use following parameter in your script to set that.

```sh
#SBATCH --output=%N-%j.out  # %N for node name, %j for jobID
```

Use this similar to how `#SBATCH --account=<def-someuser>` is used in `samples/script.sh`.

> Important thing is that all the output files are stored in `$SCRATCH`. So do not forget to save your results once your job is completed. You may loose them if they remained un-used for a long time.

### Common Options

Some common options are:

```sh
#SBATCH --cpus-per-task=1   # maximum CPU cores per GPU request: 6 on Cedar, 16 on Graham.
#SBATCH --mem=16000M        # memory per node
#SBATCH --time=0-02:00      # time (DD-HH:MM)
```

You can use these as you need for your script. Make sure to request the minimum resources that your script requires because these parameters are used to decide the priority of the job.You can easily get priority with less resources.

## Checking status of your job

Sometimes, you submit jobs for hours and days and you don't know if your job is completed or not. You can use the following commands to check the status of your job.

```sh
squeue
# OR
sq  # Short form of squeue
```

It will show you all of your jobs irrespective of the status. You can use some of the following flags to filter the output of this command:

```sh
sq -u <username> -t RUNNING # show only running jobs
sq -u <username> -t PENDING # show only pending jobs
```

`-t` is short of `states`. It can take any of the following values:

`PENDING`,`RUNNING`,`SUSPENDED`,`COMPLETED`,`CANCELLED`,`FAILED`,`TIMEOUT`,`NODE_FAIL`,`PREEMPTED`,`BOOT_FAIL`,`DEADLINE`,`OUT_OF_MEMORY`,`COMPLETING`,`CONFIGURING`,`RESIZING`,`REVOKED`,`SPECIAL_EXIT`

You can use `sq --help` to see what other options you have available.

## Total jobs running

For students (as of my experience), there is a limit of 1000 jobs that you can run at a time. In that case you might be interested in knowing the total number of jobs that you have running. You can use the following command to get the total number of jobs that you have running. I found it on stackoverflow.

```sh
squeue -u <username> -h -t pending,running -r -O "state" | uniq -c
```

## Running Python jobs

`samples/python-job.sh` contains a sample script on how you can run a Python job. You can use this script as a base to run Python jobs.

## Running Multiple jobs with different parameters

You can use inside a script to run multiple jobs with different parameters. If all of the jobs require same resources (time, cpu, memory, etc.), you should try to use job arrays, instead of submitting serial jobs.

`samples/array-jobs.sh` is a sample script that shows how to run multiple jobs using array with different parameters. Here, we have a list of benchmarks that we want to run. Each of them require same resources, so we can use job arrays.

Note that, `#SBATCH --array=0-99` parameter is used in this script. Do not forget to change that according to your requirements. More on [Array jobs](https://docs.computecanada.ca/wiki/Job_arrays).

The reason we do array jobs instead of serial jobs is that with job arrays, CC only evaluates the required resources once hence it is easy for it to prioritize the jobs. If you do serial jobs submission, it has evaluate the required resources everytime.

## Cancelling the jobs

You can use following command to cancel a job.

```sh
scancel <job_id> #job_id is the job ID that you get when you submit the job.
```

You can also see the ids by using `sq` command.

### Cancelling multiple jobs

You can use following command to cancel range jobs in a range.

```sh
scancel {<starting_job_id>..<ending_job_id>}
```

## More on Compute Canada

* Resources from [RLAI Lab](https://docs.google.com/document/d/1wyf4KtyFOPUnvBbUe1_u1JcM00w0WWDtK8djICMrFuc/)
* As mentioned earlier, CC uses slurm. Contrary to CC, you can find a lot of community resources for slurm. So if you want to search for anything, try using the keyword `slurm` with your query on Google instead of `compute canada`.
* [Compute Canada Wiki](https://docs.computecanada.ca/wiki/Getting_started)
* Join `#compute-canada` channel on Amii Slack for discussions or any sort of help.
* Follow [Compute Canada Status](https://twitter.com/CanadaCompute) on Twitter and turn on notifications if you use it regularly. It will keep you updated with the latest status of CC.
