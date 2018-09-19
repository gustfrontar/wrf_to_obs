#!/bin/bash
# =======================================================================
#
#  Verification against observations      
#
# =======================================================================


#This function uses the offline observation operator to 
#generate verfication files for the forecast.

CDATEL=20170926000000    #Forecast start date
EDATEL=20170927120000    #Forecast end date  
FOUTPUTFREQ=3600 #Forecast output frequency in seconds.
TMPDIR=/tmpdir/    #TMP directory.
NAMELISTOBSOPE=./obsope.namelist  #Namelist to be used to control offline obsope module.
NPROCS=10
FORECASTDIR=/forecast/
OBSDIR=/obs/
RADAROBSDIR=/radarobs/
NRADARS=1
MAX_DOM=1
MEMBER=10
NSOLTS=1
NBSLOT=1
GROSS_ERROR=10
SLOTSTEP=1
SLOTOFFSET=0
REGRID_RES="20.0e3"
DO_OBSGRID=.FALSE.
REGRID_VERT_RES=100.0
REGRID_VERT_ZRES=1000.0
NAREA=1
VLON1=-60
VLON2=-30
VLAT1=-10
VLAT2=-60

source ./mini_utils.sh 

WORKDIR=$TMPDIR/verification/

rm -fr $TMPDIR/*.txt
rm -fr $TMPDIR/*.grd

#Prepare namelist for observation operator
cp $NAMELISTOBSOPE $TMPDIR/verification/obsope.namelist

edit_namelist_obsope $TMPDIR/verification/obsope.namelist

INIMEMBER=1
ENDMEMBER=$MEMBER


if [ $FORECAST -eq 1  ] ; then

my_domain=1
while [ $my_domain -le $MAX_DOM ] ; do

 my_domain=` add_zeros $my_domain 2 `
 

 output_dir=${FORECASTDIR}/obsver_d$my_domain
 mkdir -p $output_dir

 my_date=$CDATEL
 S=1
 while [ $my_date -le $EDATEL ] ; do

  my_file_name=`wrfout_file_name ${my_date} $my_domain `
  SLOT=`add_zeros $S 2 `

  M=$INIMEMBER
  while [ $M -le $ENDMEMBER ] ; do
    MEM=`ens_member $M `
    ln -sf ${FORECASTDIR}/${MEM}/${my_file_name}       ${WORKDIR}/gs${SLOT}${MEM}              
    M=`expr $M + 1 `
  done

  #Get conventional obs.
  ln -sf ${OBSDIR}/${my_date}.dat                       ${WORKDIR}/obs${SLOT}.dat     
  #Get radar obs.
  it=1
  while [ $it -le $NRADARS  ] ; do
     it=`add_zeros $it 2 `
     cp -f $RADAROBSDIR/radar${it}_${my_date}.dat $DESTDIR/rad${SLOT}${itradar}.dat
  done 

  my_date=`date_edit2 $my_date $FOUTPUTFREQ `
  S=`expr $S + 1 `
 done

 cd ${WORKDIR}/      
 mpiexec -np $NPROCS ./obsope.exe   > ${output_dir}/obsop.log     
 mv ${WORKDIR}/*.grd       ${output_dir}                                        
 mv ${WORKDIR}/*.txt       ${output_dir}                                      
 mv ${WORKDIR}/obsope????? ${output_dir}                                     
 mv ${WORKDIR}/OBSO-???    ${output_dir}                                    


 my_domain=`expr $my_domain + 1 `
done


