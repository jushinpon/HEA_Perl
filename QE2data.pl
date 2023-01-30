use strict;
use warnings;
use Data::Dumper;
use POSIX;
use lib '.';
use HEA;
use Cwd;
my $currentPath = getcwd();
$dptrain_setting{type_map} = ("Fe","Na","O","P");# json template file
1 55.845
2 22.98977
3 15.9994
4 30.973761
my @elements = ("Co","Ni","Cr","Fe","Mn","Hf","Nb","Ta","Ti","Zr");
my $eletype = @myelement; 
# "Hf","Nb",,"Ta","Ti","Zr"
my $myelement = join ('',@myelement);

my @out = sort `find -name "*.sout"`;
chomp @out;
for (0..$#out){


    my ($out_path) = $out[$_] =~ (m/(.*)\/.*.sout/);
    my ($out_name) = $out[$_] =~ (m/.*\/(.*).sout/);
        
    my @data_num;
    for(0..41){
        push (@data_num , $_+1);
    }

            
    # my $done = `grep -o -a 'DONE' $out[$_]`; 
    # chomp $done;
        
    # if($done eq "DONE" ){
        &makedata("$out[$_]","$currentPath","$out_name", @data_num);
    # }
}

sub makedata 
{
    (my $sout, my $path, my $prefix , my @num) = @_;

    my $natom = `cat "$sout"  |sed -n '/number of atoms\\/cell/p' | sed -n '\$p'| awk '{print \$5}'`;
    chomp $natom;

    &printdata($sout,$sout,$path,$prefix,$natom,@num);
}
 
sub make_ela
{
    (my $sout, my $path, my $prefix , my $num) = @_;
    my ($sout_name) = $sout =~ (m/.*\/(.*).sout/);
    my ($sout_path) = $sout =~ (m/(.*)\/.*.sout/);
    my $in = "$sout_path"."/$sout_name.in";

    my $natom = `cat "$in" |sed -n '/nat/p' |  awk '{print \$3}'`;
    chomp $natom;
    &printdata($in,$in,$path,$prefix,$natom,$num);
}



sub printdata
{

    (my $getbox, my $getposition, my $path, my $prefix, my $natom ,my @num) = @_;


    if(!$natom){die "You don't get the Atom Number!!!\n $getposition";}
    for my $num (@num){
        my $data;
        if($#num == 0 ){
            open $data ,"> $path/$prefix.data";
        }else{
            open $data ,"> $path/$prefix\_$num.data";
        }


    print $data "LAMMPS data file via write_data, version 10 Mar 2021, timestep = 0\n";
    print $data "$natom atoms\n";
    print $data "$eletype atom types\n";

        my @box;
        for(1..3){
            my $sed = "n;" x$_."p";
            my $box1 = `cat $getbox | sed -n '/CELL_PARAMETERS.*/{$sed}' | sed -n '$num p' `;
            my @box1 = split (' ', $box1);
            push (@box ,\@box1);
        }
        my $a = ( @{$box[0]}[0]**2 + @{$box[0]}[1]**2 + @{$box[0]}[2]**2 )**0.5;
        my $b = ( @{$box[1]}[0]**2 + @{$box[1]}[1]**2 + @{$box[1]}[2]**2 )**0.5;
        my $c = ( @{$box[2]}[0]**2 + @{$box[2]}[1]**2 + @{$box[2]}[2]**2 )**0.5;

        ## cos = (a˙b)/a*b 
        my $cosalpha = (@{$box[1]}[0]*@{$box[2]}[0] + @{$box[1]}[1]*@{$box[2]}[1] + @{$box[1]}[2]*@{$box[2]}[2])/($b*$c);
        my $cosbeta = (@{$box[2]}[0]*@{$box[0]}[0] + @{$box[2]}[1]*@{$box[0]}[1] + @{$box[2]}[2]*@{$box[0]}[2])/($c*$a);
        my $cosgamma = (@{$box[0]}[0]*@{$box[1]}[0] + @{$box[0]}[1]*@{$box[1]}[1] + @{$box[0]}[2]*@{$box[1]}[2])/($a*$b);

        my $lx = $a;
        my $xy = $b*$cosgamma;
        my $xz = $c*$cosbeta;
        my $ly = sqrt($b**2 - $xy**2);
        my $yz = ($b*$c*$cosalpha-$xy*$xz)/$ly;
        my $lz = sqrt($c**2 - $xz**2 - $yz**2);
        print $data "0.0 $lx xlo xhi\n";
        print $data "0.0 $ly ylo yhi\n";
        print $data "0.0 $lz zlo zhi\n";
        print $data "$xy $xz $yz xy xz yz\n\n";


    print $data "Masses\n\n";
    for (1..$#myelement+1){
    print $data "$_ "."$HEA{$myelement{$_}}{mass}\n";
    }
    print $data "Atoms\n\n";
    my @position;
        for(1..$natom){
            my $i = $_-1;
            my $sed = "n;" x$_."p";
            my $position1 = `cat $getposition| sed -n '/ATOMIC_POSITIONS.*/{$sed}' | sed -n '$num p' `;
            my @position1 = split (/\s+/, $position1);
            # print Dumper $position1;
            push (@position , \@position1);
            print $data "$_ "."$HEA{@{$position[$i]}[0]}{type}\t"."@{$position[$i]}[1]\t"."@{$position[$i]}[2]\t"."@{$position[$i]}[3]\n";
        }
    close $data;
    }

}
