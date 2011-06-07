package no.donkeylube.donkeyslug;

import java.util.Random;

public class BattleCalculator {
    private final Fighter attacker;
    private final Attackable defender;
    
    public BattleCalculator(Fighter attacker, Attackable defender) {
	this.attacker = attacker;
	this.defender = defender; 
    }
        
    public boolean attackerHitsOpponent() {
	int attackersDexterity = attacker.getStatistics().getDexterity();
	int defendersDexterity = defender.getStatistics().getDexterity();
	Random random = new Random();
	int attackRoll = random.nextInt(attackersDexterity+1);
	int defenseRoll = random.nextInt((defendersDexterity/2)+1);
	GameReporter.getInstance().offer("Attack roll: " + attackRoll + ", Defense roll: " + defenseRoll);
	return attackRoll > defenseRoll;
    }

    public int determineDamage() {
	Weapon attackersWeapon = attacker.getWeapon();
	Random random = new Random();
	int damageAboveMinimum = random.nextInt((attackersWeapon.getMaxDamage() - attackersWeapon.getMinDamage()) + 1);
	int weaponDamage = attackersWeapon.getMinDamage() + damageAboveMinimum;
	int attackersStrength = attacker.getStatistics().getStrength();
	int attackDamage = weaponDamage + (attackersStrength/3);
	int totalDamage = attackDamage - defender.getAccumulatedDefensiveValueOfArmor();
	if (totalDamage < 0) {
	    totalDamage = 0;
	}
	GameReporter.getInstance().offer("Attacker deals " + totalDamage + " damage.");
	return totalDamage;
    }
}
