#!/bin/tcsh 

# setup the environment a bit (more speed, fewer warnings)
setenv AFNI_IMSAVE_WARNINGS    NO
setenv AFNI_THRESH_INIT_EXPON  0
setenv AFNI_NOSPLASH           YES
setenv AFNI_SPLASH_MELT        NO
setenv AFNI_STARTUP_WARNINGS   NO
setenv AFNI_NIFTI_TYPE_WARN    NO
setenv AFNI_NO_OBLIQUE_WARNING YES
#setenv AFNI_IMAGE_GLOBALRANGE  VOLUME
setenv AFNI_IMAGE_LABEL_IJK    NO 
setenv AFNI_IMAGE_ZOOM_NN      YES
setenv AFNI_NEVER_SAY_GOODBYE  YES
setenv AFNI_MOTD_CHECK         NO
setenv AFNI_NIFTI_TYPE_WARN    NO


# define all variables used in AFNI drive command
set read_ulay    = "MNI152_2009_template_SSW.nii.gz"  
set read_olay    = "TSNR.vreg.r01.sub-002+tlrc.HEAD"  
set read_dir     = "."  
set crossh       = "SINGLE"  
set see_olay     = "+"  
set pbar_sign    = "+"  
set ncolors      = "99"  
set topval       = "1"  
set my_cbar      = "CET_L17"  
set XXX_NPANE    = ""  
set com_pbar_str = "PBAR_SAVEIM QC_sub-002/media/qc_18_regr_tsnr_vreg.pbar.jpg dim=64x512H"  
set subbb        = ( 0 0 0 )
set com_ulay_str = "SET_ULAY_RANGE A.all 0.000000 1296.724320"  
set frange       = "143"  
set thrnew       = "0"  
set thrflag      = "*"  
set olay_alpha   = "No"  
set olay_boxed   = "No"  
set func_resam   = "NN"  
set xh_gap       = "-1"  
set OW           = "OPEN_WINDOW"  
set opac         = "5"  
set butpress     = ""  
set mx           = "7"  
set my           = "1"  
set mgap         = "1"  
set mcolor       = "black"  
set gapord       = ( 20 25 22 )
set scropx       = ( 0 0 )  
set scropy       = ( 0 0 )  
set ccropx       = ( 0 0 ) 
set ccropy       = ( 0 0 )  
set acropx       = ( 0 0 )  
set acropy       = ( 0 0 )  
set coor_type    = "SET_DICOM_XYZ"
set coors        = ( 1 17 5 )  
set ftype        = "JPEG"  
set odir         = "QC_sub-002/media"  
set impref       = "qc_18_regr_tsnr_vreg"  
set bufac        = "2"  
set do_quit      = "QUITT"  

set view_planes = ( )
if ( 1 && "1" != "1" ) then
    set view_planes = ( ${view_planes:q} -com "SAVE_${ftype} axialimage    ${odir}/${impref}.axi blowup=${bufac}" )
endif
if ( 1 && "1" != "1" ) then
    set view_planes = ( ${view_planes:q} -com "SAVE_${ftype} sagittalimage ${odir}/${impref}.sag blowup=${bufac}" )
endif
if ( 0 && "1" != "1" ) then
    set view_planes = ( ${view_planes:q} -com "SAVE_${ftype} coronalimage  ${odir}/${impref}.cor blowup=${bufac}" )
endif

# port communication
set portnum = 0

# the drive command itself (without quitting)
afni -q -no1D  -noplugins -no_detach  -echo_edu          \
    -npb ${portnum}  -all_dsets                                      \
    -com "SWITCH_UNDERLAY ${read_ulay}"                              \
    -com "SWITCH_OVERLAY  ${read_olay}"                              \
    -com "SEE_OVERLAY     +"                               \
    -com "OPEN_WINDOW sagittalimage opacity=5               \
           mont=7x1:20:1:black           \
           crop=0:0,0:0" \
    -com "OPEN_WINDOW coronalimage  opacity=5               \
           mont=7x1:25:1:black           \
           crop=0:0,0:0" \
    -com "OPEN_WINDOW axialimage    opacity=5               \
           mont=7x1:22:1:black           \
           crop=0:0,0:0" \
    -com "SET_PBAR_ALL    +99 1 CET_L17"   \
    -com "PBAR_SAVEIM QC_sub-002/media/qc_18_regr_tsnr_vreg.pbar.jpg dim=64x512H"                                             \
    -com "SET_SUBBRICKS   0 0 0"                                  \
    -com "SET_ULAY_RANGE A.all 0.000000 1296.724320"                                             \
    -com "SET_FUNC_RANGE  143"                                 \
    -com "SET_THRESHNEW   0 *"                          \
    -com "SET_FUNC_ALPHA  No"                               \
    -com "SET_FUNC_BOXED  No"                               \
    -com "SET_FUNC_RESAM  NN.NN"               \
    -com "SET_XHAIRS      ${crossh}"                                 \
    -com "SET_XHAIR_GAP   -1"                                 \
    -com "SET_DICOM_XYZ 1 17 5"                                         \
    ${view_planes:q}                                                 \
    ${read_dir} &

set l = `prompt_popup -message \
"APQC, regr: tsnr_vreg\n\n\
\n\n\
Initial ulay dataset : ${read_ulay}\n\
Initial olay dataset : ${read_olay} (${see_olay})\n\
\n" \
-b '          Done - Close AFNI GUI          '`


if ("$l" != "1") then
    echo "+* Warn: AFNI driving guidance message failed to open"
endif

echo "++ Quiet talkers"
@Quiet_Talkers -quiet -npb_val ${portnum}

echo "================================================="
echo "++ Goodbye, and thank you for checking your data."

