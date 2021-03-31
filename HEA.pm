##This module is developed by Prof. Shin-Pon JU at NSYSU on March 28 2021
package HEA; 

use strict;
use warnings;

our (%element); # density (g/cm3), arrangement, mass

$element{"Al"} = [2.7,"fcc",26.981539]; 
$element{"Mo"} = [10.28,"fcc",95.95]; 
$element{"Nb"} = [8.57,"bcc",92.90638]; 
$element{"Ta"} = [16.69,"bcc",180.94788]; 
$element{"Ti"} = [4.506,"hcp",47.867]; 
$element{"Zr"} = [6.52,"hcp",91.224]; 

sub eleObj {# return properties of an element
    my $elem = shift @_;
    return (@{$element{"$elem"}});
}

1;               # Loaded successfully
