#!/bin/bash


# Program Description: This program runs the feat analysis fora set of tasks for 1 single subject.

# Author: Negin Nadvar

# Date: Apr 25, 2019

# Notes: This is the right directory for 'func' and 'scripts' on my own computer. 
# 		 Since I copied the data over to brainbox at the end of my analysis, if you
# 		 want to run the code on brain box please change these to the following:

# 	     dataDir=~/Projects/Psych808FinalProject/Data/func
# 		 scriptDir=~/Projects/Psych808FinalProject/scripts

#Data and script directories
dataDir=~/Zdrive/UM/Psych808FinalProject/Data/func
scriptDir=~/Zdrive/UM/Psych808FinalProject/scripts

# Change to the data directory
cd $dataDir


# --------------Initialize a few variables before entring the for-loop ---------------

# keeps track of the iteration in the loop
n=-1 
#EVs hold all the EV filenames related to each task in order
EVs=(EV_FLASH_ON.txt EV_SANDPAPER_ACTIVE.txt EV_SHAPE_ACTIVE.txt EV_VENTRILI_ACTIVE.txt EV_IMAGIN_ACTIVE.txt );
#TRs hold all the TR numbers related to each task in order
TRs=(420 226 226 402 226);
#DelVols hold the number of volumes that needs to be deleted from the beginning of each functional run, 
#related to each task in order
DelVols=(0 1 1 0 1);
#These variables hold the line strings in design.fs related to the number of deleted volumes and TRs 
#for the very first template run. 
DelVolstxt_old="set fmri(ndelete) 0";
TRstxt_old="set fmri(npts) 420";


# ----------- Each iteration of this for loop prepares and run one task-related analysis -----------


for task in "righteyeflash" "sandpaper1" "shape1" "ventriloquist1" "visualimagery1" ; do


	echo "******** task $task is being processed ********"
	let n=n+1
	echo $n

	#Change the current directory to the current run directory
	cd $dataDir/$task/run_01
	# Copy the template design file to the current run directory
	cp -f ../../../../scripts/design.fsf .
	
	#Pick the current EV filename, TR numbers and deleted volumes to be used next
	EVfname=${EVs[$n]} ;
	echo $EVfname
    TR=${TRs[$n]} ;
	echo $TR
  	DelVol=${DelVols[$n]} ;
	echo $DelVol

	# Define the new lines to be used in the template design file to reflect the nubmer of 
	#deleted volumes and TRs for the current run
	DelVolstxt_new="set fmri(ndelete) ${DelVol}";
	TRstxt_new="set fmri(npts) ${TR}";

	#Replace the appropriate variables/line of codes in the template design file per the new run
	sed -i "s|EV_FLASH_ON.txt|${EVfname}|g ; s|lefteyeflash|${task}|gI ; s|${DelVolstxt_old}|${DelVolstxt_new}|g ; s|${TRstxt_old}|${TRstxt_new}|g"  design.fsf
	chmod 777 ./design.fsf

	
	echo "===> starting feat for ${task}"
	#Run the feat analysis for the current run
	feat design.fsf

done

echo