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

'Returns the monster spell effect.
Function GetMonSpellEffect(id As spellid) As weapdamtype
   Dim ret As weapdamtype
   
   Select Case id
      Case splMonClaw     'Monster: Magic claw that slashes.
         ret = wdSlash
      Case splMonFist     'Monster: Magic fist that crushes.
         ret = wdCrush
      Case splMonFang     'Monster: Magic fang that pierces.
         ret = wdPierce
      Case splMonPoison  'Monster: Poison attack.
         ret = wdPoison   
      Case splMonBolt     'Monster: Magic energy.
         ret = wdEnergy
      Case splMonFire     'Monster: Magic fire.
         ret = wdFire
      Case splMonAcid     'Monster: Magic fire.
         ret = wdAcid
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

'Returns the jewlery spell effect.
Function GetJewelrySpellEffect(id As spellid) As jeffects
   Dim ret As jeffects
   
   Select Case id
      Case splUCF
         ret = jwUCF
      Case splACF
         ret = jwACF
      Case splPCF
         ret = jwPCF
      Case splMCF
         ret = jwMCF
      Case splCDF
         ret = jwCDF
      Case splMDF
         ret = jwMDF
      Case splRegenHP
         ret = jwRegenHP
      Case splRegenMana 
         ret = jwRegenMana
      Case Else
         ret = jwNone
   End Select

   Return ret
End Function

'Returns a description for a spell.
Function GetSpellName(spl As spellid) As String
   Dim As String ret = ""
   
   Select Case spl
      Case splMaxHealing  'Heal to max HP.
         ret = "Spell of Maximum Healing"
      Case splStrongMeat 'Adds str bonus for time. 
         ret = "Spell of Enhance Strength"
      Case splBreadLife   'Cures any poison.
         ret = "Spell of Cure Poison"
      Case splMaxMana     'Restore full mana.
         ret = "Spell of Restore Mana"
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
      Case splUCF         'Jewelry: +% to UCF.
         ret = "Spell of Unarmed Combat"
      Case splACF         'Jewelry: +% to ACF.
         ret = "Spell of Armed Combat"
      Case splPCF         'Jewelry: +% to PCF.
         ret = "Spell of Projectile Combat"
      Case splMCF         'Jewelry: +% to MCF.
         ret = "Spell of Magic Combat"
      Case splCDF         'Jewelry: +% to CDF.
         ret = "Spell of Combat Defense"
      Case splMDF         'Jewelry: +% to MDF.
         ret = "Spell of Magic Defense"
      Case splRegenHP     'Jewelry: +% to healing per turn.
         ret = "Spell of Regenerate Health"
      Case splRegenMana   'Jewelry: +% to mana per turn.
         ret = "Spell of Regenerate Mana" 
      Case splAcidFog     'Spellbook: 5 dam over lvl turns
         ret = "Spell of Acid Fog"
      Case splFireCloak   'Spellbook: Target gets 10 dam over lvl turns
         ret = "Spell of Fire Cloak"
      Case splHeal        'Spellbook: 1% x lvl
         ret = "Spell of Healing"
      Case splMana        'Spellbook: 1% x lvl (does not consume mana)
         ret = "Spell of Restore Mana"
      Case splRecharge    'Spellbook: 1 x lvl recharge on wand
         ret = "Spell of Recharge Wand"
      Case splFocus       'Spellbook: +lvl to all combat factors for 1 turn
         ret = "Spell of Focus"
      Case splLightning   'Spellbook: 2 * lvl damage (ignores armor)
         ret = "Spell of Lightning"
      Case splBlind       'Spellbook: Blinds target for lvl turns
         ret = "Spell of Blindness"
      Case splTeleport    'Spellbook: Teleport to location lvl distance away (must be visible).
         ret = "Spell of Teleport"
      Case splOpen        'Spellbook: Attempts to open a locked door (lvl vs. DR).
         ret = "Spell of Open Door"
      Case splFear        'Spellbook: Makes monster flee for lvl turns.
         ret = "Spell of Fear"
      Case splConfuse     'Spellbook: Confuses monster for lvl turns.
         ret = "Spell of Confusion"
      Case splFireBomb    'Spellbook: Area damage 20 x lvl. Sets monsters on fire lvl turns.
         ret = "Spell of Fire Bomb" 
      Case splEntangle    'Spellbook: Immobilze target for lvel turns doing lvl damage each turn.
         ret = "Spell of Entanglement"
      Case splCloudMind   'Spellbook: Target cannot cast spells for lvl turns.
         ret = "Spell of Cloud Mind"
      Case splFireball    'Spellbook: Area damage 10 x lvl. Sets monsters on fire lvl turns.
         ret = "Spell of Fire Ball"
      Case splIceStatue   'Spellbook: Freezes target for lvl turns. If frozen can be killed with single hit.
         ret = "Spell of Ice Statue"
      Case splRust        'Spellbook: Reduces armor by lvl x 10%.
         ret = "Spell of Rust Armor"
      Case splShatter     'Spellbook: Destroys target weapon, if any.
         ret = "Spell of Shatter Weapon"
      Case splMagicDrain  'Spellbook: Lower target MDF by lvl% and adds to caster for 1 turn.
         ret = "Spell of Drain Magic"
      Case splPoison      'Spellbook: Posions target 1 HP for lvl turns.
         ret = "Spell of Poison"
      Case splEnfeeble    'Spellbook: Lowers target combat factors lvl x 10%.
         ret = "Spell of Enfeeblement"
      Case splShout       'Spellbook: Stuns all visible monsters for lvl turns.
         ret = "Spell of Warrior Shout"
      Case splStealHealth 'Spellbook: Lowers HP lvl% of target and adds to caster.
         ret = "Spell of Vampire"
      Case splMindBlast   'Spellbook: Lowers target MCF and MDF lvl% for lvl turns.
         ret = "Spell of Mind Blast" 
      Case splBlink       'Spellbook: Immune to damage.
         ret = "Spell of Blink"     
      Case splMonClaw     'Monster: Magic claw that slashes.
         ret = "Magic Claw"
      Case splMonFist     'Monster: Magic fist that crushes.
         ret = "Magic Fist"
      Case splMonFang     'Monster: Magic fang that pierces.
         ret = "Magic Fang"
      Case splMonPoison   'Monster: Poison attack.
         ret = "Magic Poison"
      Case splMonBolt     'Monster: Magic energy.
         ret = "Magic Bolt"
      Case splMonFire     'Monster: Magic fire.
         ret = "Fire Blast"
      Case splMonAcid     'Monster: Magic acid.
         ret = "Acid Blast"
      Case Else
         ret = "No spell."
   End Select

   Return ret
End Function

'Returns a description for a spell.
Function GetSpellShortName(spl As spellid) As String
   Dim As String ret = ""
   
   Select Case spl
      Case splMaxHealing  'Heal to max HP.
         ret = "Healing"
      Case splStrongMeat 'Adds str bonus for time. 
         ret = "Strength"
      Case splBreadLife   'Cures any poison.
         ret = "C Poison"
      Case splMaxMana     'Restore full mana.
         ret = "R Mana"
      Case splSerpentBite 'Weapon: Inflict poison damage.
         ret = "S Bite"
      Case splRend        'Weapon: Decrease armor of target.
         ret = "R Armor"
      Case splSunder      'Weapon: Decrease target weapon damage.
         ret = "Sunder"
      Case splReaper      'Weapon: Causes monster to flee.
         ret = "Reaper"
      Case splFire        'Weapon: Does fire damage to target for lvl turns.
         ret = "Fire"
      Case splGoliath     'Weapon: Adds str to attack.
         ret = "Goliath"
      Case splStun        'Weapon: Stuns target for lvl turns.
         ret = "Stun"
      Case splChaos       'Weapon: Random amount of additonal damage.
         ret = "Chaos"
      Case splWraith      'Weapon: Decreases random stat of target.
         ret = "Wraith"
      Case splThief       'Weapon: Steals random stat from target and adds to character.
         ret = "Phantom"
      Case splNoSlash     'Armor: +% from slash attacks.
         ret = "Slash Pr"              
      Case splNoCrush     'Armor: +% from crush attacks.
         ret = "Crush Pr"
      Case splNoPierce    'Armor: +% from pierce attacks.
         ret = "Pierce P"
      Case splNoEnergy    'Armor: +% from energy attacks.
         ret = "Energy P" 
      Case splNoMagic     'Armor: +% from magic attacks.
         ret = "Magic Pr"
      Case splNoFire      'Armor: +% from fire attacks.
         ret = "Fire Res"
      Case wdAcid         'Armor: +% from acid attacks.
         ret = "Res Acid"
      Case splUCF         'Jewelry: +% to UCF.
         ret = "UCF"
      Case splACF         'Jewelry: +% to ACF.
         ret = "ACF"
      Case splPCF         'Jewelry: +% to PCF.
         ret = "PCF"
      Case splMCF         'Jewelry: +% to MCF.
         ret = "MCF"
      Case splCDF         'Jewelry: +% to CDF.
         ret = "CDF"
      Case splMDF         'Jewelry: +% to MDF.
         ret = "MDF"
      Case splRegenHP     'Jewelry: +% to healing per turn.
         ret = "Rgn Hlth"
      Case splRegenMana   'Jewelry: +% to mana per turn.
         ret = "Rgn Mana" 
      Case splAcidFog     'Spellbook: 5 dam over lvl turns
         ret = "Acid Fog"
      Case splFireCloak   'Spellbook: Target gets 10 dam over lvl turns
         ret = "F Cloak"
      Case splHeal        'Spellbook: 1% x lvl
         ret = "Healing"
      Case splMana        'Spellbook: 1% x lvl (does not consume mana)
         ret = "R Mana"
      Case splRecharge    'Spellbook: 1 x lvl recharge on wand
         ret = "Rec Wand"
      Case splFocus       'Spellbook: +lvl to all combat factors for 1 turn
         ret = "Focus"
      Case splLightning   'Spellbook: 2 * lvl damage (ignores armor)
         ret = "Lightng"
      Case splBlind       'Spellbook: Blinds target for lvl turns
         ret = "Blind"
      Case splTeleport    'Spellbook: Teleport to location lvl distance away (must be visible).
         ret = "Teleport"
      Case splOpen        'Spellbook: Attempts to open a locked door (lvl vs. DR).
         ret = "Op Door"
      Case splFear        'Spellbook: Makes monster flee for lvl turns.
         ret = "Fear"
      Case splConfuse     'Spellbook: Confuses monster for lvl turns.
         ret = "Confuse"
      Case splFireBomb    'Spellbook: Area damage 20 x lvl. Sets monsters on fire lvl turns.
         ret = "F Bomb" 
      Case splEntangle    'Spellbook: Immobilze target for lvel turns doing lvl damage each turn.
         ret = "Entangle"
      Case splCloudMind   'Spellbook: Target cannot cast spells for lvl turns.
         ret = "Cld Mind"
      Case splFireball    'Spellbook: Area damage 10 x lvl. Sets monsters on fire lvl turns.
         ret = "F Ball"
      Case splIceStatue   'Spellbook: Freezes target for lvl turns. If frozen can be killed with single hit.
         ret = "I Statue"
      Case splRust        'Spellbook: Reduces armor by lvl x 10%.
         ret = "Rust"
      Case splShatter     'Spellbook: Destroys target weapon, if any.
         ret = "Shatter"
      Case splMagicDrain  'Spellbook: Lower target MDF by lvl% and adds to caster for 1 turn.
         ret = "Dr Magic"
      Case splPoison      'Spellbook: Posions target 1 HP for lvl turns.
         ret = "Poison"
      Case splEnfeeble    'Spellbook: Lowers target combat factors lvl x 10%.
         ret = "Enfeeble"
      Case splShout       'Spellbook: Stuns all visible monsters for lvl turns.
         ret = "Shout"
      Case splStealHealth 'Spellbook: Lowers HP lvl% of target and adds to caster.
         ret = "Vampire"
      Case splMindBlast   'Spellbook: Lowers target MCF and MDF lvl% for lvl turns.
         ret = "M Blast" 
      Case splBlink       'Spellbook: Teleport to random location lvl distance away. If location is occupied, item/monster destroyed.
         ret = "Blink"     
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
      Case splUCF         'Jewelry: +% to UCF.
         ret = "Level % increase to Unarmed Combat"
      Case splACF         'Jewelry: +% to ACF.
         ret = "Level % increase to Armed Combat"
      Case splPCF         'Jewelry: +% to PCF.
         ret = "Level % increase to Projectile Combat"
      Case splMCF         'Jewelry: +% to MCF.
         ret = "Level % increase to Magic Combat"
      Case splCDF         'Jewelry: +% to CDF.
         ret = "Level % increase to Combat Defense"
      Case splMDF         'Jewelry: +% to MDF.
         ret = "Level % increase to Magic Defense"
      Case splRegenHP     'Jewelry: +% to healing per turn.
         ret = "Level % regenerate health per turn."
      Case splRegenMana   'Jewelry: +% to mana per turn.
         ret = "Level % regenerate mana per turn." 
      Case splAcidFog     'Spellbook: 5 dam over lvl turns
         ret = "Target receives 5 damage for level turns."
      Case splFireCloak   'Spellbook: Target gets 10 dam over lvl turns
         ret = "Target receives 10 damage over level turns."
      Case splHeal        'Spellbook: 1% x lvl
         ret = "1% x level healing."
      Case splMana        'Spellbook: 1% x lvl (does not consume mana)
         ret = "1% x level mana (does not consume mana)."
      Case splRecharge    'Spellbook: 1 x lvl recharge on wand
         ret = "Level recharge of any wand in inventory."
      Case splFocus       'Spellbook: +lvl to all combat factors for 1 turn
         ret = "+Level to all combat factors for 1 turn."
      Case splLightning   'Spellbook: 2 * lvl damage (ignores armor)
         ret = "2 x level damage to target )ignores armor)."
      Case splBlind       'Spellbook: Blinds target for lvl turns
         ret = "Blinds target for level turns."
      Case splTeleport    'Spellbook: Teleport to location lvl distance away (must be visible).
         ret = "Teleport up to level distance (must be visible)."
      Case splOpen        'Spellbook: Attempts to open a locked door (lvl vs. DR).
         ret = "Attempts to open locked door (level vs. DR)."
      Case splFear        'Spellbook: Makes monster flee for lvl turns.
         ret = "Makes target flee for level turns."
      Case splConfuse     'Spellbook: Confuses monster for lvl turns.
         ret = "Confuse target for level turns."
      Case splFireBomb    'Spellbook: Area damage 20 x lvl. Sets monsters on fire lvl turns.
         ret = "Area damage 20 x level. Stes target(s) on fire." 
      Case splEntangle    'Spellbook: Immobilze target for lvel turns doing lvl damage each turn.
         ret = "Immobilize target for level turns, doing level damage."
      Case splCloudMind   'Spellbook: Target cannot cast spells for lvl turns.
         ret = "Target cannot cast spells for level turns."
      Case splFireball    'Spellbook: Area damage 10 x lvl. Sets monsters on fire lvl turns.
         ret = "Area damage 10 x level. Sets target(s) on fire."
      Case splIceStatue   'Spellbook: Freezes target for lvl turns. If frozen can be killed with single hit.
         ret = "Freezes target for level turns. Can be killed with single blow."
      Case splRust        'Spellbook: Reduces armor by lvl x 10%.
         ret = "Reduces target armor by level x 10%."
      Case splShatter     'Spellbook: Destroys target weapon, if any.
         ret = "Destroys target weapon."
      Case splMagicDrain  'Spellbook: Lower target MDF by lvl% and adds to caster for 1 turn.
         ret = "Lower target MDF by level%, adds to caster for 1 turn."
      Case splPoison      'Spellbook: Posions target 1 HP for lvl turns.
         ret = "Poisons target 1 HP for level turns."
      Case splEnfeeble    'Spellbook: Lowers target combat factors lvl x 10%.
         ret = "Lowers target combat factors level x 10%."
      Case splShout       'Spellbook: Stuns all visible monsters for lvl turns.
         ret = "Stuns all visible targets for level turns."
      Case splStealHealth 'Spellbook: Lowers HP lvl% of target and adds to caster.
         ret = "Lowers HP level% and adds to caster."
      Case splMindBlast   'Spellbook: Lowers target MCF and MDF lvl% for lvl turns.
         ret = "Lowers target MCF and MDF level% for level turns." 
      Case splBlink       'Spellbook: Teleport to random location lvl distance away. If location is occupied, item/monster destroyed.
         ret = "Teleport to random location up to level distance."     
      Case Else
         ret = "No effect."
   End Select
   
   Return ret
End Function

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
            ClearSpell inv.armor.spell
            inv.armor.spelleffect = wpNone
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
            ClearSpell inv.shield.spell 
            inv.shield.spelleffect = wpNone
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
            ClearSpell inv.weapon.spell  
            inv.weapon.damtype = wpNone
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
            ClearSpell inv.jewelry.spell
            inv.jewelry.spelleffect = jwNone
            inv.jewelry.noise = 0
            inv.jewelry.use = useNone
            inv.jewelry.jslot(1) = wNone
            inv.jewelry.jslot(2) = wNone
         Case clSpellBook
            inv.spellbook.id = bkNone
            inv.spellbook.evaldr = 0
            inv.spellbook.eval = FALSE
            inv.spellbook.use = useNone     
            inv.spellbook.noise = 0   
            ClearSpell inv.spellbook.spell
      End Select
     'Clear main description.
      inv.desc = ""
      'Clear the classid.
      inv.classid = clNone
      'Clear icon info.
      inv.icon = ""
      inv.iconclr = fbBlack
      inv.buy = 0
      inv.sell = 0
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
   inv.buy = 100
   inv.sell = 90
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

'Generates spell data.
Sub GenerateSpell(spl As spelltype, spllevel As Integer)
   
   'Set the defaults.   
   spl.lvl = spllevel 'Spell level.
   spl.splname = GetSpellName(spl.id) 'Sets the spell name.
   spl.splsname = GetSpellShortName(spl.id)
   spl.spldesc = GetSpellEffect(spl.id) 'Sets the spell description.
   spl.lvl = spllevel
   spl.dam = spllevel 
   spl.manacost = 0
   'Set damage/mana on spells.
   Select Case spl.id
      Case splAcidFog     'Spellbook: 5 dam over lvl turns
         spl.dam = 5
         spl.manacost = 5  
      Case splFireCloak   'Spellbook: Target gets 10 dam over lvl turns
         spl.dam = 10
         spl.manacost = 10  
      Case splLightning   'Spellbook: 2 * lvl damage (ignores armor)
         spl.dam = 2
         spl.manacost = 6  
      Case splFireBomb    'Spellbook: Area damage 20 x lvl. Sets monsters on fire lvl turns.
         spl.dam = 20 
         spl.manacost = 20  
      Case splEntangle    'Spellbook: Immobilze target for lvel turns doing lvl damage each turn.
         spl.dam = 4
         spl.manacost = 4  
      Case splFireball    'Spellbook: Area damage 10 x lvl. Sets monsters on fire lvl turns.
         spl.dam = 10
         spl.manacost = 15  
      Case splRust        'Spellbook: Reduces armor by lvl x 10%.
         spl.manacost = 8  
      Case splMagicDrain  'Spellbook: Lower target MDF by lvl% and adds to caster for 1 turn.
         spl.manacost = 3  
      Case splPoison      'Spellbook: Posions target 1 HP for lvl turns.
         spl.dam = 1
         spl.manacost = 3  
      Case splEnfeeble    'Spellbook: Lowers target combat factors lvl x 10%.
         spl.manacost = 9  
      Case splHeal        'Spellbook: 1% x lvl
         spl.manacost = 4  
      Case splMana        'Spellbook: 1% x lvl (does not consume mana)
         spl.manacost = 0  
      Case splRecharge    'Spellbook: 1 x lvl recharge on wand
         spl.manacost = 2  
      Case splFocus       'Spellbook: +lvl to all combat factors for 1 turn
         spl.manacost = 12  
      Case splBlind       'Spellbook: Blinds target for lvl turns
         spl.manacost = 6  
      Case splTeleport    'Spellbook: Teleport to location lvl distance away (must be visible).
         spl.manacost = 4  
      Case splOpen        'Spellbook: Attempts to open a locked door (lvl vs. DR).
         spl.manacost = 2  
      Case splFear        'Spellbook: Makes monster flee for lvl turns.
         spl.manacost = 4  
      Case splConfuse     'Spellbook: Confuses monster for lvl turns.
         spl.manacost = 9  
      Case splCloudMind   'Spellbook: Target cannot cast spells for lvl turns.
         spl.manacost = 12  
      Case splIceStatue   'Spellbook: Freezes target for lvl turns. If frozen can be killed with single hit.
         spl.manacost = 14  
      Case splShatter     'Spellbook: Destroys target weapon, if any.
         spl.manacost = 5  
      Case splShout       'Spellbook: Stuns all visible monsters for lvl turns.
         spl.manacost = 12  
      Case splStealHealth 'Spellbook: Lowers HP lvl% of target and adds to caster.
         spl.manacost = 8  
      Case splMindBlast   'Spellbook: Lowers target MCF and MDF lvl% for lvl turns.
         spl.manacost = 12  
      Case splBlink       'Spellbook: Teleport to random location lvl distance away. If location is occupied, item/monster destroyed.     
         spl.manacost = 4
      Case Else
         spl.splname = "Unknown Spell"
         spl.splsname = "Unknown"
   End Select
   
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
         inv.desc = "Claymore"
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
   'Set the buy and sell amounts.
   inv.buy = inv.weapon.dam * 10
   inv.sell = inv.weapon.dam * 8
   If inv.weapon.spell.id <> splNone Then
      inv.buy += 100
      inv.sell += 90
   EndIf
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
   inv.armor.spelleffect = wdNone
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
   'Set the buy and sell amounts.
   inv.buy = inv.armor.dampct * 100
   inv.sell = inv.armor.dampct * 80
   If inv.armor.spell.id <> splNone Then
      inv.buy += 100
      inv.sell += 100
   EndIf
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
   'Set the buy and sell amounts.
   inv.buy = inv.shield.dampct * 100
   inv.sell = inv.shield.dampct * 80
   If inv.shield.spell.id <> splNone Then
      inv.buy += 100
      inv.sell += 100
   EndIf
   
End Sub

'Generate new supply item.
Sub GenerateSupplies(inv As invtype, currlevel As Integer)
   Dim item As supplyids
   Dim As Integer isMagic  
   
   isMagic = ItemIsMagic(currlevel)
   item = RandomRange(supHealingHerb, supSkeletonKey)
   'Set the supply item id.
   inv.classid = clSupplies
   inv.supply.id = item
   inv.supply.evaldr = GetScaledFactor(charint, currlevel)
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
         inv.buy = 50
         inv.sell = 40
         'Set the magic properties.
         If isMagic = TRUE Then
            inv.supply.spell.id = splMaxHealing
            inv.supply.spell.splname = GetSpellName(inv.supply.spell.id)
            inv.supply.spell.spldesc = GetSpellEffect(inv.supply.spell.id)
            inv.supply.spell.manacost = 0
            inv.supply.spell.dam = 0
            inv.buy += 20
            inv.sell += 10
         EndIf
      Case supHunkMeat
         inv.desc = "Hunk of Meat"
         inv.supply.desc = "Adds 25% max HP to current HP"
         inv.supply.noise = 1
         inv.icon = Chr(224)
         inv.iconclr = fbSalmon
         inv.supply.eval = FALSE
         inv.supply.use = useEatDrink
         inv.buy = 25
         inv.sell = 15
         'Set the magic properties.
         If isMagic = TRUE Then
            inv.supply.spell.id = splStrongMeat
            inv.supply.spell.splname = GetSpellName(inv.supply.spell.id)
            inv.supply.spell.spldesc = GetSpellEffect(inv.supply.spell.id)
            inv.supply.spell.manacost = 0
            inv.supply.spell.dam = 0
            inv.buy += 10
            inv.sell += 5
         EndIf
      Case supBread       
         inv.desc = "Loaf of Bread"
         inv.supply.desc = "Adds 10% max HP to current HP"
         inv.supply.noise = 1
         inv.icon = Chr(247)
         inv.iconclr = fbHoneydew
         inv.supply.eval = FALSE 
         inv.supply.use = useEatDrink
         inv.buy = 10
         inv.sell = 5
         'Set the magic properties.
         If isMagic = TRUE Then
            inv.supply.spell.id = splBreadLife
            inv.supply.spell.splname = GetSpellName(inv.supply.spell.id)
            inv.supply.spell.spldesc = GetSpellEffect(inv.supply.spell.id)
            inv.supply.spell.manacost = 0
            inv.supply.spell.dam = 0
            inv.buy += 5
            inv.sell += 3
         EndIf
      Case supManaOrb   
         inv.desc = "Mana Orb"
         inv.supply.desc = "Restores Mana"
         inv.supply.noise = 4
         inv.icon = Chr(229)
         inv.iconclr = fbYellowGreen
         inv.supply.eval = FALSE
         inv.supply.use = useEatDrink
         inv.buy = 20
         inv.sell = 10
         'Set the magic properties.
         If isMagic = TRUE Then
            inv.supply.spell.id = splMaxMana
            inv.supply.spell.splname = GetSpellName(inv.supply.spell.id)
            inv.supply.spell.spldesc = GetSpellEffect(inv.supply.spell.id)
            inv.supply.spell.manacost = 0
            inv.supply.spell.dam = 0
            inv.buy += 10
            inv.sell += 5
         EndIf
      Case supLockPick    'Lock pick set.
         inv.desc = "Lock Pick"
         inv.supply.desc = "Opens Lock"
         inv.supply.noise = 3
         inv.icon = Chr(168)
         inv.iconclr = fbSilver
         inv.supply.eval = FALSE
         inv.supply.use = useWieldWear
         inv.supply.sslot(1) = wPrimary
         inv.supply.sslot(2) = wSecondary
         inv.buy = 10
         inv.sell = 5
      Case supSkeletonKey 'Skeleton key.
         inv.desc = "Skeleton Key"
         inv.supply.desc = "Opens Lock"
         inv.supply.noise = 1
         inv.icon = Chr(13)
         inv.iconclr = fbSilver
         inv.supply.eval = FALSE
         inv.supply.use = useWieldWear
         inv.supply.sslot(1) = wPrimary
         inv.supply.sslot(2) = wSecondary
         inv.buy = 10
         inv.sell = 5
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
         inv.buy = 5
         inv.sell = 3
      Case amCaseBolts
         inv.desc = "Case of Bolts"
         inv.ammo.cnt = RandomRange(10, 20)
         inv.ammo.noise = inv.ammo.cnt 
         inv.icon = Chr(22)
         inv.buy = 10
         inv.sell = 5
      Case amQuiverArrows
         inv.desc = "Quiver of Arrows"
         inv.ammo.cnt = RandomRange(10, 20)
         inv.ammo.noise = inv.ammo.cnt 
         inv.icon = Chr(173)
         inv.buy = 10
         inv.sell = 5
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
      inv.jewelry.spell.id = RandomRange(splUCF, splRegenMana) 'Spell id.
      GenerateSpell inv.jewelry.spell, currlevel
      inv.jewelry.spelleffect = GetJewelrySpellEffect(inv.jewelry.spell.id)
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
         inv.buy = 5
         inv.sell = 3
      Case jewBronze
         inv.desc = "Bronze" & inv.desc
         inv.buy = 10
         inv.sell = 5
      Case jewCopper
         inv.desc = "Copper" & inv.desc
         inv.buy = 15
         inv.sell = 7
      Case jewBrass
         inv.desc = "Brass" & inv.desc
         inv.buy = 20
         inv.sell = 10
      Case jewSilver
         inv.desc = "Silver" & inv.desc
         inv.buy = 50
         inv.sell = 40
      Case jewGold
         inv.desc = "Gold" & inv.desc
         inv.buy = 100
         inv.sell = 90
      Case jewAgate
         inv.desc = "Agate" & inv.desc
         inv.buy = 25
         inv.sell = 15
      Case jewOpal
         inv.desc = "Opal" & inv.desc
         inv.buy = 25
         inv.sell = 15
      Case jewAmethyst
         inv.desc = "Amethyst" & inv.desc
         inv.buy = 25
         inv.sell = 15
      Case jewRuby
         inv.desc = "Ruby" & inv.desc
         inv.buy = 30
         inv.sell = 20
      Case jewEmerald
         inv.desc = "Emerald" & inv.desc
         inv.buy = 40
         inv.sell = 30
      Case jewJade
         inv.desc = "Jade" & inv.desc
         inv.buy = 25
         inv.sell = 15
      Case jewPearl
         inv.desc = "Pearl" & inv.desc
         inv.buy = 35
         inv.sell = 25
      Case jewQuartz
         inv.desc = "Quartz" & inv.desc
         inv.buy = 5
         inv.sell = 3
      Case jewSapphire
         inv.desc = "Sapphire" & inv.desc
         inv.buy = 45
         inv.sell = 35
      Case jewDiamond
         inv.desc = "Diamond" & inv.desc
         inv.buy = 110
         inv.sell = 100
   End Select
   'If magic bump the price.
   If isMagic = TRUE Then
      inv.buy += 100
      inv.sell += 90
   EndIf
End Sub


'Generate new spellbook item.
Sub GenerateSpellBook(inv As invtype, currlevel As Integer)
   Dim item As spellbkids
   Dim As Integer r
   
   'Set the class id.
   inv.classid = clSpellBook
   'Two kinds of spell books, blank ones and one that contain a spell.
   r = RandomRange(1, 10)
   If r = 5 Then
      item = bkSpellBlank
   Else
      item = bkSpellBook
   EndIf
   'These are the common items.
   inv.spellbook.evaldr = GetScaledFactor(charint, currlevel)
   inv.spellbook.eval = FALSE
   inv.spellbook.id = item
   inv.iconclr = fbOrange
   inv.icon = Chr(254)
   inv.spellbook.use = useRead
   inv.spellbook.noise = 1
   inv.desc = "Spell Book"
   inv.buy = 100
   inv.sell = 90
   'If we have a non-blank, generate a spell for it.
   If item = bkSpellBook Then
      'Get the spell.
      inv.spellbook.spell.id = RandomRange(splAcidFog, splBlink) 'Spell id.
      GenerateSpell inv.spellbook.spell, 1
   Else
      ClearSpell inv.spellbook.spell
   End If
   inv.buy += inv.spellbook.spell.dam + RandomRange(1, 10)
   inv.sell += inv.spellbook.spell.dam + RandomRange(1, 8)
   
End Sub


'Generates a new item and places it into the invetory slot.
Sub GenerateItem(inv As invtype, currlevel As Integer, clid As classids = clNone)
   Dim iclass As classids
   
   If clid = clNone Then
      iclass = RandomRange(clGold, clSpellBook)
   Else
      iclass = clid
   End If
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
         Case clSpellBook
            GenerateSpellBook inv, currlevel
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
         Case clSpellBook
            ret = inv.spellbook.eval
         Case clUnavailable
            ret = TRUE
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
         Case clSpellBook
            ret = inv.spellbook.evaldr 'Return spellbook eval dr.
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
         Case clSpellBook
            inv.spellbook.eval = state
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
         Case clSpellBook
            If inv.spellbook.use = whatuse Then
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
         Case clSpellBook
            idx += 1
            ReDim Preserve lines(0 to idx) As String
            lines(idx) = GetInvItemDesc(inv)
            If IsEval(inv) = TRUE Then
               If inv.spellbook.spell.id <> splNone Then
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Spell: " & Trim(inv.spellbook.spell.splname)
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Effect: " & Trim(inv.spellbook.spell.spldesc)
               Else
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "Blank Spellbook"
               End If
               idx += 1
               ReDim Preserve lines(0 to idx) As String
               lines(idx) = "* Item is evaluated"
            Else
               idx += 1
               ReDim Preserve lines(0 to idx) As String
               lines(idx) = "* Item is not evaluated"
            End If
         Case clSpell
            idx += 1
            ReDim Preserve lines(0 to idx) As String
            lines(idx) = GetInvItemDesc(inv)
            If inv.spell.id <> splNone Then
               idx += 1
               ReDim Preserve lines(0 to idx) As String
               lines(idx) = "* Spell: " & Trim(inv.spell.splname)
               idx += 1
               ReDim Preserve lines(0 to idx) As String
               lines(idx) = "* Effect: " & Trim(inv.spell.spldesc)
               idx += 1
               ReDim Preserve lines(0 to idx) As String
               lines(idx) = "* Level: " & inv.spell.lvl
               idx += 1
               ReDim Preserve lines(0 to idx) As String
               lines(idx) = "* Mana Cost: " & inv.spell.manacost
               If inv.spell.dam > 0 Then
                  idx += 1
                  ReDim Preserve lines(0 to idx) As String
                  lines(idx) = "* Damage: " & inv.spell.dam
               End If
            Else
               idx += 1
               ReDim Preserve lines(0 to idx) As String
               lines(idx) = "* No spell."
            End If
         Case clUnavailable
               idx += 1
               ReDim Preserve lines(0 to idx) As String
               lines(idx) = "* Slot is not available."
      End Select
   EndIf
   
End Sub

'Returns the inventory slots for wield items.
Function GetInvWSlot(inv As invtype, slotnum As Integer) As wieldpos
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
   ElseIf (inv.classid = clRing) Or (inv.classid = clNecklace) Then
      If slotnum >= LBound(inv.jewelry.jslot) And slotnum <= UBound(inv.jewelry.jslot) Then 
         ret = inv.jewelry.jslot(slotnum)
      End If
   ElseIf inv.classid = clSupplies Then
      'Check for lock pick or skeleton key.
      If (inv.supply.id = supLockPick) Or (inv.supply.id = supSkeletonKey) Then
         If slotnum >= LBound(inv.supply.sslot) And slotnum <= UBound(inv.supply.sslot) Then 
            ret = inv.supply.sslot(slotnum)
         End If
      EndIf
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

'Initialzes the target spell set.
Sub InitTargetSpells()
   Dim As Integer ret
   
'Add target spells to spell set.
ret = splSet.AddToSet(splAcidFog)     
ret = splSet.AddToSet(splFireCloak)   
ret = splSet.AddToSet(splLightning)   
ret = splSet.AddToSet(splBlind)       
ret = splSet.AddToSet(splFear)        
ret = splSet.AddToSet(splConfuse)     
ret = splSet.AddToSet(splFireBomb)     
ret = splSet.AddToSet(splEntangle)    
ret = splSet.AddToSet(splCloudMind)   
ret = splSet.AddToSet(splFireball)    
ret = splSet.AddToSet(splIceStatue)   
ret = splSet.AddToSet(splRust)        
ret = splSet.AddToSet(splShatter)     
ret = splSet.AddToSet(splMagicDrain)  
ret = splSet.AddToSet(splEnfeeble)    
ret = splSet.AddToSet(splStealHealth) 
ret = splSet.AddToSet(splMindBlast)
   
End Sub

'Generates an Unavailable inventory item.
Sub GenerateUnavail (inv As invtype)
   ClearInv inv
   inv.classid = clUnavailable
   inv.desc = "Unavailable"
   inv.iconclr = fbWhite
End Sub

'Returns the name of the spell for an item.
Function GetItemSpell(inv As invtype) As String
   Dim As String ret = "None"
   
   'If classid is None then nothing to do.
   If inv.classid <> clNone Then
      Select Case inv.classid
         Case clSupplies
            If inv.supply.spell.id <> splNone Then
               ret = inv.supply.spell.splname 
            EndIf
         Case clArmor
            If inv.armor.spell.id <> splNone Then
               ret = inv.armor.spell.splname 
            EndIf
         Case clShield
            If inv.shield.spell.id <> splNone Then
               ret = inv.shield.spell.splname 
            EndIf
         Case clWeapon
            If inv.weapon.spell.id <> splNone Then
               ret = inv.weapon.spell.splname 
            EndIf
         Case clPotion
            ret = GetPotionEffectDesc(inv.potion.id)
         Case clRing, clNecklace
            If inv.jewelry.spell.id <> splNone Then
               ret = inv.jewelry.spell.splname 
            EndIf
         Case clSpellBook
            If inv.spellbook.spell.id <> splNone Then
               ret = inv.spellbook.spell.splname 
            EndIf
      End Select
   End If
   
   Return ret
End Function

'Returns a string associated with wield position.
Function GetWieldString(w As wieldpos) As String
   Dim As String ret = "None"
   
   Select Case w
      Case wPrimary
         ret = "Primary"
      Case wSecondary
         ret = "Secondary"
      Case wArmor
         ret = "Armor"
      Case wNeck
         ret = "Neck"
      Case wRingRt
         ret = "Ring RT"
      Case wRingLt
         ret = "Ring LT"
   End Select
   
   Return ret
End Function
