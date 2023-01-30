#!/usr/bin/perl
use strict;
use warnings;
my @names=('A','C','C','D','E');
my $names=join("\n", sort(@names));
#print $names";
#die; 
my %QE_para = (
calculation => "vc-md",
output_file => "test.in",
coord => "$names"
);

&QEinput(\%QE_para); 

######here doc for QE input##########
sub QEinput{

my ($QE_hr) = @_;

my $QEinput = <<"END_MESSAGE";
&CONTROL
calculation = "$QE_hr->{calculation}"
nstep = 200
etot_conv_thr = 1.0d-5
forc_conv_thr = 1.0d-4
disk_io = 'none'
pseudo_dir = '/opt/QEpot/SSSP_precision_pseudos/'
tprnfor = .true.
tstress = .true.
verbosity = 'high'
dt = 50
/
!controlend
&SYSTEM
ntyp = 2
occupations = 'smearing'
smearing = 'gaussian'
degauss =   7.3498618000d-03
ecutrho =   4.400d+02
ecutwfc =   8.0d+01 
ibrav = 0
nat = 4
nosym = .TRUE.
starting_magnetization(1) =   1.0000000000d-01
starting_magnetization(2) =   1.0000000000d-01
nspin = 2
!systemend
/
&ELECTRONS
conv_thr =   2.0000000000d-10
electron_maxstep = 1000
mixing_beta =   4.0000000000d-01
/
&IONS
ion_dynamics = "beeman"
ion_temperature = "rescaling"
tempw = 500
/
&CELL
!press_conv_thr = 0.1
cell_dynamics = "pr"
press = 0
/
K_POINTS {automatic}
2 2 2 0 0 0
ATOMIC_SPECIES
B  10.81  B_pbe_v1.01.uspp.F.UPF
N  14.007  N.oncvpsp.upf
ATOMIC_POSITIONS {angstrom}
B -1.022455e-06 1.450073593782 2.066949
B 1.255801197472 0.725035709336 6.200847
N 0 0 2.066949
N 0 0 6.200847
$QE_hr->{coord}
CELL_PARAMETERS {angstrom}
2.51159965 0 0
-1.255799474983 2.175109303119 0
0.000000000000 0.000000000000 8.267796
!End
END_MESSAGE

my $temp = $QE_hr->{output_file};
open(FH, '>', $QE_hr->{output_file}) or die $!;
print FH $QEinput;
close(FH);

#`cat << $QEinput > $temp`;

}