package no.donkeylube.donkeyslug;

import no.donkeylube.donkeyslug.items.Armor;

import org.junit.Before;
import org.junit.Test;

import static org.mockito.Mockito.*;
import static no.donkeylube.donkeyslug.items.Armor.Type.*;
import static org.junit.Assert.*;

public class WearingArmorTest {
    private Attackable attackable;
    private Armor helmet = new Armor("Helmet", HEAD, 1);
    private Armor chainMail = new Armor("Chain mail", TORSO, 4);
    private Armor gloves = new Armor("Leather gloves", HANDS, 1);
    private Armor boots = new Armor("Leather boots", FEET, 1);
    
    @Before
    public void initializeCreature() {
	attackable = new AttackableFighterCreature("Knight", mock(CreatureStatistics.class));
    }
    
    @Test
    public void wearingAFullSetOfArmorShouldIncreaseArmorValue() {
	assertEquals("Armor value", 0, attackable.accumulativeDefensiveValueOfArmor());
	attackable.equipArmor(helmet);
	attackable.equipArmor(chainMail);
	attackable.equipArmor(gloves);
	attackable.equipArmor(boots);
	assertEquals("Armor value", 7, attackable.accumulativeDefensiveValueOfArmor());	
    }
    
    @Test
    public void equippingArmorOfSameTypeShouldReplaceOldArmor() {
	attackable.equipArmor(chainMail);
	assertEquals("Armor value", 4, attackable.accumulativeDefensiveValueOfArmor());
	attackable.equipArmor(new Armor("Plate mail", TORSO, 9));
	assertEquals("Armor value", 9, attackable.accumulativeDefensiveValueOfArmor());
    }    
}
