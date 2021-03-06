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
'Nodes
#Define nodemax 1000
'Node links.
#Define lnodemax 20
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
'Viewport width and height.
#Define vw 40 
#Define vh 53 
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

'Door type.
Type doortype
   locked As Integer   'True if locked.
   lockdr As Integer   'Lock pick difficulty.
   dstr As Integer     'Strength of door (for bashing).
End Type

'Node type
Type nodetype
	nodeloc As mcoord                 'Map location of node.
	numnodes As Integer               'The number of links in the link list.
	nodecoll(1 To lnodemax) As Integer 'List of connected node indexes
End Type

'Map info type
Type mapinfotype
	terrid As terrainids  'The terrain type.
	monidx As Integer     'Index into monster array.
	visible As Integer    'Character can see cell.
	seen As Integer       'Character has seen cell.
	doorinfo As doortype  'Door information.
	nodeid As integer     'Node index. -1 = no node.
End Type

'Dungeon level information.
Type levelinfo
   numlevel As Integer                       'Current level number.
   nodecnt As Integer                        'Number of nodes on map.
   nodes (1 To nodemax) As nodetype          'List of nodes on map. 
   lmap(1 To mapw, 1 To maph) As mapinfotype 'Map array.
   linv(1 To mapw, 1 To maph) As invtype     'Map inventory type.
   nummon As Integer                         'Number of monsters on the map: 10 to maxmonster.
   moninfo(1 To nroommax) As montype         'Array of monsters.   
End Type

'Dungeon level object.
Type levelobj
   Private:
   _level As levelinfo                 'The level map structure.
   _numrooms As Integer                'The number of rooms in the level.
   _rooms(1 To nroommax) As roomtype   'Room information.
   _grid(1 To gw, 1 To gh) As celltype 'Grid infromation.
   Declare Function _BlockingTile(tx As Integer, ty As Integer) As Integer 'Returns true if blocking tile.
   Declare Function _LineOfSight(x1 As Integer, y1 As Integer, x2 As Integer, y2 As Integer) As Integer 'Returns true if line of sight to tile.
   Declare Function _CanSee(tx As Integer, ty As Integer) As Integer 'Can character see tile.
   Declare Sub _CalcLOS () 'Calculates line of sight with post processing to remove artifacts.
   Declare Function _GetMapSymbol(tile As terrainids) As String 'Returns the ascii symbol for terrian id.
   Declare Function _GetMapSymbolColor(tile As terrainids) As UInteger 'Returns color for terrain id.
   Declare Function _GetTerrainDesc(x As Integer, y As Integer) As String 'Returns item description.
   Declare Function _AddNode(ncoord As mcoord, prune As Integer = FALSE) As Integer'Adds a node to the map.
   Declare Sub _InitGrid() 'Inits the grid.
   Declare Sub _ConnectRooms( r1 As Integer, r2 As Integer) 'Connects rooms.
   Declare Sub _ConnectNodes ()  'Connects nodes to each other.
   Declare Sub _AddDoorsToRoom(i As Integer) 'Adds doors to a room.
   Declare Sub _AddDoors() 'Iterates through all rooms adding doors to each room.
   Declare Sub _DrawMapToArray() 'Transfers room data to map array.
   Declare Sub _GenerateItems()  'Generates items on the map. 
   Public:
   Declare Constructor ()
   Declare Property LevelID(lvl As Integer) 'Sets the current level.
   Declare Property LevelID() As Integer 'Returns the current level number.
   Declare Sub DrawMap () 'Draws the map on the screen.
   Declare Sub GenerateDungeonLevel() 'Generates a new dungeon level.
   Declare Sub SetTile(x As Integer, y As Integer, tileid As terrainids) 'Sets the tile at x, y of map.
   Declare Sub GetItemFromMap(x As Integer, y As Integer, inv As invtype) 'Adds item from map to passed inventory type. 
   Declare Sub PutItemOnMap(x As Integer, y As Integer, inv As invtype) 'Puts an item from passed inventory type to map.
   Declare Function IsBlocking(x As Integer, y As Integer) As Integer 'Returns true of tile at x, y is blocking.
   Declare Function GetTileID(x As Integer, y As Integer) As terrainids 'Returns the tile id at x, y.
   Declare Function IsDoorLocked(x As Integer,y As Integer) As Integer 'Returns True if door is locked.
   Declare Function GetTerrainDescription(x As Integer, y As Integer) As String 'Returns item description at coordinate.
   Declare Function HasItem(x As Integer, y As Integer) As Integer 'Returns True if coordinate has item.
   Declare Function GetItemDescription(x As Integer, y As Integer) As String 'Returns item description at x, y coordinate.
   Declare Function GetInvClassID(x As Integer, y As Integer) As classids 'Returns inv class id at x, y.
   Declare Function GetEmptySpot(v As vec) As Integer 'Returns true if an empty spot is found and returns coords in vec.
End Type

'Initlaizes object.
Constructor levelobj ()
   'Set the level number.
   _level.numlevel = 0
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
   Dim ret As Integer = FALSE
   
   'If tile contains a monster it is blocking.
   If _level.lmap(tx, ty).monidx > 0 Then
      ret = TRUE
   Else
      If _level.lmap(tx, ty).terrid = tWall Or _level.lmap(tx, ty).terrid = tdoorclosed Or _level.lmap(tx, ty).terrid = tstairup Then
         ret = TRUE
      EndIf
   EndIf
   
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

'Adds a node to the map and returns node.
Function levelobj._AddNode(ncoord As mcoord, prune As Integer = FALSE) As Integer
	Dim As Integer idx, tx, ty, ok, ret
   Dim As vec v
   
	'Make sure we don't already have a node at location.
	If _level.lmap(ncoord.x, ncoord.y).nodeid = -1 Then
	   'Set the add flag.
      ok = TRUE
	   'Check for neighbor nodes if we are pruning.
	   If prune = TRUE Then
	      For i As compass = north To nwest
	         'Set the vector position.
	         v.vx = ncoord.x
	         v.vy = ncoord.y
	         'Add compass direction.
	         v += i
	         'Check for a node.
	         If _level.lmap(v.vx, v.vy).nodeid <> -1 Then
	            'Set the add flag to false.
	            ok = FALSE
	            'Set the return.
	            ret = _level.lmap(v.vx, v.vy).nodeid
	            Exit For
	         EndIf
	      Next
	   Else
	      ret = _level.lmap(ncoord.x, ncoord.y).nodeid
	   EndIf
	   'Add a node if add flag is true.
	   If ok = TRUE Then
	      'Increment the node count.
	      idx = _level.nodecnt + 1
	      'Make sure we don't exceed the max nodes.
   	  	If idx <= nodemax Then
   	  	   'Save the count.
      	  	_level.nodecnt = idx
            'Set node info.
            _level.nodes(idx).nodeloc = ncoord
            'Set the return.
            ret = idx
            'No connections yet.
            _level.nodes(idx).numnodes = 0
            'Save the index.
            _level.lmap(ncoord.x, ncoord.y).nodeid = idx
   	  	EndIf
	   End If
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
	      If _level.lmap(i, j).visible = False Then
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
      Case Else
         ret = "Uknown"
   End Select
   
   Return ret
End Function

'Draws the map on the screen.
Sub levelobj.DrawMap ()
   Dim As Integer i, j, w = vw, h = vh, x, y, px, py, pct, vis = vh, monid
   Dim As UInteger tilecolor, bcolor
   Dim As String mtile
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
	         If _level.lmap(i + x, j + y).visible = True Then
		         'Print the item marker.
		         If HasItem(i + x, j + y) = True Then
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
	         		If HasItem(i + x, j + y) = True Then
	         			PutText "?", y + 1, x + 1, fbSlateGrayDark
	         		Else
	            		PutText mtile, y + 1, x + 1, fbSlateGrayDark
	         		End If
	         	End If
	         End If
	     Next 
	 Next
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
				'Check to see if no node.
				If _level.lmap(x, currcell.y).nodeid = -1 Then
					ncoord.x = x
					ncoord.y = currcell.y
					nid = _AddNode(ncoord)
				EndIf
				Exit Sub
			EndIf
			_level.lmap(x, currcell.y).terrid = tfloor
		Loop Until x = lastcell.x
	End If
	'Add node to current spot.
	If _level.lmap(x, currcell.y).nodeid = -1 Then
		ncoord.x = x
		ncoord.y = currcell.y
		nid = _AddNode(ncoord, TRUE)
	EndIf
	
	If x > lastcell.x Then
		wflag = FALSE
		Do
			x -= 1
			If _level.lmap(x, currcell.y).terrid = twall Then wflag = TRUE
			If (_level.lmap(x, currcell.y).terrid = tfloor) And (wflag = TRUE) Then 
				'Check to see if no node.
				If _level.lmap(x, currcell.y).nodeid = -1 Then
					ncoord.x = x
					ncoord.y = currcell.y
					nid = _AddNode(ncoord)
				EndIf
				Exit Sub
			EndIf
			_level.lmap(x, currcell.y).terrid = tfloor
		Loop Until x = lastcell.x
	EndIf
	'Add node to current spot.
	If _level.lmap(x, currcell.y).nodeid = -1 Then
		ncoord.x = x
		ncoord.y = currcell.y
		nid = _AddNode(ncoord, TRUE)
	EndIf
	
	y = currcell.y
	If y < lastcell.y Then
		wflag = FALSE
		Do
			y += 1
			If _level.lmap(x, y).terrid = twall Then wflag = TRUE
			If (_level.lmap(x, y).terrid = tfloor) And (wflag = TRUE) Then 
				'Check to see if no node.
				If _level.lmap(x, y).nodeid = -1 Then
					ncoord.x = x
					ncoord.y = y
					nid = _AddNode(ncoord)
				EndIf
				Exit Sub
			EndIf
			_level.lmap(x, y).terrid = tfloor
		Loop Until y = lastcell.y
	EndIf
	'Add node to current spot.
	If _level.lmap(x, currcell.y).nodeid = -1 Then
		ncoord.x = x
		ncoord.y = currcell.y
		nid = _AddNode(ncoord, TRUE)
	EndIf
	
	If y > lastcell.y Then
		Do
			y -= 1
			If _level.lmap(x, y).terrid = twall Then wflag = TRUE
			If (_level.lmap(x, y).terrid = tfloor) And (wflag = TRUE) Then 
				'Check to see if not in room and no node.
				If _level.lmap(x, y).nodeid = -1 Then
					ncoord.x = x
					ncoord.y = y
					nid = _AddNode(ncoord)
				EndIf
				Exit Sub
			EndIf
			_level.lmap(x, y).terrid = tfloor
		Loop Until y = lastcell.y
	EndIf
	'Add node to current spot.
	If _level.lmap(x, currcell.y).nodeid = -1 Then
		ncoord.x = x
		ncoord.y = currcell.y
		nid = _AddNode(ncoord, TRUE)
	EndIf
		 
End Sub

'Connect up to lnodemax nodes.
Sub levelobj._ConnectNodes
	Dim As Integer i, j, k, ncnt, nids, nidt 
	Dim As mcoord n1, n2
		
	For i = 1 To _level.nodecnt
		ncnt = 0
		For j = 1 to _level.nodecnt
			'Skip over same node.
			If j <> i Then
			   'Is j in line of sight if i?
			   If _LineOfSight(_level.nodes(i).nodeloc.x, _level.nodes(j).nodeloc.x, _
			      _level.nodes(i).nodeloc.y, _level.nodes(j).nodeloc.y) = TRUE Then
				   ncnt = _level.nodes(i).numnodes + 1
				   If ncnt <= lnodemax Then
					   'Add j to i's list.
					   _level.nodes(i).numnodes = ncnt
					   _level.nodes(i).nodecoll(ncnt) = j
				   End If
			   EndIf
			End If
		Next
	Next
	'Set monster node targets.
	For i = 1 To _level.nummon
	   'Get source node id.
	   nids = _level.moninfo(i).srcnode
	   'Get target node id.
	   nidt = RandomRange(1, _level.nodes(nids).numnodes)
	   _level.moninfo(i).tgtnode = _level.nodes(nids).nodecoll(nidt)
	Next
End Sub

'Add doors to a room.
Sub levelobj._AddDoorsToRoom(i As Integer)
	Dim As Integer row, col, dd1, dd2, nid
	Dim As mcoord ncoord
	
	'First we add the nodes without doors so we can connect them.
	For col = _rooms(i).tl.x To _rooms(i).br.x
		dd1 = _rooms(i).tl.y
		dd2 = _rooms(i).br.y
		'If a floor space in the wall.
		If _level.lmap(col, dd1).terrid = tfloor Then
			'Add node at door location using pruning.
			ncoord.x = col
			ncoord.y = dd1
			nid = _AddNode(ncoord, TRUE)
		EndIf
		'Iterate along bottom of room.
		If _level.lmap(col, dd2).terrid = tfloor Then
			'Add node at door location.
			ncoord.x = col
			ncoord.y = dd2
			nid = _AddNode(ncoord, TRUE)
		End If
	Next
	'Iterate along left side of room.
	For row = _rooms(i).tl.y To _rooms(i).br.y
		dd1 = _rooms(i).tl.x
		dd2 = _rooms(i).br.x
		If _level.lmap(dd1, row).terrid = tfloor Then
			'Add node at door location.
			ncoord.x = dd1
			ncoord.y = row
			nid = _AddNode(ncoord, TRUE)
		End If
		'Iterate along right side of room.
		If _level.lmap(dd2, row).terrid = tfloor Then
			'Add node at door location.
			ncoord.x = dd2
			ncoord.y = row
			nid = _AddNode(ncoord, TRUE)
		EndIf
	Next
	'Connect all the nodes.
	_ConnectNodes
   'Now add the doors.
	For col = _rooms(i).tl.x To _rooms(i).br.x
		dd1 = _rooms(i).tl.y
		dd2 = _rooms(i).br.y
		'If a floor space in the wall.
		If _level.lmap(col, dd1).terrid = tfloor Then
			'Add door.
			_level.lmap(col, dd1).terrid = tdoorclosed
			_level.lmap(col, dd1).doorinfo.locked = FALSE
			If _level.lmap(col, dd1).doorinfo.locked = TRUE Then
			   _level.lmap(col, dd1).doorinfo.lockdr = 0
			   _level.lmap(col, dd1).doorinfo.dstr = 0
			End If
		EndIf
		'Iterate along bottom of room.
		If _level.lmap(col, dd2).terrid = tfloor Then
			'Add door.
			_level.lmap(col, dd2).terrid = tdoorclosed
			_level.lmap(col, dd2).doorinfo.locked = FALSE
			If _level.lmap(col, dd2).doorinfo.locked = TRUE Then
			   _level.lmap(col, dd2).doorinfo.lockdr = 0
			   _level.lmap(col, dd2).doorinfo.dstr = 0
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
			_level.lmap(dd1, row).doorinfo.locked = FALSE
			If _level.lmap(dd1, row).doorinfo.locked = TRUE Then
			   _level.lmap(dd1, row).doorinfo.lockdr = 0
			   _level.lmap(dd1, row).doorinfo.dstr = 0
			End If
		End If
		'Iterate along right side of room.
		If _level.lmap(dd2, row).terrid = tfloor Then
			'Add door.
			_level.lmap(dd2, row).terrid = tdoorclosed
			_level.lmap(dd2, row).doorinfo.locked = FALSE
			If _level.lmap(dd2, row).doorinfo.locked = TRUE Then
			   _level.lmap(dd2, row).doorinfo.lockdr = 0
			   _level.lmap(dd2, row).doorinfo.dstr = 0
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
	Dim As Integer i, x, y, pr, rr, rl, ru, kr, moncnt, nid
	Dim As mcoord ncoord
	
	'Draw the first room to map array
	For x = _rooms(1).tl.x + 1 To _rooms(1).br.x - 1
		For y = _rooms(1).tl.y + 1 To _rooms(1).br.y - 1
			_level.lmap(x, y).terrid = tfloor
		Next
	Next
  	'Add node to room.
  	ncoord.x = _rooms(1).roomdim.rcoord.x + 1
  	ncoord.y = _rooms(1).roomdim.rcoord.y + 1
  	'Add a node using pruning.
  	nid = _AddNode(ncoord, TRUE)
   'Set the monster count. Don't add start and end rooms.
   _level.nummon = RandomRange(5, _numrooms - 2)
	'Draw the rest of the rooms to the map array and connect them.
	For i = 2 To _numrooms
		For x = _rooms(i).tl.x + 1 To _rooms(i).br.x - 1
			For y = _rooms(i).tl.y + 1 To _rooms(i).br.y - 1
				_level.lmap(x, y).terrid = tfloor
			Next
		Next
  	   ncoord.x = _rooms(i).roomdim.rcoord.x + 1
  	   ncoord.y = _rooms(i).roomdim.rcoord.y + 1
  	   nid = _AddNode(ncoord, TRUE)
  	   'Add a monster to the room.
      moncnt += 1
  	   If moncnt <= _level.nummon Then
  	      GenerateMonster _level.moninfo(moncnt)
  	      'Set the node location.
  	      _level.moninfo(moncnt).srcnode = nid
  	      _level.moninfo(moncnt).tgtnode = -1
  	      _level.lmap(ncoord.x, ncoord.y).monidx = moncnt
  	      _level.moninfo(moncnt).currcoord = ncoord 
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
	'Set up stairs down in last room.
	x = _rooms(_numrooms).roomdim.rcoord.x + (_rooms(_numrooms).roomdim.rwidth \ 2) 
	y = _rooms(_numrooms).roomdim.rcoord.y + (_rooms(_numrooms).roomdim.rheight \ 2)
	_level.lmap(x - 1, y - 1).terrid = tstairdn
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
	   GenerateItem _level.linv(x, y), _level.numlevel
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
			_level.lmap(x, y).nodeid = -1              'Set node id to -1. No node index.
			_level.nummon = 0                          'Set monster count to 0.
			_level.nodecnt = 0                         'No nodes.
			ClearInv _level.linv(x,y)                  'Clear inventory slot.
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

'Level variable.
Dim Shared level As levelobj
