package no.donkeylube.donkeyslug;

import java.util.Random;

import no.donkeylube.donkeyslug.items.Weapon;

public class BattleExecutor {
    private final Fighter attacker;
    private final Attackable defender;
    private AttackReport attackReport;

    public BattleExecutor(Fighter attacker, Attackable defender) {
	if (attacker.isDead()) {
	    throw new IllegalStateException("Trying to fight with dead attacker.");
	}
	if (defender.isDead()) {
	    throw new IllegalStateException("Trying to fight with dead defender.");
	}
	this.attacker = attacker;
	this.defender = defender;
    }

    public void executeAttack() {
	attackReport = new AttackReport();
	if (attackerHitsOpponent()) {
	    defender.takeDamage(determineDamage());
	}
    }

    private boolean attackerHitsOpponent() {
	int attackersDexterity = attacker.getStatistics().getDexterity();
	int defendersDexterity = defender.getStatistics().getDexterity();
	Random random = new Random();
	int attackRoll = random.nextInt(attackersDexterity + 1);
	int defenseRoll = random.nextInt((defendersDexterity / 3) + 1);
	attackReport.setAttackRoll(attackRoll);
	attackReport.setDefenseRoll(defenseRoll);
	attackReport.setSuccessfulHit(attackRoll > defenseRoll);
	return attackRoll > defenseRoll;
    }

    private int determineDamage() {
	Weapon attackersWeapon = attacker.getWeapon();
	Random random = new Random();
	int damageAboveMinimum = random.nextInt((attackersWeapon.getMaxDamage() - attackersWeapon.getMinDamage()) + 1);
	int weaponDamage = attackersWeapon.getMinDamage() + damageAboveMinimum;
	int attackersStrength = attacker.getStatistics().getStrength();
	int initialAttackDamage = weaponDamage + Math.round(attackersStrength / 3);
	if (random.nextDouble() < attackersWeapon.getChanceOfCritical()) {
	    initialAttackDamage *= attackersWeapon.getCriticalModifier();
	    attackReport.setCriticalHit(true);
	}
	else {
	    attackReport.setCriticalHit(false);
	}
	int defendersDamageReduction = (int) Math.round(defender.accumulativeDefensiveValueOfArmor() * 0.3);
	int totalDamage = initialAttackDamage - defendersDamageReduction;
	if (totalDamage < 0) {
	    totalDamage = 0;
	}
	attackReport.setInitialAttackDamage(initialAttackDamage);
	attackReport.setDefendersDamageReduction(defendersDamageReduction);
	attackReport.setTotalDamage(totalDamage);
	return totalDamage;
    }

    public AttackReport attackReport() {
	return attackReport;
    }
}
