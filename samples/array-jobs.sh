#!/bin/bash
#SBATCH --cpus-per-task=1   # maximum CPU cores per GPU request: 6 on Cedar, 16 on Graham.
#SBATCH --mem=16000M        # memory per node
#SBATCH --time=0-02:00      # time (DD-HH:MM)
#SBATCH --output=%N-%A-%a.out  # %N for node name, %j for jobID
#SBATCH --account=<def-someuser>
#SBATCH --array=0-99

module load python/3.6

lines=(`cat benchmarks`)

# SLURM_ARRAY_TASK_ID represents the index of the current job.

echo ${lines[SLURM_ARRAY_TASK_ID]}
python3 main.py ${lines[SLURM_ARRAY_TASK_ID]}
