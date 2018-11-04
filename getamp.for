C       GETAMP.FOR               D.H. KLATT              8/1/78
C
C       CONVERT DB ATTEN. (FROM 96 TO -72) TO A LINEAR SCALE FACTOR.
C               (TRUNCATE NDB IF OUTSIDE RANGE)
C
        elemental real FUNCTION GETAMP(NDB)
        use, intrinsic:: iso_fortran_env, only: int16, sp=>real32
        implicit none
        
        INTEGER(int16), intent(in) :: NDB
        integer(int16) :: NDB1, NDB2, NDB3
        REAL(sp) ::  XX1, XX2
        
        real(sp), parameter :: DTABLE(11) =
     &    [1.8,1.6,1.43,1.26,1.12,
     &     1.0,0.89,0.792,0.702,0.623,0.555]

        real(sp), parameter :: STABLE(28) =
     &    [65536.,32768.,16384.,8192.,
     &     4096.,2048.,1024.,512.,256.,128.,
     &      64.,32.,16.,8.,4.,2.,
     &      1.,.5,.25,.125,.0625,.0312,.0156,.0078,.0039,.00195,
     &     .000975,.000487]

        NDB1=NDB
        GETAMP=0.
        IF (NDB1<=-72) RETURN
        IF (NDB1>=96) NDB1=96
        NDB2=NDB1/6
        NDB3=NDB1-(6*NDB2)
        XX1=STABLE(17-NDB2)
        XX2=DTABLE(6-NDB3)
        GETAMP=XX1*XX2

        END function getamp
