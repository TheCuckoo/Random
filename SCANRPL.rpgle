     H DFTACTGRP(*NO)
     H ACTGRP(*NEW)
     H DEBUG(*YES)
     H OPTION(*SRCSTMT:*NODEBUGIO:*SHOWCPY)
     H COPYRIGHT('(c) 2017 Ray Gillies-Jones. All rights reserved.')
      * 
      * Copyright (c) 2017 Ray Gillies-Jones
      * All rights reserved.
      * 
      * Redistribution and use in source and binary forms are permitted
      * provided that the above copyright notice and this paragraph are
      * duplicated in all such forms and that any documentation,
      * advertising materials, and other materials related to such
      * distribution and use acknowledge that the software was developed
      * by Ray Gillies-Jones. The name "Ray Gillies-Jones"
      * may not be used to endorse or promote products derived
      * from this software without specific prior written permission.
      * THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR
      * IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
      * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
      * 
      * 
      * ------------------------------------------------------------------------
      * In-Line Scan and Replace
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     D QScanRpl...
     D                 PR          2048A   VARYING
     D  Search                     2048A   VARYING CONST
     D  Replace                    2048A   VARYING CONST
     D  Source                     2048A   VARYING VALUE
     D oScanStart                    10U 0 OPTIONS(*NOPASS) CONST
     D oScanLen                      10U 0 OPTIONS(*NOPASS) CONST
      * 
      * 
      * Used in the example
     D txt             S             50A   VARYING
      * 
      /free

         // Source string
            txt= 'Everybody Loves Raymond' ;

         // Scan and Replace
            txt= QScanRpl('Raymond':'Pizza!':txt) ;

         // txt= 'Everybody Loves Pizza!'

         // Finished
            *INLR= *ON ;
            RETURN ;

      /end-free
      * 
      * ------------------------------------------------------------------------
      * In-Line Scan and Replace
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
     P QScanRpl...
     P                 B                   EXPORT
     D                 PI          2048A   VARYING
     D  Search                     2048A   VARYING CONST
     D  Replace                    2048A   VARYING CONST
     D  Source                     2048A   VARYING VALUE
     D oScanStart                    10U 0 OPTIONS(*NOPASS) CONST
     D oScanLen                      10U 0 OPTIONS(*NOPASS) CONST
      * 
     D ScanStart       S             10U 0
     D ScanLen         S             10U 0
     D x               S             10I 0
     D y               S             10I 0
      * 
      /free

         // Null values
            IF (%Len(Search) = 0) OR (%Len(Source) = 0) ;
               RETURN Source ;
            ENDIF ;

         // Optional Parameter
            IF (%Parms() >= 4) ;
               ScanStart= oScanStart ;
            ELSE ;
               ScanStart= 1 ;
            ENDIF ;

         // Optional Parameter
            IF (%Parms() >= 5) ;
               ScanLen= oScanLen ;
            ELSE ;
               ScanLen= *HIVAL ;
            ENDIF ;

         // Do an initial scan of the string
            x= %Scan(Search:Source:ScanStart) ;
            DOW (x > 0) ;

            // Found, but outside limits set by caller
               IF (x+%Len(Search)+y-1 > ScanLen) ;
                  LEAVE ;
               ENDIF ;

            // Replace one string with another
               Source=
                 %Replace(
                 Replace:
                 Source:
                 x:
                 %Len(Search) ) ;

            // Adjustment
               y+= %Len(Search)-%Len(Replace) ;

            // Avoid problems
               IF (x+%Len(Replace) > %Len(Source)) ;
                  LEAVE ;
               ENDIF ;

            // Continue scan starting just after the replacement
               x= %Scan(Search:Source:x+%Len(Replace)) ;
            ENDDO ;

         // Finished
            RETURN Source ;

      /end-free
      * 
      * End of procedure
     P                 E
      * 
