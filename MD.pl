use strict;
use warnings;
use  Cwd;
my $path = getcwd();
my @myelement = sort ("Ag","Mn","Ge");
my $myelement = join ('',@myelement);
my $slurmbatch = "QE_slurmMD.sh"; #slurm filename

my $QE_path = "/opt/QEGCC_MPICH3.4.2-cp/bin/pw.x";
my @pressure = ("0");  #!!!!!! pressure !!!!!!
my @temperature = ("300","600","900"); #!!!!!! temperature !!!!!!

my $foldername = `find  $path/$myelement/Opt -type d -name "Opt-*"`;
my @foldername = split("\n", $foldername);
@foldername = sort @foldername;


for my $id (0..$#foldername){

    my @dataname = map (($_ =~ m/Opt-(\w+-\w+)/g),$foldername[$id]);
    `rm -rf $path/$myelement/Opt/Opt-@dataname/MD`;

    foreach my $temp (@temperature)
    {
        foreach my $press (@pressure)
        { 
        system("mkdir -p $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname");

        `cp $path/$myelement/Opt/Opt-@dataname/Opt-@dataname.in $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in`;

        system("sed -i 's/!press = 0/press = $press/' $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");
        system("sed -i 's/vc-relax/vc-md/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");
        system("sed -i 's/!ion_temperature/ion_temperature/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");
        system("sed -i 's/ion_dynamics = \"bfgs\"/ion_dynamics = \"beeman\"/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");                 
        system("sed -i 's/!tempw = 0/tempw = 300/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in"); 
        system("sed -i 's/cell_dynamics = \"bfgs\"/cell_dynamics = \"pr\"/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");
        system("sed -i 's/!tempw = 0/tempw = 300/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");
        
        chdir("$path/$myelement/Opt/Opt-@dataname/Opt-@dataname.sout");
        system("sed -i 's/4.07378999274266 0 0/3.970142198   0.000000000   0.000000000/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");
        system("sed -i 's/0 4.07378999274266 0/0.000000000   3.970021222   0.000000000/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");
        system("sed -i 's/0 0 4.07378999274266/0.000000000   0.000000000   3.555404611/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");

        system("sed -i 's/Ge 2.03689499637133 2.03689499637133 0/Ge            1.9850908349        1.9849915988        0.0000002732/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");
        system("sed -i 's/Mn 2.03689499637133 0 2.03689499637133/Mn            1.9850634444       -0.0000078247        1.7777022127/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");
        system("sed -i 's/Mn 0 2.03689499637133 2.03689499637133/Mn            0.0000069700        1.9850182157        1.7777022299/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");
        system("sed -i 's/Ge 0 0 0/Ge           -0.0000190515        0.0000192322       -0.0000001047/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");

        system("sed -i 's/3.9385432118112 0 0/4.263977748   0.000000000   0.000000000/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");
        system("sed -i 's/0 3.9385432118112 0/0.000000000   4.263977705   0.000000000/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");
        system("sed -i 's/0 0 3.9385432118112/0.000000000   0.000000000   3.888650351/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");

        system("sed -i 's/Ag 1.9692716059056 1.9692716059056 0/Ag            2.1319889061        2.1319890181       -0.0000000306/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");
        system("sed -i 's/Mn 1.9692716059056 0 1.9692716059056/Mn            2.1319885288        0.0000003112        1.9443251605/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");
        system("sed -i 's/Mn 0 1.9692716059056 1.9692716059056/Mn            0.0000003232        2.1319884210        1.9443251668/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");
        system("sed -i 's/Ag 0 0 0/Ag           -0.0000000101       -0.0000000450        0.0000000542/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");
        
        system("sed -i 's/4.23242448699348 0 0/5.221568020   0.000000000   0.000000000/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");
        system("sed -i 's/0 4.23242448699348 0/0.000000000   5.221566552   0.000000000/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");
        system("sed -i 's/0 0 4.23242448699348/0.000000000   0.000000000   2.788179462/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");

        system("sed -i 's/Ag 2.11621224349674 2.11621224349674 0/Ag            2.6107790214        2.6108206959       -0.0000019510/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");
        system("sed -i 's/Ge 2.11621224349674 0 2.11621224349674/Ge            2.6107917961        0.0000750120        1.3940917968/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");
        system("sed -i 's/Ge 0 2.11621224349674 2.11621224349674/Ge           -0.0000076602        2.6107084566        1.3940917140/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");
        system("sed -i 's/Ag 0 0 0/Ag            0.0000048622       -0.0000376126       -0.0000020975/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");
        
        system("sed -i 's/4.0853 0 0/4.237224970   0.000000000   0.000000000/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");
        system("sed -i 's/0 4.0853 0/0.000000000   4.237229296   0.000000000/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");
        system("sed -i 's/0 0 4.0853/0.000000000   0.000000000   4.237228226/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");

        system("sed -i 's/Ag 2.04265 2.04265 0/Ag            2.1186122359        2.1186151593        0.0000005866/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");
        system("sed -i 's/Ag 2.04265 0 2.04265/Ag            2.1186118092       -0.0000010819        2.1186133214/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");
        system("sed -i 's/Ag 0 2.04265 2.04265/Ag            0.0000002423        2.1186153795        2.1186136754/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");
        system("sed -i 's/Ag 0 0 0/Ag            0.0000006825       -0.0000001604        0.0000006422/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");

        system("sed -i 's/5.6575 0 0/5.835375212   0.000000000   0.000000000/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");
        system("sed -i 's/0 5.6575 0/0.000000000   5.835375211   0.000000000/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");
        system("sed -i 's/0 0 5.6575/0.000000000   0.000000000   5.835375210/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");

        system("sed -i 's/Ge 4.243125 4.243125 1.414375/Ge            4.3765308700        4.3765307762        1.4588449465/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");
        system("sed -i 's/Ge 4.243125 1.414375 4.243125/Ge            4.3765309801        1.4588430957        4.3765309991/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");
        system("sed -i 's/Ge 2.82875 2.82875 0/Ge            2.9176869791        2.9176874791       -0.0000002227/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");
        system("sed -i 's/Ge 2.82875 0 2.82875/Ge            2.9176875395        0.0000005954        2.9176875336/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");
        system("sed -i 's/Ge 1.414375 4.243125 4.243125/Ge            1.4588441295        4.3765320551        4.3765311265/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");
        system("sed -i 's/Ge 0 2.82875 2.82875/Ge            0.0000007453        2.9176871125        2.9176881643/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");
        system("sed -i 's/Ge 1.414375 1.414375 1.414375/Ge            1.4588440618        1.4588445301        1.4588441261/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");
        system("sed -i 's/Ge 0 0 0/Ge            0.0000003301       -0.0000000123       -0.00000104432/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");

        system("sed -i 's/8.9125 0 0/8.912500000   0.000000000   0.000000000/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");
        system("sed -i 's/0 8.9125 0/0.000000000   8.912500000   0.000000000/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");
        system("sed -i 's/0 0 8.9125/0.000000000   0.000000000   8.912500000/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");

        system("sed -i 's/Mn 4.45625 4.45625 4.45625/Mn            4.4562500000        4.4562500000        4.4562500000/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");
        system("sed -i 's/Mn 0 0 0/Mn            0.0000000000        0.0000000000        0.0000000000/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in");
        


                                                                               #/home/zhi/QEmain/AgGeMn/Opt/Opt-fcc-AgMn/MD/900K0Gpa-fcc-AgMn/900K0Gpa-fcc-AgMn.in
        #`sed -i '/#SBATCH.*--job-name/d' $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.in`;
	    #`sed -i '/#sed_anchor01/a #SBATCH --job-name=$temp\\K$press\\Gpa-@dataname' $slurmbatch`;
        

    

        `sed -i '/#SBATCH.*--job-name/d' $slurmbatch`;
	    `sed -i '/#sed_anchor01/a #SBATCH --job-name=$temp\\K$press\\Gpa-@dataname' $slurmbatch`;
	
	    `sed -i '/#SBATCH.*--output/d' $slurmbatch`;
	    `sed -i '/#sed_anchor01/a #SBATCH --output=$temp\\K$press\\Gpa-@dataname.sout' $slurmbatch`;
	
        `sed -i '/mpiexec.*/d' $slurmbatch`;
        `sed -i '/#sed_anchor02/a mpiexec $QE_path -in $temp\\K$press\\Gpa-@dataname.in' $slurmbatch`;
         #`sed -i '/mpiexec.* /opt/QEGCC/bin/pw.x/d' $slurmbatch`;
         #`sed -i '/#sed_anchor02/a mpiexec /opt/QEGCC_MPICH3.3.2/bin/pw.x -in Optimize$foldname.data.in' $slurmbatch`;
        `cp $slurmbatch $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K$press\\Gpa-@dataname/$temp\\K$press\\Gpa-@dataname.sh`;
        chdir("$path/$myelement/Opt/Opt-@dataname/MD/$temp\K$press\Gpa-@dataname");
        system("sbatch $temp\\K$press\\Gpa-@dataname.sh");
        chdir("$path");

        }

 
        # system("mkdir -p $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K-00Gpa-@dataname"); #make MD folder

        # `cp $path/$myelement/Opt/Opt-@dataname/Opt-@dataname.in $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K-00Gpa-@dataname/$temp\\K-00Gpa-@dataname.in`;

        # system("sed -i 's/!press = 0/press = 0/' $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K-00Gpa-@dataname/$temp\\K-00Gpa-@dataname.in");
        # system("sed -i 's/vc-relax/vc-md/' $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K-00Gpa-@dataname/$temp\\K-00Gpa-@dataname.in");
        # system("sed -i 's/!ion_temperature/ion_temperature/' $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K-00Gpa-@dataname/$temp\\K-00Gpa-@dataname.in");
        # system("sed -i 's/ion_dynamics = \"bfgs\"/ion_dynamics = \"beeman\"/' $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K-00Gpa-@dataname/$temp\\K-00Gpa-@dataname.in");                    
        # system("sed -i 's/!tempw = 0/tempw = $temp/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K-00Gpa-@dataname/$temp\\K-00Gpa-@dataname.in");  
        # system("sed -i 's/cell_dynamics = \"bfgs\"/cell_dynamics = \"pr\"/'  $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K-00Gpa-@dataname/$temp\\K-00Gpa-@dataname.in"); 


        # `sed -i '/#SBATCH.*--job-name/d' $slurmbatch`;
	    # `sed -i '/#sed_anchor01/a #SBATCH --job-name=$temp\\K-00Gpa-@dataname' $slurmbatch`;
	
	    # `sed -i '/#SBATCH.*--output/d' $slurmbatch`;
	    # `sed -i '/#sed_anchor01/a #SBATCH --output=300K-$temp\\K-00Gpa-@dataname.sout' $slurmbatch`;
	
        # `sed -i '/mpiexec.*/d' $slurmbatch`;
        # `sed -i '/#sed_anchor02/a mpiexec $QE_path -in $temp\\K-00Gpa-@dataname.in' $slurmbatch`;
        #  #`sed -i '/mpiexec.* /opt/QEGCC/bin/pw.x/d' $slurmbatch`;
        #  #`sed -i '/#sed_anchor02/a mpiexec /opt/QEGCC_MPICH3.3.2/bin/pw.x -in Optimize$foldname.data.in' $slurmbatch`;
        # `cp $slurmbatch $path/$myelement/Opt/Opt-@dataname/MD/$temp\\K-00Gpa-@dataname/$temp\\K-00Gpa-@dataname.sh`;
        # chdir("$path/$myelement/Opt/Opt-@dataname/MD/$temp\\K-00Gpa-@dataname/");
        # # system("sbatch $temp\\K-00Gpa-@dataname.sh");
        # chdir("$path");


    }
}


