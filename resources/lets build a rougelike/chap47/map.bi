/'****************************************************************************
*
* Name: map.bi
*
* Synopsis: Map related routines.
*
* Description: This file contains map related routines used in the program.  
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
'Size of the map.
#Define mapw 100
#Define maph 100
'Min and max room dimensions
#Define roommax 8 
#Define roommin 4
#Define nroommin 20
#Define nroommax 50
'Empty cell flag.
#Define emptycell 0
'Grid cell size (width and height)
#Define csizeh 10
#Define csizew 10
'Grid dimensions.
Const gw = mapw \ csizew
Const gh = maph \ csizeh

'The types of terrain in the map.
Enum terrainids
   tfloor = 0  'Walkable terrain.
   twall       'Impassable terrain.
   tdooropen   'Open door.
   tdoorclosed 'Closed door.
   tstairup    'Stairs up.
   tstairdn   'Stairs down.
   twmerch    'Wandering Merchant.
   tamulet    'The amulet.
End Enum

'Room dimensions.
Type rmdim
	rwidth As Integer
	rheight As Integer
	rcoord As mcoord
End Type

'Room information
Type roomtype
	roomdim As rmdim  'Room width and height.
	tl As mcoord      'Room rect
	br As mcoord
	secret As Integer         
End Type

'Grid cell structure.
Type celltype
	cellcoord As mcoord 'The cell position.
	Room As Integer     'Room id. This is an index into the room array.
End Type

'Door states.
Enum doorstates
   dsNone
   dsLocked
   dsOpen
   dsClosed
End Enum

'Door type.
Type doortype
   locked As Integer   'True if locked.
   lockdr As Integer   'Lock pick difficulty.
   dstr As Integer     'Strength of door (for bashing).
End Type

'Target type.
Type targettype
   id As Integer      'Ascii code of icon.
   tcolor As UInteger 'Color of icon.
End Type

'Trap ids.
Enum trapid
   trpNone
   trpBlade  'Slash trap.
   trpHammer 'Crush trap.
   trpSpike  'Pierce trap.
   trpEnergy 'Energy trap.
   trpFire   'Fire trap.
   trpAcid   'Acid trap. 
End Enum

'Trap types.
Type traptype
   id As trapid           'The trap id.
   icon As String * 1     'Map icon.
   iconcolor As UInteger  'Icon color.
   desc As String * 20    'The trap description.
   sprung As Integer      'FALSE = not triggered or found.
   dr As Integer          'The trap DR; compared to character agility.
   dam As Integer         'Damage trap does.
   damtype As weapdamtype 'The type of damage.
End Type

'Map info type
Type mapinfotype
	terrid As terrainids  'The terrain type.
	monidx As Integer     'Index into monster array.
	visible As Integer    'Character can see cell.
	seen As Integer       'Character has seen cell.
	doorinfo As doortype  'Door information.
	sndvol As Integer     'Sound volume at current tile.
	target As targettype  'Target and projectile map.
	trap As traptype      'Trap.
End Type

'Type monstat
Type monstat
   cnt As Integer
   mname As String * 15
End Type

'Dungeon level information.
Type levelinfo
   numlevel As Integer                       'Current level number.
   lmap(1 To mapw, 1 To maph) As mapinfotype 'Map array.
   linv(1 To mapw, 1 To maph) As invtype     'Map inventory type.
   nummon As Integer                         'Number of monsters on the map.
   moninfo(1 To nroommax) As montype         'Array of monsters.   
   killedmon(monDarkangel To monGriffon) As monstat     'The list of vanquished monsters.
   lastmon As monstat 'Last monster encountered.
End Type

'Dungeon level object.
Type levelobj
   Private:
   _level As levelinfo                 'The level map structure.
   _numrooms As Integer                'The number of rooms in the level.
   _rooms(1 To nroommax) As roomtype   'Room information.
   _grid(1 To gw, 1 To gh) As celltype 'Grid infromation.
   _blockset As setobj                 'Blocking set.
   Declare Function _BlockingTile(tx As Integer, ty As Integer) As Integer 'Returns true if blocking tile.
   Declare Function _LineOfSight(x1 As Integer, y1 As Integer, x2 As Integer, y2 As Integer) As Integer 'Returns true if line of sight to tile.
   Declare Function _CanSee(tx As Integer, ty As Integer) As Integer 'Can character see tile.
   Declare Sub _CalcLOS () 'Calculates line of sight with post processing to remove artifacts.
   Declare Function _GetMapSymbol(tile As terrainids) As String 'Returns the ascii symbol for terrian id.
   Declare Function _GetMapSymbolColor(tile As terrainids) As UInteger 'Returns color for terrain id.
   Declare Function _GetTerrainDesc(x As Integer, y As Integer) As String 'Returns item description.
   Declare Function _GetNextTile(mx As Integer, my As Integer, x As Integer, y As Integer, flee As Integer = FALSE) As mcoord 'Returns the next tile closest to x, y.
   Declare Function _GetNextSndTile(x As Integer, y As Integer) As mcoord 'Returns the next higher sound tile.
   Declare Sub _InitGrid() 'Inits the grid.
   Declare Sub _ConnectRooms( r1 As Integer, r2 As Integer) 'Connects rooms.
   Declare Sub _AddDoorsToRoom(i As Integer) 'Adds doors to a room.
   Declare Sub _AddDoors() 'Iterates through all rooms adding doors to each room.
   Declare Sub _DrawMapToArray() 'Transfers room data to map array.
   Declare Sub _GenerateItems()  'Generates items on the map.
   Declare Sub _BuildTrap(trp As traptype) 'Creates a trap.
   Public:
   Declare Constructor ()
   Declare Property LevelID(lvl As Integer) 'Sets the current level.
   Declare Property LevelID() As Integer 'Returns the current level number.
   Declare Sub DrawMap () 'Draws the map on the screen.
   Declare Sub GenerateDungeonLevel() 'Generates a new dungeon level.
   Declare Sub SetTile(x As Integer, y As Integer, tileid As terrainids) 'Sets the tile at x, y of map.
   Declare Sub GetItemFromMap(x As Integer, y As Integer, inv As invtype) 'Adds item from map to passed inventory type. 
   Declare Sub PutItemOnMap(x As Integer, y As Integer, inv As invtype) 'Puts an item from passed inventory type to map.
   Declare Sub MoveMonsters () 'Moves all the monsters in the list.
   Declare Sub ClearSoundMap () 'Clears the current sound map.
   Declare Sub GenSoundMap(x As Integer, y As Integer, sndvol As Integer) 'Generate sound map.
   Declare Sub MonsterAttack(mx As Integer, my As Integer) 'Monster attacks character.
   Declare Sub CastSpell(mx As Integer, my As Integer)
   Declare Sub SetTarget(x As Integer, y As Integer, id As Integer, tcolor As UInteger = fbBlack) 'Sets target map at x, y with id.
   Declare Sub AnimateProjectile (source As vec, target As vec) 'Animates projectile.
   Declare Sub DoTimedEvents() 'Resolves any timed events.
   Declare Sub SetDoorState(x As Integer, y As Integer, state As doorstates) 'Sets the door state.
   Declare Sub DisArmTrap (x As Integer, y As Integer) 'Disarms a trap.
   Declare Sub IsAmulet(x As Integer, y As Integer) 'Check for amulet at x, y.
   Declare sub GetDeadMonster(monid As monids, mstat As monstat) 'Returns the number of dead monsters for passed monster id.
   Declare Sub GetLastMonster(mstat As monstat) 'Returns the name of last monster encountered.
   Declare Sub GetLevelData(ld As levelinfo) 'Gets the level information.
   Declare Sub SetLevelData(ld As levelinfo) 'Sets the level data.
   Declare Function ApplySpell(spl As spelltype, mx As Integer, my As Integer) As Integer 'Applies spell to monster.
   Declare Function IsBlocking(x As Integer, y As Integer) As Integer 'Returns true of tile at x, y is blocking.
   Declare Function GetTileID(x As Integer, y As Integer) As terrainids 'Returns the tile id at x, y.
   Declare Function IsDoorLocked(x As Integer,y As Integer) As Integer 'Returns True if door is locked.
   Declare Function GetTerrainDescription(x As Integer, y As Integer) As String 'Returns item description at coordinate.
   Declare Function HasItem(x As Integer, y As Integer) As Integer 'Returns True if coordinate has item.
   Declare Function GetItemDescription(x As Integer, y As Integer) As String 'Returns item description at x, y coordinate.
   Declare Function GetInvClassID(x As Integer, y As Integer) As classids 'Returns inv class id at x, y.
   Declare Function GetEmptySpot(v As vec) As Integer 'Returns true if an empty spot is found and returns coords in vec.
   Declare Function IsMonster(x As Integer, y As Integer) As Integer 'Returns true if monster at location.
   Declare Function GetMonsterDefense(mx As Integer, my As Integer) As Integer 'Returns the defense factor of monster.
   Declare Function GetMonsterName(mx As Integer, my As Integer) As String 'Returns the monster type.
   Declare Function GetMonsterArmor(mx As Integer, my As Integer) As Single 'Returns the monster armor rating.
   Declare Function ApplyDamage(mx As Integer, my As Integer, dam As Integer) As Integer 'Applies damage to monsters returns true if dead.
   Declare Function GetMonsterCombatFactor(mx As Integer, my As Integer) As Integer 'Returns the monster combat factor.
   Declare Function GetMonsterXP(mx As Integer, my As Integer) As Integer 'Returns the monster xp amount.
   Declare Function IsTileVisible(x As Integer, y As Integer) As Integer 'Returns True if tile is visible,
   Declare Function GetMonsterMagicDefense(mx As Integer, my As Integer) As Integer 'Returns the magic defense of the monster.
   Declare Function GetMonsterStatAmt(stat As monStats, mx As Integer, my As Integer) As Integer 'Returns the current monster stat amt.
   Declare Function OpenLockedDoor(x As Integer, y As Integer, dr As Integer) As Integer 'Attempts to open a locked door.
   Declare Function IsTrap(x As Integer, y As Integer, ByRef dam As Integer, ByRef damtype As weapdamtype, ByRef tdr As Integer, tdesc As String) As Integer 'Returns TRUE if trap at x, y.
End Type

'Initlaizes object.
Constructor levelobj ()
   Dim As Integer ret
   
   'Set the level number.
   _level.numlevel = 0
   'Create the blocking set.
   ret = _blockset.AddToSet(twall)
   ret = _blockset.AddToSet(tdoorclosed)
   ret = _blockset.AddToSet(tstairup)
   ret = _blockset.AddToSet(twmerch)
End Constructor

'Sets the current level.
Property levelobj.LevelID(lvl As Integer)
   _level.numlevel = lvl
End Property

'Returns the current level number.
Property levelobj.LevelID() As Integer
   Return _level.numlevel
End Property

'Returns True if tile is blocking tile.
Function levelobj._BlockingTile(tx As Integer, ty As Integer) As Integer
   Dim ret As Integer
   
   'Check to see if tile is in blocking set.
   ret = (_blockset.IsMember(_level.lmap(tx, ty).terrid) = TRUE)
   
   Return ret
End Function

'Bresenhams line algo
Function levelobj._LineOfSight(x1 As Integer, y1 As Integer, x2 As Integer, y2 As Integer) As Integer
    Dim As Integer i, deltax, deltay, numtiles
    Dim As Integer d, dinc1, dinc2
    Dim As Integer x, xinc1, xinc2
    Dim As Integer y, yinc1, yinc2
    Dim isseen As Integer = TRUE
    
    deltax = Abs(x2 - x1)
    deltay = Abs(y2 - y1)

    If deltax >= deltay Then
        numtiles = deltax + 1
        d = (2 * deltay) - deltax
        dinc1 = deltay Shl 1
        dinc2 = (deltay - deltax) Shl 1
        xinc1 = 1
        xinc2 = 1
        yinc1 = 0
        yinc2 = 1
    Else
        numtiles = deltay + 1
        d = (2 * deltax) - deltay
        dinc1 = deltax Shl 1
        dinc2 = (deltax - deltay) Shl 1
        xinc1 = 0
        xinc2 = 1
        yinc1 = 1
        yinc2 = 1
    End If

    If x1 > x2 Then
        xinc1 = - xinc1
        xinc2 = - xinc2
    End If
    
    If y1 > y2 Then
        yinc1 = - yinc1
        yinc2 = - yinc2
    End If

    x = x1
    y = y1
    
    For i = 2 To numtiles
      If _BlockingTile(x, y) Then
        isseen = FALSE
        Exit For
      End If
      If d < 0 Then
          d = d + dinc1
          x = x + xinc1
          y = y + yinc1
      Else
          d = d + dinc2
          x = x + xinc2
          y = y + yinc2
        End If
    Next
    
    Return isseen
End Function

'Determines if player can see object.
Function levelobj._CanSee(tx As Integer, ty As Integer) As Integer
   Dim As Integer ret = FALSE, px = pchar.Locx, py = pchar.Locy, vis = vh
   Dim As Integer dist
        
	dist = CalcDist(pchar.Locx, tx, pchar.Locy, ty)
	If dist <= vis Then
   	ret = _LineOfSight(tx, ty, px, py)
	End If
    
   Return ret
End Function

'Caclulate los with post processing.
Sub levelobj._CalcLOS 
	Dim As Integer i, j, x, y, w = vw / 2, h = vh / 2
	Dim As Integer x1, x2, y1, y2
	
	'Clear the vismap
	For i = 1 To mapw
   	For j = 1 To maph
   		_level.lmap(i, j).visible = FALSE
   	Next
	Next
	'Only check within viewport
	x1 = pchar.Locx - w
	If x1 < 1 Then x1 = 1
	y1 = pchar.Locy - h
	If y1 < 1 Then y1 = 1
	
	x2 = pchar.Locx + w
	If x2 > mapw Then x2 = mapw
	y2 = pchar.Locy + h
	If y2 > maph Then y2 = maph
	'iterate through vision area
	For i = x1 To x2
		For j = y1 To y2
	   	'Don't recalc seen tiles
	      If _level.lmap(i, j).visible = FALSE Then
	         If _CanSee(i, j) Then
	         	_level.lmap(i, j).visible = TRUE
	         	_level.lmap(i, j).seen = TRUE
	         End If
	      End If
	  Next
	Next
	'Post process the map to remove artifacts.
	For i = x1 To x2
		For j = y1 To y2
			If (_BlockingTile(i, j) = TRUE) And (_level.lmap(i, j).visible = FALSE) Then
				x = i
				y = j - 1
				If (x > 0) And (x < mapw + 1) Then
					If (y > 0) And (y < maph + 1) Then
						If (_level.lmap(x, y).terrid = tfloor) And (_level.lmap(x, y).visible = TRUE) Then
							_level.lmap(i, j).visible = TRUE
							_level.lmap(i, j).seen = TRUE
						EndIf
					EndIf
				EndIf 
				
				x = i
				y = j + 1
				If (x > 0) And (x < mapw + 1) Then
					If (y > 0) And (y < maph + 1) Then
						If (_level.lmap(x, y).terrid = tfloor) And (_level.lmap(x, y).visible = TRUE) Then
							_level.lmap(i, j).visible = TRUE
							_level.lmap(i, j).seen = TRUE
						EndIf
					EndIf
				EndIf 

				x = i + 1
				y = j
				If (x > 0) And (x < mapw + 1) Then
					If (y > 0) And (y < maph + 1) Then
						If (_level.lmap(x, y).terrid = tfloor) And (_level.lmap(x, y).visible = TRUE) Then
							_level.lmap(i, j).visible = TRUE
							_level.lmap(i, j).seen = TRUE
						EndIf
					EndIf
				EndIf 

				x = i - 1
				y = j
				If (x > 0) And (x < mapw + 1) Then
					If (y > 0) And (y < maph + 1) Then
						If (_level.lmap(x, y).terrid = tfloor) And (_level.lmap(x, y).visible = TRUE) Then
							_level.lmap(i, j).visible = TRUE
							_level.lmap(i, j).seen = TRUE
						EndIf
					EndIf
				EndIf 

				x = i - 1
				y = j - 1
				If (x > 0) And (x < mapw + 1) Then
					If (y > 0) And (y < maph + 1) Then
						If (_level.lmap(x, y).terrid = tfloor) And (_level.lmap(x, y).visible = TRUE) Then
							_level.lmap(i, j).visible = TRUE
							_level.lmap(i, j).seen = TRUE
						EndIf
					EndIf
				EndIf 

				x = i + 1
				y = j - 1
				If (x > 0) And (x < mapw + 1) Then
					If (y > 0) And (y < maph + 1) Then
						If (_level.lmap(x, y).terrid = tfloor) And (_level.lmap(x, y).visible = TRUE) Then
							_level.lmap(i, j).visible = TRUE
							_level.lmap(i, j).seen = TRUE
						EndIf
					EndIf
				EndIf 

				x = i + 1
				y = j + 1
				If (x > 0) And (x < mapw + 1) Then
					If (y > 0) And (y < maph + 1) Then
						If (_level.lmap(x, y).terrid = tfloor) And (_level.lmap(x, y).visible = TRUE) Then
							_level.lmap(i, j).visible = TRUE
							_level.lmap(i, j).seen = TRUE
						EndIf
					EndIf
				EndIf 

				x = i - 1
				y = j + 1
				If (x > 0) And (x < mapw + 1) Then
					If (y > 0) And (y < maph + 1) Then
						If (_level.lmap(x, y).terrid = tfloor) And (_level.lmap(x, y).visible = TRUE) Then
							_level.lmap(i, j).visible = TRUE
							_level.lmap(i, j).seen = TRUE
						EndIf
					EndIf
				EndIf
				
			EndIf 
		Next
	Next
End Sub

'Return ascii symbol for tile
Function levelobj._GetMapSymbol(tile As terrainids) As String
	Dim As String ret
	
   Select Case tile
   	Case twall
   		ret = Chr(178)
   	Case tfloor
   		ret = Chr(249)
      Case tstairup
   		ret = "<"
      Case tstairdn
   		ret = ">"
   	Case tdooropen
   		ret = "'"
   	Case tdoorclosed
   		ret = "\"
      Case twmerch
         ret = "W"
      Case tamulet
         ret = Chr(21)
   	Case Else
            ret = "?"
   End Select
   
   Return ret
End Function

'Returns the color for object.
Function levelobj._GetMapSymbolColor(tile As terrainids) As UInteger
	Dim ret As UInteger
	
   Select Case tile
   	Case twall
   		ret = fbTan
      Case tfloor
   		ret = fbWhite
      Case tstairup
   		ret = fbYellowBright
      Case tstairdn
   		ret = fbYellowBright
   	Case tdooropen
   		ret = fbTan
   	Case tdoorclosed
   		ret = fbSienna
      Case twmerch
         ret = fbGreen
      Case tamulet
         ret = fbFlame
      Case Else
         ret = fbWhite
   End Select
   
   Return ret
End Function

'Returns terrain description.
Function levelobj._GetTerrainDesc(x As Integer, y As Integer) As String
	Dim tile As terrainids
   Dim ret As String
   
   'Must be a tile.
   tile = _level.lmap(x, y).terrid
   Select Case tile
   	Case twall
   		ret = "Wall"
      Case tfloor
   		ret = "Floor"
      Case tstairup
   		ret = "Stairs up"
      Case tstairdn
   		ret = "Stairs down"
      Case tdooropen
   		ret = "Open door"
   	Case tdoorclosed
   		ret = "Closed door"
      Case twmerch
         ret = "Wandering Merchant"
      Case Else
         ret = "Uknown"
   End Select
   
   Return ret
End Function

'Returns the next tile closest to x, y.
Function levelobj._GetNextTile(mx As Integer, my As Integer, x As Integer, y As Integer, flee As Integer = FALSE) As mcoord
   Dim As Integer pdist, mdist, xx, yy
   Dim v As vec
   Dim As mcoord ret
   
   'Set current location.
   xx = mx
   yy = my
   'Set reference number.
   If flee = FALSE Then
      pdist = 1000
   Else
      pdist = 0
   End If
   'Iterate through all local tiles and find closest tile to character.
   For j As compass = north To nwest
      v.vx = mx
      v.vy = my
      v += j
      'Make sure tile isn't a blocking tile.
      If (_BlockingTile(v.vx, v.vy) = FALSE) And (_level.lmap(v.vx, v.vy).monidx = 0) And (pchar.IsLocation(v.vx, v.vy) = FALSE) Then
         'Get the tile distance.
         mdist = CalcDist(v.vx, x, v.vy, y)
         'Moving toward character.
         If flee = FALSE Then
            'If less than last diatance, set new coords.
            If mdist <= pdist Then
               xx = v.vx
               yy = v.vy
               pdist = mdist
            EndIf
         Else
            'Moving away from character.
            If mdist >= pdist Then
               xx = v.vx
               yy = v.vy
               pdist = mdist
            EndIf
         End If
      EndIf
   Next
   ret.x = xx
   ret.y = yy
   
   Return ret
End Function

'Returns the next higher sound tile.
Function levelobj._GetNextSndTile(x As Integer, y As Integer) As mcoord
   Dim As mcoord ret
   Dim As Integer xx, yy, msnd = 0, psnd = 0
   Dim v As vec
   
   'Set current location.
   xx = x
   yy = y
   'Iterate through all local tiles and find closest tile to character.
   For j As compass = north To nwest
      v.vx = x
      v.vy = y
      v += j
      'Make sure tile isn't a blocking tile.
      If (_BlockingTile(v.vx, v.vy) = FALSE) And (_level.lmap(v.vx, v.vy).monidx = 0) Then
         'Get the current sound value.
         msnd = _level.lmap(v.vx, v.vy).sndvol
         'If greater than last value then save new coords.
         If msnd >= psnd Then
            xx = v.vx
            yy = v.vy
            psnd = msnd
         EndIf
      EndIf
   Next
   ret.x = xx
   ret.y = yy
   
   Return ret
End Function

'Draws the map on the screen.
Sub levelobj.DrawMap ()
   Dim As Integer i, j, w = vw, h = vh, x, y, px, py, pct, vis = vh, monid
   Dim As UInteger tilecolor, bcolor, trpcolor
   Dim As String mtile, trptile
   Dim As terrainids tile
   
	_CalcLOS
	'Get the view coords
	i = pchar.Locx - (w / 2)
	j = pchar.Locy - (h / 2)
	If i < 1 Then i = 1
	If j < 1 Then j = 1
	If i + w > mapw Then i = mapw - w
	If j + h > mapw Then j = mapw - h
	'Draw the visible portion of the map.
	 For x = 1 To w
	     For y = 1 To h
	        'Clears current location to black.
	     		tilecolor = fbBlack 
	     		PutText acBlock, y + 1, x + 1, tilecolor
  			   'Get tile id
  			   tile = _level.lmap(i + x, j + y).terrid
     		   'Get the tile symbol
      	   mtile = _GetMapSymbol(tile)
      	   'Get the tile color
      	   tilecolor = _GetMapSymbolColor(tile)
	     		'Print the tile.
	         If _level.lmap(i + x, j + y).visible = TRUE Then
	            'Print trap icon if trap is sprung.
	            If _level.lmap(i + x, j + y).trap.sprung = TRUE Then
		            'Get the item symbol.
		         	trptile = _level.lmap(i + x, j + y).trap.icon
		         	'Get the item color.
		         	trpcolor = _level.lmap(i + x, j + y).trap.iconcolor
	            EndIf
	            PutText trptile, y + 1, x + 1, trpcolor
		         'Print the item marker.
		         If HasItem(i + x, j + y) = TRUE Then
		            'Get the item symbol.
		         	mtile = _level.linv(i + x, j + y).icon
		         	'Get the item color.
		         	tilecolor = _level.linv(i + x, j + y).iconclr
		         EndIf
	            PutText mtile, y + 1, x + 1, tilecolor
		         'If the current location has a monster print that monster.
		         If _level.lmap(i + x, j + y).monidx > 0 Then
		         	monid = _level.lmap(i + x, j + y).monidx
		         	mtile = _level.moninfo(monid).micon
		         	tilecolor = _level.moninfo(monid).mcolor
		         	PutText acBlock, y + 1, x + 1, fbBlack
		         	PutText mtile, y + 1, x + 1, tilecolor
		         EndIf
	         Else
	         	'Not in los. Don't print monsters when not in LOS.
	         	If _level.lmap(i + x, j + y).seen = TRUE Then
	         		If HasItem(i + x, j + y) = TRUE Then
	         			PutText "?", y + 1, x + 1, fbSlateGrayDark
	         		Else
	            		PutText mtile, y + 1, x + 1, fbSlateGrayDark
	         		End If
	         	End If
	         End If
	         'Print any targets in target map.
	         If _level.lmap(i + x, j + y).target.id <> 0 Then
	            tilecolor = _level.lmap(i + x, j + y).target.tcolor
	            mtile = Chr(_level.lmap(i + x, j + y).target.id)
            	PutText acBlock, y + 1, x + 1, fbBlack
	         	PutText mtile, y + 1, x + 1, tilecolor
	         EndIf
	     Next 
	 Next
	'Don't draw if character on target icon.
	If _level.lmap(pchar.Locx, pchar.Locy).target.id = 0 Then
      'Draw the player
	   px = (pchar.Locx - i) + 1
	   py = (pchar.Locy - j) + 1
   	pct = Int((pchar.CurrHP / pchar.MaxHP) * 100) 
   	If pct > 74 Then
   		PutText acBlock, py, px, fbBlack
   		PutText "@", py, px, fbGreen
   	ElseIf (pct > 24) And (pct < 75) Then
   		PutText acBlock, py, px, fbBlack
   		PutText "@", py, px, fbYellow
   	Else
   		PutText acBlock, py, px, fbBlack
   		PutText "@", py, px, fbRed
   	EndIf
	End If
End Sub

'Creates a trap.
Sub levelobj._BuildTrap(trp As traptype)
   
   'Get the trap type.
   trp.id = RandomRange(trpBlade, trpAcid) 
   trp.icon = Chr(240)
   trp.iconcolor = fbRedBright
   trp.sprung = FALSE
   trp.dr = _level.numlevel
   trp.dam = RandomRange(1, _level.numlevel)
   'Set data based on type.
   If trp.id = trpBlade Then
      trp.desc = "Blade Trap"
      trp.damtype = wdSlash
   ElseIf trp.id = trpHammer Then
      trp.desc = "Hammer Trap"
      trp.damtype = wdCrush
   ElseIf trp.id = trpSpike Then
      trp.desc = "Spike Trap"
      trp.damtype = wdPierce
   ElseIf trp.id = trpEnergy Then
      trp.desc = "Energy Bolt Trap"
      trp.damtype = wdPierce
   ElseIf trp.id = trpFire Then
      trp.desc = "Fire Trap"
      trp.damtype = wdFire
   ElseIf trp.id = trpAcid Then
      trp.desc = "Acid Trap"
      trp.damtype = wdAcid
   EndIf
   
End Sub

'Init the grid and room arrays
Sub levelobj._InitGrid()
   Dim As Integer i, j, x, y, gx = 1, gy = 1
	
	'Clear room array.		
   For i = 1 To nroommax
   	_rooms(i).roomdim.rwidth = 0
   	_rooms(i).roomdim.rheight = 0
   	_rooms(i).roomdim.rcoord.x = 0
   	_rooms(i).roomdim.rcoord.y = 0
   	_rooms(i).tl.x = 0
   	_rooms(i).tl.y = 0
   	_rooms(i).br.x = 0
   	_rooms(i).br.y = 0
   Next 
   'How many rooms
   _numrooms = RandomRange(nroommin, nroommax)
   'Build some rooms
   For i = 1 To _numrooms
   	_rooms(i).roomdim.rwidth = RandomRange(roommin, roommax)
    	_rooms(i).roomdim.rheight = RandomRange(roommin, roommax)
   Next
    'Clear the grid array
   For i = 1 To gw 
   	For j = 1 To gh
    		_grid(i, j).cellcoord.x = gx
    		_grid(i, j).cellcoord.y = gy
     		_grid(i, j).Room = emptycell
     		gy += csizeh
   	Next
   	gy = 1
   	gx += csizew
   Next
	'Add rooms to the grid
   For i = 1 To _numrooms
   	'Find an empty spot in the grid
   	Do
   		x = RandomRange(2, gw - 1)
   		y = RandomRange(2, gh - 1)
   	Loop Until _grid(x, y).Room = emptycell
   	'Room center
   	_rooms(i).roomdim.rcoord.x = _grid(x, y).cellcoord.x + (_rooms(i).roomdim.rwidth \ 2) 
   	_rooms(i).roomdim.rcoord.y = _grid(x, y).cellcoord.y + (_rooms(i).roomdim.rheight \ 2)
		'Set the room rect
		_rooms(i).tl.x = _grid(x, y).cellcoord.x 
		_rooms(i).tl.y = _grid(x, y).cellcoord.y 
		_rooms(i).br.x = _grid(x, y).cellcoord.x + _rooms(i).roomdim.rwidth + 1
		_rooms(i).br.y = _grid(x, y).cellcoord.y + _rooms(i).roomdim.rheight + 1
   	'Save the room index
   	_grid(x, y).Room = i
   Next
End Sub 

'Connect all the rooms.
Sub levelobj._ConnectRooms( r1 As Integer, r2 As Integer)
	Dim As Integer idx, x, y, nid
	Dim As mcoord currcell, lastcell, ncoord
	Dim As Integer wflag
	
	currcell = _rooms(r1).roomdim.rcoord
	lastcell = _rooms(r2).roomdim.rcoord
		
	x = currcell.x
	If x < lastcell.x Then
		wflag = FALSE
		Do
			x += 1
			If _level.lmap(x, currcell.y).terrid = twall Then wflag = TRUE
			If (_level.lmap(x, currcell.y).terrid = tfloor) And (wflag = TRUE) Then
				Exit Sub
			EndIf
			_level.lmap(x, currcell.y).terrid = tfloor
		Loop Until x = lastcell.x
	End If
	If x > lastcell.x Then
		wflag = FALSE
		Do
			x -= 1
			If _level.lmap(x, currcell.y).terrid = twall Then wflag = TRUE
			If (_level.lmap(x, currcell.y).terrid = tfloor) And (wflag = TRUE) Then 
				Exit Sub
			EndIf
			_level.lmap(x, currcell.y).terrid = tfloor
		Loop Until x = lastcell.x
	EndIf
	y = currcell.y
	If y < lastcell.y Then
		wflag = FALSE
		Do
			y += 1
			If _level.lmap(x, y).terrid = twall Then wflag = TRUE
			If (_level.lmap(x, y).terrid = tfloor) And (wflag = TRUE) Then 
				Exit Sub
			EndIf
			_level.lmap(x, y).terrid = tfloor
		Loop Until y = lastcell.y
	EndIf
	If y > lastcell.y Then
		Do
			y -= 1
			If _level.lmap(x, y).terrid = twall Then wflag = TRUE
			If (_level.lmap(x, y).terrid = tfloor) And (wflag = TRUE) Then 
				Exit Sub
			EndIf
			_level.lmap(x, y).terrid = tfloor
		Loop Until y = lastcell.y
	EndIf
End Sub

'Add doors to a room.
Sub levelobj._AddDoorsToRoom(i As Integer)
	Dim As Integer row, col, dd1, dd2, nid, roll
	
   'Add the doors.
	For col = _rooms(i).tl.x To _rooms(i).br.x
		dd1 = _rooms(i).tl.y
		dd2 = _rooms(i).br.y
		'If a floor space in the wall.
		If _level.lmap(col, dd1).terrid = tfloor Then
			'Add door.
			_level.lmap(col, dd1).terrid = tdoorclosed
			'Check to see if door is locked.
			roll = RandomRange(0, maxlevel * 2)
		   _level.lmap(col, dd1).doorinfo.locked = (roll < _level.numlevel)
			If _level.lmap(col, dd1).doorinfo.locked = TRUE Then
			   _level.lmap(col, dd1).doorinfo.lockdr = _level.numlevel
			   _level.lmap(col, dd1).doorinfo.dstr = _level.numlevel * 10
			End If
		EndIf
		'Iterate along bottom of room.
		If _level.lmap(col, dd2).terrid = tfloor Then
			'Add door.
			_level.lmap(col, dd2).terrid = tdoorclosed
			'Check to see if door is locked.
			roll = RandomRange(0, maxlevel * 2)
		   _level.lmap(col, dd1).doorinfo.locked = (roll < _level.numlevel)
			If _level.lmap(col, dd2).doorinfo.locked = TRUE Then
			   _level.lmap(col, dd2).doorinfo.lockdr = _level.numlevel
			   _level.lmap(col, dd2).doorinfo.dstr = _level.numlevel * 10
			End If
		End If
	Next
	'Iterate along left side of room.
	For row = _rooms(i).tl.y To _rooms(i).br.y
		dd1 = _rooms(i).tl.x
		dd2 = _rooms(i).br.x
		If _level.lmap(dd1, row).terrid = tfloor Then
			'Add door.
			_level.lmap(dd1, row).terrid = tdoorclosed
			'Check to see if door is locked.
			roll = RandomRange(0, maxlevel * 2)
		   _level.lmap(col, dd1).doorinfo.locked = (roll < _level.numlevel)
			If _level.lmap(dd1, row).doorinfo.locked = TRUE Then
			   _level.lmap(dd1, row).doorinfo.lockdr = _level.numlevel
			   _level.lmap(dd1, row).doorinfo.dstr = _level.numlevel * 10
			End If
		End If
		'Iterate along right side of room.
		If _level.lmap(dd2, row).terrid = tfloor Then
			'Add door.
			_level.lmap(dd2, row).terrid = tdoorclosed
			'Check to see if door is locked.
			roll = RandomRange(0, maxlevel * 2)
		   _level.lmap(col, dd1).doorinfo.locked = (roll < _level.numlevel)
			If _level.lmap(dd2, row).doorinfo.locked = TRUE Then
			   _level.lmap(dd2, row).doorinfo.lockdr = _level.numlevel
			   _level.lmap(dd2, row).doorinfo.dstr = _level.numlevel * 10
			End If
		EndIf
	Next
	
End Sub

'Adds doors to rooms.
Sub levelobj._AddDoors()
    For i As Integer = 1 To _numrooms
        _AddDoorsToRoom i
    Next
End Sub

'Transfer grid data to map array.
Sub levelobj._DrawMapToArray()
	Dim As Integer i, x, y, pr, rr, rl, ru, kr, nid, moncnt, tcnt
	Dim As mcoord ncoord
	
	'Draw the first room to map array
	For x = _rooms(1).tl.x + 1 To _rooms(1).br.x - 1
		For y = _rooms(1).tl.y + 1 To _rooms(1).br.y - 1
			_level.lmap(x, y).terrid = tfloor
		Next
	Next
	'Draw the rest of the rooms to the map array and connect them.
	For i = 2 To _numrooms
		For x = _rooms(i).tl.x + 1 To _rooms(i).br.x - 1
			For y = _rooms(i).tl.y + 1 To _rooms(i).br.y - 1
				_level.lmap(x, y).terrid = tfloor
			Next
		Next
		'Get room center.
  	   ncoord.x = _rooms(i).roomdim.rcoord.x + 1
  	   ncoord.y = _rooms(i).roomdim.rcoord.y + 1
  	   'Add a monster to the room.
      If RandomRange(0, _level.numlevel) <= _level.numlevel Then
         moncnt += 1
         If moncnt <= nroommax Then
  	         _level.nummon = moncnt
  	         GenerateMonster _level.moninfo(_level.nummon), _level.numlevel
  	         _level.lmap(ncoord.x, ncoord.y).monidx = _level.nummon
  	         _level.moninfo(_level.nummon).currcoord = ncoord
         End If 
  	   End If
		_ConnectRooms i, i - 1
	Next
	'Add doors to selected rooms.
	_AddDoors
	'Set up player location.
	x = _rooms(1).roomdim.rcoord.x + (_rooms(1).roomdim.rwidth \ 2) 
	y = _rooms(1).roomdim.rcoord.y + (_rooms(1).roomdim.rheight \ 2)
	pchar.Locx = x - 1
	pchar.Locy = y - 1
	'Set up the stairs up.
	_level.lmap(pchar.Locx, pchar.Locy).terrid = tstairup
	'Add wandering merchant.
	_level.lmap(pchar.Locx - 1, pchar.Locy).terrid = twmerch
	'Set up stairs down in last room.
	If _level.numlevel < maxlevel Then
	   x = _rooms(_numrooms).roomdim.rcoord.x + (_rooms(_numrooms).roomdim.rwidth \ 2) 
	   y = _rooms(_numrooms).roomdim.rcoord.y + (_rooms(_numrooms).roomdim.rheight \ 2)
	   _level.lmap(x - 1, y - 1).terrid = tstairdn
	Else
	   'Don't add a duplicate amulet. 
	   If pchar.HasAmulet = FALSE Then
	      'Set amulet location.
	      x = _rooms(_numrooms).roomdim.rcoord.x + (_rooms(_numrooms).roomdim.rwidth \ 2) 
	      y = _rooms(_numrooms).roomdim.rcoord.y + (_rooms(_numrooms).roomdim.rheight \ 2)
	      _level.lmap(x - 1, y - 1).terrid = tamulet
	   End If
	End If
	'Add some traps to the level.
	tcnt = _level.numlevel / 10
	'Add at least one trap.
	If tcnt < 1 Then tcnt = 1
	'Add in the traps.
	For i = 1 To tcnt
	   x = RandomRange(2, mapw - 1)
	   y = RandomRange(2, maph - 1)
	   'See if we have a floor tile.
	   If _level.lmap(pchar.Locx, pchar.Locy).terrid = tfloor Then
	      _BuildTrap _level.lmap(pchar.Locx, pchar.Locy).trap
	   EndIf
	Next
End Sub

'Generate items for the map.
Sub levelobj._GenerateItems()
   Dim As Integer i, x, y
   
	'Generate some items for the level. 
	For i = 1 To 10
	   Do
	      'Get a spot in the dungeon.
	      x = RandomRange(2, mapw - 1)
	      y = RandomRange(2, maph - 1)
	   'Look for floor tile that doesn't have an item on it.
	   Loop Until (_level.lmap(x, y).terrid = tfloor) And (HasItem(x, y) = FALSE)
	   'Check for amulet.
	   If pchar.HasAmulet = FALSE Then
	      GenerateItem _level.linv(x, y), _level.numlevel
	   Else
	      GenerateItem _level.linv(x, y), maxlevel
	   End If
	Next
   
End Sub

'Generate a new dungeon level.
Sub levelobj.GenerateDungeonLevel()
	Dim As Integer x, y, i
   
	'Clear level
	For x = 1 To mapw
		For y = 1 To maph
			_level.lmap(x, y).terrid = twall           'Set tile to wall.
			_level.lmap(x, y).visible = FALSE          'Not visible.
			_level.lmap(x, y).seen = FALSE             'Not seen.
			_level.lmap(x, y).monidx = 0               'No monster.
			_level.lmap(x, y).doorinfo.locked = FALSE  'Door not locked.
			_level.lmap(x, y).doorinfo.lockdr = 0      'No lock DR.
			_level.lmap(x, y).doorinfo.dstr = 0        'No door strength.
			_level.nummon = 0                          'Set monster count to 0.
			ClearInv _level.linv(x,y)                  'Clear inventory slot.
         _level.lmap(x, y).trap.id = trpNone        'Clear trap data.
         _level.lmap(x, y).trap.icon = ""     
         _level.lmap(x, y).trap.iconcolor = fbBlack  
         _level.lmap(x, y).trap.desc = ""    
         _level.lmap(x, y).trap.sprung = FALSE      
         _level.lmap(x, y).trap.dr = 0          
         _level.lmap(x, y).trap.dam = 0         
         _level.lmap(x, y).trap.damtype = wdNone 
		Next
	Next
	_InitGrid
	_DrawMapToArray
	_GenerateItems
End Sub

'Sets the tile at x, y of map.
Sub levelobj.SetTile(x As Integer, y As Integer, tileid As terrainids)
   _level.lmap(x, y).terrid = tileid
End Sub

'Adds item from map to passed inventory type.
Sub levelobj.GetItemFromMap(x As Integer, y As Integer, inv As invtype)
   If inv.classid <> clNone Then
      ClearInv inv
   EndIf
   inv = _level.linv(x, y)
   ClearInv _level.linv(x, y)
End Sub

'Puts an item from passed inventory type to map.
Sub levelobj.PutItemOnMap(x As Integer, y As Integer, inv As invtype)
   ClearInv _level.linv(x, y)
   _level.linv(x, y) = inv
End Sub

'Moves all living monsters.
Sub levelobj.MoveMonsters ()
   Dim As mcoord nxt
   Dim As Integer pdist, croll, aroll
         
   'Iterate through each monster.
   For i As Integer = 1 To _level.nummon
      'Make sure monster is not dead.
      If (_level.moninfo(i).isdead = FALSE) And _
         (_level.moninfo(i).effects(meStun).cnt < 1) And _
         (_level.moninfo(i).effects(meBlind).cnt < 1) And _
         (_level.moninfo(i).effects(meEntangle).cnt < 1) And _
         (_level.moninfo(i).effects(meIceStatue).cnt < 1) And _
         (_level.moninfo(i).effects(meConfuse).cnt < 1) Then
         'Is the monster fleeing?
         If _level.moninfo(i).flee = FALSE Then
            'Is the character in line of sight?
            If  _level.lmap(_level.moninfo(i).currcoord.x, _level.moninfo(i).currcoord.y).visible = TRUE Then
               'Set the sighted flag.
               _level.moninfo(i).psighted = TRUE
               'Set the character location.
               _level.moninfo(i).plastloc.x = pchar.Locx
               _level.moninfo(i).plastloc.y = pchar.Locy
               'Check the distance to character.
               pdist = CalcDist(_level.moninfo(i).currcoord.x, pchar.Locx, _level.moninfo(i).currcoord.y, pchar.Locy)
               'Check the attack range of monster.
               If pdist <= _level.moninfo(i).atkrange Then
                  'If magic check for spell cast.
                  If _level.moninfo(i).ismagic = TRUE Then
                     'Get the rolls for the attack.
                     croll = RandomRange(1, _level.moninfo(i).spell.dam)
                     aroll = RandomRange(0, _level.moninfo(i).atkdam) 
                     'Cast spell if magic roll higher.
                     If  croll > aroll Then
                        CastSpell(_level.moninfo(i).currcoord.x, _level.moninfo(i).currcoord.y)
                     Else
                        'Attack character.
                        MonsterAttack _level.moninfo(i).currcoord.x, _level.moninfo(i).currcoord.y
                     EndIf
                  Else
                     'Not magic, just attack.
                     MonsterAttack _level.moninfo(i).currcoord.x, _level.moninfo(i).currcoord.y
                  End If
               Else
                  'Is monster magic.
                  If _level.moninfo(i).ismagic = TRUE Then
                     'Get the rolls for the attack.
                     croll = RandomRange(1, _level.moninfo(i).spell.dam)
                     aroll = RandomRange(0, _level.moninfo(i).atkdam) 
                     'Cast spell if magic roll higher otherwise move toward player.
                     If croll > aroll Then
                        CastSpell(_level.moninfo(i).currcoord.x, _level.moninfo(i).currcoord.y)
                     Else
                        'Get the next closest tile to player.
                        nxt = _GetNextTile(_level.moninfo(i).currcoord.x, _level.moninfo(i).currcoord.y, pchar.Locx, pchar.Locy)
                        'Set the new coords for monster.
                        _level.lmap(_level.moninfo(i).currcoord.x, _level.moninfo(i).currcoord.y).monidx = 0
                        _level.lmap(nxt.x, nxt.y).monidx = i
                        _level.moninfo(i).currcoord = nxt
                     EndIf
                  Else
                     'Get the next closest tile to player.
                     nxt = _GetNextTile(_level.moninfo(i).currcoord.x, _level.moninfo(i).currcoord.y, pchar.Locx, pchar.Locy)
                     'Set the new coords for monster.
                     _level.lmap(_level.moninfo(i).currcoord.x, _level.moninfo(i).currcoord.y).monidx = 0
                     _level.lmap(nxt.x, nxt.y).monidx = i
                     _level.moninfo(i).currcoord = nxt
                  End If
               End If   
            Else
               'Character not in line of sight. Was player sighted.
               If _level.moninfo(i).psighted = TRUE Then
                  'Make sure we have a location.
                  If (_level.moninfo(i).plastloc.x > -1) And (_level.moninfo(i).plastloc.y > -1) Then 
                     'Move toward last sighted position.
                     nxt = _GetNextTile(_level.moninfo(i).currcoord.x, _level.moninfo(i).currcoord.y, _level.moninfo(i).plastloc.x, _level.moninfo(i).plastloc.y)
                     'Set the new monster coordinates.
                     _level.lmap(_level.moninfo(i).currcoord.x, _level.moninfo(i).currcoord.y).monidx = 0
                     _level.lmap(nxt.x, nxt.y).monidx = i
                     _level.moninfo(i).currcoord = nxt
                     'Are we at the character last coordinates?
                     If (nxt.x = _level.moninfo(i).plastloc.x) And (nxt.y = _level.moninfo(i).plastloc.y) Then
                        'Reset monster target.
                        _level.moninfo(i).psighted = FALSE
                        _level.moninfo(i).plastloc.x = -1
                        _level.moninfo(i).plastloc.y = -1
                     EndIf
                  Else
                     'Lost sight of character so reset monster target.
                     _level.moninfo(i).psighted = FALSE
                     _level.moninfo(i).plastloc.x = -1
                     _level.moninfo(i).plastloc.y = -1
                  End If
               Else
                  'Check sound map here.
                  If _level.lmap(_level.moninfo(i).currcoord.x, _level.moninfo(i).currcoord.y).sndvol > 0 Then
                     nxt = _GetNextSndTile(_level.moninfo(i).currcoord.x, _level.moninfo(i).currcoord.y)
                     'Set the new monster coordinates.
                     _level.lmap(_level.moninfo(i).currcoord.x, _level.moninfo(i).currcoord.y).monidx = 0
                     _level.lmap(nxt.x, nxt.y).monidx = i
                     _level.moninfo(i).currcoord = nxt
                  EndIf
               EndIf
            EndIf
         Else
            If (_level.moninfo(i).psighted = TRUE) Or (_level.lmap(_level.moninfo(i).currcoord.x, _level.moninfo(i).currcoord.y).visible = TRUE) Then
               'Move away from the character.
               nxt = _GetNextTile(_level.moninfo(i).currcoord.x, _level.moninfo(i).currcoord.y, pchar.Locx, pchar.Locy, TRUE)
               'Set the new monster coordinates.
               _level.lmap(_level.moninfo(i).currcoord.x, _level.moninfo(i).currcoord.y).monidx = 0
               _level.lmap(nxt.x, nxt.y).monidx = i
               _level.moninfo(i).currcoord = nxt
               'Check the distance to character.
               pdist = CalcDist(_level.moninfo(i).currcoord.x, pchar.Locx, _level.moninfo(i).currcoord.y, pchar.Locy)
               'Check the attack range of monster.
               If pdist <= _level.moninfo(i).atkrange Then
                  'Attack character.
                  MonsterAttack _level.moninfo(i).currcoord.x, _level.moninfo(i).currcoord.y
               EndIf
            End If
         End If
      EndIf
   Next
   
End Sub

'Clears the current sound map.
Sub levelobj.ClearSoundMap()
   For x As Integer = 1 To mapw
      For y As Integer = 1 To maph
         _level.lmap(x, y).sndvol = 0
      Next
   Next
End Sub

'Generate the sound map using the passed noise factor.
Sub levelobj.GenSoundMap(x As Integer, y As Integer, sndvol As Integer)
    Dim csound As Integer
    Dim sdist As Integer
    
    'Set up exit conditions.
    If x < 0 Or x > mapw Then Exit Sub
    If y < 0 Or y > mapw Then Exit Sub
    If sndvol <= 0 Then Exit Sub
    If _BlockingTile(x, y) Then Exit Sub
    If _level.lmap(x, y).sndvol > 0 Then Exit Sub
    'Attenuate the sound using square of distance.
    sdist = CalcDist(pchar.Locx, x, pchar.Locy, y)
    csound = sndvol - (sdist * sdist)
    'No sound so exit.
    If csound <= 0 Then Exit Sub
    'Recursively call the routine to build the map.
    _level.lmap(x, y).sndvol = csound
    GenSoundMap x+1, y, csound
    GenSoundMap x, y+1, csound
    GenSoundMap x-1, y, csound 
    GenSoundMap x, y-1, csound 
    GenSoundMap x+1, y+1, csound 
    GenSoundMap x-1, y+1, csound 
    GenSoundMap x-1, y-1, csound 
    GenSoundMap x+1, y-1,  csound
End Sub

'Monster attacks character.
Sub levelobj.MonsterAttack(mx As Integer, my As Integer)
   Dim As Integer midx, cd, mc, rollc, rollm, chp, dam
   Dim As String txt
   Dim As Single arm
   
   'Make sure there is a monster here.
   If (_level.lmap(mx, my).monidx > 0) And (pchar.BlinkActive = FALSE) Then
      midx = _level.lmap(mx, my).monidx
      'Get character defense factor.
      cd = pchar.GetDefenseFactor()
      'Get monster attack factor.
      mc = _level.moninfo(midx).cf
      'Get the rolls.
      rollc = RandomRange(1, cd)
      rollm = RandomRange(1, mc)
      'Compare monster roll to character roll.
      If rollm > rollc Then
         'Get the damage.
         dam = _level.moninfo(midx).atkdam
         'Get any shield values if any.
         arm = pchar.GetShieldArmorValue(_level.moninfo(midx).damtype)
         'Make sure the character has some armor.
         If arm > 0 Then
            dam = dam - (dam * arm)
         End If
         'Get the character armor value.
         arm = pchar.GetArmorValue (_level.moninfo(midx).damtype)
         'Make sure the character has some armor.
         If arm > 0 Then
            dam = dam - (dam * arm)
         End If
         'Get character hp.
         chp = pchar.CurrHP
         'Subtract damage from it.
         chp -= dam
         If chp < 0 Then chp = 0
         'Reset character hp.
         pchar.CurrHP = chp
         txt = "The " &  _level.moninfo(midx).mname & " hits for " & dam & " " & _level.moninfo(midx).damstr & " damage points."
         'Set the last monster attack.
         _level.lastmon.mname = _level.moninfo(midx).mname
      Else
         txt = "The " &  _level.moninfo(midx).mname & " misses."
      EndIf
      PrintMessage txt
   End If   
End Sub

'Monster casts spell.
Sub levelobj.CastSpell(mx As Integer, my As Integer)
   Dim As Integer midx, cd, mc, rollc, rollm, chp, dam
   Dim As String txt
   Dim As Single arm
   Dim As weapdamtype damtype
   
   'Make sure there is a monster here.
   If (_level.lmap(mx, my).monidx > 0) And (pchar.BlinkActive = FALSE) Then
      midx = _level.lmap(mx, my).monidx
      'Get character defense factor.
      cd = pchar.GetMagicDefenseFactor()
      'Get monster attack factor.
      mc = _level.moninfo(midx).mf
      'Get the rolls.
      rollc = RandomRange(1, cd)
      rollm = RandomRange(1, mc)
      'Compare monster roll to character roll.
      If rollm > rollc Then
         'If poison attack, poison character.
         If _level.moninfo(midx).spell.id = splMonPoison Then
            pchar.Poisoned = TRUE
            pchar.PoisonStr = _level.moninfo(midx).spell.lvl
            PrintMessage "You are poisoned."
         EndIf
         'Get the damage.
         dam = _level.moninfo(midx).spell.dam
         damtype = GetMonSpellEffect(_level.moninfo(midx).spell.id)
         'Get any shield values if any.
         arm = pchar.GetShieldArmorValue(damtype)
         'Make sure the character has some armor.
         If arm > 0 Then
            dam = dam - (dam * arm)
         End If
         'Get the character armor value.
         arm = pchar.GetArmorValue(damtype)
         'Make sure the character has some armor.
         If arm > 0 Then
            dam = dam - (dam * arm)
         End If
         'Get character hp.
         chp = pchar.CurrHP
         'Subtract damage from it.
         chp -= dam
         If chp < 0 Then chp = 0
         'Reset character hp.
         pchar.CurrHP = chp
         txt = "The " &  _level.moninfo(midx).mname & " casts " & GetSpellName(_level.moninfo(midx).spell.id) & " for " & dam & " " & _level.moninfo(midx).damstr & " damage points."
      Else
         txt = "You dispell the " &  GetSpellName(_level.moninfo(midx).spell.id) & " cast by the " & _level.moninfo(midx).mname & "."
      EndIf
      PrintMessage txt
   End If   
End Sub

'Sets target map at x, y.
Sub levelobj.SetTarget(x As Integer, y As Integer, id As Integer, tcolor As UInteger = fbBlack) 
   _level.lmap(x, y).target.id = id
   _level.lmap(x, y).target.tcolor = tcolor
End Sub

'Animates projectile.
Sub levelobj.AnimateProjectile (source As vec, target As vec)
   Dim As Integer x = source.vx, y = source.vy, d = 0, dx = target.vx - source.vx 
   Dim As Integer dy = target.vy - source.vy, c, m, xinc = 1, yinc = 1
   Dim As Integer delay = 10
   
   If dx < 0 Then
      xinc = -1
      dx = -dx
   EndIf
   If dy < 0 Then
      yinc = -1
      dy = -dy
   EndIf
   If dy < dx Then
      c = 2 * dx
      m = 2 * dy
      Do While x <> target.vx
         _level.lmap(x, y).target.id = 7
         _level.lmap(x, y).target.tcolor = fbYellow
         DrawMap
         Sleep delay
         _level.lmap(x, y).target.id = 0
         _level.lmap(x, y).target.tcolor = fbBlack
         DrawMap
         x += xinc
         d += m
         If d > dx Then
            y += yinc
            d -= c
         EndIf
      Loop
   Else
      c = 2 * dy
      m = 2 * dx
      Do While y <> target.vy
         _level.lmap(x, y).target.id = 7
         _level.lmap(x, y).target.tcolor = fbYellow
         DrawMap
         Sleep delay
         _level.lmap(x, y).target.id = 0
         _level.lmap(x, y).target.tcolor = fbBlack
         DrawMap
         y += yinc
         d += m
         If d > dy Then
            x += xinc
            d -= c
         EndIf
      Loop
   EndIf
   _level.lmap(x, y).target.id = 249
   _level.lmap(x, y).target.tcolor = fbYellow
   DrawMap
   Sleep delay
   _level.lmap(x, y).target.id = 0
   _level.lmap(x, y).target.tcolor = fbBlack
   DrawMap
End Sub

'Resolves any timed events.
Sub levelobj.DoTimedEvents()
   Dim As String txt
   Dim As Integer tmp
   
   'Iterate through each monster.
   For i As Integer = 1 To _level.nummon
      'Make sure monster is not dead.
      If _level.moninfo(i).isdead = FALSE Then
         'Examine each effect and apply any damages/effects.
         If _level.moninfo(i).effects(mePoison).cnt > 0 Then
            tmp = ApplyDamage(_level.moninfo(i).currcoord.x, _level.moninfo(i).currcoord.y, _level.moninfo(i).effects(mePoison).dam)  
            _level.moninfo(i).effects(mePoison).cnt -= 1
         Else
            _level.moninfo(i).mcolor = fbRedBright
         EndIf
         
         If _level.moninfo(i).effects(meFire).cnt > 0 Then
            tmp = ApplyDamage(_level.moninfo(i).currcoord.x, _level.moninfo(i).currcoord.y, _level.moninfo(i).effects(meFire).dam)
            _level.moninfo(i).effects(meFire).cnt -= 1
         Else
            _level.moninfo(i).mcolor = fbRedBright
         EndIf
         
         If _level.moninfo(i).effects(meStun).cnt > 0 Then
            tmp = ApplyDamage(_level.moninfo(i).currcoord.x, _level.moninfo(i).currcoord.y, _level.moninfo(i).effects(meStun).dam)
            _level.moninfo(i).effects(meStun).cnt -= 1
         Else
            _level.moninfo(i).mcolor = fbRedBright
         EndIf
         
         If _level.moninfo(i).effects(meAcidFog).cnt > 0 Then
            tmp = ApplyDamage(_level.moninfo(i).currcoord.x, _level.moninfo(i).currcoord.y, _level.moninfo(i).effects(meAcidFog).dam)
            _level.moninfo(i).effects(meAcidFog).cnt -= 1
         Else
            _level.moninfo(i).mcolor = fbRedBright
         EndIf
         
         If _level.moninfo(i).effects(meBlind).cnt > 0 Then
            tmp = ApplyDamage(_level.moninfo(i).currcoord.x, _level.moninfo(i).currcoord.y, _level.moninfo(i).effects(meBlind).dam)
            _level.moninfo(i).effects(meBlind).cnt -= 1
         Else
            _level.moninfo(i).mcolor = fbRedBright
         EndIf
         
         If _level.moninfo(i).effects(meFear).cnt > 0 Then
            tmp = ApplyDamage(_level.moninfo(i).currcoord.x, _level.moninfo(i).currcoord.y, _level.moninfo(i).effects(meFear).dam)
            _level.moninfo(i).flee = TRUE
            _level.moninfo(i).effects(meFear).cnt -= 1
            _level.moninfo(i).mcolor = fbMagenta
         Else
            _level.moninfo(i).flee = FALSE
         EndIf
         
         If _level.moninfo(i).effects(meConfuse).cnt > 0 Then
            tmp = ApplyDamage(_level.moninfo(i).currcoord.x, _level.moninfo(i).currcoord.y, _level.moninfo(i).effects(meConfuse).dam)
            _level.moninfo(i).effects(meConfuse).cnt -= 1
         Else
            _level.moninfo(i).mcolor = fbRedBright
         EndIf
         
         If _level.moninfo(i).effects(meEntangle).cnt > 0 Then
            tmp = ApplyDamage(_level.moninfo(i).currcoord.x, _level.moninfo(i).currcoord.y, _level.moninfo(i).effects(meEntangle).dam)
            _level.moninfo(i).effects(meEntangle).cnt -= 1
         Else
            _level.moninfo(i).mcolor = fbRedBright
         EndIf
         
         If _level.moninfo(i).effects(meCloudMind).cnt > 0 Then
            tmp = ApplyDamage(_level.moninfo(i).currcoord.x, _level.moninfo(i).currcoord.y, _level.moninfo(i).effects(meCloudMind).dam)
            _level.moninfo(i).effects(meCloudMind).cnt -= 1
         Else
            _level.moninfo(i).mcolor = fbRedBright
         EndIf
         
         If _level.moninfo(i).effects(meMagicDrain).cnt > 0 Then
            tmp = ApplyDamage(_level.moninfo(i).currcoord.x, _level.moninfo(i).currcoord.y, _level.moninfo(i).effects(meMagicDrain).dam)
            'Get the percentage totals.
            tmp = _level.moninfo(i).md * (_level.moninfo(i).effects(meMagicDrain).lvl / 100)
            'Subtract from monster.
            _level.moninfo(i).md = _level.moninfo(i).md - tmp
            If _level.moninfo(i).md < 1 Then _level.moninfo(i).md = 1
            'Add the character.
            pchar.BonMdf = tmp
            pchar.BonMdfCnt = 1 
            _level.moninfo(i).effects(meMagicDrain).cnt -= 1
         Else
            _level.moninfo(i).mcolor = fbRedBright
            'Restore monster total.
            _level.moninfo(i).md = _level.moninfo(i).mdtot
         EndIf
         
         If _level.moninfo(i).effects(meEnfeeble).cnt > 0 Then
            tmp = ApplyDamage(_level.moninfo(i).currcoord.x, _level.moninfo(i).currcoord.y, _level.moninfo(i).effects(meEnfeeble).dam)
            'Lower all combat totals.
            tmp = _level.moninfo(i).cd * (_level.moninfo(i).effects(meEnfeeble).lvl / 100)
            _level.moninfo(i).cd = _level.moninfo(i).cd - tmp
            If _level.moninfo(i).cd < 1 Then _level.moninfo(i).cd = 1
            tmp = _level.moninfo(i).md * (_level.moninfo(i).effects(meEnfeeble).lvl / 100)
            _level.moninfo(i).md = _level.moninfo(i).md - tmp
            If _level.moninfo(i).md < 1 Then _level.moninfo(i).md = 1
            tmp = _level.moninfo(i).mf * (_level.moninfo(i).effects(meEnfeeble).lvl / 100)
            _level.moninfo(i).mf = _level.moninfo(i).mf - tmp
            If _level.moninfo(i).mf < 1 Then _level.moninfo(i).mf = 1
            tmp = _level.moninfo(i).cf * (_level.moninfo(i).effects(meEnfeeble).lvl / 100)
            _level.moninfo(i).cf = _level.moninfo(i).cf - tmp
            If _level.moninfo(i).cf < 1 Then _level.moninfo(i).cf = 1
            _level.moninfo(i).effects(meEnfeeble).cnt -= 1
         Else
            _level.moninfo(i).mcolor = fbRedBright
            'Restore totals.
            _level.moninfo(i).cd = _level.moninfo(i).cdtot
            _level.moninfo(i).cf = _level.moninfo(i).cftot 
            _level.moninfo(i).md = _level.moninfo(i).mdtot 
            _level.moninfo(i).mf = _level.moninfo(i).mftot
         EndIf
         
         If _level.moninfo(i).effects(meIceStatue).cnt > 0 Then
            _level.moninfo(i).effects(meIceStatue).cnt -= 1
         Else
            _level.moninfo(i).mcolor = fbRedBright
         EndIf
         
         If _level.moninfo(i).effects(meMDF).cnt > 0 Then
            _level.moninfo(i).currhp -= _level.moninfo(i).effects(meMDF).dam
            tmp = _level.moninfo(i).md * (_level.moninfo(i).effects(meMDF).lvl / 100)
            _level.moninfo(i).md = _level.moninfo(i).md - tmp
            If _level.moninfo(i).md < 1 Then _level.moninfo(i).md = 1
            _level.moninfo(i).effects(meMDF).cnt -= 1
         Else
            _level.moninfo(i).mcolor = fbRedBright
            _level.moninfo(i).md = _level.moninfo(i).mdtot 
         EndIf
         
         If _level.moninfo(i).effects(meMCF).cnt > 0 Then
            _level.moninfo(i).currhp -= _level.moninfo(i).effects(meMCF).dam
            tmp = _level.moninfo(i).mf * (_level.moninfo(i).effects(meMCF).lvl / 100)
            _level.moninfo(i).mf = _level.moninfo(i).mf - tmp
            If _level.moninfo(i).mf < 1 Then _level.moninfo(i).mf = 1
            _level.moninfo(i).effects(meMCF).cnt -= 1
         Else
            _level.moninfo(i).mf = _level.moninfo(i).mftot
            _level.moninfo(i).mcolor = fbRedBright
         EndIf
      EndIf
   Next
End Sub

'Checks to see if x, y has amulet.
Sub levelobj.IsAmulet(x As Integer, y As Integer)
   
   'Check the location for the amulet.
   If _level.lmap(x, y).terrid = tamulet Then
      'Set the amulet flag.
      pchar.HasAmulet = TRUE
      'Reset the map.
      _level.lmap(x, y).terrid = tfloor
      'Tell the player they found the amulet.
      PrintMessage "You found the Amulet of Crystal Fire!"
   EndIf
   
End Sub

'Applies spell to monster.
Function levelobj.ApplySpell(spl As spelltype, mx As Integer, my As Integer) As Integer
   Dim As Integer ret, midx, tmp, dam
   Dim stat As monStats
   Dim As String txt
   Dim As Single pct, armfact
   Dim vm As vec
   
   'Make sure there is a monster here.
   If _level.lmap(mx, my).monidx > 0 Then
      'Get the monster index.
      midx = _level.lmap(mx, my).monidx
      'Get the armor factor.
      armfact = _level.moninfo(midx).armval
      'Calc the damage.
      dam = armfact * spl.dam
      If dam < 1 Then dam = 1
      'Set the monster flags based on spell.
      Select Case spl.id
         Case splSerpentBite 'Weapon: Inflict poison damage.
            ret = ApplyDamage(mx, my, dam)
            'If not dead set the timed flag.
            If ret = FALSE Then
               _level.moninfo(midx).effects(mePoison).cnt = spl.lvl
               _level.moninfo(midx).effects(mePoison).dam = dam
            EndIf
            txt = "Sperpent Bite Spell does " & dam & " to " & _level.moninfo(midx).mname & "."
            PrintMessage txt
            _level.moninfo(midx).mcolor = fbMagenta
         Case splRend        'Weapon: Decrease armor of target.
            _level.moninfo(midx).armval = _level.moninfo(midx).armval - (dam / maxlevel)
            If _level.moninfo(midx).armval < 0.0 Then
               _level.moninfo(midx).armval = 0.0
            EndIf
            txt = "Rend Spell reduces armor to  " & _level.moninfo(midx).armval & " for " & _level.moninfo(midx).mname & "."
            PrintMessage txt
            _level.moninfo(midx).mcolor = fbMagenta
         Case splSunder      'Weapon: Decrease target weapon damage.
            _level.moninfo(midx).atkdam = _level.moninfo(midx).atkdam - dam
            If _level.moninfo(midx).atkdam < 1 Then
               _level.moninfo(midx).atkdam = 1
            EndIf
            txt = "Sunder Spell reduces attack damage to  " & _level.moninfo(midx).atkdam & " for " & _level.moninfo(midx).mname & "."
            PrintMessage txt
            _level.moninfo(midx).mcolor = fbMagenta
         Case splReaper 'Weapon: Causes monster to flee.
            _level.moninfo(midx).flee = TRUE
            txt = "Reaper Spell is making " & _level.moninfo(midx).mname & " flee."
            PrintMessage txt
            _level.moninfo(midx).mcolor = fbMagenta
         Case splFire        'Weapon: Does fire damage to target for lvl turns.
            ret = ApplyDamage(mx, my, dam)
            'If not dead set the timed flag.
            If ret = FALSE Then
               _level.moninfo(midx).effects(meFire).cnt = spl.lvl
               _level.moninfo(midx).effects(meFire).dam = dam
            EndIf
            txt = "Fire Spell inflicted  " & dam & " to " & _level.moninfo(midx).mname & "."
            PrintMessage txt
            _level.moninfo(midx).mcolor = fbMagenta
         Case splStun        'Weapon: Stuns target for lvl turns.
            _level.moninfo(midx).effects(meStun).cnt = spl.lvl
            _level.moninfo(midx).effects(meStun).dam = 0
            txt = "Stun Spell stunned " & _level.moninfo(midx).mname & " for " & spl.lvl & " turns."
            PrintMessage txt
            _level.moninfo(midx).mcolor = fbMagenta
         Case splChaos       'Weapon: Random amount of additonal damage.
            ret = ApplyDamage(mx, my, dam)
            txt = "Chaos Spell inflicted  " & dam & " additional damage to " & _level.moninfo(midx).mname & "."
            PrintMessage txt
            _level.moninfo(midx).mcolor = fbMagenta
         Case splWraith      'Weapon: Decreases random stat of target.
            'Get the stat.
            stat = RandomRange(CombatFactor, MagicDefense)
            Select Case stat
               Case CombatFactor
                  _level.moninfo(midx).cf = _level.moninfo(midx).cf - dam
                  If _level.moninfo(midx).cf < 0 Then
                     _level.moninfo(midx).cf = 1
                  EndIf
                  txt = "Wraith Spell reduced " & _level.moninfo(midx).mname & " combat factor by " & dam & "."
                  PrintMessage txt
                  _level.moninfo(midx).mcolor = fbMagenta
               Case CombatDefense
                  _level.moninfo(midx).cd = _level.moninfo(midx).cd - dam
                  If _level.moninfo(midx).cd < 0 Then
                     _level.moninfo(midx).cd = 1
                  EndIf
                  txt = "Wraith Spell reduced " & _level.moninfo(midx).mname & " combat defense by " & dam & "."
                  PrintMessage txt
                  _level.moninfo(midx).mcolor = fbMagenta
               Case MagicCombat
                  _level.moninfo(midx).mf = _level.moninfo(midx).mf - dam
                  If _level.moninfo(midx).mf < 0 Then
                     _level.moninfo(midx).mf = 1
                  EndIf
                  txt = "Wraith Spell reduced " & _level.moninfo(midx).mname & " magic combat by " & dam & "."
                  PrintMessage txt
                  _level.moninfo(midx).mcolor = fbMagenta
               Case MagicDefense
                  _level.moninfo(midx).md = _level.moninfo(midx).md - dam
                  If _level.moninfo(midx).md < 0 Then
                     _level.moninfo(midx).md = 1
                  EndIf
                  txt = "Wraith Spell reduced " & _level.moninfo(midx).mname & " magic defense by " & dam & "."
                  PrintMessage txt
                  _level.moninfo(midx).mcolor = fbMagenta
            End Select
         Case splStealHealth
            ret = ApplyDamage(mx, my, dam)
            pchar.CurrHP = pchar.CurrHP + dam
            txt = "Steal Health Spell stole  " & dam & " health from " & _level.moninfo(midx).mname & "."
            PrintMessage txt
            _level.moninfo(midx).mcolor = fbMagenta
         Case splLightning
            ret = ApplyDamage(mx, my, spl.dam)
            txt = "Lightning Spell inflicted  " & spl.dam & " damage to " & _level.moninfo(midx).mname & "."
            PrintMessage txt
            _level.moninfo(midx).mcolor = fbMagenta
         Case splAcidFog     'Spellbook: 5 dam over lvl turns
            ret = ApplyDamage(mx, my, dam)
            'If not dead set the timed flag.
            If ret = FALSE Then
               _level.moninfo(midx).effects(meAcidFog).cnt = spl.lvl
               _level.moninfo(midx).effects(meAcidFog).dam = dam
            End If
            txt = "Acid Fog Spell inflicted  " & dam & " damage to " & _level.moninfo(midx).mname & " for " & spl.lvl & " turns."
            PrintMessage txt
            _level.moninfo(midx).mcolor = fbMagenta
         Case splFireCloak   'Spellbook: Target gets 10 dam over lvl turns
            ret = ApplyDamage(mx, my, dam)
            'If not dead set the timed flag.
            If ret = FALSE Then
               _level.moninfo(midx).effects(meFire).cnt = spl.lvl
               _level.moninfo(midx).effects(meFire).dam = dam
            End If
            txt = "Fire Cloak Spell inflicted  " & dam & " damage to " & _level.moninfo(midx).mname & " for " & spl.lvl & " turns."
            PrintMessage txt
            _level.moninfo(midx).mcolor = fbMagenta
         Case splBlind       'Spellbook: Blinds target for lvl turns
            txt = _level.moninfo(midx).mname & " is blinded for " & spl.lvl & " turns."
            _level.moninfo(midx).effects(meBlind).cnt = spl.lvl
            _level.moninfo(midx).effects(meBlind).dam = dam
            PrintMessage txt
            _level.moninfo(midx).mcolor = fbMagenta
         Case splFear        'Spellbook: Makes monster flee for lvl turns.
            txt = _level.moninfo(midx).mname & " is filled with fear for " & spl.lvl & " turns."
            _level.moninfo(midx).effects(meFear).cnt = spl.lvl
            _level.moninfo(midx).effects(meFear).dam = dam
            PrintMessage txt
            _level.moninfo(midx).mcolor = fbMagenta
         Case splConfuse     'Spellbook: Confuses monster for lvl turns.
            txt = _level.moninfo(midx).mname & " is confused for " & spl.lvl & " turns."
            _level.moninfo(midx).effects(meConfuse).cnt = spl.lvl
            _level.moninfo(midx).effects(meConfuse).dam = spl.lvl
            PrintMessage txt
            _level.moninfo(midx).mcolor = fbMagenta
         Case splFireBomb, splFireBall    'Spellbook: Area damage 20 (or 10) x lvl. Sets monsters on fire lvl turns.
            'Check to make sure monster isn't already on fire. 'Prevents infinite loop.
            If _level.moninfo(midx).effects(meFire).cnt < 1 Then
               ret = ApplyDamage(mx, my, dam * spl.lvl)
               'If not dead set the timed flag.
               If ret = FALSE Then
                  _level.moninfo(midx).effects(meFire).cnt = spl.lvl
                  _level.moninfo(midx).effects(meFire).dam = dam
               End If
               'Check for spell type.
               If spl.id = splFireBomb Then
                  txt = "Fire Bomb Spell inflicted  " & dam & " damage to " & _level.moninfo(midx).mname & "."
               Else
                  txt = "Fire Ball Spell inflicted  " & dam & " damage to " & _level.moninfo(midx).mname & "."
               End If
               PrintMessage txt
               'We will call this recursively to hit any monsters next to target.
               'This will cause a chain reaction hitting all monsters next to
               'each other on the map.
               For i As compass = north To nwest
                  'Set ititial position.
                  vm.vx = mx
                  vm.vy = my
                  'Get new position.
                  vm += i
                  'Recusively call function.
                  tmp = ApplySpell(spl, vm.vx, vm.vy)
               Next
            Else
               txt = _level.moninfo(midx).mname & " is already on fire."
               PrintMessage txt
            _level.moninfo(midx).mcolor = fbMagenta
            End If
         Case splEntangle    'Spellbook: Immobilze target for lvel turns doing lvl damage each turn.
            ret = ApplyDamage(mx, my, dam)
            'If not dead set the timed flag.
            If ret = FALSE Then
               _level.moninfo(midx).effects(meEntangle).cnt = spl.lvl
               _level.moninfo(midx).effects(meEntangle).dam = dam
            End If
            txt = "Entangle Spell inflicted  " & dam & " damage to " & _level.moninfo(midx).mname & " for " & spl.lvl & " turns."
            PrintMessage txt
            _level.moninfo(midx).mcolor = fbMagenta
         Case splCloudMind   'Spellbook: Target cannot cast spells for lvl turns.
            txt = _level.moninfo(midx).mname & "mind is clouded for " & spl.lvl & " turns."
            _level.moninfo(midx).effects(meEntangle).cnt = spl.lvl
            _level.moninfo(midx).effects(meEntangle).dam = dam
            PrintMessage txt
            _level.moninfo(midx).mcolor = fbMagenta
         Case splIceStatue   'Spellbook: Freezes target for lvl turns. If frozen can be killed with single hit.
            _level.moninfo(midx).effects(meIceStatue).cnt = spl.lvl
            _level.moninfo(midx).effects(meIceStatue).dam = dam
            txt = _level.moninfo(midx).mname & " is frozen for " & spl.lvl & " turns."
            PrintMessage txt
            _level.moninfo(midx).mcolor = fbMagenta
         Case splRust        'Spellbook: Reduces armor by lvl x 10%.
            pct = spl.lvl * .10
            _level.moninfo(midx).armval = _level.moninfo(midx).armval - pct
            If _level.moninfo(midx).armval < 0.0 Then
               _level.moninfo(midx).armval = 0.0
            EndIf
            txt = _level.moninfo(midx).mname & " armor has been reduced."
            PrintMessage txt
            _level.moninfo(midx).mcolor = fbMagenta
         Case splShatter     'Spellbook: Destroys target weapon, if any.
            ret = ApplyDamage(mx, my, spl.lvl)
            'If not dead set the timed flag.
            If ret = FALSE Then
               _level.moninfo(midx).atkdam = 0
            End If
            txt = "Shatter Spell destroyed " & _level.moninfo(midx).mname & " attack ability."
            PrintMessage txt
            _level.moninfo(midx).mcolor = fbMagenta
         Case splMagicDrain  'Spellbook: Lower target MDF by lvl% and adds to caster for 1 turn.
            _level.moninfo(midx).effects(meMDF).cnt = spl.lvl
            _level.moninfo(midx).effects(meMDF).dam = dam
            txt = "Magic Drain Spell has lowered " & _level.moninfo(midx).mname & " magic defense."
            PrintMessage txt
            _level.moninfo(midx).mcolor = fbMagenta
         Case splPoison      'Spellbook: Posions target 1 HP for lvl turns.
            ret = ApplyDamage(mx, my, dam)
            'If not dead set the timed flag.
            If ret = FALSE Then
               _level.moninfo(midx).effects(mePoison).cnt = spl.lvl
               _level.moninfo(midx).effects(mePoison).dam = dam
            EndIf
            txt = "Poison Spell has poisoned " & _level.moninfo(midx).mname & " for " & spl.lvl & " turns."
            PrintMessage txt
            _level.moninfo(midx).mcolor = fbMagenta
         Case splEnfeeble    'Spellbook: Lowers target combat factors lvl x 10%.
            _level.moninfo(midx).effects(meEnfeeble).cnt = spl.lvl
            _level.moninfo(midx).effects(meEnfeeble).dam = dam
            txt = "Enfeeble Spell has lowered " & _level.moninfo(midx).mname & " combat factors for " & spl.lvl & " turns."
            PrintMessage txt
            _level.moninfo(midx).mcolor = fbMagenta
         Case splShout       'Spellbook: Stuns all visible monsters for lvl turns.
            For i As Integer = 1 To _level.nummon
               If _level.moninfo(i).isdead = FALSE Then
                  If  _level.lmap(_level.moninfo(i).currcoord.x, _level.moninfo(i).currcoord.y).visible = TRUE Then
                     _level.moninfo(i).effects(meStun).cnt = spl.lvl
                     _level.moninfo(i).effects(meStun).dam = dam
                     txt = "Warrior Shout Spell has stunned " & _level.moninfo(i).mname & " for " & spl.lvl & " turns."
                     PrintMessage txt
                  EndIf
               End If
            Next
            _level.moninfo(midx).mcolor = fbMagenta
         Case splMindBlast   'Spellbook: Lowers target MCF and MDF lvl% for lvl turns.
            _level.moninfo(midx).effects(meMDF).cnt = spl.lvl
            _level.moninfo(midx).effects(meMDF).dam = dam
            _level.moninfo(midx).effects(meMCF).cnt = spl.lvl
            _level.moninfo(midx).effects(meMCF).dam = dam
            txt = "Mind Blast Spell has lowered " & _level.moninfo(midx).mname & " magic magic combat factors."
            PrintMessage txt
            _level.moninfo(midx).mcolor = fbMagenta
         Case splTeleport
            'Apply enough damage to kill any monster.
            ret = ApplyDamage(mx, my, 1000000)
            txt = "You tleported into " & _level.moninfo(midx).mname & " killing it."
            PrintMessage txt
      End Select
   End If
   
   Return ret
End Function

'Returns true of tile at x, y is blocking.
Function levelobj.IsBlocking(x As Integer, y As Integer) As Integer
   Return _BlockingTile(x, y)         
End Function

'Returns the tile id at x, y.
Function levelobj.GetTileID(x As Integer, y As Integer) As terrainids
   Return _level.lmap(x, y).terrid         
End Function

'Returns True if door is locked.
Function levelobj.IsDoorLocked(x As Integer,y As Integer) As Integer
   Return _level.lmap(x, y).doorinfo.locked
End Function

'Returns item description at coordinate.
Function levelobj.GetTerrainDescription(x As Integer, y As Integer) As String
   Return _GetTerrainDesc(x, y)
End Function

'Returns True if coordinate has item.
Function levelobj.HasItem(x As Integer, y As Integer) As Integer
      'Look at inventory slot. If no class id then slot empty.
      If _level.linv(x, y).classid = clNone Then
         Return FALSE
      Else
         Return TRUE
      EndIf
End Function

'Returns item description at x, y coordinate.
Function levelobj.GetItemDescription(x As Integer, y As Integer) As String
   Dim As String ret = "None"
   
   If _level.linv(x, y).classid <> clNone Then
      ret = GetInvItemDesc(_level.linv(x, y))
   EndIf
   
   Return ret
End Function

'Returns class id for inventory item at x, y.
Function levelobj.GetInvClassID(x As Integer, y As Integer) As classids
   Return _level.linv(x, y).classid
End Function

'Returns true if an empty spot is found and returns coords in vec.
Function levelobj.GetEmptySpot(v As vec) As Integer
   Dim As Integer ret = FALSE, hi
   Dim As vec ev
   Dim As terrainids tid
   
   'Check character spot.
   ev.vx = pchar.Locx
   ev.vy = pchar.Locy
   hi = HasItem(ev.vx, ev.vy) 
   If  hi = FALSE Then
      ret = TRUE
      v = ev
   Else
      'Check each tile around character.
      For i As compass = north To nwest
         ev.vx = pchar.Locx
         ev.vy = pchar.Locy
         ev += i
         'Get the tile type. 
         tid = GetTileID(ev.vx, ev.vy)
         'Check to see if it already has an item.
         hi = HasItem(ev.vx, ev.vy)
         'If floor and no item, found space.
         If (tid = tfloor) And (hi = FALSE) Then
            v = ev
            ret = TRUE
            Exit For
         EndIf
      Next
   EndIf
   
   Return ret
End Function

'Returns true if monster at location.
Function levelobj.IsMonster(x As Integer, y As Integer) As Integer
   Dim As Integer ret = FALSE
   
   If _level.lmap(x, y).monidx > 0 Then
      ret = TRUE
   EndIf
   
   Return ret
End Function

'Returns the defense factor of monster.
Function levelobj.GetMonsterDefense(mx As Integer, my As Integer) As Integer
   Dim As Integer ret = 0, midx = 0
   
   'Make sure there is a monster here.
   If _level.lmap(mx, my).monidx > 0 Then
      midx = _level.lmap(mx, my).monidx
      ret = _level.moninfo(midx).cd
   EndIf
   
   Return ret
End Function

'Returns the magic defense of the monster.
Function levelobj.GetMonsterMagicDefense(mx As Integer, my As Integer) As Integer
   Dim As Integer ret = 0, midx = 0
   
   'Make sure there is a monster here.
   If _level.lmap(mx, my).monidx > 0 Then
      midx = _level.lmap(mx, my).monidx
      ret = _level.moninfo(midx).md
   EndIf
   
   Return ret
End Function

'Returns the monster type.
Function levelobj.GetMonsterName(mx As Integer, my As Integer) As String
   Dim As String ret
   Dim As Integer midx
   
   'Make sure there is a monster here.
   If _level.lmap(mx, my).monidx > 0 Then
      midx = _level.lmap(mx, my).monidx
      ret = _level.moninfo(midx).mname
   EndIf
   
   Return ret
End Function

'Returns the monster armor rating.
Function levelobj.GetMonsterArmor(mx As Integer, my As Integer) As Single
   Dim As Single ret
   Dim As Integer midx
   
   'Make sure there is a monster here.
   If _level.lmap(mx, my).monidx > 0 Then
      midx = _level.lmap(mx, my).monidx
      ret = _level.moninfo(midx).armval
   EndIf
   
   Return ret
End Function

'Applies damage to monsters. Returns true if monster is dead.
Function levelobj.ApplyDamage(mx As Integer, my As Integer, dam As Integer) As Integer
   Dim As Integer midx, i, ret = FALSE
   Dim As vec v
   Dim As String txt
   
   'Make sure there is a monster here.
   If _level.lmap(mx, my).monidx > 0 Then
      midx = _level.lmap(mx, my).monidx
      _level.moninfo(midx).currhp = _level.moninfo(midx).currhp - dam
      'Check for flee.
      If _level.moninfo(midx).currhp < 2 Then _level.moninfo(midx).flee = TRUE 
      'Check to see if monster is dead.
      If (_level.moninfo(midx).currhp < 1) Or (_level.moninfo(midx).effects(meIceStatue).cnt > 0) Then
         'Bump the number of killed monsters.
         _level.killedmon(_level.moninfo(midx).id).cnt += 1
         _level.killedmon(_level.moninfo(midx).id).mname = _level.moninfo(midx).mname
         'Add some experience to the character.
         pchar.CurrXP = pchar.CurrXP + _level.moninfo(midx).xp
         'Monster is dead.
         ret = TRUE
         'Flag the monster as dead.
         _level.moninfo(midx).isdead = TRUE
         'Remove from map.
         _level.lmap(mx, my).monidx = 0
         'Drop any items.
         If _level.moninfo(midx).dropcount > 0 Then
            For i = 1 To _level.moninfo(midx).dropcount
               For j As compass = north To nwest
                  v.vx = mx
                  v.vy = my
                  v += j
                  'If empty drop item.
                  If (_level.lmap(v.vx, v.vy).terrid = tFloor) And (_level.linv(v.vx, v.vy).classid = clNone) Then
                     PutItemOnMap v.vx, v.vy, _level.moninfo(midx).dropitem(i)
                     Exit For
                  EndIf
               Next
               ClearInv _level.moninfo(midx).dropitem(i)
            Next
         EndIf
      EndIf
     'Print the result of the combat.
      If _level.moninfo(midx).isdead = TRUE Then
         txt = pchar.CharName & " killed the " & _level.moninfo(midx).mname & " with " & dam & " damage points."
      Else
         txt = pchar.CharName & " hit the " & _level.moninfo(midx).mname & " for " & dam & " damage points."
      EndIf
      PrintMessage txt
   EndIf
   
   Return ret
End Function

'Returns the monster xp amount.
Function levelobj.GetMonsterXP(mx As Integer, my As Integer) As Integer
   Dim As Integer midx, ret
   
   'Make sure there is a monster here.
   If _level.lmap(mx, my).monidx > 0 Then
      midx = _level.lmap(mx, my).monidx
      ret = _level.moninfo(midx).xp
   EndIf
   
   Return ret
End Function

'Returns True if tile is visible,
Function levelobj.IsTileVisible(x As Integer, y As Integer) As Integer
   Return _level.lmap(x, y).visible
End Function

'Returns the current monster stat amt.
Function levelobj.GetMonsterStatAmt(stat As monStats, mx As Integer, my As Integer) As Integer
   Dim As Integer midx, ret = 0
   
   If _level.lmap(mx, my).monidx > 0 Then
      midx = _level.lmap(mx, my).monidx
      If stat = CombatFactor Then
         ret = _level.moninfo(midx).cf 
      ElseIf stat = CombatDefense Then
         ret = _level.moninfo(midx).cd
      ElseIf stat = MagicCombat Then
         ret = _level.moninfo(midx).mf
      ElseIf stat = MagicDefense Then
         ret = _level.moninfo(midx).md
      EndIf
   End If
   
   Return ret
End Function

'Attempts to open a locked door. 
Function levelobj.OpenLockedDoor(x As Integer, y As Integer, dr As Integer) As Integer
   Dim As Integer ret = TRUE, ddr, rolld, rollp
   Dim tid As terrainids
   
   'Make sure we have a door.
   tid = GetTileID(x, y)
   If tid = tDoorClosed Then
     If IsDoorLocked(x, y) = TRUE Then
        'Get the difficulty rating of the door.
        ddr = _level.lmap(x, y).doorinfo.lockdr
        'Get the rolls.
        rollp = RandomRange(1, dr)
        rolld = RandomRange(1, ddr)
        If rollp > rolld Then
           'Open door.
           _level.lmap(x, y).doorinfo.locked = FALSE
           SetTile x, y, tdooropen
           'Give the character some experience points.
           pchar.CurrXP = pchar.CurrXP + ddr 
        Else
           'Didn't open the door.
           ret = FALSE
        EndIf
     EndIf
   EndIf
   
   Return ret
End Function

'Sets the door state.
Sub levelobj.SetDoorState(x As Integer, y As Integer, state As doorstates)
   Dim tid As terrainids
   
   'Make sure we have a door.
   tid = GetTileID(x, y)
   If tid = tDoorClosed Then
      If state = dsOpen Then
         _level.lmap(x, y).terrid = tDoorOpen
      ElseIf state = dsLocked Then
         _level.lmap(x, y).doorinfo.locked = TRUE
	      _level.lmap(x, y).doorinfo.lockdr = _level.numlevel
			_level.lmap(x, y).doorinfo.dstr = _level.numlevel * 10
      EndIf
   ElseIf tid = tDoorOpen Then
      If state = dsClosed Then
         _level.lmap(x, y).terrid = tDoorClosed
      ElseIf state = dsLocked Then
         _level.lmap(x, y).terrid = tDoorClosed
         _level.lmap(x, y).doorinfo.locked = TRUE
	      _level.lmap(x, y).doorinfo.lockdr = _level.numlevel
			_level.lmap(x, y).doorinfo.dstr = _level.numlevel * 10
      EndIf
   End If
End Sub

'Disarms a trap.
Sub levelobj.DisArmTrap (x As Integer, y As Integer)
   
   'Do we have a trap at the current location?
   If _level.lmap(x, y).trap.id <> trpNone Then
      'Spring trap.
      _level.lmap(x, y).trap.sprung = TRUE
   End If
   
End Sub

'Returns TRUE if trap at x, y.
Function levelobj.IsTrap(x As Integer, y As Integer, ByRef dam As Integer, ByRef damtype As weapdamtype, ByRef tdr As Integer, tdesc As String) As Integer
   Dim As Integer ret
   
   'Do we have a trap at the current location?
   If _level.lmap(x, y).trap.id <> trpNone Then
      'Is it sprung yet?
      If _level.lmap(x, y).trap.sprung = FALSE Then
         'There is a trap. Spring it and return damage amt and type.
         ret = TRUE
         _level.lmap(x, y).trap.sprung = TRUE
         dam = _level.lmap(x, y).trap.dam
         damtype = _level.lmap(x, y).trap.damtype
         tdr = _level.lmap(x, y).trap.dr
         tdesc = _level.lmap(x, y).trap.desc
      EndIf
   EndIf
   
   Return ret
End Function

'Returns the number and name of dead monster for passed monster id.
Sub levelobj.GetDeadMonster(monid As monids, mstat As monstat)
   
   'Verify the passed id.
   If (monid >= monDarkangel) And (monid <= monGriffon) Then
      mstat = _level.killedmon(monid)
   EndIf
End Sub

'Returns the stat for last monster encounter.
Sub levelobj.GetLastMonster(mstat As monstat)
   
   mstat = _level.lastmon
   
End Sub

'Get the level information.
Sub levelobj.GetLevelData(ld As levelinfo)
   'Get the level number.
   ld  = _level
End Sub

'Get the level information.
Sub levelobj.SetLevelData(ld As levelinfo)
   'Get the level number.
   _level = ld
End Sub

'Level variable.
Dim Shared level As levelobj
