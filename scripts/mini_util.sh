#!/bin/bash
# =======================================================================
#
#       Utility Shell Finctions for WRF_LETKF
#
#                                                   2010.05.11 M.Kunii
# =======================================================================

# -----------------------------
#    date_edit
# -----------------------------
date_edit () {
(

        if [ $# -lt 7 ]; then
                echo "Usage : date_edit"
                echo "    date_edit [yyyy] [mm] [dd] [hh] [mn] [dt(min)]"
                echo "    ex) date_edit 201005051200 -180"
                exit
        fi

        yy=$1
        mm=$2
        dd=$3
        hh=$4
        mn=$5
        ss=$6
        dt=$7

        echo $yy-$mm-$dd $hh:$mn:$ss

        seconds=`date +%s -d"$yy-$mm-$dd $hh:$mn:$ss UTC"`

        seconds=`expr $seconds + $dt \* 60 `


        date -u +%Y%m%d%H%M%S -d"@$seconds "


)
}


date_edit2 () {
(

        if [ $# -lt 2 ]; then
                echo "Usage : date_edit"
                echo "    date_edit [yyyy][mm][dd][hh][mn] [dt(sec)]"
                echo "    ex) date_edit 201005051200 -60"
                exit
        fi

        CDATEL=$1
        dt=$2

        cy=`echo $CDATEL | cut -c1-4`
        cm=`echo $CDATEL | cut -c5-6`
        cd=`echo $CDATEL | cut -c7-8`
        ch=`echo $CDATEL | cut -c9-10`
        cn=`echo $CDATEL | cut -c11-12`
        cs=`echo $CDATEL | cut -c13-14`

        seconds=`date +%s -d"$cy-$cm-$cd $ch:$cn:$cs UTC"`

        seconds=`expr $seconds + $dt `


        date -u +%Y%m%d%H%M%S -d"@$seconds "


)
}

ens_member () {

local    MEMBER="$1"
local    MEMBER_STR=$MEMBER
   
    echo `add_zeros $1 5 `
}

forecast_lead () {

local    FLEADT="$1"
local    FLEADT_STR=$FLEADT


    if test $FLEADT -lt 1000000
    then
      FLEADT_STR=0$FLEADT_STR
    fi
    if test $FLEADT -lt 100000
    then
      FLEADT_STR=0$FLEADT_STR
    fi
    if test $FLEADT -lt 10000
    then
      FLEADT_STR=0$FLEADT_STR
    fi
    if test $FLEADT -lt 1000
    then
      FLEADT_STR=0$FLEADT_STR
    fi
    if test $FLEADT -lt 100
    then
      FLEADT_STR=0$FLEADT_STR
    fi
    if test $FLEADT -lt 10
    then
      FLEADT_STR=0$FLEADT_STR
    fi

    echo $FLEADT_STR
}


wrfout_file_name () {

local    DATE="$1"
local    DOMAIN="$2"
  
    cy=`echo $DATE | cut -c1-4`
    cm=`echo $DATE | cut -c5-6`
    cd=`echo $DATE | cut -c7-8`
    ch=`echo $DATE | cut -c9-10`
    cn=`echo $DATE | cut -c11-12`
    cs=`echo $DATE | cut -c13-14`

    echo wrfout_d${DOMAIN}_${cy}-${cm}-${cd}_${ch}:${cn}:${cs}
}

date_in_wrf_format() {


local    DATE="$1"

    cy=`echo $DATE | cut -c1-4`
    cm=`echo $DATE | cut -c5-6`
    cd=`echo $DATE | cut -c7-8`
    ch=`echo $DATE | cut -c9-10`
    cn=`echo $DATE | cut -c11-12`
    cs=`echo $DATE | cut -c13-14`

    echo ${cy}-${cm}-${cd}_${ch}:${cn}:${cs}

}

edit_namelist_obsope () {

        NAMELIST=$1

    sed -i 's/@NBV@/'${MEMBER}'/g'                                  $NAMELIST
    sed -i 's/@NSLOTS@/'${NSLOTS}'/g'                               $NAMELIST
    sed -i 's/@NBSLOT@/'${NBSLOT}'/g'                               $NAMELIST
    sed -i 's/@GROSS_ERROR@/'${GROSS_ERROR}'/g'                     $NAMELIST
    sed -i 's/@NRADARS@/'${NRADARS}'/g'                             $NAMELIST
    sed -i 's/@SLOTSTEP@/'${SLOTSTEP}'/g'                           $NAMELIST
    sed -i 's/@SLOTOFFSET@/'${SLOTOFFSET}'/g'                       $NAMELIST
    sed -i 's/@DO_OBSGRID@/'${DO_OBSGRID}'/g'                       $NAMELIST
    sed -i 's/@REGRID_RES@/'${REGRID_RES}'/g'                       $NAMELIST 
    sed -i 's/@REGRID_VERT_RES@/'${REGRID_VERT_RES}'/g'             $NAMELIST
    sed -i 's/@REGRID_VERT_ZRES@/'${REGRID_VERT_ZRES}'/g'           $NAMELIST
    sed -i 's/@NAREA@/'${NAREA}'/g'                                 $NAMELIST
    sed -i 's/@VLON1@/'${VLON1}'/g'                                 $NAMELIST
    sed -i 's/@VLON2@/'${VLON2}'/g'                                 $NAMELIST
    sed -i 's/@VLAT1@/'${VLAT1}'/g'                                 $NAMELIST
    sed -i 's/@VLAT2@/'${VLAT2}'/g'                                 $NAMELIST
 
}

add_zeros() {

	local number=$1
	local size=$2

	local result=`printf "%0${size}d" $number`

	echo $result

}



