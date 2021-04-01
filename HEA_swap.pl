# We will submit slrum in the local folder

use strict;
use warnings;
use POSIX;
use lib '.';
use HEA;
use Cwd; #Find Current Path

my $slurm = "yes"; # use slurm or not
my $slurmbatch = "slurm.sh"; # slurm batch template
my $lmp_path = "/opt/lammps-mpich-3.4.1/lmp_20210329";
my $lmp_script = "swap.in";# lmp script, you may use different one for your purpose
my $swaptime = 1000;# swap time for each run
my $currentPath = getcwd(); #get perl code path
my $eleNo = 6; #total element types
my $pair0 = "pair_coeff * * ../ref.lib Al0 Mo0 Nb0 Ta0 Ti0 Zr0 ../Bestfitted.meam Al0 Mo0 Nb0 Ta0 Ti0 Zr0";#for swap
my $pair_coeff = "pair_coeff * * ../ref.lib Al Mo Nb Ta Ti Zr ../Bestfitted.meam Al Mo Nb Ta Ti Zr";
# Initial setting
my $folder4read = "original"; #folder to read required files
my $folder4write = "swap"; #folder to write data
my $prefix4write = "swap"; #prefix of the output file
`rm -rf $folder4write`; # remove old folder first
`mkdir $folder4write`; # create a new folder

chdir("$currentPath/$folder4read");
my @lmp_data = <out-*.data>;# get the data you want to read for script
print "lmp_data @lmp_data\n";
## modify script
chdir("$currentPath");

#`sed -i '/#SBATCH.*--job-name/d' $currentPath/$slurmbatch`;
`sed -i '/pair_coeff/d' $currentPath/$lmp_script`;
`sed -i '/pair_style/a $pair0' $currentPath/$lmp_script`;
`sed -i '/.*atom\\/swap.*/d' $currentPath/$lmp_script`;#remove all first
`sed -i '/unfix.*/d' $currentPath/$lmp_script`;#remove all first
my $fixID = 100;
for my $id1 (1..$eleNo-1){
	for my $id2 ($id1+1..$eleNo){
		my $swaprand = POSIX::ceil(10000*rand());
		my $temp = "fix $fixID all atom\/swap 1 $swaptime $swaprand 300.0 ke no types $id1 $id2";
	    `sed -i '/thermo_style/a $temp' $currentPath/$lmp_script`;
	    `sed -i '/run.*/a unfix $fixID' $currentPath/$lmp_script`;
	    $fixID++;
	}	
}

## modify read_data and write_data according to the file path 

for (@lmp_data){
#	print "$_ \n";
	/out-(.*).data/;
	chomp;
	print "$1\n";
	
	my $read_data = "read_data ../$folder4read/$_";
	`sed -i 's:.*read_data.*:$read_data:' $lmp_script`;# modify atom type numbers for the system you want
	my $write_data = "write_data $prefix4write-$1.data";
	`sed -i 's:.*write_data.*:$write_data:' $lmp_script`;# modify atom type numbers for the system you want
#    `sed -i '/log/d' $prefix.in`;
#    `sed -i '1i log $prefix.log' $prefix.in`;

	`sed -i '/#SBATCH.*--job-name/d' $slurmbatch`;
	`sed -i '/#sed_anchor01/a #SBATCH --job-name=$1-$prefix4write' $slurmbatch`;
	
	`sed -i '/#SBATCH.*--output/d' $slurmbatch`;
	`sed -i '/#sed_anchor01/a #SBATCH --output=$1-$prefix4write.out' $slurmbatch`;
	
	`sed -i '/mpiexec.*/d' $slurmbatch`;
	`sed -i '/#sed_anchor02/a mpiexec $lmp_path -l none -in $currentPath/$lmp_script' $slurmbatch`;
	chdir("$currentPath/$folder4write");	
	system("sbatch $currentPath/$slurmbatch");
	chdir("$currentPath");
}
