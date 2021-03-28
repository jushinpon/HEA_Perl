##This module is developed by Prof. Shin-Pon JU at NSYSU on March 28 2021
package HEA; 

use strict;
use warnings;

our (%element); # density (g/cm3), arrangement...

$element{"Al"} = [2.7,"fcc"]; 
$element{"W"} = [19.25,"bcc"]; 

sub eleObj {# return properties of an element
    my $elem = shift @_;
    return (@{$element{"$elem"}});
}

1;               # Loaded successfully