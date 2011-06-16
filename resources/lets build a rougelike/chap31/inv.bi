/'****************************************************************************
*
* Name: inv.bi
*
* Synopsis: Inventory routines for DOD.
*
* Description: This file contains the the inventory routines used in the game.  
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
Dim Shared charint As Integer 'Need this for the evaldrs.

'Armor strength ratings.
Const strCloth = 10
Const strLeather = 50
Const strCuirboli = 100
Const strRing = 150
Const strBrigantine = 200
Const strChain = 250
Const strScale = 300
Const strPlate = 350

'Effects ids.
Enum spellid
   splNone        'No effect.
   splMaxHealing  'Heal to max HP.
   splStrongMeat  'Adds bonus to Str for count time.
   splBreadLife   'Cures any poison.
   splMaxMana     'Restore full mana.
   splSerpentBite 'Weapon: Inflict poison damage.
   splRend        'Weapon: Decrease armor of target.
   splSunder      'Weapon: Decrease target weapon damage.
   splReaper      'Weapon: Causes monster to flee in fright.
   splFire        'Weapon: Does fire damage to target for lvl turns.
   splGoliath     'Weapon: Adds str to attack.
   splStun        'Weapon: Stuns target for lvl turns.
   splChaos       'Weapon: Random amount of additonal damage.
   splWraith      'Weapon: Decreases random stat of target.
   splThief       'Weapon: Steals random stat amount from target and adds to character.
   splNoSlash     'Armor: +% from slash attacks.
   splNoCrush     'Armor: +% from crush attacks.
   splNoPierce    'Armor: +% from pierce attacks.
   splNoEnergy    'Armor: +% from energy attacks.
   splNoFire      'Armor: +% from fire attacks.
   splNoAcid      'Armor: +% from acid attacks.
   splNoMagic     'Armor: +% from magic attacks.
End Enum

'Item use id.
Enum itemuse
   useNone      'No Use
   useEatDrink  'Eat or drink item.
   useWieldWear 'Wield or wear.
End Enum

'Item class ids.
Enum classids
   clNone
   clGold
   clSupplies 
   clArmor
   clShield
   clWeapon
   clAmmo
   clPotion
   clRing
   clNecklace
   clSpellBook
End Enum

'Gold item ids.
Enum goldids
   gldGoldNone   'No gold.
   gldGold       'Gold coins.
   gldBagGold    'Bag of gold.
End Enum

'Supply item ids.
Enum supplyids
   supSupplyNone  'No supply id.
   supHealingHerb 'Healing herb-50% of max HP healing effect.
   supHunkMeat    '25% of max HP healing effect.
   supBread       '10% of max HP healing effect.
   supManaOrb     '10% of max mana to mana total.
End Enum

'Armor ids
Enum armorids
   armArmorNone
   armCloth        'Cloth armor 1% damage reduction
   armLeather      'Leather armor: 5% damage reduction
   armCuirboli     'Cuirboli armor: 10 % damage reduction
   armRing         'Ring armor: 20% damage reduction
   armBrigantine   'Brigantine armor: 30% dam reduction
   armChain        'Chain armor: 50 % dam reduction
   armScale        'Scale armor: 70% dam reduction
   armPlate        'Plate armor: 90% dam reduction
End Enum

'Shield ids
Enum shieldids
   shldShieldNone
   shldLeather    'Shield amounts same as armor.
   shldCuirboli
   shldRing
   shldBrigantine
   shldChain
   shldScale
   shldPlate
End Enum

'Weapon ids.
Enum weaponids
   wpNone
   wpClub            '1 hand, dam 4 chr:33
   wpWarclub         '1 hand, dam 4
   wpCudgel          '1 hand, dam 5
   wpDagger          '1 hand, dam 4 chr: 173
   wpLongknife       '1 hand, dam 6
   wpSmallsword      '1 hand, dam 4
   wpShortsword      '1 hand, dam 6
   wpRapier          '1 hand, dam 9
   wpBroadsword      '1 hands, dam 12
   wpScimitar        '1 hand, dam 10
   wpKatana          '2 hands, dam 12
   wpLongsword       '2 hands, dam 14
   wpClaymore        '2 hands, dam 16
   wpGreatsword      '2 hands, dam 18
   wpOdinsword       '2 hands, dam 20
   wpHellguard       '2 hands, dam 30
   wpQuarterstaff    '2 hands, dam 4
   wpLongstaff       '2 hands, dam 6
   wpPolearm         '2 hands, dam 8
   wpLightspear      '2 hands, dam 7 chr: 179
   wpHeavyspear      '2 hands, dam 9
   wpTrident         '2 hands, dam 10
   wpGlaive          '2 hands, dam 12
   wpHandaxe         '1 hand, dam 6 chr: 244
   wpBattleaxe       '1 hand, dam 9
   wpGothicbattleaxe '2 hands, dam 12
   wpWaraxe          '2 hands, dam 14
   wpHalberd         '2 hands, dam 16
   wpPoleaxe         '2 hands, dam 18
   wpGreataxe        '2 hands, dam 20
   wpSmallmace       '1 hand, dam 6 chr: 226
   wpBattlemace      '1 hand, dam 8
   wpSpikedmace      '1 hand, dam 10
   wpDoubleballmace  '1 hand, dam 12
   wpWarhammer       '1 hand, dam 14
   wpMaul            '2 hands, dam 16
   wpGreatMaul       '2 hands, dam 20
   wpHellMaul        '2 hands, dam 30
   wpBullwhip        '1 hand, dam 4 chr: 231
   wpBallflail       '1 hand, dam 6
   wpSpikedflail     '1 hand, dam 8
   wpMorningstar     '1 hand, dam 10
   wpBattleflail     '2 hand, dam 12
   wpBishopsflail    '2 hand, dam 14
   wpSling           '1 hand, dam 2 chr: 125
   wpShortbow        '2 hands, dam 8
   wpLongbow         '2 hands, dam 10
   wpBonebow         '2 hands, dam 14
   wpAdaminebow      '2 hands, dam 20
   wpLightcrossbow   '2 hands, dam 10 chr: 209
   wpHeavycrossbow   '2 hands, dam 14
   wpBarrelcrossbow  '2 hands, dam 18
   wpAdaminecrossbow '2 hands, dam 25
   wpIronWand        '1 hand, dam 10
   wpBrassWand       '1 hand, dam 20
   wpCopperWand      '1 hand, dam 40
   wpSilverWand      '1 hand, dam 80
   wpGoldWand        '1 hand, dam 100
End Enum

'Ammo ids.
Enum ammoids
   amNone
   amBagStones
   amCaseBolts
   amQuiverArrows
End Enum

'Wield slots in character inventory.
Enum wieldpos
   wNone
   wPrimary
   wSecondary
   wArmor
   wNeck
   wRingRt
   wRingLt
   wAny
End Enum

'Weapon type.
Enum weaptype
   wtNone
   wtMelee
   wtProjectile
End Enum

'Weapon damage type.
Enum weapdamtype
   wdNone
   wdSlash
   wdCrush
   wdPierce
   wdEnergy
   wdFire
   wdAcid
   wdMagicProt
   wdMagic
End Enum

'The effect of the potion.
Enum poteffect
   potEffectNone
   potStrength
   potStamina
   potDexterity
   potAgility
   potIntelligence
   potUCF
   potACF
   potPCF
   potMCF
   potCDF
   potMDF
   potHealing
   potMana
End Enum

'Potion ids.
Enum potionids
   potNone
   potWhite 'str
   potBlack 'sta
   potBlue 'dex
   potGreen 'agl
   potCyan 'int
   potRed 'ucf
   potMagenta 'acf
   potYellow 'pcf
   potGray 'mcf
   potSilver 'cdf
   potGold 'mdf
   potOrange 'healing
   potPink 'mana
End Enum

'Jewelry ids
Enum jewleryids
   jewNone
   jewSteel
   jewBronze
   jewCopper
   jewBrass
   jewSilver
   jewGold
   jewAgate
   jewOpal
   jewAmethyst
   jewRuby
   jewEmerald
   jewJade
   jewPearl
   jewQuartz
   jewSapphire
   jewDiamond
End Enum

'Type of jewlery
Enum jewtype
   jNone
   jRing
   jNecklace
End Enum

'Spell info type.
Type spelltype
   id As spellid          'The spell id.
   lvl As Integer         'Spell level.
   splname As String * 30 'Spell name.
   spldesc As String * 60 'Spell desc.
   manacost As Integer    'Cost in mana.
   dam As Integer         'The amount of damage the spell does.
End Type

'Armor type
Type jewelrytype
   id As jewleryids          'Jewlery ids
   jtype As jewtype          'Ring or necklace
   evaldr As Integer         'Evaluation difficutly. Evaldr > 0 then magical item.
   eval As Integer           'Is item evaluated.
   spell As spelltype          'Magical spell.
   noise As Integer          'The amount of noise item generates, includes use and in character inventory.
   use As itemuse            'How the item is used.
   jslot(1 To 2) As wieldpos 'Slot item is held in. Could be in up to 2 slots.
End Type

'Potion type.
Type pottype
   id As potionids
   potname As String * 30 'Name of potion. 
   potdesc As String * 30 'Potion desc.
   evaldr As Integer      'Evaluation difficulty rating. Used to evaluate magical effects: 0 = nonMagic.
   eval As Integer        'True if item has been evaluated.
   noise As Integer       'The amount of noise item generates, includes use and in character inventory.
   use As itemuse         'How the item is used.
   amt As Integer         'Effect amount.
   cnt As Integer         'Effect duration.
   effect As poteffect    'The effect type.
End Type

'Ammo type.
Type ammotype
   id As ammoids
   cnt As Integer
   noise As Integer
   eval As Integer    
End Type

'Gold type.
Type goldtype
   id As goldids    'Type of gold item.
   amt As Integer   'Number of gold coins.
End Type

'Supply type def.
Type supplytype
   id As supplyids      'This indicates what sypply is in the type.
   desc As String * 30  'The supply effect.
   evaldr As Integer    'Evaluation difficulty rating. Used to evaluate magical effects: 0 = nonMagic.
   eval As Integer      'True if item has been evaluated.
   spell As spelltype     'The type of magical effect.
   noise As Integer     'The amount of noise item generates, includes use and in character inventory.
   use As itemuse       'How the item is used.
End Type

'Armor type
Type armortype
   id As armorids       'Armor type
   evaldr As Integer    'Evaluation difficutly. Evaldr > 0 then magical item.
   eval As Integer      'Is item evaluated.
   spell As spelltype   'Magical spell.
   spelleffect As weapdamtype 'The spell effect.
   noise As Integer     'The amount of noise item generates, includes use and in character inventory.
   use As itemuse       'How the item is used.
   dampct As Single     'Percentage of damage reduction.
   struse As Integer    'Strength required to use.
   wslot(1 To 2) As wieldpos 'Slot item is held in. Could be in up to 2 slots.
End Type

'Shield type
Type shieldtype
   id As shieldids       'Shield type
   evaldr As Integer    'Evaluation difficutly. Evaldr > 0 then magical item.
   eval As Integer      'Is item evaluated.
   spell As spelltype    'Magical spell.
   spelleffect As weapdamtype 'The spell effect.
   noise As Integer     'The amount of noise item generates, includes use and in character inventory.
   use As itemuse       'How the item is used.
   dampct As Single     'Percentage of damage reduction.
   struse As Integer    'Strength required to use.
   wslot(1 To 2) As wieldpos 'Slot item is held in. Could be in up to 2 slots.
End Type

'Weapon type def.
Type weapontype
   id As weaponids           'Weapon type
   evaldr As Integer         'Evaluation difficutly. Evaldr > 0 then magical item.
   eval As Integer           'Is item evaluated.
   spell As spelltype        'Magical spell.
   noise As Integer          'The amount of noise item generates, includes use and in character inventory.
   use As itemuse            'How the item is used.
   dam As integer            'Damage weapons does.
   hands As Integer          'Number of hands weapon requires.
   wslot(1 To 2) As wieldpos 'Slot item is held in. Could be in up to 2 slots.
   weapontype As weaptype    'Type of weapon: melee, projectile.
   damtype As weapdamtype    'Type of damage infflicted.
   capacity As Integer       'The number of rounds the weapon uses.
   ammotype As ammoids       'Type of ammo used.
   ammocnt As Integer        'Weapon ammo. Can be loaded to capacity.
   iswand As Integer         'Marks item as a wand.
End Type

'Inventory type.
Type invtype
   classid As classids     'This indicates what class is in the union.
   desc As String * 30     'Plain text description.
   icon As String * 1      'This is the item icon.
   iconclr As UInteger     'This is the item's icon color.
   Union                   'Union of item types.
      gold As goldtype     'Gold coins. 
      supply As supplytype 'Supplies.
      armor As armortype   'Armor
      shield As shieldtype 'Shield
      weapon As weapontype 'Weapon
      ammo As ammotype     'Ammo for projectile weapons.
      potion As pottype    'Potion.
      jewelry As jewelrytype 'Rings and necklaces
   End Union
End Type

'Returns the effect description of the potion.
Function GetPotionEffectDesc(effect As poteffect) As String
   Dim As String ret = "None"
   
   Select Case effect
      Case potStrength
         ret = "Strength"
      Case potStamina
         ret = "Stamina"
      Case potDexterity
         ret = "Dexterity"
      Case potAgility
         ret = "Agility"
      Case potIntelligence
         ret = "Intelligence"
      Case potUCF
         ret = "Unarmed Combat"
      Case potACF
         ret = "Armed Combat"
      Case potPCF
         ret = "Projectile Combat"
      Case potMCF
         ret = "Magic Combat"
      Case potCDF
         ret = "Combat Defense"
      Case potMDF
         ret = "Magic Defense"
      Case potHealing
         ret = "Healing"
      Case potMana
         ret = "Mana"
   End Select
   
   Return ret
End Function

'Returns the spell effect for armor.
Function GetArmorSpellEffect(id As spellid) As weapdamtype
   Dim ret As weapdamtype
   
   Select Case id
      Case splNoSlash     
         ret = wdSlash              
      Case splNoCrush     
         ret = wdCrush
      Case splNoPierce    
         ret = wdPierce
      Case splNoEnergy    
         ret = wdEnergy 
      Case splNoMagic     
         ret = wdMagicProt
      Case splNoFire      
         ret = wdFire
      Case wdAcid         
         ret = wdAcid
      Case Else
         ret = wdNone
   End Select
   
   Return ret
End Function

'Returns a description for a spell.
Function GetSpellName(spl As spellid) As String
   Dim As String ret = ""
   
   Select Case spl
      Case splMaxHealing  'Heal to max HP.
         ret = "Spell of Maximum healing."
      Case splStrongMeat 'Adds str bonus for time. 
         ret = "Spell of Enhance Strength."
      Case splBreadLife   'Cures any poison.
         ret = "Spell of Cure Poison."
      Case splMaxMana     'Restore full mana.
         ret = "Spell of Restore Mana."
      Case splSerpentBite 'Weapon: Inflict poison damage.
         ret = "Serpent's Bite"
      Case splRend        'Weapon: Decrease armor of target.
         ret = "Spell of Rend Armor"
      Case splSunder      'Weapon: Decrease target weapon damage.
         ret = "Spell of Sunder"
      Case splReaper      'Weapon: Causes monster to flee.
         ret = "Spell of The Reaper"
      Case splFire        'Weapon: Does fire damage to target for lvl turns.
         ret = "Spell of Fire"
      Case splGoliath     'Weapon: Adds str to attack.
         ret = "The Strength of Goliath"
      Case splStun        'Weapon: Stuns target for lvl turns.
         ret = "Spell of Stun"
      Case splChaos       'Weapon: Random amount of additonal damage.
         ret = "Chaos Attack"
      Case splWraith      'Weapon: Decreases random stat of target.
         ret = "Hand of the Wraith"
      Case splThief       'Weapon: Steals random stat from target and adds to character.
         ret = "Spell of The Phantom"
      Case splNoSlash     'Armor: +% from slash attacks.
         ret = "Spell of Slash Protection"              
      Case splNoCrush     'Armor: +% from crush attacks.
         ret = "Spell of Crush Protection"
      Case splNoPierce    'Armor: +% from pierce attacks.
         ret = "Spell of Pierce Protection"
      Case splNoEnergy    'Armor: +% from energy attacks.
         ret = "Spell of Energy Protection" 
      Case splNoMagic     'Armor: +% from magic attacks.
         ret = "Spell of Magic Protection"
      Case splNoFire      'Armor: +% from fire attacks.
         ret = "Spell of Fire Resist"
      Case wdAcid         'Armor: +% from acid attacks.
         ret = "Spell of Resist Acid"
      Case Else
         ret = "No spell."
   End Select

   Return ret
End Function

'Returns spell effect. Used in spell descriptions.
Function GetSpellEffect(spl As spellid) As String
   Dim As String ret = ""
   
   Select Case spl
      Case splMaxHealing  'Heal to max HP.
         ret = "Restore full health."
      Case splStrongMeat 'Adds str bonus for time. 
         ret = "Adds bonus to strength."
      Case splBreadLife   'Cures any poison.
         ret = "Cures poison."
      Case splMaxMana     'Restore full mana.
         ret = "Restore full mana."
      Case splSerpentBite 'Weapon: Inflict poison damage.
         ret = "Inflicts poison damage over time."
      Case splRend        'Weapon: Decrease armor of target.
         ret = "Decreases armor of target."
      Case splSunder      'Weapon: Decrease target weapon damage.
         ret = "Decreases target weapon damage."
      Case splReaper      'Weapon: Causes monster to flee.
         ret = "Causes monster to flee."
      Case splFire        'Weapon: Does fire damage to target for lvl turns.
         ret = "Inflicts fire damage over time."
      Case splGoliath     'Weapon: Adds str to attack.
         ret = "Adds additional strength to damage."
      Case splStun        'Weapon: Stuns target for lvl turns.
         ret = "Stuns target doing damage for a time."
      Case splChaos       'Weapon: Random amount of additonal damage.
         ret = "Adds random damage to attack."
      Case splWraith      'Weapon: Decreases random stat of target.
         ret = "Decreases random attribute of target."
      Case splThief       'Weapon: Steals random stat from target and adds to character.
         ret = "Steals random attribute amount and adds to character."              
      Case splNoSlash     'Armor: +% from slash weapons.
         ret = "Level % protection from slash attacks."              
      Case splNoCrush     'Armor: +% from crush weapons.
         ret = "Level % protection from crush attacks."
      Case splNoPierce    'Armor: +% from pierce weapons.
         ret = "Level % protection from pierce atatcks."
      Case splNoEnergy    'Armor: +% from energy weapons (wands).
         ret = "Level % protection from energy attacks." 
      Case splNoMagic     'Armor: +% to MDF.
         ret = "Level % protection from magic attacks."
      Case splNoFire     'Armor +% from fire damage.
         ret = "Level % resistance to fire attacks."
      Case wdAcid        'Armor +% from acid damage.
         ret = "Level % resistance to acid attacks."
      Case Else
         ret = "No effect."
   End Select
   
   Return ret
End Function

'Clears the inventory type instance. 
Sub ClearInv(inv As invtype)
   
   'If classid is None then nothing to do.
   If inv.classid <> clNone Then
      Select Case inv.classid
         Case clGold
            inv.gold.id = gldGoldNone
            inv.gold.amt = 0
         Case clSupplies
            inv.supply.id = supSupplyNone
            inv.supply.desc = ""
            inv.supply.evaldr = 0
            inv.supply.eval = FALSE
            inv.supply.spell.id = splNone
            inv.supply.spell.splname = ""
            inv.supply.spell.spldesc = ""
            inv.supply.spell.manacost = 0
            inv.supply.spell.dam = 0
            inv.supply.noise = 0
            inv.supply.use = useNone
         Case clArmor
            inv.armor.id = armArmorNone
            inv.armor.evaldr = 0
            inv.armor.eval = FALSE
            inv.armor.spell.id = splNone
            inv.armor.spell.splname = ""
            inv.armor.spell.spldesc = ""
            inv.armor.spell.manacost = 0
            inv.armor.spell.dam = 0
            inv.armor.noise = 0
            inv.armor.use = UseNone
            inv.armor.dampct = 0
            inv.armor.struse = 0
            inv.armor.wslot(1) = wNone
            inv.armor.wslot(2) = wNone
         Case clShield
            inv.shield.id = shldShieldNone
            inv.shield.evaldr = 0
            inv.shield.eval = FALSE
            inv.shield.spell.id = splNone
            inv.shield.spell.splname = ""
            inv.shield.spell.spldesc = ""
            inv.shield.spell.manacost = 0
            inv.shield.spell.dam = 0
            inv.shield.noise = 0
            inv.shield.use = UseNone
            inv.shield.dampct = 0
            inv.shield.struse = 0
            inv.shield.wslot(1) = wNone
            inv.shield.wslot(2) = wNone
         Case clWeapon
            inv.weapon.id = wpNone
            inv.weapon.evaldr = 0
            inv.weapon.eval = FALSE 
            inv.weapon.spell.id = splNone 
            inv.weapon.spell.splname = ""
            inv.weapon.spell.spldesc = ""
            inv.weapon.spell.manacost = 0
            inv.weapon.spell.dam = 0
            inv.weapon.noise = 0 
            inv.weapon.use = useNone 
            inv.weapon.dam = 0  
            inv.weapon.hands = 0
            inv.weapon.wslot(1) = wNone 
            inv.weapon.wslot(2) = wNone 
            inv.weapon.weapontype = wtNone
            inv.weapon.capacity = 0
            inv.weapon.ammocnt = 0
         Case clAmmo
            inv.ammo.id = amNone
            inv.ammo.cnt = 0
            inv.weapon.evaldr = 0
            inv.weapon.eval = FALSE 
            inv.ammo.noise = 0
         Case clPotion
            inv.potion.id = potNone
            inv.potion.potname = ""
            inv.potion.potdesc = ""
            inv.potion.evaldr = 0
            inv.potion.eval = FALSE
            inv.potion.noise = 0
            inv.potion.use = useNone
            inv.potion.amt = 0
            inv.potion.cnt = 0
            inv.potion.effect = potEffectNone
         Case clRing, clNecklace
            inv.jewelry.id = jewNone
            inv.jewelry.jtype = jNone
            inv.jewelry.evaldr = 0
            inv.jewelry.eval = FALSE
            inv.jewelry.spell.id = splNone
            inv.jewelry.spell.splname = ""
            inv.jewelry.spell.spldesc = ""
            inv.jewelry.spell.manacost = 0
            inv.jewelry.spell.dam = 0
            inv.jewelry.noise = 0
            inv.jewelry.use = useNone
            inv.jewelry.jslot(1) = wNone
            inv.jewelry.jslot(2) = wNone 
      End Select
     'Clear main description.
      inv.desc = ""
      'Clear the classid.
      inv.classid = clNone
      'Clear icon info.
      inv.icon = ""
      inv.iconclr = fbBlack
   EndIf
End Sub

'Returns the item desc for item at x, y coordinate.
Function GetInvItemDesc(inv As invtype) As String
   Dim As String ret = "None"
   
   'If classid is None then nothing to do.
   If inv.classid <> clNone Then
      ret = inv.desc
      'Get weapon description.
      If inv.classid = clWeapon Then
         'Check for loaded state.
         If inv.weapon.weapontype = wtProjectile Then
            If inv.weapon.ammocnt > 0 Then
               ret &= " (Loaded)"
            Else
               ret &= " (Empty)"
            EndIf
         EndIf
      EndIf
   EndIf
   
   Return ret
End Function

'Returns True if item is magic.
Function ItemIsMagic(currlevel As Integer) As Integer
   Dim As Integer num, ret = FALSE
   
   'Get a random number from 1 to 100
   num = RandomRange(1, maxlevel * 2)
   'If number matches or is less than current level, item is magic.
   If num <= currlevel Then
      ret = TRUE
   EndIf
   
   Return ret   
End Function

'Generate a potion.
Sub GeneratePotion(inv As invtype, currlevel As Integer, potid As potionids = potNone)
   Dim item As potionids 
   Dim As Integer effmax = 100
   item = potid
   'Generate item is not passed.
   If item = potNone Then
      item = RandomRange(potWhite, potPink)
   EndIf
   'These are the common items.
   inv.classid = clPotion
   inv.potion.id = item
   inv.potion.use = useEatDrink
   inv.potion.eval = FALSE
   inv.potion.evaldr = GetScaledFactor(charint, currlevel)
   inv.icon = Chr(147)
   inv.potion.noise = 10
   inv.potion.amt = RandomRange(-1, 10)
   If inv.potion.amt = 0 Then inv.potion.amt = 1 
   inv.potion.cnt = 0
   'Set the weapon type and amount.
   Select Case item
      Case potWhite 'str
         inv.iconclr = fbWhite
         inv.desc = "White Potion"
         inv.potion.potname = "Potion of Strength"
         inv.potion.effect = potStrength
         inv.potion.potdesc = GetPotionEffectDesc(inv.potion.effect)
      Case potBlack 'sta
         inv.iconclr = fbBlack
         inv.desc = "Black Potion"
         inv.potion.potname = "Potion of Stamina"
         inv.potion.effect = potStamina
         inv.potion.potdesc = GetPotionEffectDesc(inv.potion.effect)
      Case potBlue 'dex
         inv.iconclr = fbBlue
         inv.desc = "Blue Potion"
         inv.potion.potname = "Potion of Dexterity"
         inv.potion.effect = potDexterity
         inv.potion.potdesc = GetPotionEffectDesc(inv.potion.effect)
      Case potGreen 'agl
         inv.iconclr = fbGreen
         inv.desc = "Green Potion"
         inv.potion.potname = "Potion of Agility"
         inv.potion.effect = potAgility
         inv.potion.potdesc = GetPotionEffectDesc(inv.potion.effect)
      Case potCyan 'int
         inv.iconclr = fbCyan
         inv.desc = "Cyan Potion"
         inv.potion.potname = "Potion of Intelligence"
         inv.potion.effect = potIntelligence
         inv.potion.potdesc = GetPotionEffectDesc(inv.potion.effect)
      Case potRed 'ucf
         inv.iconclr = fbRed
         inv.desc = "Red Potion"
         inv.potion.potname = "Potion of Unarmed Comabt"
         inv.potion.effect = potUCF
         inv.potion.potdesc = GetPotionEffectDesc(inv.potion.effect)
         inv.potion.cnt = RandomRange(1, effmax)
      Case potMagenta 'acf
         inv.iconclr = fbMagenta
         inv.desc = "Magenta Potion"
         inv.potion.potname = "Potion of Armed Combat"
         inv.potion.effect = potACF
         inv.potion.potdesc = GetPotionEffectDesc(inv.potion.effect)
         inv.potion.cnt = RandomRange(1, effmax)
      Case potYellow 'pcf
         inv.iconclr = fbYellow
         inv.desc = "Yellow Potion"
         inv.potion.potname = "Potion of Projectile Combat"
         inv.potion.effect = potPCF
         inv.potion.potdesc = GetPotionEffectDesc(inv.potion.effect)
         inv.potion.cnt = RandomRange(1, effmax)
      Case potGray 'mcf
         inv.iconclr = fbGray
         inv.desc = "Gray Potion"
         inv.potion.potname = "Potion of Magic Comabt"
         inv.potion.effect = potMCF
         inv.potion.potdesc = GetPotionEffectDesc(inv.potion.effect)
         inv.potion.cnt = RandomRange(1, effmax)
      Case potSilver 'cdf
         inv.iconclr = fbSilver
         inv.desc = "Silver Potion"
         inv.potion.potname = "Potion of Combat Defense"
         inv.potion.effect = potCDF
         inv.potion.potdesc = GetPotionEffectDesc(inv.potion.effect)
         inv.potion.cnt = RandomRange(1, effmax)
      Case potGold 'mdf
         inv.iconclr = fbGold
         inv.desc = "Gold Potion"
         inv.potion.potname = "Potion of Magic Defense"
         inv.potion.effect = potMDF
         inv.potion.potdesc = GetPotionEffectDesc(inv.potion.effect)
         inv.potion.cnt = RandomRange(1, effmax)
      Case potOrange 'healing
         inv.iconclr = fbOrange
         inv.desc = "Orange Potion"
         inv.potion.potname = "Potion of Healing"
         inv.potion.effect = potHealing
         inv.potion.potdesc = GetPotionEffectDesc(inv.potion.effect)
      Case potPink 'mana
         inv.iconclr = fbPink
         inv.desc = "Pink Potion"
         inv.potion.potname = "Potion of Mana"
         inv.potion.effect = potMana
         inv.potion.potdesc = GetPotionEffectDesc(inv.potion.effect)
      Case Else
         inv.iconclr = fbWhite
         inv.icon = "?"
         inv.potion.potname = "Unknown Potion"
         inv.desc = inv.potion.potname
         inv.potion.effect = potEffectNone 
   End Select   
End Sub

'Clears the spell type.
Sub ClearSpell (spl As spelltype)
   'Clear the spell type.
   spl.id = splNone
   spl.lvl = 0
   spl.splname = ""
   spl.spldesc = ""
   spl.manacost = 0
   spl.dam = 0
End Sub

'Generates spell data.
Sub GenerateSpell(spl As spelltype, spllevel As Integer)
   
   'Set the defaults.   
   spl.lvl = spllevel 'Spell level.
   spl.splname = GetSpellName(spl.id) 'Sets the spell name.
   spl.spldesc = GetSpellEffect(spl.id) 'Sets the spell description.
   spl.manacost = 0 'Cost in mana.
   spl.dam = spllevel 'Default damage.
   
End Sub

'Generate a weapon.
Sub GenerateWeapon(inv As invtype, currlevel As Integer, wpid As weaponids = wpNone)
   Dim item As weaponids 
   Dim As Integer isMagic 

   isMagic = ItemIsMagic(currlevel)
   item = wpid
   'Generate item is not passed.
   If item = wpNone Then
      item = RandomRange(wpClub, wpGoldWand)
   EndIf
   'These are the common items.
   inv.classid = clWeapon
   inv.weapon.id = item
   inv.iconclr = fbCadmiumYellow
   inv.weapon.use = useWieldWear
   inv.weapon.eval = FALSE
   inv.weapon.wslot(1) = wPrimary
   inv.weapon.wslot(2) = wSecondary
   inv.weapon.iswand = FALSE
   ClearSpell inv.weapon.spell
   'Magic item.
   If IsMagic = TRUE Then
      inv.weapon.evaldr = GetScaledFactor(charint, currlevel) 'The eval dr.
      inv.weapon.spell.id = RandomRange(splSerpentBite, splThief) 'Spell id.
      GenerateSpell inv.weapon.spell, currlevel
   EndIf
   'Set default weapon/ammo types.
   inv.weapon.weapontype = wtMelee
   inv.weapon.ammotype =  amNone
   inv.weapon.ammocnt = 0
   'Set the weapon type and amount.
   Select Case item
      Case wpClub            '1 hand, dam 4 chr:33
         inv.desc = "Club"
         inv.icon = Chr(33)
         inv.weapon.noise = 1
         inv.weapon.dam = 4
         inv.weapon.hands = 1
         inv.weapon.damtype = wdCrush
      Case wpCudgel          '1 hand, dam 5
         inv.desc = "Cudgel"
         inv.icon = Chr(33)
         inv.weapon.noise = 2
         inv.weapon.dam = 5
         inv.weapon.hands = 1
         inv.weapon.damtype = wdCrush
      Case wpWarclub         '1 hand, dam 6
         inv.desc = "War Club"
         inv.icon = Chr(33)
         inv.weapon.noise = 3
         inv.weapon.dam = 6
         inv.weapon.hands = 1
         inv.weapon.damtype = wdCrush
      Case wpDagger          '1 hand, dam 4 chr: 173
         inv.desc = "Dagger"
         inv.icon = Chr(173)
         inv.weapon.noise = 1
         inv.weapon.dam = 4
         inv.weapon.hands = 1
         inv.weapon.damtype = wdPierce
      Case wpLongknife       '1 hand, dam 5
         inv.desc = "Dagger"
         inv.icon = Chr(173)
         inv.weapon.noise = 2
         inv.weapon.dam = 5
         inv.weapon.hands = 1
         inv.weapon.damtype = wdPierce
      Case wpSmallsword      '1 hand, dam 6
         inv.desc = "Small Sword"
         inv.icon = Chr(173)
         inv.weapon.noise = 3
         inv.weapon.dam = 6
         inv.weapon.hands = 1
         inv.weapon.damtype = wdSlash
      Case wpShortsword      '1 hand, dam 8
         inv.desc = "Short Sword"
         inv.icon = Chr(173)
         inv.weapon.noise = 4
         inv.weapon.dam = 8
         inv.weapon.hands = 1
         inv.weapon.damtype = wdSlash
      Case wpRapier          '1 hand, dam 10
         inv.desc = "Rapier"
         inv.icon = Chr(173)
         inv.weapon.noise = 5
         inv.weapon.dam = 10
         inv.weapon.hands = 1
         inv.weapon.damtype = wdSlash
      Case wpBroadsword      '1 hands, dam 12
         inv.desc = "Broadsword"
         inv.icon = Chr(173)
         inv.weapon.noise = 6
         inv.weapon.dam = 12
         inv.weapon.hands = 1
         inv.weapon.damtype = wdSlash
      Case wpScimitar        '1 hand, dam 12
         inv.desc = "Scimitar"
         inv.icon = Chr(173)
         inv.weapon.noise = 7
         inv.weapon.dam = 12
         inv.weapon.hands = 1
         inv.weapon.damtype = wdSlash
      Case wpLongsword       '2 hands, dam 14
         inv.desc = "Longsword"
         inv.icon = Chr(173)
         inv.weapon.noise = 8
         inv.weapon.dam = 16
         inv.weapon.hands = 2
         inv.weapon.damtype = wdSlash
      Case wpKatana          '2 hands, dam 16
         inv.desc = "Katana"
         inv.icon = Chr(173)
         inv.weapon.noise = 9
         inv.weapon.dam = 16
         inv.weapon.hands = 2
         inv.weapon.damtype = wdSlash
      Case wpClaymore        '2 hands, dam 18
         inv.desc = "Claynore"
         inv.icon = Chr(173)
         inv.weapon.noise = 12
         inv.weapon.dam = 18
         inv.weapon.hands = 2
         inv.weapon.damtype = wdSlash
      Case wpGreatsword      '2 hands, dam 20
         inv.desc = "Greatsword"
         inv.icon = Chr(173)
         inv.weapon.noise = 16
         inv.weapon.dam = 20
         inv.weapon.hands = 2
         inv.weapon.damtype = wdSlash
      Case wpOdinsword       '2 hands, dam 30
         inv.desc = "Odinsword"
         inv.icon = Chr(173)
         inv.weapon.noise = 20
         inv.weapon.dam = 30
         inv.weapon.hands = 2
         inv.weapon.damtype = wdSlash
      Case wpHellguard       '2 hands, dam 40
         inv.desc = "Hellguard"
         inv.icon = Chr(173)
         inv.weapon.noise = 30
         inv.weapon.dam = 40
         inv.weapon.hands = 2
         inv.weapon.damtype = wdSlash
      Case wpQuarterstaff    '2 hands, dam 4 chr: 179
         inv.desc = "Quarterstaff"
         inv.icon = Chr(179)
         inv.weapon.noise = 1
         inv.weapon.dam = 4
         inv.weapon.hands = 2
         inv.weapon.damtype = wdCrush
      Case wpLongstaff       '2 hands, dam 6
         inv.desc = "Longstaff"
         inv.icon = Chr(179)
         inv.weapon.noise = 2
         inv.weapon.dam = 6
         inv.weapon.hands = 2
         inv.weapon.damtype = wdCrush
      Case wpLightspear      '2 hands, dam 7 
         inv.desc = "Light Spear"
         inv.icon = Chr(179)
         inv.weapon.noise = 3
         inv.weapon.dam = 7
         inv.weapon.hands = 2
         inv.weapon.damtype = wdPierce
      Case wpPolearm         '2 hands, dam 8
         inv.desc = "Polearm"
         inv.icon = Chr(179)
         inv.weapon.noise = 4
         inv.weapon.dam = 8
         inv.weapon.hands = 2
         inv.weapon.damtype = wdPierce
      Case wpLightspear      '2 hands, dam 9
         inv.desc = "Light Spear"
         inv.icon = Chr(179)
         inv.weapon.noise = 3
         inv.weapon.dam = 5
         inv.weapon.hands = 2
         inv.weapon.damtype = wdPierce
      Case wpHeavyspear      '2 hands, dam 9
         inv.desc = "Heavy Spear"
         inv.icon = Chr(179)
         inv.weapon.noise = 5
         inv.weapon.dam = 9
         inv.weapon.hands = 2
         inv.weapon.damtype = wdPierce
      Case wpTrident         '2 hands, dam 10
         inv.desc = "Trident"
         inv.icon = Chr(179)
         inv.weapon.noise = 6
         inv.weapon.dam = 10
         inv.weapon.hands = 2
         inv.weapon.damtype = wdPierce
      Case wpGlaive          '2 hands, dam 12
         inv.desc = "Glaive"
         inv.icon = Chr(179)
         inv.weapon.noise = 7
         inv.weapon.dam = 12
         inv.weapon.hands = 2
         inv.weapon.damtype = wdPierce
      Case wpHandaxe         '1 hand, dam 6 chr: 244
         inv.desc = "Hand Axe"
         inv.icon = Chr(244)
         inv.weapon.noise = 2
         inv.weapon.dam = 6
         inv.weapon.hands = 1
         inv.weapon.damtype = wdSlash
      Case wpBattleaxe       '1 hand, dam 9
         inv.desc = "Battle Axe"
         inv.icon = Chr(244)
         inv.weapon.noise = 3
         inv.weapon.dam = 9
         inv.weapon.hands = 1
         inv.weapon.damtype = wdSlash
      Case wpGothicbattleaxe '2 hands, dam 12
         inv.desc = "Gothic Battle Axe"
         inv.icon = Chr(244)
         inv.weapon.noise = 4
         inv.weapon.dam = 12
         inv.weapon.hands = 2
         inv.weapon.damtype = wdSlash
      Case wpWaraxe          '2 hands, dam 14
         inv.desc = "War Axe"
         inv.icon = Chr(244)
         inv.weapon.noise = 5
         inv.weapon.dam = 14
         inv.weapon.hands = 2
         inv.weapon.damtype = wdSlash
      Case wpHalberd         '2 hands, dam 16
         inv.desc = "Halberd"
         inv.icon = Chr(244)
         inv.weapon.noise = 6
         inv.weapon.dam = 16
         inv.weapon.hands = 2
         inv.weapon.damtype = wdSlash
      Case wpPoleaxe         '2 hands, dam 18
         inv.desc = "Pole Axe"
         inv.icon = Chr(244)
         inv.weapon.noise = 8
         inv.weapon.dam = 18
         inv.weapon.hands = 2
         inv.weapon.damtype = wdSlash
      Case wpGreataxe        '2 hands, dam 20
         inv.desc = "Great Axe"
         inv.icon = Chr(244)
         inv.weapon.noise = 10
         inv.weapon.dam = 20
         inv.weapon.hands = 2
         inv.weapon.damtype = wdSlash
      Case wpSmallmace       '1 hand, dam 6 chr: 226
         inv.desc = "Small Mace"
         inv.icon = Chr(226)
         inv.weapon.noise = 1
         inv.weapon.dam = 6
         inv.weapon.hands = 1
         inv.weapon.damtype = wdCrush
      Case wpBattlemace      '1 hand, dam 8
         inv.desc = "Battle Mace"
         inv.icon = Chr(226)
         inv.weapon.noise = 4
         inv.weapon.dam = 8
         inv.weapon.hands = 1
         inv.weapon.damtype = wdCrush
      Case wpSpikedmace      '1 hand, dam 10
         inv.desc = "Spiked Mace"
         inv.icon = Chr(226)
         inv.weapon.noise = 6
         inv.weapon.dam = 10
         inv.weapon.hands = 1
         inv.weapon.damtype = wdCrush
      Case wpDoubleballmace  '1 hand, dam 12
         inv.desc = "Double-Ball Mace"
         inv.icon = Chr(226)
         inv.weapon.noise = 8
         inv.weapon.dam = 12
         inv.weapon.hands = 1
         inv.weapon.damtype = wdCrush
      Case wpWarhammer       '1 hand, dam 14
         inv.desc = "War Hammer"
         inv.icon = Chr(226)
         inv.weapon.noise = 10
         inv.weapon.dam = 14
         inv.weapon.hands = 1
         inv.weapon.damtype = wdCrush
      Case wpMaul            '2 hands, dam 16
         inv.desc = "Maul"
         inv.icon = Chr(226)
         inv.weapon.noise = 12
         inv.weapon.dam = 16
         inv.weapon.hands = 2
         inv.weapon.damtype = wdCrush
      Case wpGreatMaul            '2 hands, dam 16
         inv.desc = "Great Maul"
         inv.icon = Chr(226)
         inv.weapon.noise = 12
         inv.weapon.dam = 20
         inv.weapon.hands = 2
         inv.weapon.damtype = wdCrush
      Case wpHellMaul            '2 hands, dam 16
         inv.desc = "Hell Maul"
         inv.icon = Chr(226)
         inv.weapon.noise = 16
         inv.weapon.dam = 30
         inv.weapon.hands = 2
         inv.weapon.damtype = wdCrush
      Case wpBullwhip        '1 hand, dam 4 chr: 231
         inv.desc = "Bull Whip"
         inv.icon = Chr(231)
         inv.weapon.noise = 2
         inv.weapon.dam = 4
         inv.weapon.hands = 1
         inv.weapon.damtype = wdCrush
      Case wpBallflail       '1 hand, dam 6
         inv.desc = "Ball Flail"
         inv.icon = Chr(231)
         inv.weapon.noise = 4
         inv.weapon.dam = 6
         inv.weapon.hands = 1
         inv.weapon.damtype = wdCrush
      Case wpSpikedflail     '1 hand, dam 8
         inv.desc = "Spiked Flail"
         inv.icon = Chr(231)
         inv.weapon.noise = 6
         inv.weapon.dam = 8
         inv.weapon.hands = 1
         inv.weapon.damtype = wdCrush
      Case wpMorningstar     '1 hand, dam 10
         inv.desc = "Morning Star"
         inv.icon = Chr(231)
         inv.weapon.noise = 8
         inv.weapon.dam = 10
         inv.weapon.hands = 1
         inv.weapon.damtype = wdCrush
      Case wpBattleflail     '2 hand, dam 12
         inv.desc = "Battle Flail"
         inv.icon = Chr(231)
         inv.weapon.noise = 10
         inv.weapon.dam = 12
         inv.weapon.hands = 2
         inv.weapon.damtype = wdCrush
      Case wpBishopsflail    '2 hand, dam 14
         inv.desc = "Bishop's Flail"
         inv.icon = Chr(231)
         inv.weapon.noise = 12
         inv.weapon.dam = 14
         inv.weapon.hands = 2
         inv.weapon.damtype = wdCrush
      Case wpSling           '1 hand, dam 2 chr: 125
         inv.desc = "Sling"
         inv.icon = Chr(125)
         inv.weapon.noise = 1
         inv.weapon.dam = 2
         inv.weapon.hands = 1
         inv.weapon.weapontype = wtProjectile
         inv.weapon.capacity = 1
         inv.weapon.ammotype =  amBagStones
         inv.weapon.damtype = wdCrush
      Case wpShortbow        '2 hands, dam 8
         inv.desc = "Short Bow"
         inv.icon = Chr(125)
         inv.weapon.noise = 4
         inv.weapon.dam = 8
         inv.weapon.hands = 2
         inv.weapon.weapontype = wtProjectile
         inv.weapon.capacity = 1
         inv.weapon.ammotype =  amQuiverArrows
         inv.weapon.damtype = wdPierce
      Case wpLongbow         '2 hands, dam 10
         inv.desc = "Long Bow"
         inv.icon = Chr(125)
         inv.weapon.noise = 6
         inv.weapon.dam = 10
         inv.weapon.hands = 2
         inv.weapon.weapontype = wtProjectile
         inv.weapon.capacity = 1
         inv.weapon.ammotype = amQuiverArrows
         inv.weapon.damtype = wdPierce
      Case wpBonebow         '2 hands, dam 14
         inv.desc = "Dragon Bone Bow"
         inv.icon = Chr(125)
         inv.weapon.noise = 10
         inv.weapon.dam = 14
         inv.weapon.hands = 1
         inv.weapon.weapontype = wtProjectile
         inv.weapon.capacity = 2
         inv.weapon.ammotype =  amQuiverArrows
         inv.weapon.damtype = wdPierce
      Case wpAdaminebow      '2 hands, dam 20
         inv.desc = "Adamine Bow"
         inv.icon = Chr(125)
         inv.weapon.noise = 12
         inv.weapon.dam = 20
         inv.weapon.hands = 1
         inv.weapon.weapontype = wtProjectile
         inv.weapon.capacity = 1
         inv.weapon.ammotype =  amQuiverArrows
         inv.weapon.damtype = wdPierce
      Case wpLightcrossbow   '2 hands, dam 10 chr: 209
         inv.desc = "Light Crossbow"
         inv.icon = Chr(209)
         inv.weapon.noise = 4
         inv.weapon.dam = 10
         inv.weapon.hands = 2
         inv.weapon.weapontype = wtProjectile
         inv.weapon.capacity = 1
         inv.weapon.ammotype =  amCaseBolts
         inv.weapon.damtype = wdPierce
      Case wpHeavycrossbow   '2 hands, dam 14
         inv.desc = "Heavy Crossbow"
         inv.icon = Chr(209)
         inv.weapon.noise = 8
         inv.weapon.dam = 14
         inv.weapon.hands = 2
         inv.weapon.weapontype = wtProjectile
         inv.weapon.capacity = 1
         inv.weapon.ammotype =  amCaseBolts
         inv.weapon.damtype = wdPierce
      Case wpBarrelcrossbow  '2 hands, dam 18
         inv.desc = "Barrel Crossbow"
         inv.icon = Chr(209)
         inv.weapon.noise = 12
         inv.weapon.dam = 18
         inv.weapon.hands = 2
         inv.weapon.weapontype = wtProjectile
         inv.weapon.capacity = 6
         inv.weapon.ammotype =  amCaseBolts
         inv.weapon.damtype = wdPierce
      Case wpAdaminecrossbow '2 hands, dam 25
         inv.desc = "Adamine Crossbow"
         inv.icon = Chr(209)
         inv.weapon.noise = 16
         inv.weapon.dam = 25
         inv.weapon.hands = 2
         inv.weapon.weapontype = wtProjectile
         inv.weapon.capacity = 1
         inv.weapon.ammotype =  amCaseBolts
         inv.weapon.damtype = wdPierce
      Case wpIronWand '1 hand, dam 10
         inv.desc = "Iron Wand"
         inv.icon = Chr(139)
         inv.weapon.noise = 1
         inv.weapon.dam = 10
         inv.weapon.hands = 1
         inv.weapon.weapontype = wtProjectile
         inv.weapon.capacity = RandomRange(1, 100)
         inv.weapon.ammotype =  amNone
         inv.weapon.ammocnt = inv.weapon.capacity
         inv.weapon.iswand = TRUE
         inv.weapon.damtype = wdEnergy
      Case wpBrassWand '1 hand, dam 20
         inv.desc = "Brass Wand" 
         inv.icon = Chr(139)
         inv.weapon.noise = 1
         inv.weapon.dam = 20
         inv.weapon.hands = 1
         inv.weapon.weapontype = wtProjectile
         inv.weapon.capacity = RandomRange(1, 80)
         inv.weapon.ammotype =  amNone
         inv.weapon.ammocnt = inv.weapon.capacity 
         inv.weapon.iswand = TRUE
         inv.weapon.damtype = wdEnergy
      Case wpCopperWand '1 hand, dam 40
         inv.desc = "Copper Wand"
         inv.icon = Chr(139)
         inv.weapon.noise = 1
         inv.weapon.dam = 40
         inv.weapon.hands = 1
         inv.weapon.weapontype = wtProjectile
         inv.weapon.capacity = RandomRange(1, 40)
         inv.weapon.ammotype =  amNone
         inv.weapon.ammocnt = inv.weapon.capacity 
         inv.weapon.iswand = TRUE
         inv.weapon.damtype = wdEnergy
      Case wpSilverWand '1 hand, dam 80
         inv.desc = "Silver Wand"
         inv.icon = Chr(139)
         inv.weapon.noise = 1
         inv.weapon.dam = 80
         inv.weapon.hands = 1
         inv.weapon.weapontype = wtProjectile
         inv.weapon.capacity = RandomRange(1, 20)
         inv.weapon.ammotype =  amNone
         inv.weapon.ammocnt = inv.weapon.capacity 
         inv.weapon.iswand = TRUE
         inv.weapon.damtype = wdEnergy
      Case wpGoldWand '1 hand, dam 100
         inv.desc = "Gold Wand"
         inv.icon = Chr(139)
         inv.weapon.noise = 1
         inv.weapon.dam = 100
         inv.weapon.hands = 1
         inv.weapon.weapontype = wtProjectile
         inv.weapon.capacity = RandomRange(1, 10)
         inv.weapon.ammotype =  amNone
         inv.weapon.ammocnt = inv.weapon.capacity 
         inv.weapon.iswand = TRUE
         inv.weapon.damtype = wdEnergy
      Case Else
         inv.desc = "Unknown Weapon"
         inv.icon = Chr(63)
         inv.weapon.noise = 0
         inv.weapon.dam = 0
         inv.weapon.hands = 0
         inv.weapon.weapontype = wtNone
         inv.weapon.ammotype =  amNone
         inv.weapon.damtype = wdNone
   End Select
End Sub

'Generate new armor item.
Sub GenerateArmor(inv As invtype, currlevel As Integer, arid As armorids = armArmorNone)
   Dim item As armorids 
   Dim As Integer isMagic 
   
   isMagic = ItemIsMagic(currlevel)
   'These are the common items.
   inv.classid = clArmor
   If arid = armArmorNone Then
      item = RandomRange(armCloth, armPlate)
      inv.armor.id = item
   Else
      item = arid
      inv.armor.id = item
   End If
   inv.icon = Chr(234)
   inv.iconclr = fbSteelBlue
   inv.armor.use = useWieldWear
   inv.armor.eval = FALSE
   inv.armor.wslot(1) = wArmor
   inv.armor.wslot(2) = wNone
   'Set spell if magic.
   If IsMagic = TRUE Then
      inv.armor.evaldr = GetScaledFactor(charint, currlevel) 'The eval dr.
      inv.armor.spell.id = RandomRange(splNoSlash, splNoMagic) 'Spell id.
      inv.armor.spelleffect = GetArmorSpellEffect(inv.armor.spell.id)
      GenerateSpell inv.armor.spell, currlevel
   EndIf
   'Set the armor type and amount.
   Select Case item
      Case armCloth
         inv.desc = "Cloth Armor" 'Cloth armor: 1% damage reduction.
         inv.armor.noise = 1
         inv.armor.dampct = .01
         inv.armor.struse = strCloth
      Case armLeather 'Leather armor: 5% damage reduction
         inv.desc = "Leather Armor"
         inv.armor.noise = 5
         inv.armor.dampct = .05
         inv.armor.struse = strLeather
      Case armCuirboli 'Cuirboli armor: 10 % damage reduction
         inv.desc = "Cuirboli Armor"
         inv.armor.noise = 10
         inv.armor.dampct = .10
         inv.armor.struse = strCuirboli
      Case armRing  'Ring armor: 20% damage reduction  
         inv.desc = "Ring Armor"
         inv.armor.noise = 15
         inv.armor.dampct = .20
         inv.armor.struse = strRing
      Case armBrigantine 'Brigantine armor: 30% dam reduction  
         inv.desc = "Brigantine Armor"
         inv.armor.noise = 20
         inv.armor.dampct = .30
         inv.armor.struse = strBrigantine
      Case armChain 'Chain armor: 50 % dam reduction
         inv.desc = "Chain Armor"
         inv.armor.noise = 25
         inv.armor.dampct = .50
         inv.armor.struse = strChain
      Case armScale 'Scale armor: 70% dam reduction
         inv.desc = "Scale Armor"
         inv.armor.noise = 30
         inv.armor.dampct = .70
         inv.armor.struse = strScale
      Case armPlate 'Plate armor: 90% dam reduction
         inv.desc = "Plate Armor"
         inv.armor.noise = 35
         inv.armor.dampct = .90
         inv.armor.struse = strPlate
      Case Else
         inv.desc = "Unknown Armor"
         inv.armor.noise = 0
         inv.armor.dampct = 0
         inv.armor.struse = 0
         inv.icon = Chr(63)
   End Select
End Sub

'Generate new shield item.
Sub GenerateShield(inv As invtype, currlevel As Integer)
   Dim item As shieldids 
   Dim As Integer isMagic 
   
   item = RandomRange(shldLeather, shldPlate)
   isMagic = ItemIsMagic(currlevel)
   'Set spell if magic.
   If IsMagic = TRUE Then
      inv.shield.evaldr = GetScaledFactor(charint, currlevel) 'The eval dr.
      inv.shield.spell.id = RandomRange(splNoSlash, splNoMagic) 'Spell id.
      GenerateSpell inv.shield.spell, currlevel
      inv.shield.spelleffect = GetArmorSpellEffect(inv.shield.spell.id)
   EndIf
   'These are the common items.
   inv.classid = clShield
   inv.shield.id = item
   inv.icon = Chr(233)
   inv.iconclr = fbSteelBlue
   inv.shield.use = useWieldWear
   inv.shield.eval = FALSE
   inv.shield.wslot(1) = wPrimary
   inv.shield.wslot(2) = wSecondary
   'Set the shield type and amount.
   Select Case item
      Case shldLeather 'Leather shield: 5% damage reduction
         inv.desc = "Leather Shield"
         inv.shield.noise = 5
         inv.shield.dampct = .05
         inv.shield.struse = 50
      Case shldCuirboli 'Cuirboli shield: 10 % damage reduction
         inv.desc = "Cuirboli Shield"
         inv.shield.noise = 10
         inv.shield.dampct = .10
         inv.shield.struse = 100
      Case shldRing  'Ring shield: 20% damage reduction  
         inv.desc = "Ring Shield"
         inv.shield.noise = 15
         inv.shield.dampct = .20
         inv.shield.struse = 150
      Case shldBrigantine 'Brigantine shield: 30% dam reduction  
         inv.desc = "Brigantine Shield"
         inv.shield.noise = 20
         inv.shield.dampct = .30
         inv.shield.struse = 200
      Case shldChain 'Chain shield: 50 % dam reduction
         inv.desc = "Chain Shield"
         inv.shield.noise = 25
         inv.shield.dampct = .50
         inv.shield.struse = 250
      Case shldScale 'Scale shield: 70% dam reduction
         inv.desc = "Scale Shield"
         inv.shield.noise = 30
         inv.shield.dampct = .70
         inv.shield.struse = 300
      Case shldPlate 'Plate shield: 90% dam reduction
         inv.desc = "Plate Shield"
         inv.shield.noise = 35
         inv.shield.dampct = .90
         inv.shield.struse = 350
      Case Else
         inv.desc = "Unknown Shield"
         inv.shield.noise = 0
         inv.shield.dampct = 0
         inv.shield.struse = 0
         inv.icon = Chr(63)
   End Select
   
End Sub

'Generate new supply item.
Sub GenerateSupplies(inv As invtype, currlevel As Integer)
   Dim item As supplyids
   Dim As Integer isMagic  
   
   isMagic = ItemIsMagic(currlevel)
   item = RandomRange(supHealingHerb, supManaOrb)
   'Set the supply item id.
   inv.classid = clSupplies
   inv.supply.id = item
   inv.supply.evaldr = 0
   inv.supply.spell.id = splNone
   Select Case item
      Case supHealingHerb 
         inv.supply.desc = "Adds 50% max HP to current HP"
         inv.desc = "Healing Herb"
         inv.supply.noise = 1
         inv.icon = Chr(157)
         inv.iconclr = fbGreen
         inv.supply.eval = FALSE
         inv.supply.use = useEatDrink
         'Set the magic properties.
         If isMagic = TRUE Then
            inv.supply.evaldr = GetScaledFactor(charint, currlevel)
            inv.supply.spell.id = splMaxHealing
            inv.supply.spell.splname = GetSpellName(inv.supply.spell.id)
            inv.supply.spell.spldesc = GetSpellEffect(inv.supply.spell.id)
            inv.supply.spell.manacost = 0
            inv.supply.spell.dam = 0
         EndIf
      Case supHunkMeat
         inv.desc = "Hunk of Meat"
         inv.supply.desc = "Adds 25% max HP to current HP"
         inv.supply.noise = 1
         inv.icon = Chr(224)
         inv.iconclr = fbSalmon
         inv.supply.eval = FALSE
         inv.supply.use = useEatDrink
         'Set the magic properties.
         If isMagic = TRUE Then
            inv.supply.evaldr = GetScaledFactor(charint, currlevel)
            inv.supply.spell.id = splStrongMeat
            inv.supply.spell.splname = GetSpellName(inv.supply.spell.id)
            inv.supply.spell.spldesc = GetSpellEffect(inv.supply.spell.id)
            inv.supply.spell.manacost = 0
            inv.supply.spell.dam = 0
         EndIf
      Case supBread       
         inv.desc = "Loaf of Bread"
         inv.supply.desc = "Adds 10% max HP to current HP"
         inv.supply.noise = 1
         inv.icon = Chr(247)
         inv.iconclr = fbHoneydew
         inv.supply.eval = FALSE 
         inv.supply.use = useEatDrink
         'Set the magic properties.
         If isMagic = TRUE Then
            inv.supply.evaldr = GetScaledFactor(charint, currlevel)
            inv.supply.spell.id = splBreadLife
            inv.supply.spell.splname = GetSpellName(inv.supply.spell.id)
            inv.supply.spell.spldesc = GetSpellEffect(inv.supply.spell.id)
            inv.supply.spell.manacost = 0
            inv.supply.spell.dam = 0
         EndIf
      Case supManaOrb   
         inv.desc = "Mana Orb"
         inv.supply.desc = "Restores Mana"
         inv.supply.noise = 4
         inv.icon = Chr(229)
         inv.iconclr = fbYellowGreen
         inv.supply.eval = FALSE
         inv.supply.use = useEatDrink
         'Set the magic properties.
         If isMagic = TRUE Then
            inv.supply.evaldr = GetScaledFactor(charint, currlevel)
            inv.supply.spell.id = splMaxMana
            inv.supply.spell.splname = GetSpellName(inv.supply.spell.id)
            inv.supply.spell.spldesc = GetSpellEffect(inv.supply.spell.id)
            inv.supply.spell.manacost = 0
            inv.supply.spell.dam = 0
         EndIf
      Case Else
         inv.desc = "Uknown Supply"
         inv.supply.noise = 0
         inv.icon = Chr(63)
         inv.iconclr = fbYellow
         inv.supply.eval = FALSE
         inv.supply.use = useNone
   End Select
End Sub

'Generate new gold item.
Sub GenerateGold(inv As invtype)
   Dim As Integer rng
   
   rng = RandomRange(1, 10)
   'Set the gold item id.
   inv.classid = clGold
   If rng = 1 Then 
      inv.gold.id = gldBagGold
   Else
      inv.gold.id = gldGold
   EndIf
   Select Case inv.gold.id
      Case gldGold
         inv.desc = "Gold Coins"
         inv.gold.amt = RandomRange(1, 10)
         inv.icon = Chr(147)
         inv.iconclr = fbGold
      Case gldBagGold
         inv.desc = "Bag of Gold"
         inv.gold.amt = RandomRange(10, 100)
         inv.icon = Chr(147)
         inv.iconclr = fbGold
      Case Else
         inv.desc = "Unknown Gold"
         inv.gold.amt = 0
         inv.icon = Chr(63)
         inv.iconclr = fbGold
   End Select
End Sub

'Generate an ammo item.
Sub GenerateAmmo(inv As invtype, currlevel As Integer, ammoid As ammoids = amNone)
   Dim item As ammoids

   If ammoid = amNone Then
      item = RandomRange(amBagStones, amQuiverArrows)
   Else
      item = ammoid
   End If
   'Set the ammo item id.
   inv.classid = clAmmo
   inv.ammo.id = item
   inv.iconclr = fbCadmiumYellow
   inv.ammo.eval = TRUE
   Select Case item
      Case amBagStones   
         inv.desc = "Bag of Stones"
         inv.ammo.cnt = RandomRange(10, 20)
         inv.ammo.noise = inv.ammo.cnt 
         inv.icon = Chr(167)
      Case amCaseBolts
         inv.desc = "Case of Bolts"
         inv.ammo.cnt = RandomRange(10, 20)
         inv.ammo.noise = inv.ammo.cnt 
         inv.icon = Chr(22)
      Case amQuiverArrows
         inv.desc = "Quiver of Arrows"
         inv.ammo.cnt = RandomRange(10, 20)
         inv.ammo.noise = inv.ammo.cnt 
         inv.icon = Chr(173)
      Case Else
         inv.desc = "Unknown Ammo"
         inv.ammo.cnt = 0
         inv.ammo.noise = 0 
         inv.icon = "?"
   End Select
   
End Sub

'Generate new jewlery item.
Sub GenerateJewlery(inv As invtype, currlevel As Integer)
   Dim item As jewleryids
   Dim jtype As jewtype 
   Dim As Integer isMagic 
   
   item = RandomRange(jewSteel, jewDiamond)
   jtype = RandomRange(jRing, jNecklace)
   isMagic = ItemIsMagic(currlevel)
   'Magic Item.
   If IsMagic = TRUE Then
      inv.jewelry.evaldr = GetScaledFactor(charint, currlevel)
      inv.jewelry.spell.id = splNone
   EndIf
   inv.jewelry.eval = FALSE
   'These are the common items.
   inv.jewelry.id = item
   inv.jewelry.jtype = jtype
   inv.iconclr = fbTurquoise
   inv.jewelry.use = useWieldWear
   inv.jewelry.noise = 1
   If jtype = jRing Then
      inv.icon = "o"
      inv.jewelry.jslot(1) = wRingRt
      inv.jewelry.jslot(2) = wRingLt
      inv.desc = " Ring"
   Else
      inv.icon = "0"
      inv.jewelry.jslot(1) = wNeck
      inv.jewelry.jslot(2) = wNone
      inv.desc = " Necklace"
   EndIf
   Select Case item
      Case jewSteel
         inv.desc = "Steel" & inv.desc
      Case jewBronze
         inv.desc = "Bronze" & inv.desc
      Case jewCopper
         inv.desc = "Copper" & inv.desc
      Case jewBrass
         inv.desc = "Brass" & inv.desc
      Case jewSilver
         inv.desc = "Silver" & inv.desc
      Case jewGold
         inv.desc = "Gold" & inv.desc
      Case jewAgate
         inv.desc = "Agate" & inv.desc
      Case jewOpal
         inv.desc = "Opal" & inv.desc
      Case jewAmethyst
         inv.desc = "Amethyst" & inv.desc
      Case jewRuby
         inv.desc = "Ruby" & inv.desc
      Case jewEmerald
         inv.desc = "Emerald" & inv.desc
      Case jewJade
         inv.desc = "Jade" & inv.desc
      Case jewPearl
         inv.desc = "Pearl" & inv.desc
      Case jewQuartz
         inv.desc = "Quartz" & inv.desc
      Case jewSapphire
         inv.desc = "Sapphire" & inv.desc
      Case jewDiamond
         inv.desc = "Diamond" & inv.desc
   End Select
End Sub

'Generates a new item and places it into the invetory slot.
Sub GenerateItem(inv As invtype, currlevel As Integer)
   Dim iclass As classids
   
   iclass = RandomRange(clGold, clNecklace)
   'Make sure we generated an item.
   If iclass <> clNone Then
      'Clear current item if not cleared.
      If inv.classid <> clNone Then
         ClearInv inv
      EndIf
      'Set the item class.
      inv.classid = iclass
      'Generate item based on class id.
      Select Case iclass
         Case clGold
            GenerateGold inv
         Case clSupplies
            GenerateSupplies inv, currlevel
         Case clArmor
            GenerateArmor inv, currlevel
         Case clShield
            GenerateShield inv, currlevel
         Case clWeapon
            GenerateWeapon inv, currlevel
         Case clAmmo
            GenerateAmmo inv, currlevel
         Case clPotion
            GeneratePotion inv, currlevel
         Case clRing, clNecklace
            GenerateJewlery inv, currlevel
      End Select
   End If
End Sub

'Returns True if item has been evaluated.
Function IsEval(inv As invtype) As Integer
   Dim As Integer ret
   
   'If nothing then mark as evaluated.
   If inv.classid = clNone Then
      ret = TRUE
   Else
      'Select the item type.
      Select Case inv.classid 'Don't need to eval gold.
         Case clGold
            ret = TRUE
         Case clSupplies  'Return supply eval glag.
            ret = inv.supply.eval
         Case clArmor
            ret = inv.armor.eval
         Case clShield
            ret = inv.shield.eval
         Case clWeapon
            ret = inv.weapon.eval
         Case clAmmo
            ret = inv.ammo.eval
         Case clPotion
            ret = inv.potion.eval
         Case clRing, clNecklace
            ret = inv.jewelry.eval
      End Select
   EndIf
   
   Return ret
End Function

'Returns the eval difficulty rating.
Function GetEvalDR(inv As invtype) As Integer
   Dim As Integer ret
   
   'If nothing then evaldr is 0.
   If inv.classid = clNone Then
      ret = 0
   Else
      'Select the item.
      Select Case inv.classid
         Case clGold 'Don't need to eval gold.
            ret = 0
         Case clSupplies
            ret = inv.supply.evaldr 'Return supply eval dr.
         Case clArmor
            ret = inv.armor.evaldr 'Return armor eval dr.
         Case clShield
            ret = inv.shield.evaldr 'Return shield eval dr.
         Case clWeapon
            ret = inv.weapon.evaldr 'Return shield eval dr.
         Case clAmmo
            ret = 0 'Ammo is set to 0. Doesn't eval.
         Case clPotion
            ret = inv.potion.evaldr 'Return potion eval dr.
         Case clRing, clNecklace
            ret = inv.jewelry.evaldr 'Return jewelry eval dr.
      End Select
   EndIf
   
   Return ret
End Function

'Sets eval state to passed type.
Sub SetInvEval(inv As invtype, state As Integer)
   
   'If nothing then no eval.
   If inv.classid <> clNone Then
      'Select the item.
      Select Case inv.classid
         Case clSupplies
            inv.supply.eval = state 'Set the eval state.
         Case clArmor
            inv.armor.eval = state 
         Case clShield
            inv.shield.eval = state 
         Case clWeapon
            inv.weapon.eval = state 
         Case clAmmo
            inv.ammo.eval = TRUE
         Case clPotion
            inv.potion.eval = state
            'Set unscrambled name.
            If state = TRUE Then
               inv.desc = inv.potion.potname
            EndIf
         Case clRing, clNecklace
            inv.jewelry.eval = state
      End Select
   EndIf
   
End Sub

'Returns True if item matches the use flag.
Function MatchUse(inv As invtype, whatuse As itemuse) As Integer
   Dim As Integer ret = FALSE
   
   'If nothing then no use.
   If inv.classid <> clNone Then
      'Select the item.
      Select Case inv.classid
         'Compare the passed use to the flag use.
         Case clSupplies
            If inv.supply.use = whatuse Then
               ret = TRUE
            EndIf
         Case clArmor
            If inv.armor.use = whatuse Then
               ret = TRUE
            EndIf
         Case clShield
            If inv.shield.use = whatuse Then
               ret = TRUE
            EndIf
         Case clWeapon
            If inv.weapon.use = whatuse Then
               ret = TRUE
            EndIf
         Case clPotion
            If inv.potion.use = whatuse Then
               ret = TRUE
            EndIf
         Case clRing, clNecklace
            If inv.jewelry.use = whatuse Then
               ret = TRUE
            EndIf
      End Select
   EndIf
   
   Return ret
End Function

'Returns an extended description of an item.
Sub GetFullDesc(lines() As String, inv As invtype)
   Dim As Integer idx = 0
   
   'Reset the array.
   ReDim lines(0 To idx) As String
   'Make sure we have something to inspect.
   If inv.classid <> clNone Then
      'Select the item.
      Select Case inv.classid
         Case clSupplies 
            idx += 1
            ReDim Preserve lines(0 to idx) As String
            lines(idx) = GetInvItemDesc(inv)
            idx += 1
            ReDim Preserve lines(0 to idx) As String
            lines(idx) = " * " & Trim(inv.supply.desc)
            If IsEval(inv) = TRUE Then
               If inv.supply.spell.id <> splNone Then
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Spell: " & Trim(inv.supply.spell.splname)
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Effect: " & Trim(inv.supply.spell.spldesc)
               End If
               idx += 1
               ReDim Preserve lines(0 to idx) As String
               lines(idx) = "* Item is evaluated"
            Else
               idx += 1
               ReDim Preserve lines(0 to idx) As String
               lines(idx) = "* Item is not evaluated"
            End If
         Case clArmor
            idx += 1
            ReDim Preserve lines(0 to idx) As String
            lines(idx) = GetInvItemDesc(inv)
            idx += 1
            ReDim Preserve lines(0 to idx) As String
            lines(idx) = "* " & (inv.armor.dampct * 100) & "% damage reduction"
            idx += 1
            ReDim Preserve lines(0 to idx) As String
            lines(idx) = "* Strength Required: " & inv.armor.struse
            If IsEval(inv) = TRUE Then
               If inv.armor.spell.id <> splNone Then
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Spell: " & Trim(inv.armor.spell.splname)
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Effect: " & Trim(inv.armor.spell.spldesc)
               End If
               idx += 1
               ReDim Preserve lines(0 to idx) As String
               lines(idx) = "* Item is evaluated"
            Else
               idx += 1
               ReDim Preserve lines(0 to idx) As String
               lines(idx) = "* Item is not evaluated"
            End If
         Case clShield
            idx += 1
            ReDim Preserve lines(0 to idx) As String
            lines(idx) = GetInvItemDesc(inv)
            idx += 1
            ReDim Preserve lines(0 to idx) As String
            lines(idx) = "* " & (inv.shield.dampct * 100) & "% damage reduction"
            idx += 1
            ReDim Preserve lines(0 to idx) As String
            lines(idx) = "* Strength Required: " & inv.shield.struse
            If IsEval(inv) = TRUE Then
               If inv.shield.spell.id <> splNone Then
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Spell: " & Trim(inv.shield.spell.splname)
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Effect: " & Trim(inv.shield.spell.spldesc)
               End If
               idx += 1
               ReDim Preserve lines(0 to idx) As String
               lines(idx) = "* Item is evaluated"
            Else
               idx += 1
               ReDim Preserve lines(0 to idx) As String
               lines(idx) = "* Item is not evaluated"
            End If
         Case clWeapon
            idx += 1
            ReDim Preserve lines(0 to idx) As String
            lines(idx) = GetInvItemDesc(inv)
            idx += 1
            ReDim Preserve lines(0 to idx) As String
            lines(idx) = "* " & inv.weapon.dam & " weapon damage"
            idx += 1
            ReDim Preserve lines(0 to idx) As String
            lines(idx) = "* Hands Required: " & inv.weapon.hands
            If inv.weapon.weapontype = wtProjectile Then
               idx += 1
               ReDim Preserve lines(0 to idx) As String
               lines(idx) = "* Capacity: " & inv.weapon.capacity
               idx += 1
               ReDim Preserve lines(0 to idx) As String
               lines(idx) = "* Ammo Cnt: " & inv.weapon.ammocnt
            EndIf
            If IsEval(inv) = TRUE Then
               If inv.weapon.spell.id <> splNone Then
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Spell: " & Trim(inv.weapon.spell.splname)
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Effect: " & Trim(inv.weapon.spell.spldesc)
               End If
               idx += 1
               ReDim Preserve lines(0 to idx) As String
               lines(idx) = "* Item is evaluated"
            Else
               idx += 1
               ReDim Preserve lines(0 to idx) As String
               lines(idx) = "* Item is not evaluated"
            End If
         Case clAmmo
            idx += 1
            ReDim Preserve lines(0 to idx) As String
            lines(idx) = GetInvItemDesc(inv)
            idx += 1
         Case clPotion
            idx += 1
            ReDim Preserve lines(0 to idx) As String
            lines(idx) = GetInvItemDesc(inv)
            If IsEval(inv) = TRUE Then
               idx += 1
               ReDim Preserve lines(0 to idx) As String
               If inv.potion.amt > 0 Then
                  lines(idx) = "* Effect: +" & inv.potion.amt & " " & inv.potion.potdesc
               Else
                  lines(idx) = "* Effect: " & inv.potion.amt & " " & inv.potion.potdesc
               End If
               If inv.potion.cnt > 0 Then
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Length in Turns: " & inv.potion.cnt
               EndIf
               idx += 1
               ReDim Preserve lines(0 to idx) As String
               lines(idx) = "* Item is evaluated"
            Else
               idx += 1
               ReDim Preserve lines(0 to idx) As String
               lines(idx) = "* Item is not evaluated"
            End If
         Case clRing, clNecklace
            idx += 1
            ReDim Preserve lines(0 to idx) As String
            lines(idx) = GetInvItemDesc(inv)
            idx += 1
            ReDim Preserve lines(0 to idx) As String
            lines(idx) = "* Magic: Offense and Defense"
            If IsEval(inv) = TRUE Then
               If inv.jewelry.spell.id <> splNone Then
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Spell: " & Trim(inv.jewelry.spell.splname)
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Effect: " & Trim(inv.jewelry.spell.spldesc)
               End If
               idx += 1
               ReDim Preserve lines(0 to idx) As String
               lines(idx) = "* Item is evaluated"
            Else
               idx += 1
               ReDim Preserve lines(0 to idx) As String
               lines(idx) = "* Item is not evaluated"
            End If
      End Select
   EndIf
   
End Sub

'Returns the inventory slots for wield items.
Function GetInvWSlot(inv As invtype, slotnum As Integer) As Integer
   Dim As Integer ret = wNone
   
   If inv.classid = clArmor Then
      If slotnum >= LBound(inv.armor.wslot) And slotnum <= UBound(inv.armor.wslot) Then 
         ret = inv.armor.wslot(slotnum)
      End If
   ElseIf inv.classid = clShield Then
      If slotnum >= LBound(inv.shield.wslot) And slotnum <= UBound(inv.shield.wslot) Then 
         ret = inv.shield.wslot(slotnum)
      End If
   ElseIf inv.classid = clWeapon Then
   If slotnum >= LBound(inv.weapon.wslot) And slotnum <= UBound(inv.weapon.wslot) Then 
         ret = inv.weapon.wslot(slotnum)
      End If
   ElseIf inv.classid = clRing Then
         If slotnum >= LBound(inv.jewelry.jslot) And slotnum <= UBound(inv.jewelry.jslot) Then 
         ret = inv.jewelry.jslot(slotnum)
      End If
   ElseIf inv.classid = clNecklace Then
      If slotnum >= LBound(inv.jewelry.jslot) And slotnum <= UBound(inv.jewelry.jslot) Then 
         ret = inv.jewelry.jslot(slotnum)
      End If
   EndIf
   
   Return ret
End Function

'Returns the noise factor item.
Function GetItemNoise(inv As invtype) As Integer
   Dim As Integer ret = 0
   
   'If nothing then no use.
   If inv.classid <> clNone Then
      'Select the item.
      Select Case inv.classid
         'Get the noise factor for the item.
         Case clSupplies
            ret = inv.supply.noise
         Case clArmor
            ret = inv.armor.noise
         Case clShield
            ret = inv.shield.noise
         Case clWeapon
            ret = inv.weapon.noise
         Case clAmmo
            ret = inv.ammo.noise
         Case clPotion
            ret = inv.potion.noise
         Case clRing, clNecklace
            ret = inv.jewelry.noise
      End Select
   EndIf
   
   Return ret
End Function

'Returns True if ammo type fits weapon type.
Function MatchAmmoType (wid As weaponids, amid As ammoids) As Integer
   Dim As Integer ret = FALSE

   'Check the weapon type.
   If wid = wpSling Then
      'Check the ammo type.
      If amid = amBagStones Then
         ret = TRUE
      EndIf
   EndIf
   If wid = wpShortbow Then
      If amid = amQuiverArrows Then
         ret = TRUE
      EndIf
   EndIf
   If wid = wpLongbow Then
      If amid = amQuiverArrows Then
         ret = TRUE
      EndIf
   EndIf
   If wid = wpBonebow Then
      If amid = amQuiverArrows Then
         ret = TRUE
      EndIf
   EndIf
   If wid = wpAdaminebow Then
      If amid = amQuiverArrows Then
         ret = TRUE
      EndIf
   EndIf
   If wid = wpLightcrossbow Then
      If amid = amCaseBolts Then
         ret = TRUE
      EndIf
   EndIf
   If wid = wpHeavycrossbow Then
      If amid = amCaseBolts Then
         ret = TRUE
      EndIf
   EndIf
   If wid = wpBarrelcrossbow Then
      If amid = amCaseBolts Then
         ret = TRUE
      EndIf
   EndIf
   If wid = wpAdaminecrossbow Then
      If amid = amCaseBolts Then
         ret = TRUE
      EndIf
   EndIf
      
   Return ret
End Function

 