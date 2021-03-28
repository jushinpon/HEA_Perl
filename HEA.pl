use strict;
use warnings;
use lib '.';
#use EPMS;
#require HEA.pm;
use HEA;
my @myelement = ("Al","W");

for (@myelement){
    chomp;
    my @temp = &HEA::eleObj("$_");
    print "element: $_, properties: @temp\n";    
}
