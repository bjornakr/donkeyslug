/'****************************************************************************
*
* Name: defs.bi
*
* Synopsis: Data definitions for DOD.
*
* Description: This file contains the various data definitions used in the game.  
*
* Copyright 2010, Richard D. Clark
*
*                          The Wide Open License (WOL)
*
* Permission to use, copy, modify, distribute and sell this software and its
* documentation for any purpose is hereby granted without fee, provided that
* the above copyright notice and this license appear in all source copies. 
* THIS SOFTWARE IS PROVIDED "AS IS" WITHOUT EXPRESS OR IMPLIED WARRANTY OF
* ANY KIND. See http://www.dspguru.com/wol.htm for more information.
*
*****************************************************************************'/
'Define true and false.
#Ifndef FALSE
   #Define FALSE 0
#EndIf
#Ifndef TRUE
   #Define TRUE -1
#EndIf
'NULL value.
#Define NULL 0
'Return max of two items.
#Define imax(a,b) IIf( a > b, a, b ) 
'Using 8x8 characters.
#Define charw 8
#Define charh 8
'Text mode 80x60
#Define txcols 80
#Define txrows 60
'Macro that calculates the center point on the screen.
#Define CenterX(ct) ((txcols / 2) - (Len(ct) / 2))
#Define CenterY(ni)((txrows / 2) - (ni / 2))
'Current version.
Const dodver = "0.1.0"
'Colors
Const fbYellow = RGB(255, 255, 0)
Const fbWhite = RGB(255, 255, 255)
Const fbBlack = RGB(0, 0, 0)
Const fbGray = RGB(128, 128, 128)
Const fbTan = RGB (210, 180, 140)
Const fbSlateGrayDark = RGB (47, 79, 79)
Const fbGreen = RGB (0, 255, 0)
Const fbRed = RGB (255, 0, 0)
const fbSienna = RGB (160, 082, 045)
'Ascii Chars
Const acBlock = Chr(219)
'Key consts
Const xk = Chr(255)
Const key_up = xk + "H"
Const key_dn = xk + "P"
Const key_rt = xk + "M"
Const key_lt = xk + "K"
Const key_close = xk + "k"
Const key_esc = Chr(27)
Const key_enter = Chr(13)

'Coordinates.
Type mcoord
	x As Integer
	y As Integer
End Type

'Working variables.
Dim As String ckey
Dim As Integer mret
