/'****************************************************************************
*
* Name: vec.bi
*
* Synopsis: 2D Vector object for DOD.
*
* Description: This implements a 2D vector as an object along with useful operators.
*
* Copyright 2006, Richard D. Clark
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

'Compass directions
Enum compass
	north
	neast
	east
	seast
	south
	swest
	west
	nwest
End Enum

'Coordinates.
Type mcoord
	x As Integer
	y As Integer
End Type

'2D Vector type.
Type vec
	Private:
	_x As Integer
	_y As Integer
	Public:
	Declare Constructor ()
	Declare Constructor (x As Integer, y As Integer)
	Declare Property vx (x As Integer)
	Declare Property vx () As Integer
	Declare Property vy (y As Integer)
	Declare Property vy () As Integer
	Declare Operator += (cd As compass)
	Declare Operator Let (v As vec)
	Declare Sub ClearVec()
End Type

'Empty constructor. Used when part of another object.
Constructor vec ()
	_x = 0
	_y = 0
End Constructor

'Initialzed vector.
Constructor vec (x As Integer, y As Integer)
	_x = x
	_y = y
End Constructor

'Properties to set and return the x and y components.
Property vec.vx (x As Integer)
	_x = x
End Property

Property vec.vx () As Integer
	Return _x
End Property

Property vec.vy (y As Integer)
	_y = y
End Property

Property vec.vy () As Integer
	Return _y
End Property

'Set vector based on passed vector.
Operator vec.Let (v As vec)
   _x = v.vx
   _y = v.vy
End Operator

'Updates x and y using compass direction.
Operator vec.+= (cd As compass)
   Select Case cd
      Case north
         _y -= 1
      Case neast
         _x += 1
         _y -= 1
      Case east
         _x += 1
      Case seast
         _x += 1
         _y += 1
      Case south
         _y += 1
      Case swest
         _x -= 1
         _y += 1
      Case west
         _x -= 1
      Case nwest
         _x -= 1
         _y -= 1
   End Select
End Operator

'Sets vector to 0.
Sub vec.Clearvec ()
	_x = 0
	_y = 0
End Sub

