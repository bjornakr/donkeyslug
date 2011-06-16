/'****************************************************************************
*
* Name: character.bi
*
* Synopsis: Character related routines for DOD.
*
* Description: This file contains the character generation and management
*              routines used in the program. 
*              
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
'Character screen background.
#Include "charback.bi"

'Indexes into attribute/factor arrays.
Enum attrindex
   idxAttr = 0 'Attribute/factor
   idxAttrBon 'Bonus
   idxAttrCnt 'Count
   idxArrMax 'Array max index. Insert new index before this entry.
End Enum

'Character attribute type def.
Type characterinfo
   cname As String * 35 'Name of character.
   stratt(idxArrMax) As Integer 'Strength attribute (0), str bonus (1), bonus length in turns(2)
   staatt(idxArrMax) As Integer 'Stamina  
   dexatt(idxArrMax) As Integer 'Dexterity 
   aglatt(idxArrMax) As Integer 'Agility 
   intatt(idxArrMax) As Integer 'Intelligence 
   currhp As Integer    'Current HP
   maxhp As Integer     'Max HP
   currmana As Integer  'Current mana
   maxmana As Integer   'Max mana
   ucfsk(idxArrMax) As Integer  'Unarmed combat skill
   acfsk(idxArrMax) As Integer  'Armed combat skill
   pcfsk(idxArrMax) As Integer  'Projectile combat skill
   mcfsk(idxArrMax) As Integer  'Magic combat skill 
   cdfsk(idxArrMax) As Integer  'Combat defense skill
   mdfsk(idxArrMax) As Integer  'Magic defense skill 
   currxp As Integer    'Current spendable XP amount.
   totxp As Integer     'Lifetime XP amount.
   currgold As Integer  'Current gold amount.
   totgold As Integer   'Lifetime gold amount.
   ploc As mcoord       'Character current x and y location.
   cinv(97 To 122) As invtype 'Character inventory-using ascii codes for index values.
   cwield(wPrimary To wRingLt) As invtype 'Active items: 1 = primary weapon, 2 = secondary weapon/shield, 3 = armor, 4 = necklace, 5 = ring rt, 6 = rint lt 
   isPoisoned As Integer  'The Poisoned flag. True = character is poisoned.
   PoisonStr As Integer   'The strength of the poison. Poison is accumlative.
End Type

'Character object.
Type character
   Private:
   _cinfo As characterinfo
   Declare Function _GetBestArmor() As armorids 'Returns the best armor based on strength.
   Public:
   Declare Property CharName() As String    'Character name. 
   Declare Property Locx(xx As Integer)     'Sets X coord of character.
   Declare Property Locx() As Integer       'Returns the X coord of character.
   Declare Property Locy(xx As Integer)     'Sets X coord of character.
   Declare Property Locy() As Integer       'Returns the X coord of character.
   Declare Property CurrHP(hp As Integer)   'Sets the hp.
   Declare Property CurrHP() As Integer     'Returns the current HP.
   Declare Property MaxHP() As Integer      'Returns the current HP.
   Declare Property CurrMana(hp As Integer) 'Sets the mana.
   Declare Property CurrMana() As Integer   'Returns the current mana.
   Declare Property MaxMana() As Integer    'Returns the current mana.
   Declare Property CurrStr() As Integer    'Returns the current strength value.
   Declare Property CurrStr(amt As Integer) 'Sets the current strength value. 
   Declare Property BonStr() As Integer     'Returns the current strength bonus value..
   Declare Property BonStr(amt As Integer)  'Sets the current strength bonus value.
   Declare Property BonStrCnt() As Integer   'Returns the current strength bonus value..
   Declare Property BonStrCnt(amt As Integer)'Sets the current strength bonus value.
   Declare Property CurrSta() As Integer    'Returns the current stamina value.
   Declare Property CurrSta(amt As Integer) 'Sets the current stamina value. 
   Declare Property BonSta() As Integer     'Returns the current stamina bonus value..
   Declare Property BonSta(amt As Integer)  'Sets the current stamina bonus value.
   Declare Property BonStaCnt() As Integer     'Returns the current stamina bonus value..
   Declare Property BonStaCnt(amt As Integer)  'Sets the current stamina bonus value.
   Declare Property CurrDex() As Integer    'Returns the current dexterity value.
   Declare Property CurrDex(amt As Integer) 'Sets the current dexterity value. 
   Declare Property BonDex() As Integer     'Returns the current dexterity bonus value..
   Declare Property BonDex(amt As Integer)  'Sets the current dexterity bonus value.
   Declare Property BonDexCnt() As Integer     'Returns the current dexterity bonus value..
   Declare Property BonDexCnt(amt As Integer)  'Sets the current dexterity bonus value.
   Declare Property CurrAgl() As Integer    'Returns the current agility value.
   Declare Property CurrAgl(amt As Integer) 'Sets the current agility value. 
   Declare Property BonAgl() As Integer     'Returns the current agility bonus value..
   Declare Property BonAgl(amt As Integer)  'Sets the current agility bonus value.
   Declare Property BonAglCnt() As Integer     'Returns the current agility bonus value..
   Declare Property BonAglCnt(amt As Integer)  'Sets the current agility bonus value.
   Declare Property CurrInt() As Integer    'Returns the current intelligence value.
   Declare Property CurrInt(amt As Integer) 'Sets the current intelligence value. 
   Declare Property BonInt() As Integer     'Returns the current intelligence bonus value..
   Declare Property BonInt(amt As Integer)  'Sets the current intelligence bonus value.
   Declare Property BonIntCnt() As Integer     'Returns the current intelligence bonus value..
   Declare Property BonIntCnt(amt As Integer)  'Sets the current intelligence bonus value.
   Declare Property CurrUcf() As Integer    'Returns the current unarmed combat value.
   Declare Property BonUcf() As Integer     'Returns the current unarmed combat bonus value..
   Declare Property BonUcf(amt As Integer)  'Sets the current unarmed combat bonus value.
   Declare Property BonUcfCnt() As Integer     'Returns the current unarmed combat bonus value..
   Declare Property BonUcfCnt(amt As Integer)  'Sets the current unarmed combat bonus value.
   Declare Property CurrAcf() As Integer    'Returns the current armed combat value.
   Declare Property BonAcf() As Integer     'Returns the current armed combat bonus value..
   Declare Property BonAcf(amt As Integer)  'Sets the current armed combat bonus value.
   Declare Property BonAcfCnt() As Integer     'Returns the current armed combat bonus value..
   Declare Property BonAcfCnt(amt As Integer)  'Sets the current armed combat bonus value.
   Declare Property CurrPcf() As Integer    'Returns the current projectile combat value.
   Declare Property BonPcf() As Integer     'Returns the current projctile combat bonus value..
   Declare Property BonPcf(amt As Integer)  'Sets the current projectile combat bonus value.
   Declare Property BonPcfCnt() As Integer     'Returns the current projctile combat bonus value..
   Declare Property BonPcfCnt(amt As Integer)  'Sets the current projectile combat bonus value.
   Declare Property CurrMcf() As Integer    'Returns the current magic combat value.
   Declare Property BonMcf() As Integer     'Returns the current magic combat bonus value..
   Declare Property BonMcf(amt As Integer)  'Sets the current magic combat bonus value.
   Declare Property BonMcfCnt() As Integer     'Returns the current magic combat bonus value..
   Declare Property BonMcfCnt(amt As Integer)  'Sets the current magic combat bonus value.
   Declare Property CurrCdf() As Integer    'Returns the current combat defense value.
   Declare Property BonCdf() As Integer     'Returns the current combat defense bonus value..
   Declare Property BonCdf(amt As Integer)  'Sets the current combat defense bonus value.
   Declare Property BonCdfCnt() As Integer     'Returns the current combat defense bonus value..
   Declare Property BonCdfCnt(amt As Integer)  'Sets the current combat defense bonus value.
   Declare Property CurrMdf() As Integer    'Returns the current magic defense value.
   Declare Property BonMdf() As Integer     'Returns the current magic defense bonus value..
   Declare Property BonMdf(amt As Integer)  'Sets the current magic defense bonus value.
   Declare Property BonMdfCnt() As Integer     'Returns the current magic defense bonus value..
   Declare Property BonMdfCnt(amt As Integer)  'Sets the current magic defense bonus value.
   Declare Property CurrXP() As Integer     'Returns the current xp points.
   Declare Property CurrXP(amt As Integer)  'Sets the current xp points.
   Declare Property TotXP() As Integer      'Returns the total xp points.
   Declare Property TotXP(amt As Integer)   'Sets the total total points.
   Declare Property CurrGold() As Integer     'Returns the current gold amount.
   Declare Property CurrGold(amt As Integer)  'Sets the current gold amount.
   Declare Property TotGold() As Integer     'Returns the total gold amount.
   Declare Property TotGold(amt As Integer)  'Sets the total gold amount.
   Declare Property LowInv() As Integer      'Returns the low index of inv array.
   Declare Property HighInv() As Integer      'Returns the high index of inv array.
   Declare Property Poisoned() As Integer     'Returns the poinsoned flag.
   Declare Property Poisoned(flag As Integer) 'Set the poisoned flag.
   Declare Property PoisonStr() As Integer     'Returns the poinsoned flag.
   Declare Property PoisonStr(amt As Integer) 'Set the poisoned flag.
   Declare Sub PrintStats ()                 'Prints out stats for character.
   Declare Sub AddInvItem(idx As Integer, inv As invtype) 'Adds inventory item to character inventory slot.
   Declare Sub GetInventoryItem(idx As Integer, inv As invtype) 'Gets an item from an inventory slot.
   Declare Sub DoTimedActions ()               'Goes through character and decrements bonus counts, etc.
   Declare Sub ChangeStrength(change As Integer) 'Changes attribute and updates associated stats. 
   Declare Sub ChangeStamina(change As Integer) 'Changes attribute and updates associated stats. 
   Declare Sub ChangeDexterity(change As Integer) 'Changes attribute and updates associated stats. 
   Declare Sub ChangeAgility(change As Integer) 'Changes attribute and updates associated stats. 
   Declare Sub ChangeIntelligence(change As Integer) 'Changes attribute and updates associated stats.
   Declare Sub DecrementAmmo(slot As wieldpos) 'Decrements the ammo in held weapon.
   Declare Function ApplyInvItem(inv As invtype) As String 'Applies the inv type to the character. 
   Declare Function HasInvItem(idx As Integer) As Integer 'Returns True if item exists in inventory slot.
   Declare Function GetFreeInventoryIndex() As Integer 'Returns free inventory slot index or -1.
   Declare Function GenerateCharacter() As Integer 'Generates a new character.
   Declare Function CanWear(inv As invtype) As Integer 'Returns True if character can wear item.
   Declare Function GetNoise() As Integer 'Returns the current noise amount.
   Declare Function GetMeleeCombatFactor() As Integer 'Returns the current combat factor.
   Declare Function GetWeaponDamage(wslot As wieldpos = wAny) As Integer 'Returns the amount of weapon damage.
   Declare Function GetDefenseFactor () As Integer 'Returns the character defense factor.
   Declare Function GetArmorValue() As Single 'Returns the current armor value.
   Declare Function GetShieldArmorValue () As Single 'Returns shield armor value.
   Declare Function ProjectileEquipped(slot As wieldpos) As Integer 'Returns True if character has pojectile weapon equipped.
   Declare Function IsLoaded(slot As wieldpos) As Integer 'Returns true if projectile weapon isn slot has ammo.
   Declare Function GetAmmoID(slot As wieldpos) As ammoids 'Returns the id for weapon in slot. 
   Declare Function LoadProjectile(aid As ammoids, slot As wieldpos) As Integer 'Returns True if weapon was loaded.
   Declare Function GetProjectileCombatFactor() As Integer 'Returns projectile combat factor.
   Declare Function GetMagicCombatFactor() As Integer 'Returns magic combat factor.
   Declare Function ProjectileIsWand(slot As wieldpos) As Integer 'Returns state of idwand flag.
   Declare Function IsLocation(x As Integer, y As Integer) As Integer 'Returns True if x and y are at char's location.
End Type

'Returns the best armor based on strength.
Function character._GetBestArmor() As armorids
   Dim As armorids ret = armArmorNone

   If _cinfo.stratt(idxAttr) >= strPlate Then
      ret = armPlate
   ElseIf _cinfo.stratt(idxAttr) >= strScale Then
      ret = armScale
   ElseIf _cinfo.stratt(idxAttr) >= strChain Then
      ret = armChain   
   ElseIf _cinfo.stratt(idxAttr) >= strBrigantine Then
      ret = armBrigantine   
   ElseIf _cinfo.stratt(idxAttr) >= strRing Then
      ret = armRing
   ElseIf _cinfo.stratt(idxAttr) >= strCuirboli Then
      ret = armCuirboli
   ElseIf _cinfo.stratt(idxAttr) >= strLeather Then
      ret = armLeather   
   ElseIf _cinfo.stratt(idxAttr) >= strCloth Then
      ret = armCloth
   EndIf
   
   Return ret
End Function

'Returns the character name.
Property character.CharName() As String
   Return _cinfo.cname
End Property

'Sets X coord of character.
Property character.Locx(xx As Integer)
   _cinfo.ploc.x = xx
End Property

'Returns the x coord of the character.
Property character.Locx() As Integer
   Return _cinfo.ploc.x
End Property

'Sets X coord of character.     
Property character.Locy(yy As Integer)
   _cinfo.ploc.y = yy
End Property

'Returns the X coord of character.
Property character.Locy() As Integer
   Return _cinfo.ploc.y
End Property

'Sets the hp.
Property character.CurrHP(hp As Integer)
   _cinfo.currhp = hp
End Property

'Returns the current HP.
Property character.CurrHP() As Integer
   Return _cinfo.currhp
End Property

'Returns the max HP.
Property character.MaxHP() As Integer
   Return _cinfo.maxhp
End Property

'Sets the mana.
Property character.CurrMana(mana As Integer)
   _cinfo.currmana = mana
End Property

'Returns the current mana.
Property character.CurrMana() As Integer
   Return _cinfo.currmana
End Property

'Returns the max mana.
Property character.MaxMana() As Integer
   Return _cinfo.maxmana
End Property

'Returns the current strength value.
Property character.CurrStr() As Integer    
   Return _cinfo.stratt(idxAttr)
End Property

'Sets the current strength value.
Property character.CurrStr(amt As Integer) 
   _cinfo.stratt(idxAttr) = amt
End Property

'Returns the current strength bonus value..
Property character.BonStr() As Integer     
   Return _cinfo.stratt(idxAttrBon)
End Property

'Sets the current strength bonus value. Any new value replaces the old value.
Property character.BonStr(amt As Integer)  
   _cinfo.stratt(idxAttrBon) = amt
End Property

'Sets the bonus count amount.
property character.BonStrCnt() As Integer
   Return _cinfo.stratt(idxAttrCnt)
End Property

'Returns the bonus count amount.
Property character.BonStrCnt(amt As Integer)  
   _cinfo.stratt(idxAttrCnt) = amt
End Property

'Returns the current stamina value.
Property character.CurrSta() As Integer    
   Return _cinfo.staatt(idxAttr)
End Property

'Sets the current stamina value.
Property character.CurrSta(amt As Integer) 
   _cinfo.staatt(idxAttr) = amt
End Property

'Returns the current stamina bonus value..
Property character.BonSta() As Integer     
   Return _cinfo.staatt(idxAttrBon)
End Property

'Sets the current stamina bonus value.
Property character.BonSta(amt As Integer)  
   _cinfo.staatt(idxAttrBon) = amt
End Property

'Returns the current stamina bonus value cnt.
Property character.BonStaCnt() As Integer     
   Return _cinfo.staatt(idxAttrCnt)
End Property

'Sets the current stamina bonus value.
Property character.BonStaCnt(amt As Integer)  
   _cinfo.staatt(idxAttrCnt) = amt
End Property

'Returns the current dexterity value.
Property character.CurrDex() As Integer    
   Return _cinfo.dexatt(idxAttr)
End Property

'Sets the current dexterity value.
Property character.CurrDex(amt As Integer) 
   _cinfo.dexatt(idxAttr) = amt
End Property

'Returns the current dexterity bonus value..
Property character.BonDex() As Integer     
   Return _cinfo.dexatt(idxAttrBon)
End Property

'Sets the current dexterity bonus value.
Property character.BonDex(amt As Integer)  
   _cinfo.dexatt(idxAttrBon) = amt
End Property

'Returns the current dexterity bonus value cnt.
Property character.BonDexCnt() As Integer     
   Return _cinfo.dexatt(idxAttrCnt)
End Property

'Sets the current dexterity bonus value cnt.
Property character.BonDexCnt(amt As Integer)  
   _cinfo.dexatt(idxAttrCnt) = amt
End Property

'Returns the current agility value.
Property character.CurrAgl() As Integer    
   Return _cinfo.aglatt(idxAttr)
End Property

'Sets the current agility value.
Property character.CurrAgl(amt As Integer) 
   _cinfo.aglatt(idxAttr) = amt
End Property

'Returns the current agility bonus value..
Property character.BonAgl() As Integer     
   Return _cinfo.aglatt(idxAttrBon)
End Property

'Sets the current agility bonus value.
Property character.BonAgl(amt As Integer)  
   _cinfo.aglatt(idxAttrBon) = amt
End Property

'Returns the current agility bonus value cnt.
Property character.BonAglCnt() As Integer     
   Return _cinfo.aglatt(idxAttrCnt)
End Property

'Sets the current agility bonus value cnt.
Property character.BonAglCnt(amt As Integer)  
   _cinfo.aglatt(idxAttrCnt) = amt
End Property

'Returns the current intelligence value.
Property character.CurrInt() As Integer    
   Return _cinfo.intatt(idxAttr)
End Property

'Sets the current intelligence value.
Property character.CurrInt(amt As Integer) 
   _cinfo.intatt(idxAttr) = amt
End Property

'Returns the current intelligence bonus value..
Property character.BonInt() As Integer     
   Return _cinfo.intatt(idxAttrBon)
End Property

'Sets the current intelligence bonus value.
Property character.BonInt(amt As Integer)  
   _cinfo.intatt(idxAttrBon) = amt
End Property

'Returns the current intelligence bonus value cnt.
Property character.BonIntCnt() As Integer     
   Return _cinfo.intatt(idxAttrCnt)
End Property

'Sets the current intelligence bonus value cnt.
Property character.BonIntCnt(amt As Integer)  
   _cinfo.intatt(idxAttrCnt) = amt
End Property

'Returns the current unarmed combat value.
Property character.CurrUcf() As Integer    
   Return _cinfo.ucfsk(idxAttr)
End Property

'Returns the current unarmed bonus value..
Property character.BonUcf() As Integer     
   Return _cinfo.ucfsk(idxAttrBon)
End Property

'Sets the current unarmed bonus value.
Property character.BonUcf(amt As Integer)  
   _cinfo.ucfsk(idxAttrBon) = amt
End Property

'Returns the current unarmed bonus value cnt.
Property character.BonUcfCnt() As Integer     
   Return _cinfo.ucfsk(idxAttrCnt)
End Property

'Sets the current unarmed bonus value cnt.
Property character.BonUcfCnt(amt As Integer)  
   _cinfo.ucfsk(idxAttrCnt) = amt
End Property

'Returns the current armed combat value.
Property character.CurrAcf() As Integer    
   Return _cinfo.acfsk(idxAttr)
End Property

'Returns the current armed bonus value.
Property character.BonAcf() As Integer     
   Return _cinfo.acfsk(idxAttrBon)
End Property

'Sets the current armed bonus value.
Property character.BonAcf(amt As Integer)  
   _cinfo.acfsk(idxAttrBon) = amt
End Property

'Returns the current armed bonus value cnt.
Property character.BonAcfCnt() As Integer     
   Return _cinfo.acfsk(idxAttrCnt)
End Property

'Sets the current armed bonus value cnt.
Property character.BonAcfCnt(amt As Integer)  
   _cinfo.acfsk(idxAttrCnt) = amt
End Property

'Returns the current projectile combat value.
Property character.CurrPcf() As Integer    
   Return _cinfo.pcfsk(idxAttr)
End Property

'Returns the current projectile bonus value.
Property character.BonPcf() As Integer     
   Return _cinfo.pcfsk(idxAttrBon)
End Property

'Sets the current projectile bonus value.
Property character.BonPcf(amt As Integer)  
   _cinfo.pcfsk(idxAttrBon) = amt
End Property

'Returns the current projectile bonus value cnt.
Property character.BonPcfCnt() As Integer     
   Return _cinfo.pcfsk(idxAttrCnt)
End Property

'Sets the current projectile bonus value.
Property character.BonPcfCnt(amt As Integer)  
   _cinfo.pcfsk(idxAttrCnt) = amt
End Property

'Returns the current magic combat value.
Property character.CurrMcf() As Integer    
   Return _cinfo.mcfsk(idxAttr)
End Property

'Returns the current magic bonus value.
Property character.BonMcf() As Integer     
   Return _cinfo.mcfsk(idxAttrBon)
End Property

'Sets the current magic bonus value.
Property character.BonMcf(amt As Integer)  
   _cinfo.mcfsk(idxAttrBon) = amt
End Property

'Returns the current magic bonus value cnt.
Property character.BonMcfCnt() As Integer     
   Return _cinfo.mcfsk(idxAttrCnt)
End Property

'Sets the current magic bonus value cnt.
Property character.BonMcfCnt(amt As Integer)  
   _cinfo.mcfsk(idxAttrCnt) = amt
End Property

'Returns the current combat defense value.
Property character.CurrCdf() As Integer    
   Return _cinfo.cdfsk(idxAttr)
End Property

'Returns the current combat defense bonus value.
Property character.BonCdf() As Integer     
   Return _cinfo.cdfsk(idxAttrBon)
End Property

'Sets the current combat defense bonus value.
Property character.BonCdf(amt As Integer)  
   _cinfo.cdfsk(idxAttrBon) = amt
End Property

'Returns the current combat defense bonus value cnt.
Property character.BonCdfCnt() As Integer     
   Return _cinfo.cdfsk(idxAttrCnt)
End Property

'Sets the current combat defense bonus value cnt.
Property character.BonCdfCnt(amt As Integer)  
   _cinfo.cdfsk(idxAttrCnt) = amt
End Property

'Returns the current magic defense value.
Property character.CurrMdf() As Integer    
   Return _cinfo.Mdfsk(idxAttr)
End Property

'Returns the current magic defense bonus value.
Property character.BonMdf() As Integer     
   Return _cinfo.mdfsk(idxAttrBon)
End Property

'Sets the current magic defense bonus value.
Property character.BonMdf(amt As Integer)  
   _cinfo.mdfsk(idxAttrBon) = amt
End Property

'Returns the current magic defense bonus value cnt.
Property character.BonMdfCnt() As Integer     
   Return _cinfo.mdfsk(idxAttrCnt)
End Property

'Sets the current magic defense bonus value cnt.
Property character.BonMdfCnt(amt As Integer)  
   _cinfo.mdfsk(idxAttrCnt) = amt
End Property

'Returns the current xp points.
Property character.CurrXP() As Integer
   Return _cinfo.currxp
End Property

'Sets the current xp points.
Property character.CurrXP(amt As Integer)
   _cinfo.currxp = amt
End Property

'Returns the total xp points.
Property character.TotXP() As Integer
   Return _cinfo.totxp
End Property

'Sets the total xp points.
Property character.TotXP(amt As Integer)
   _cinfo.totxp = amt
End Property

'Returns the current gold amount.
Property character.CurrGold() As Integer
   Return _cinfo.currgold
End Property

'Sets the current gold amount.
Property character.CurrGold(amt As Integer)
   _cinfo.currgold = amt
End Property

'Returns the max total gold amount.
Property character.TotGold() As Integer
   Return _cinfo.totgold
End Property

'Sets the total gold amount.
Property character.TotGold(amt As Integer)
   _cinfo.totgold = amt
End Property

'Returns the low index of inv array.
Property character.LowInv() As Integer
   Return LBound(_cinfo.cinv)
End Property

'Returns the high index of inv array.
Property character.HighInv() As Integer
   Return UBound(_cinfo.cinv)
End Property

'Returns the poison flag.
Property character.Poisoned() As Integer
   Return _cinfo.IsPoisoned
End Property

'Set the poisoned flag.
Property character.Poisoned(flag As Integer)
   _cinfo.IsPoisoned = flag
End Property

'Returns the strength of the poison..
Property character.PoisonStr() As Integer
   Return _cinfo.PoisonStr
End Property

'Sets the poisoned strength.
Property character.PoisonStr(amt As Integer)
   _cinfo.PoisonStr = amt
End Property

'Prints out the current stats for character.
Sub character.PrintStats ()
   Dim As Integer tx, ty, row = 8
   Dim As String sinfo
   
   ScreenLock
   'Draw the background.
   DrawBackground charback()
   'Draw the title.
   sinfo = Trim(_cinfo.cname) & " Attributes and Skills" 
   ty = row * charh
   tx = (CenterX(sinfo)) * charw
   DrawStringShadow tx, ty, sinfo, fbYellowBright
   'Draw the attributes.
   row += 4
   ty = row * charh
   tx = 70
   sinfo = "1 Strength:     " & _cinfo.stratt(0)
   DrawStringShadow tx, ty, sinfo
   row += 2
   ty = row * charh
   sinfo = "2 Stamina:      " & _cinfo.staatt(0)
   DrawStringShadow tx, ty, sinfo
   row += 2
   ty = row * charh
   sinfo = "3 Dexterity:    " & _cinfo.dexatt(0)
   DrawStringShadow tx, ty, sinfo
   row += 2
   ty = row * charh
   sinfo = "4 Agility:      " & _cinfo.aglatt(0)
   DrawStringShadow tx, ty, sinfo
   row += 2
   ty = row * charh
   sinfo = "5 Intelligence: " & _cinfo.intatt(0)
   DrawStringShadow tx, ty, sinfo
   row += 2
   ty = row * charh
   sinfo = "Max Hit Points:   " & _cinfo.maxhp
   DrawStringShadow tx, ty, sinfo
   row += 2
   ty = row * charh
   sinfo = "Max Mana Points:   " & _cinfo.maxmana
   DrawStringShadow tx, ty, sinfo
   row += 3
   ty = row * charh
   sinfo = "Unarmed Combat:    " & _cinfo.ucfsk(0)
   DrawStringShadow tx, ty, sinfo
   row += 2
   ty = row * charh
   sinfo = "Armed Combat:      " & _cinfo.acfsk(0)
   DrawStringShadow tx, ty, sinfo
   row += 2
   ty = row * charh
   sinfo = "Projectile Combat: " & _cinfo.pcfsk(0)
   DrawStringShadow tx, ty, sinfo
   row += 2
   ty = row * charh
   sinfo = "Magic Combat:      " & _cinfo.mcfsk(0)
   DrawStringShadow tx, ty, sinfo
   row += 2
   ty = row * charh
   sinfo = "Combat Defense:    " & _cinfo.cdfsk(0)
   DrawStringShadow tx, ty, sinfo
   row += 2
   ty = row * charh
   sinfo = "Magic Defense:     " & _cinfo.mdfsk(0)
   DrawStringShadow tx, ty, sinfo
   row += 3
   ty = row * charh
   sinfo = "Experience: " & _cinfo.currxp
   DrawStringShadow tx, ty, sinfo
   row += 2
   ty = row * charh
   sinfo = "Gold:       " & _cinfo.currgold
   DrawStringShadow tx, ty, sinfo

   ScreenUnLock
End Sub

'Adds inventory item to character inventory slot.
Sub character.AddInvItem(idx As Integer, inv As invtype)
   'Check to see if the index is in bounds.
   If idx >= LBound(_cinfo.cwield) And idx <= UBound(_cinfo.cwield) Then
      'Clear the inventory slot.
      ClearInv _cinfo.cwield(idx)
      'Set the item in the inv slot.
      _cinfo.cwield(idx) = inv
   Else
      'Validate the inventory index.
      If idx >= LBound(_cinfo.cinv) And idx <= UBound(_cinfo.cinv) Then
         'Clear the inventory slot.
         ClearInv _cinfo.cinv(idx)
         'Set the item in the inv slot.
         _cinfo.cinv(idx) = inv
      End If   
   EndIf
End Sub

'Gets an item from an inventory slot.
Sub character.GetInventoryItem(idx As Integer, inv As invtype)
   
   'Clear the inv item.
   ClearInv inv
   'Check st see if the items in a help item.
   If idx >= LBound(_cinfo.cwield) And idx <= UBound(_cinfo.cwield) Then
      'Set the item in the inv slot.
      inv = _cinfo.cwield(idx)
   Else
      'Validate the index.
      If idx >= LBound(_cinfo.cinv) And idx <= UBound(_cinfo.cinv) Then
         inv = _cinfo.cinv(idx)
      End If
   End If
End Sub

'Goes through all bonus settings and adjusts counts, applies poison, etc.
Sub character.DoTimedActions ()
   Dim As Integer roll1, roll2, v1, v2
   
   'Poison will affect character based on strength of poison.
   If _cinfo.IsPoisoned = TRUE Then
      'Get the strength of the poison.
      v1 = _cinfo.PoisonStr
      'Get character stamina + bonus
      v2 = _cinfo.staatt(idxAttr) + _cinfo.staatt(idxAttrBon)
      'Roll for the poison.
      roll1 = RandomRange(1, v1)
      roll2 = RandomRange(1, v2)
      'Poison won.
      If roll1 > roll2 Then
         'Take one off the health.
         _cinfo.currhp = _cinfo.currhp - 1 
      EndIf
   EndIf
   'Check the counts
   If _cinfo.stratt(idxAttrCnt) > 0 Then
      'Dec the count.
      _cinfo.stratt(idxAttrCnt) -= 1
      If _cinfo.stratt(idxAttrCnt) <= 0 Then
         'Reset bonus amt.
         _cinfo.stratt(idxAttrBon) = 0
      EndIf
   EndIf
   
   If _cinfo.staatt(idxAttrCnt) > 0 Then
      _cinfo.staatt(idxAttrCnt) -= 1
      If _cinfo.staatt(idxAttrCnt) <= 0 Then
         _cinfo.staatt(idxAttrBon) = 0
      End If
   EndIf

   If _cinfo.dexatt(idxAttrCnt) > 0 Then
      _cinfo.dexatt(idxAttrCnt) -= 1
      If _cinfo.dexatt(idxAttrCnt) <= 0 Then
         _cinfo.dexatt(idxAttrBon) = 0
      End If
   EndIf

   If _cinfo.aglatt(idxAttrCnt) > 0 Then
      _cinfo.aglatt(idxAttrCnt) -= 1
      If _cinfo.aglatt(idxAttrCnt) <= 0 Then
         _cinfo.aglatt(idxAttrBon) = 0
      End If
   EndIf

   If _cinfo.intatt(idxAttrCnt) > 0 Then
      _cinfo.intatt(idxAttrCnt) -= 1
      If _cinfo.intatt(idxAttrCnt) <= 0 Then
         _cinfo.intatt(idxAttrBon) = 0
      End If
   EndIf

   If _cinfo.ucfsk(idxAttrCnt) > 0 Then
      _cinfo.ucfsk(idxAttrCnt) -= 1
      If _cinfo.ucfsk(idxAttrCnt) <= 0 Then
         _cinfo.ucfsk(idxAttrBon) = 0
      End If
   EndIf

   If _cinfo.acfsk(idxAttrCnt) > 0 Then
      _cinfo.acfsk(idxAttrCnt) -= 1
      If _cinfo.acfsk(idxAttrCnt) <= 0 Then
         _cinfo.acfsk(idxAttrBon) = 0
      End If
   EndIf

   If _cinfo.pcfsk(idxAttrCnt) > 0 Then
      _cinfo.pcfsk(idxAttrCnt) -= 1
      If _cinfo.pcfsk(idxAttrCnt) <= 0 Then
         _cinfo.pcfsk(idxAttrBon) = 0
      End If
   EndIf

   If _cinfo.mcfsk(idxAttrCnt) > 0 Then
      _cinfo.mcfsk(idxAttrCnt) -= 1
      If _cinfo.mcfsk(idxAttrCnt) <= 0 Then
         _cinfo.mcfsk(idxAttrBon) = 0
      End If
   EndIf

   If _cinfo.cdfsk(idxAttrCnt) > 0 Then
      _cinfo.cdfsk(idxAttrCnt) -= 1
      If _cinfo.cdfsk(idxAttrCnt) <= 0 Then
         _cinfo.cdfsk(idxAttrBon) = 0
      End If
   EndIf

   If _cinfo.mdfsk(idxAttrCnt) > 0 Then
      _cinfo.mdfsk(idxAttrCnt) -= 1
      If _cinfo.mdfsk(idxAttrCnt) <= 0 Then
         _cinfo.mdfsk(idxAttrBon) = 0
      End If
   EndIf
End Sub

'Changes attribute and updates associated stats.
Sub character.ChangeStrength(change As Integer)
   'Update the attribute
   _cinfo.stratt(idxAttr) = _cinfo.stratt(idxAttr) + change
   If _cinfo.stratt(idxAttr) < 1 Then _cinfo.stratt(idxAttr) = 1
   'Update the combat factor. 
   _cinfo.currhp = _cinfo.stratt(idxAttr) + _cinfo.staatt(idxAttr)
   _cinfo.maxhp = _cinfo.currhp 
   _cinfo.ucfsk(idxAttr) = _cinfo.stratt(idxAttr) + _cinfo.aglatt(idxAttr)
   _cinfo.acfsk(idxAttr) = _cinfo.stratt(idxAttr) + _cinfo.dexatt(idxAttr)
   _cinfo.cdfsk(idxAttr) = _cinfo.stratt(idxAttr) + _cinfo.aglatt(idxAttr)
End Sub

'Changes attribute and updates associated stats.
Sub character.ChangeStamina(change As Integer)
      'Update the attribute
      _cinfo.staatt(idxAttr) = _cinfo.staatt(idxAttr) + change
      If _cinfo.staatt(idxAttr) < 1 Then _cinfo.staatt(idxAttr) = 1
      'Update the combat factor. 
      _cinfo.currhp = _cinfo.stratt(idxAttr) + _cinfo.staatt(idxAttr)
      _cinfo.maxhp = _cinfo.currhp 
      _cinfo.currmana = _cinfo.intatt(idxAttr) + _cinfo.staatt(idxAttr) 
      _cinfo.maxmana = _cinfo.currmana
      _cinfo.mcfsk(idxAttr) = _cinfo.intatt(idxAttr) + _cinfo.staatt(idxAttr)
End Sub

'Changes attribute and updates associated stats.
Sub character.ChangeDexterity(change As Integer)
      'Update the attribute
      _cinfo.dexatt(idxAttr) = _cinfo.dexatt(idxAttr) + change
      If _cinfo.dexatt(idxAttr) < 1 Then _cinfo.dexatt(idxAttr) = 1
      'Update the combat factor. 
      _cinfo.acfsk(idxAttr) = _cinfo.stratt(idxAttr) + _cinfo.dexatt(idxAttr)
      _cinfo.pcfsk(idxAttr) = _cinfo.dexatt(idxAttr) + _cinfo.intatt(idxAttr)
End Sub

'Changes attribute and updates associated stats.
Sub character.ChangeAgility(change As Integer)
      'Update the attribute
      _cinfo.aglatt(idxAttr) = _cinfo.aglatt(idxAttr) + change
      If _cinfo.aglatt(idxAttr) < 1 Then _cinfo.aglatt(idxAttr) = 1
      'Update the combat factor. 
      _cinfo.ucfsk(idxAttr) = _cinfo.stratt(idxAttr) + _cinfo.aglatt(idxAttr)
      _cinfo.mdfsk(idxAttr) = _cinfo.aglatt(idxAttr) + _cinfo.intatt(idxAttr)
      _cinfo.cdfsk(idxAttr) = _cinfo.stratt(idxAttr) + _cinfo.aglatt(idxAttr)
End Sub

'Changes attribute and updates associated stats. 
Sub character.ChangeIntelligence(change As Integer)
      'Update the attribute
      _cinfo.intatt(idxAttr) = _cinfo.intatt(idxAttr) + change
      If _cinfo.intatt(idxAttr) < 1 Then _cinfo.intatt(idxAttr) = 1
      charint = _cinfo.intatt(idxAttr) + _cinfo.intatt(idxAttrBon)
      'Update the mana factor. 
      _cinfo.currmana = _cinfo.intatt(idxAttr) + _cinfo.staatt(idxAttr) 
      _cinfo.maxmana = _cinfo.currmana
      'Update the combat factors.
      _cinfo.pcfsk(idxAttr) = _cinfo.dexatt(idxAttr) + _cinfo.intatt(idxAttr)
      _cinfo.mcfsk(idxAttr) = _cinfo.intatt(idxAttr) + _cinfo.staatt(idxAttr)
      _cinfo.mdfsk(idxAttr) = _cinfo.aglatt(idxAttr) + _cinfo.intatt(idxAttr)
End Sub



'Decrements the ammo in held weapon.
Sub character.DecrementAmmo(slot As wieldpos)
   _cinfo.cwield(slot).weapon.ammocnt -= 1
   If _cinfo.cwield(slot).weapon.ammocnt < 0 Then 
      _cinfo.cwield(slot).weapon.ammocnt = 0
   EndIf
End Sub

'Applies the inv type to the character.
Function character.ApplyInvItem(inv As invtype) As String
   Dim As Integer evalstate, evaldr, amt, amt2, amt3
   Dim As String ret
   
   'Check the eval state.
   evalstate =  IsEval(inv)
   'Check for magic item.
   evalDR = GetEvalDR(inv)
   
   If inv.classid = clSupplies Then
      'Apply item to character.
      If inv.supply.id = supHealingHerb Then
         'Evaluated magical item.
         If (evalstate = TRUE) And (evalDR > 0) Then
            CurrHP = MaxHP
            ret = "The Healing Herb completely healed you!"
         Else
            'Does 50% healing.
            amt = MaxHP * .5 'Calc the amount.
            CurrHP = CurrHP + amt
            If CurrHP > MaxHP Then
               CurrHP = MaxHP
            EndIf
            ret = "The Healing Herb added " & amt & " health!"
         EndIf
      ElseIf inv.supply.id = supHunkMeat Then
        'Does 25% healing.
        amt = MaxHP * .25
         CurrHP = CurrHP + amt 
         If CurrHP > MaxHP Then
            CurrHP = MaxHP
         EndIf
         ret = "The Hunk of Meat added " & amt & " health!"
         'Evaluated magical item.
         If (evalstate = TRUE) And (evalDR > 0) Then
            amt2 = RandomRange(1, CurrStr)
            BonStr = amt2
            amt3 = RandomRange(1, 100)
            BonStrCnt = amt3  
            ret = "The Hunk of Meat added " & amt & " health and added " & amt2 & " strength for " & amt3 & " turns!" 
         EndIf
      ElseIf inv.supply.id = supBread Then
        'Does 10% healing.
        amt = MaxHP * .1
         CurrHP = CurrHP + amt 
         If CurrHP > MaxHP Then
            CurrHP = MaxHP
         EndIf
         ret = "The Bread added " & amt & " health!"
         'Evaluated magical item.
         If (evalstate = TRUE) And (evalDR > 0) Then
            'Cure the poison if any.
            If Poisoned = TRUE Then
               Poisoned = FALSE
               PoisonStr = 0
               ret = "The Bread added " & amt & " health and cured your poison!"
            End If
         EndIf
      ElseIf inv.supply.id = supManaOrb Then
         'Adds 25% mana.
         amt = MaxMana * .25
         CurrMana = CurrMana + amt 
         If CurrMana > MaxMana Then
            CurrMana = MaxMana
         EndIf
         ret = "The Mana Orb added " & amt & " mana!"
         'Evaluated magical item.
         If (evalstate = TRUE) And (evalDR > 0) Then
            'Cure the poison if any.
            If CurrMana = MaxMana Then
               ret = "The Mana Orb restored all your mana!"
            End If
         EndIf
      EndIf
   ElseIf inv.classid = clPotion Then
      Select Case inv.potion.effect
         Case potStrength
            ChangeStrength inv.potion.amt
            If inv.potion.amt > 0 Then
               ret = "You gained " & inv.potion.amt & " strength!" 
            Else
               ret = "You lost " & inv.potion.amt & " strength!"
            EndIf
         Case potStamina
            ChangeStamina inv.potion.amt
            If inv.potion.amt > 0 Then
               ret = "You gained " & inv.potion.amt & " stamina!" 
            Else
               ret = "You lost " & inv.potion.amt & " stamina!"
            EndIf
         Case potDexterity
            ChangeDexterity inv.potion.amt
            If inv.potion.amt > 0 Then
               ret = "You gained " & inv.potion.amt & " dexterity!" 
            Else
               ret = "You lost " & inv.potion.amt & " dexterity!"
            EndIf
         Case potAgility
            ChangeAgility inv.potion.amt
            If inv.potion.amt > 0 Then
               ret = "You gained " & inv.potion.amt & " agility!" 
            Else
               ret = "You lost " & inv.potion.amt & " agility!"
            EndIf
         Case potIntelligence
            ChangeIntelligence inv.potion.amt
            If inv.potion.amt > 0 Then
               ret = "You gained " & inv.potion.amt & " intelligence!" 
            Else
               ret = "You lost " & inv.potion.amt & " intelligence!"
            EndIf
         Case potUCF
            BonUcf = inv.potion.amt
            BonUcfCnt = inv.potion.cnt
            If inv.potion.amt > 0 Then
               ret = "You gained " & inv.potion.amt & " Unarmed Combat for " & inv.potion.cnt & " turns!"
            Else
               ret = "You lost " & inv.potion.amt & " Unarmed Combat for " & inv.potion.cnt & " turns!"
            EndIf
         Case potACF
            BonAcf = inv.potion.amt
            BonAcfCnt = inv.potion.cnt
            If inv.potion.amt > 0 Then
               ret = "You gained " & inv.potion.amt & " Armed Combat for " & inv.potion.cnt & " turns!"
            Else
               ret = "You lost " & inv.potion.amt & " Armed Combat for " & inv.potion.cnt & " turns!"
            EndIf
         Case potPCF
            BonPcf = inv.potion.amt
            BonPcfCnt = inv.potion.cnt
            If inv.potion.amt > 0 Then
               ret = "You gained " & inv.potion.amt & " Projectile Combat for " & inv.potion.cnt & " turns!"
            Else
               ret = "You lost " & inv.potion.amt & " Projectile Combat for " & inv.potion.cnt & " turns!"
            EndIf
         Case potMCF
            BonMcf = inv.potion.amt
            BonMcfCnt = inv.potion.cnt
            If inv.potion.amt > 0 Then
               ret = "You gained " & inv.potion.amt & " Magic Combat for " & inv.potion.cnt & " turns!"
            Else
               ret = "You lost " & inv.potion.amt & " Magic Combat for " & inv.potion.cnt & " turns!"
            EndIf
         Case potCDF
            BonCdf = inv.potion.amt
            BonCdfCnt = inv.potion.cnt
            If inv.potion.amt > 0 Then
               ret = "You gained " & inv.potion.amt & " Combat Defense for " & inv.potion.cnt & " turns!"
            Else
               ret = "You lost " & inv.potion.amt & " Combat Defense for " & inv.potion.cnt & " turns!"
            EndIf
         Case potMDF
            BonMdf = inv.potion.amt
            BonMdfCnt = inv.potion.cnt
            If inv.potion.amt > 0 Then
               ret = "You gained " & inv.potion.amt & " Magic Defense for " & inv.potion.cnt & " turns!"
            Else
               ret = "You lost " & inv.potion.amt & " Magic Defense for " & inv.potion.cnt & " turns!"
            EndIf
         Case potHealing
            CurrHP = CurrHP + inv.potion.amt
            If CurrHP > MaxHP Then CurrHP = MaxHP 
            If inv.potion.amt > 0 Then
               ret = "You gained " & inv.potion.amt & " health!"
            Else
               ret = "You lost " & inv.potion.amt & " health!"
            EndIf
         Case potMana
            CurrMana = CurrMana + inv.potion.amt
            If CurrMana > MaxMana Then CurrMana = MaxMana
            If inv.potion.amt > 0 Then
               ret = "You gained " & inv.potion.amt & " mana!"
            Else
               ret = "You lost " & inv.potion.amt & " mana!"
            EndIf
      End Select
   EndIf
   
   Return ret
End Function

'Returns True if item exists in inventory slot.
Function character.HasInvItem(idx As Integer) As Integer
   'Check held items.
   If idx >= LBound(_cinfo.cwield) And idx <= UBound(_cinfo.cwield) Then
      'Check the class id.
      If _cinfo.cwield(idx).classid = clNone Then
         Return FALSE
      Else
         Return TRUE
      EndIf
   Else
      'Validate the index.
      If idx >= LBound(_cinfo.cinv) And idx <= UBound(_cinfo.cinv) Then
         'Check the class id.
         If _cinfo.cinv(idx).classid = clNone Then
            Return FALSE
         Else
            Return TRUE
         EndIf
      Else
         Return FALSE
      End If   
   EndIf
   
End Function

'Generates a new character.
Function character.GenerateCharacter() As Integer
   Dim As String chname, prompt, skey
   Dim As Integer done = FALSE, ret = TRUE, tx, ty, idx
   Dim As tWidgets.btnID btn
   Dim As tWidgets.tInputbox ib
   Dim inv As invtype
   Dim arm As armorids
   
   'Set up user input prompt.
   prompt = "Press <r> to roll again, <enter> to accept, <esc> to exit to menu."
   tx = CenterX(prompt)
   ty = (txrows - 6)
   ScreenLock   
   'Draw the background.
   DrawBackground charback()
   ScreenUnLock
   ib.Title = "Character Name"
   ib.Prompt = "Enter your character's name:"
   ib.MaxLen = 35
   ib.InputLen = 35
   'Get the name of the character.
   btn = ib.Inputbox(chname)
   If btn = tWidgets.btnID.gbnCancel Then
      ret = FALSE
   EndIf
   If btn = tWidgets.btnID.gbnOK Then
      ret = TRUE
   EndIf
   'Display character.
   If ret = TRUE Then
      'Generate the character data.
      Do
         With _cinfo
            .cname = chname
            .stratt(idxAttr) = RandomRange (10, 20) 'Generate new stat.
            .staatt(idxAttr) = RandomRange (10, 20)
            .dexatt(idxAttr) = RandomRange (10, 20)
            .aglatt(idxAttr) = RandomRange (10, 20)
            .intatt(idxAttr) = RandomRange (10, 20)
            charint = _cinfo.intatt(idxAttr) + _cinfo.intatt(idxAttrBon)
            .stratt(idxAttrBon) = 0                   'Clear any bonuses.
            .staatt(idxAttrBon) = 0
            .dexatt(idxAttrBon) = 0
            .aglatt(idxAttrBon) = 0
            .intatt(idxAttrBon) = 0
            .stratt(idxAttrCnt) = 0                   'Clear counts.
            .staatt(idxAttrCnt) = 0
            .dexatt(idxAttrCnt) = 0
            .aglatt(idxAttrCnt) = 0
            .intatt(idxAttrCnt) = 0
            .currhp = .stratt(idxAttr) + .staatt(idxAttr) 
            .maxhp = .currhp
            .currmana = .intatt(idxAttr) + .staatt(idxAttr) 
            .maxmana = .currmana
            .ucfsk(idxAttr) = .stratt(idxAttr) + .aglatt(idxAttr) 
            .acfsk(idxAttr) = .stratt(idxAttr) + .dexatt(idxAttr) 
            .pcfsk(idxAttr) = .dexatt(idxAttr) + .intatt(idxAttr)
            .mcfsk(idxAttr) = .intatt(idxAttr) + .staatt(idxAttr)
            .cdfsk(idxAttr) = .stratt(idxAttr) + .aglatt(idxAttr)
            .mdfsk(idxAttr) = .aglatt(idxAttr) + .intatt(idxAttr)
            .ucfsk(idxAttrBon) = 0                       'Clear bonuses. 
            .acfsk(idxAttrBon) = 0 
            .pcfsk(idxAttrBon) = 0
            .mcfsk(idxAttrBon) = 0
            .cdfsk(idxAttrBon) = 0
            .mdfsk(idxAttrBon) = 0
            .ucfsk(idxAttrCnt) = 0                       'Clear counts.. 
            .acfsk(idxAttrCnt) = 0 
            .pcfsk(idxAttrCnt) = 0
            .mcfsk(idxAttrCnt) = 0
            .cdfsk(idxAttrCnt) = 0
            .mdfsk(idxAttrCnt) = 0
            .currxp = RandomRange (100, 200)
            .totxp = .currxp
            .currgold = RandomRange (50, 100)
            .totgold = .currgold
            .ploc.x = 0
            .ploc.y = 0
         End With
         'Print out the current character stats.
         PrintStats
         PutTextShadow prompt, ty, tx
         'Get the user command.
         Do
            'Get the key press.
            skey = Inkey
            'Fornat to lower case.
            skey = LCase(skey)
            'If escape exit back to menu.
            If skey = key_esc Then
               done = TRUE
               ret = FALSE
            EndIf
            'If enter continue with game.
            If skey = key_enter Then
               done = TRUE
            EndIf
            Sleep 10
         Loop Until (skey = "r") Or (skey = key_esc) Or (skey = key_enter)
      Loop Until done = TRUE
   End If
   'Add best armor.
   arm = _GetBestArmor
   GenerateArmor inv, 1, arm
   SetInvEval inv, TRUE
   AddInvItem wArmor, inv
   'Add short sword to character
   ClearInv inv
   GenerateWeapon inv, 1, wpShortsword
   SetInvEval inv, TRUE
   AddInvItem wPrimary, inv
      
   Return ret
End Function

'Returns free inventory slot index or -1.
Function character.GetFreeInventoryIndex() As Integer
   Dim As Integer ret = -1
   
   'Look for an empty inventory slot.
   For i As Integer = LBound(_cinfo.cinv) To UBound(_cinfo.cinv)
      'Examine class id.
      If _cinfo.cinv(i).classid = clNone Then
         'Empty slot.
         ret = i
         Exit For
      EndIf
   Next
   
   Return ret
End Function

'Returns True if character can wear item.
Function character.CanWear(inv As invtype) As Integer
   Dim As Integer ret = TRUE
   
   If inv.classid = clArmor Then
      If inv.armor.struse > _cinfo.stratt(idxAttr) Then
         ret = FALSE
      EndIf
   EndIf

   If inv.classid = clShield Then
      If inv.shield.struse > _cinfo.stratt(idxAttr) Then
         ret = FALSE
      EndIf
   EndIf
   
   Return ret
End Function

'Returns the current noise volume.
Function character.GetNoise() As Integer
   Dim As Integer ret = 0
   
   'Get gold amount.
   ret = _cinfo.currgold / 10
   'Get inventory amounts.
   For i As Integer = LBound(_cinfo.cinv) To UBound(_cinfo.cinv) 
      ret += GetItemNoise(_cinfo.cinv(i))
   Next
   'Get held amounts.
   For i As Integer = LBound(_cinfo.cwield) To UBound(_cinfo.cwield) 
      ret += GetItemNoise(_cinfo.cwield(i))
   Next
   
   Return ret
End Function

'Returns the current combat factor based on what the character is wielding.
Function character.GetMeleeCombatFactor() As Integer
   Dim As Integer ret
   
   'Unarmed combat.
   If (_cinfo.cwield(wPrimary).classid <> clWeapon) And (_cinfo.cwield(wSecondary).classid <> clWeapon) Then
      ret = CurrUcf + BonUcf
   Else
      'Check primary slot.
      If _cinfo.cwield(wPrimary).classid = clWeapon Then
         'Wielding a melee weapon.
         If _cinfo.cwield(wPrimary).weapon.weapontype <> wtProjectile Then
            ret = CurrAcf + BonAcf
         Else
          'Return UCF as projectile weapon isn't melee weapon.
           ret = CurrUcf + BonUcf
         EndIf
      Else
         If _cinfo.cwield(wSecondary).classid = clWeapon Then
            'Wielding a melee weapon.
            If _cinfo.cwield(wSecondary).weapon.weapontype <> wtProjectile Then
               ret = CurrAcf + BonAcf
            Else
               'Return UCF as projectile weapon isn't melee weapon.
               ret = CurrUcf + BonUcf
            End If
         EndIf
      End If
   EndIf

    Return ret     
End Function

'Return projectile combat factor.
Function character.GetProjectileCombatFactor() As Integer
   Return CurrPCF + BonPcf
End Function

'Return magic combat factor.
Function character.GetMagicCombatFactor() As Integer
   Return CurrMCF + BonMcf
End Function

'Returns the amount of weapon damage.
Function character.GetWeaponDamage(wslot As wieldpos = wAny) As Integer
   Dim As Integer ret = 0
   
   'See if we have any weapons.
   If (_cinfo.cwield(wPrimary).classid <> clWeapon) And (_cinfo.cwield(wSecondary).classid <> clWeapon) Then
      'If no weapon get the stength value plus bonus.
      ret = (_cinfo.stratt(idxAttr) + _cinfo.stratt(idxAttrBon)) / 2
   Else
      If wslot = wAny Then
         'Have one or more weapons.
         If _cinfo.cwield(wPrimary).classid = clWeapon Then
            'Get the current weapon damage.
            ret = _cinfo.cwield(wPrimary).weapon.dam
         EndIf
         If _cinfo.cwield(wSecondary).classid = clWeapon Then
            ret += _cinfo.cwield(wSecondary).weapon.dam
         EndIf
      Else
         ret = _cinfo.cwield(wSlot).weapon.dam
      End If
   EndIf
   
   Return ret
End Function

'Returns the character's defense factor.
Function character.GetDefenseFactor () As Integer
   Dim As Integer ret
   
   ret = currCdf + BonCdf
   
   Return ret
End Function

'Returns the current armor value.
Function character.GetArmorValue() As Single
   Dim As Single ret = 0.0
   
   'Check for armor.
   If _cinfo.cwield(wArmor).classid <> clNone Then
      ret = _cinfo.cwield(wArmor).armor.dampct 
   EndIf
   
   Return ret
End Function

'Returns any shield armor value.
Function character.GetShieldArmorValue () As Single
   Dim As Single ret = 0.0
   Dim As Integer cnt
      
   'Check for any shields.
   If _cinfo.cwield(wPrimary).classid = clShield Then
      ret += _cinfo.cwield(wPrimary).shield.dampct
      cnt = 1
   EndIf   
   If _cinfo.cwield(wSecondary).classid = clShield Then
      ret += _cinfo.cwield(wSecondary).shield.dampct
      cnt += 1
   EndIf
   
   'Get the average of the values if any.
   If cnt > 0 Then
      ret = ret / cnt
   EndIf
   
   Return ret
End Function

'Returns True if character has pojectile weapon equipped.
Function character.ProjectileEquipped(slot As wieldpos) As Integer 
   Dim As Integer ret = FALSE
   
   'Make sure the classid is a weapon.
   If _cinfo.cwield(wPrimary).classid = clWeapon Then
      'Make sure the weapon is a projectile.
      If _cinfo.cwield(wPrimary).weapon.weapontype = wtProjectile Then
         'Check the slot.
         If (slot = wAny) Or (slot = wPrimary) Then
            ret = TRUE
         End If
      EndIf
   Else
      'Make sure the classid is a weapon.
      If _cinfo.cwield(wSecondary).classid = clWeapon Then
         'Make sure the weapon is a projectile.
         If _cinfo.cwield(wSecondary).weapon.weapontype = wtProjectile Then
            'Check the slot.
            If (slot = wAny) Or (slot = wSecondary) Then
               ret = TRUE
            End If
         EndIf
      EndIf
   EndIf
   
   Return ret
End Function

'Returns true if projectile weapon in slot has ammo.
Function character.IsLoaded(slot As wieldpos) As Integer
   Dim As Integer ret = FALSE
   
   'Make sure we have a weapon.
   If _cinfo.cwield(slot).classid = clWeapon Then
      'Make sure it is a projectile.
      If _cinfo.cwield(slot).weapon.weapontype = wtProjectile Then
         'Check the loaded flag.
         ret = (_cinfo.cwield(slot).weapon.ammocnt > 0)
      EndIf
   EndIf
   
   Return ret
End Function

'Returns the ammoid for projectile weapon in slot.
Function character.GetAmmoID(slot As wieldpos) As ammoids
   Dim ret As armorids
   
   'Check to see if slot is holding a weapon.
   If _cinfo.cwield(slot).classid = clWeapon Then
      'Make sure it is projectile weapon.
      If _cinfo.cwield(slot).weapon.weapontype = wtProjectile Then
         ret = _cinfo.cwield(slot).weapon.ammotype
      Else
         ret = amNone
      EndIf
   Else
      ret = amNone
   EndIf
   Return ret
End Function

'Returns True if weapon was loaded.
Function character.LoadProjectile(aid As ammoids, slot As wieldpos) As Integer 
   Dim As Integer ret = FALSE, i, iitem
   Dim As invtype inv
   
   'Look through the inventory and see if we have any ammo matching ammo id.
   For i = LowInv To HighInv
      'If the weapon is full, then exit.
      If _cinfo.cwield(slot).weapon.ammocnt = _cinfo.cwield(slot).weapon.capacity Then
         Exit For
      EndIf
      iitem = HasInvItem(i)
      If iitem = TRUE Then
         'Get the inv item.
         GetInventoryItem i, inv
         'Check the class id.
         If inv.classid = clAmmo Then
            'See if it is the same ammo as passed id.
            If inv.ammo.id = aid Then
               'Load weapon to capacity.
               Do While _cinfo.cwield(slot).weapon.ammocnt < _cinfo.cwield(slot).weapon.capacity
                  'Load the weapon.
                  _cinfo.cwield(slot).weapon.ammocnt += 1
                  inv.ammo.cnt -= 1
                  'If no more ammo then exit.
                  If inv.ammo.cnt = 0 Then
                     Exit Do
                  EndIf
               Loop
               'Update the inventory.
               If inv.ammo.cnt > 0 Then
                  AddInvItem i,inv
               Else
                  ClearInv inv
                  AddInvItem i,inv
               EndIf
               'Does the weapon have ammo?
               If _cinfo.cwield(slot).weapon.ammocnt > 0 Then
                  ret = TRUE
               EndIf
            EndIf
         EndIf
      EndIf
   Next
   
   Return ret
End Function

'Returns state of idwand flag.
Function character.ProjectileIsWand(slot As wieldpos) As Integer
   Return _cinfo.cwield(slot).weapon.iswand
End Function

'Returns True if x and y are at char's location.
Function character.IsLocation(x As Integer, y As Integer) As Integer
   Dim As Integer ret = FALSE
   
   If (x = LocX) And (y = LocY) Then
      ret = TRUE
   EndIf
   
   Return ret   
End Function

'Set up our character variable.
Dim Shared pchar As character


