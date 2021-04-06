use strict;
use warnings;

#my @jobID = `squeue|sed -n '/jsp PD/p'| awk '{print \$1}'`;
my @jobID = `squeue|sed -n '/jsp/p'| awk '{print \$1}'`;
print "@jobID\n";

for (@jobID){
	chomp;
	system("scancel $_");	
}
