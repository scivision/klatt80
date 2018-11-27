C       HANDSY.FOR             D. KLATT             6/1/79
C
C           SPECIFY AN ARRAY OF CONTROL PARAMETER DATA
C           AND SYNTHESIZE A SPEECH WAVEFORM
C
C       LOAD WITH PARCOE.FOR, COEWAV.FOR, SETABC.FOR, GETAMP.FOR
C
C   IF THIS PROGRAM DOES NOT FIT INTO CORE, DECREASE D(10050),
C   IWAVE(10050), AND WSIZE ALL BY THE SAME FRACTION
      program klatt80
      use, intrinsic:: iso_fortran_env, only: int16, sp=>real32, 
     &      stderr=>error_unit
      IMPLICIT INTEGER(int16) (A-Z)

      REAL(sp) DB,DBLPNT,EPSLON,XMAXWA
C   EACH OF THE FOLLOWING VARIABLES HOLDS UP TO 5 ASCII CHARACTERS
      CHARACTER(5) QUIT,QUIT1,YES,NO,VAR,CON,ANSWER,MODPAR,SETPNT,DUMMY,
     &               NAMES(39),NAMEX(39),NAMEV
      INTEGER(int16) MAXVAL(39),MINVAL(39),VALUES(39),IPAR(39),
     &           VARPAR(39),LOC(39),LOCSAV(39),D(10050),IWAVE(10050)
      REAL(sp) COEFIC(50), IRAN
      COMMON /PARS/ IPAR
      COMMON /COEFS/ COEFIC
      EQUIVALENCE (D(1),IWAVE(1))

      integer :: u, ios
      character(:), allocatable :: paramfn, outfn
      character(80) :: buf
      logical :: interactive
C
C   3-CHARACTER SYMBOL FOR EACH OF 39 CONTROL PARAMETER VALUES
        DATA NAMES /'AV','AF','AH','AVS','F0','F1','F2','F3','F4','FNZ',
     1 'AN','A1','A2','A3','A4','A5','A6','AB','B1','B2',
     1 'B3','SW','FGP','BGP','FGZ','BGZ','B4','F5','B5','F6',
     1 'B6','FNP','BNP','BNZ','BGS','SR','NWS','G0','NFC'/
C
C   MAXIMUM POSSIBLE VALUE FOR EACH OF 39 CONTROL PARAMETERS
        DATA  MAXVAL/80,80,80,80,500,900,2500,3800,4500,700,
     1 80,80,80,80,80,80,80,80,1000,1500,
     1 2000,1,600,2000,5000,10000,3000,4900,4000,4999,
     1 2000,500,500,500,1000,20000,200,80,6/
C
C   MINIMUM POSSIBLE VALUE FOR EACH OF 39 CONTROL PARAMETERS
        DATA MINVAL/0,0,0,0,0,150,500,1000,2500,200,
     1 0,0,0,0,0,0,0,0,40,40,
     1 40,0,0,100,0,100,100,3500,150,4000,
     1 200,200,50,50,100,5000,1,0,4/
C
C   DETERMINATION OF VARIABLE (=1 OR =2) OR CONSTANT (=0) PRAMETERS
C   (PROGRAM SETS =2 IF ACTUALLY VARIED)
        DATA VARPAR/1,1,1,1,1,1,1,1,1,1,
     1 0,0,1,1,1,1,1,1,1,1,
     1 1,0,0,0,0,0,0,1,0,0,
     1 0,0,0,0,0,0,0,0,0/
C
C   DEFAULT VALUES FOR EACH OF 39 CONTROL PARAMETERS
        DATA VALUES/0,0,0,0,0,450,1450,2450,3300,250,
     1 0,0,0,0,0,0,0,0,50,70,
     1 110,0,0,100,1500,6000,250,3750,200,4900,
     1 1000,250,100,100,200,10000,50,47,5/
C
C   SIZE OF PARAMETER AND WAVEFORM ARRAYS THAT RESIDE IN CORE

        DATA WSIZE/10050/
C
C   NAMES OF SOME RESPONSE CHARACTERS
        DATA QUIT,QUIT1,YES,NO,VAR,CON/'Q','Q','Y','N','V','C'/
        
      print *, ' KLATT CASCADE/PARALLEL FORMANT SYMTHESIZER 6/1/79'
        
        call get_command_argument(1,buf,status=ios)
        if(ios==0) then
          paramfn=trim(buf)
          interactive=.false.
        else
          goto 1140
          interactive=.true.
        endif
        
      
        OPEN(newUNIT=u,FILE=paramfn,ACCESS='SEQUENTIAL',status='old')
        OPENPA=1
        print *, 'READING INITIAL SYNTHESIZER CONFIGURATION: ',paramfn

        DO 1060 M=1,13
        N=M+13
        N1=M+26
        READ(u,2617) DUMMY,NAMES(M),VARPAR(M),VALUES(M),DUMMY,NAMES(N),
     & VARPAR(N),VALUES(N),DUMMY,NAMES(N1),VARPAR(N1),VALUES(N1)
1060    CONTINUE
C
C   CHANGE CONFIGURATION, CHANGE WHICH PARS ARE VARIABLE
        if (command_argument_count() < 2) goto 1740
  
1140    print *, 'PRINT AND/OR CHANGE CONFIGURATION (Y,Q):'
1170    READ (5,1180,ERR=1140) ANSWER
1180    FORMAT (A1)
1185    IF (ANSWER == 'q' .or. answer=='') GO TO 1740
        GO TO 1685
1190    WRITE (6,1220)
1220    FORMAT (/' NAME OF PARAMETER TO BECOME VAR OR CON (QUIT="Q"):'$)
1240    READ (5,1260,ERR=1190) NAMEV
1260    FORMAT (A3)
1270    IF (NAMEV.EQ.QUIT) GO TO 1500
        DO 1280 N=1,39
        IF (NAMEV.EQ.NAMES(N)) GO TO 1320
1280    CONTINUE
        WRITE (6,1300) NAMEV
1300    FORMAT (' ',A5,', TYPING ERROR, TRY AGAIN')
        WRITE (6,1555) (NAMES(M),M=1,39)
        GO TO 1190
1320    MODPAR=YES
        IF (N.LT.35) GO TO 1330
        WRITE (6,1325) NAMES(N)
1325    FORMAT (' PARAMETER ',A3,' CANNOT BE MADE VARIABLE')
        GO TO 1190
1330    IF (VARPAR(N).NE.0) GO TO 1380
1340    VARPAR(N)=1
        WRITE (6,1360)NAMEV
1360    FORMAT (' ',A3,' IS NOW A VARIABLE')
        GO TO 1190
1380    IF (VARPAR(N).NE.2) GO TO 1390
C   IF VARIED IN PREVIOUS SYNTH ATTEMPT, CAN'T MAKE INTO A CONSTANT

        WRITE (6,1385) NAMEV
1385    FORMAT (' ',A3,' CAN NO LONGER BE MADE A CONSTANT')
        GO TO 1190
1390    VARPAR(N)=0
1400    WRITE (6,1420) NAMEV
1420    FORMAT (' ',A3,' IS NOW A CONSTANT')
1440    FORMAT (' DONE')
        GO TO 1190
C
C   CHANGE DEFAULT VALUE FOR A PARAMETER
1500    WRITE (6,1520)
1520    FORMAT (' NAME OF PARAMETER WHOSE ',
     1 'DEFAULT VALUE TO BE CHANGED (QUIT="Q"):'$)
        READ (5,1260,ERR=1550) NAMEV
1530    IF (NAMEV.EQ.QUIT) GO TO 1140
        DO 1540 N=1,39
        IF (NAMEV.EQ.NAMES(N)) GO TO 1560
1540    CONTINUE
1550    WRITE (6,1300) NAMEV
        WRITE (6,1555) (NAMES(M),M=1,39)
1555    FORMAT (' PARS= ',13A4)
        GO TO 1500
1560    IF ((N.NE.36).AND.(N.NE.37)) GO TO 1570
C   DON'T CHANGE NWS OR SR IF READING FROM PARAMETER FILE
        IF (OPENPA.EQ.0) GO TO 1570
        WRITE (6,1565) NAMEV
1565    FORMAT (' CANNOT CHANGE THE VALUE OF ',A3,' ANYMORE')
        GO TO 1500
1570    WRITE (6,1580) NAMEV
1580    FORMAT (' NEW DEFAULT VALUE FOR ',A3,'='$)
        READ (5,1900,ERR=1560) VALUE
1590    IF (VALUE.LE.MAXVAL(N)) GO TO 1620
        WRITE (6,1600)VALUE,MAXVAL(N)
1600    FORMAT (' ',I6,' EXCEEDS MAXIMUM OF ',I5,' TRY AGAIN')
        GO TO 1560
1620    IF (VALUE.GE.MINVAL(N)) GO TO 1660
        WRITE (6,1640)VALUE,MINVAL(N)
1640    FORMAT (' ',I5,' IS LESS THAN MINIMUM=',I5,' TRY AGAIN')
        GO TO 1560
1660    MODPAR=YES
        VALUES(N)=VALUE
        WRITE (6,1440)
        GO TO 1500
C
C     PRINT CONFIGURATION
1680    IF (MODPAR.EQ.NO) GO TO 1740
1685    WRITE (6,1690)
1690    FORMAT (' CURRENT CONFIGURATION (NAME,VAR/CON,DEFAULT-VALUE):')
        DO 1720 M=1,13
        N=M+13
        N1=M+26
        WRITE (6,1700) M,NAMES(M),VARPAR(M),VALUES(M),N,NAMES(N)
     1,VARPAR(N),VALUES(N),N1,NAMES(N1),VARPAR(N1),VALUES(N1)

1700    FORMAT (' ',I2,'  ',A4,I2,I6,2('       ',I2,'  ',A4,I2,I6))
1720    CONTINUE
        GO TO 1190
C
C   COUNT NUMBER OF VARIABLE PARAMETERS, NVAR,
C   AND PLACE NAMES IN NAMEX(NVAR)
1740    NSAMP=VALUES(37)
        DENOM=VALUES(36)/10
        DELTAT=(NSAMP*100)/DENOM
        NVAR=0
      DO N=1,39
        IF (VARPAR(N).EQ.0) cycle
        NVAR=NVAR+1
        LOC(NVAR)=N
        NAMEX(NVAR)=NAMES(N)
      enddo

      IF (NVAR<=0) then
        write(stderr,*) 'ILLEGAL CONFIG, NO VARIABLE PARAMS, TRY AGAIN'
        GO TO 1680
      endif

        MAXDUR=((WSIZE/NSAMP)*DELTAT)-20
        print '(A,I2,A)',' THERE ARE ',NVAR,' VARIABLE PARAMETERS'
        print '(A,I2,A)', ' PARAMETERS ARE TO BE SPECIFIED EVERY ',
     &        DELTAT,' MSEC'
1860    IF (OPENPA.EQ.0) GO TO 1870
        READ(u,2625) VALUE
        WRITE (6,1867) VALUE
1867    FORMAT (' LENGTH OF UTTERANCE IN MSEC = ',I5)
        GO TO 1910
1870    WRITE (6,1880) MAXDUR
1880    FORMAT (' DESIRED LENGTH OF UTTERANCE IN MSEC (MAX=',I4,'):'$)
1885    READ (5,1900,ERR=1860) VALUE
1900    FORMAT (I5)
1910    IF (VALUE.GE.DELTAT) GO TO 1920
        WRITE (6,1300) NAMEV
        GO TO 1860
1920    IF (VALUE.LE.MAXDUR) GO TO 1960
        WRITE (6,1940) VALUE,MAXDUR
1940    FORMAT (' ',I4,' ILLEGAL, MAXIMUM DURATION=',I4,' TRY AGAIN')
        GO TO 1860
1960    UTTDUR=VALUE
C
C   INSERT DEFAULT VALUES INTO PARAMETER TRACKS
        NSAMT1=((UTTDUR+20)/DELTAT)-1
        DO 2000 M=0,NSAMT1
        M1=M*NSAMP
        M2=0
        DO 1980 N=1,39
        IF (VARPAR(N).EQ.0) GO TO 1980
        M2=M2+1
        D(M1+M2)=VALUES(N)
1980    CONTINUE
2000    CONTINUE
        print *, 'DEFAULT VALUES INSERTED IN PARAMETER TRACKS'
C
C     PUT VARIABLE DATA FROM FILE PARAM.DOC INTO PARAMETER TRACKS
2040    IF (OPENPA.EQ.0) GO TO 2050
        print *, ' READING VARIABLE PARAMETRIC DATA FROM:',paramfn
        READ(u,2043) DUMMY,(DUMMY,M=1,NVAR1)
2043    FORMAT (27A5)
        NVAR1=0
      DO N=1,NVAR
        IF (VARPAR(LOC(N)) /= 2) cycle
        NVAR1=NVAR1+1
        LOCSAV(NVAR1)=N
      enddo
      
      IF (NVAR1 == 0) then
        write(stderr,*) 'ILLEGAL CONFIG, NO VARIABLE PARAMS'
        stop 1
      endif

2047    IF (NVAR1.GT.26) NVAR1=26
        NSAMT1=(UTTDUR/DELTAT)-1
        DO 2048 M=0,NSAMT1
        M1=M*NSAMP
        READ (u,2660) TIME,(D(LOCSAV(N)+M1),N=1,NVAR1)
2048    CONTINUE
        CLOSE(u)
C
C     ACCEPT MODIFICATIONS TO PARAMETER TRACKS
2050    OLDTIM=0
        SETPNT=NO
        MAXD1=UTTDUR-DELTAT
        
        if (.not.interactive) goto 2600
        print *,' NAME OF PARAMETER TRACK TO BE MODIFIED (QUIT="Q"):'
2065    READ (5,1260,ERR=2090) NAMEV
2075    IF (NAMEV == 'q' .or. namev=='') GO TO 2600
        DO 2080 N=1,NVAR
        IF (NAMEV.EQ.NAMEX(N)) GO TO 2120
2080    CONTINUE
        WRITE (6,1300) NAMEV
2090    WRITE (6,2100) (NAMEX(M), M=1,NVAR)
2100    FORMAT (' VARIABLE PARS= ',10A4)
        GO TO 2050
2120    CONTINUE
        VARPAR(LOC(N))=2
        MAXV=MAXVAL(LOC(N))
        MINV=MINVAL(LOC(N))
2180    WRITE (6,2200)
2200    FORMAT ('  T='$)
2220    READ (5,2240) TIME
2240    FORMAT (I5)
C
C   QUIT DRAWING CURRENT PARAMETER CONTOUR?

        IF ((TIME.EQ.0).AND.(SETPNT.EQ.YES)) GO TO 2050
        IF (TIME.LT.0) GO TO 2050
C   MAKE SURE LEGAL TIME
        IF (TIME.GE.OLDTIM) GO TO 2280
2255    WRITE (6,2260) TIME,OLDTIM
2260    FORMAT (' ILLEGAL TIME=',I5,', LESS THAN OLDTIM=',I3)
        GO TO 2180
2280    CONTINUE
        IF (TIME.LE.MAXD1) GO TO 2320
        WRITE (6,2300) TIME,MAXD1
2300    FORMAT (' ILLEGAL TIME=',I5,', GREATER THAN MAX=',I3)
        GO TO 2180
2320    NPTS=TIME/DELTAT
        TIME=NPTS*DELTAT
        POINTR=((NPTS)*NSAMP)+N
2330    WRITE (6,2340)
2340    FORMAT ('  V='$)
2345    READ (5,1900) VALUE
C
C     SEE IF LEGAL VALUE 
2369    IF (VALUE.LE.MAXV) GO TO 2400
2370    WRITE (6,2371) MINV,MAXV
2371    FORMAT (' VMIN=',I5,',  VMAX=',I5)
        GO TO 2330
2400    IF (VALUE.GE.MINV) GO TO 2420
        GO TO 2370
2420    IF ((SETPNT.EQ.YES).AND.(TIME.GE.(OLDTIM+DELTAT))) GO TO 2480
C
C   SET A POINT
        D(POINTR)=VALUE
2460    OLDTIM=TIME
        OLDVAL=VALUE
        SETPNT=YES
        GO TO 2180
C
C   DRAW A LINE
2480    NPTS=(TIME-OLDTIM)/DELTAT
        DVALUE=VALUE-OLDVAL
        EPSLON=0.1
        IF (DVALUE.LT.0) EPSLON=-EPSLON
        TIME1=OLDTIM/DELTAT
        DO 2500 M=1,NPTS
        DBLPNT=FLOAT(M)*FLOAT(DVALUE)
        DBLPNT=DBLPNT/FLOAT(NPTS)
        VALUE2=OLDVAL+IFIX(DBLPNT+EPSLON)
        POINTR=((TIME1+M)*NSAMP)+N
2500    D(POINTR)=VALUE2
        GO TO 2460

C   MAKE FILE OF PARAMETER VALUES VS TIME THAT CAN BE LISTED
C   ON LINE PRINTER
2600    OPEN(newUNIT=u,FILE='PARAM.DOC',ACCESS='SEQUENTIAL',
     &       status='replace', action='readwrite')
        DO 2620 M=1,13
        N=M+13
        N1=M+26
        DUMMY='     '
        WRITE (u,2617) DUMMY,NAMES(M),VARPAR(M),VALUES(M)
     1,DUMMY,NAMES(N),VARPAR(N),VALUES(N)
     1,DUMMY,NAMES(N1),VARPAR(N1),VALUES(N1)
2617    FORMAT (1X,3(A5,A3,I2,I5))
2620    CONTINUE
        WRITE (u,2625) UTTDUR
2625    FORMAT (1X,I5)
        NVAR1=0
        DO 2630 N=1,NVAR
        IF (VARPAR(LOC(N)).NE.2) GO TO 2630
        NVAR1=NVAR1+1
        LOCSAV(NVAR1)=N
2630    CONTINUE
        IF (NVAR1.GT.0) GO TO 2640
        write(stderr,*) 'ILLEGAL CONFIG, NO VARIABLE PARAMS, TRY AGAIN'
        GO TO 2900
2640    IF (NVAR1.GT.26) NVAR1=26
        WRITE (u,2650) (NAMEX(LOCSAV(M)),M=1,NVAR1)
2650    FORMAT ('     ',26A5)
        NSAMT1=(UTTDUR/DELTAT)-1
        DO 2665 M=0,NSAMT1
        TIME=M*DELTAT
        M1=M*NSAMP
        WRITE (u,2660) TIME,(D(LOCSAV(N)+M1),N=1,NVAR1)
2660    FORMAT (I5,26I5)
2665    CONTINUE
        CLOSE(u)
        WRITE (6,2667) 
2667    FORMAT (' PARAMETER FILE  "PARAM.DOC"  SAVED')
C
C   SET ALL PARAMETERS IN ARRAY IPAR TO DEFAULT VALUES
2670    IF (PPSW.EQ.1) GO TO 2676
        WRITE (6,2675)
2675    FORMAT (/' BEGIN WAVEFORM GENERATION')
2676    DO 2680 N=1,39
2680    IPAR(N)=VALUES(N)
C
C   INITIALIZE SYNTHESIZER
        MAXWA=-1
        XMAXWA=-1
        IRAN=rand(1988)
C
C   MAIN SYNTHESIZER LOOP, PUT WAVEFORM IN IWAVE(WSIZE1)
C   ADD 20 MSEC TO DURATION TO ENSURE SIGNAL WILL DECAY TO ZERO
        NPTS=(UTTDUR+20)/DELTAT        
        TIME1=0
        WSIZE1=1
        DO 2740 M=1,NPTS
        POINTR=(M-1)*NSAMP
        DO 2700 N=1,NVAR
2700    IPAR(LOC(N))=D(POINTR+N)
        CALL PARCOE(MAXWA)
        CALL COEWAV(IWAVE(WSIZE1),XMAXWA)
2740    WSIZE1=WSIZE1+NSAMP
C
C   MAKE SURE SIGNAL IS LESS THAN OR EQUAL TO 0.0 DB 
        DB=20.*LOG10(XMAXWA/32767.)
        WRITE (6,2760) DB
2760    FORMAT (' PEAK SIGNAL LEVEL ',
     1 'IN SYNTHETIC WAVEFORM =',F6.1,' DB')
C
C
C   SAVE WAVEFORM FILE IWAVE(WSIZE1) ON DISK

        outfn='wave.raw'
        OPEN(newUNIT=u,FILE=outfn,ACCESS='stream',STATUS='replace', 
     &       action='write')
        DO M=1,WSIZE1
          WRITE (u) IWAVE(M)
        enddo
        CLOSE (u)
        
        print *, 'WAVEFORM FILE  ',outfn,'  SAVED.'
2900    END
