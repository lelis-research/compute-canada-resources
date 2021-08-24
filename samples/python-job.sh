#!/bin/bash
#SBATCH --cpus-per-task=16   # maximum CPU cores per GPU request: 6 on Cedar, 16 on Graham.
#SBATCH --mem=12000M        # memory per node
#SBATCH --time=0-12:00      # time (DD-HH:MM)
#SBATCH --output=%N-%j.out  # %N for node name, %j for jobID
#SBATCH --account=<def-someuser>

module load python/3.6
python3 src/main.py
