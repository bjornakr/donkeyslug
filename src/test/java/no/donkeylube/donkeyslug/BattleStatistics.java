package no.donkeylube.donkeyslug;

import java.util.LinkedList;
import java.util.List;

import no.donkeylube.donkeyslug.items.Armor;
import no.donkeylube.donkeyslug.items.Weapon;

import org.junit.Test;

public class BattleStatistics implements AttackListener {
    private int totalDamage = 0;
    private int noOfHits = 0;
    private int noOfCriticalHits = 0;
    private AttackableFighterCreature attacker;
    private AttackableFighterCreature defender;

    @Test
    public void reportForSingleAttacker() {
	final int NO_OF_FIGHTS = 10000;
	int noOfRounds = 0;
	for (int i = 0; i < NO_OF_FIGHTS; i++) {
	    attacker = new AttackableFighterCreature("Attacker", new CreatureStatistics.Builder(100, 100).hitPoints(100)
		    .build());
	    attacker.addAttackListener(this);
	    defender = new AttackableFighterCreature("Defender", new CreatureStatistics.Builder(100, 100).hitPoints(100)
		    .build());
	    while (!defender.isDead()) {
		attacker.attack(defender);
		noOfRounds++;
	    }
	}
	System.out.println("Avg. no. of rounds: " + noOfRounds / NO_OF_FIGHTS);
	System.out.println("Avg. damage/round: " + totalDamage / noOfRounds);
	System.out.println("Chance of hit: " + ((double) noOfHits / noOfRounds));
	System.out.println("Chance of critical hit: " + ((double) noOfCriticalHits / noOfHits));
	System.out.println("--");
    }

    @Test
    public void reportWinner() {
	final int NO_OF_FIGHTS = 10000;
	int creature1Deaths = 0;
	int creature2Deaths = 0;
	int noOfRounds = 0;
	for (int i = 0; i < NO_OF_FIGHTS; i++) {
	    attacker = new AttackableFighterCreature("Attacker", new CreatureStatistics.Builder(10, 10).hitPoints(100)
		    .build());
	    defender = new AttackableFighterCreature("Defender", new CreatureStatistics.Builder(10, 10).hitPoints(100)
		    .build());
	    while (true) {
		if (!attacker.isDead()) {
		    attacker.attack(defender);
		}
		else {
		    creature1Deaths++;
		    break;
		}
		if (!defender.isDead()) {
		    defender.attack(attacker);
		}
		else {
		    creature2Deaths++;
		    break;
		}
		noOfRounds++;
	    }
	}
	System.out.println("Avg. no. of rounds: " + noOfRounds / NO_OF_FIGHTS);
	System.out.println("Chance of win for C1: " + ((double) creature2Deaths / (creature1Deaths + creature2Deaths)));
	System.out.println("--");
    }

    @Test
    public void survival() {
	final int NO_OF_FIGHTS = 10000;
	final int DEFENDER_STR = 5;
	final int DEFENDER_DEX = 5;
	final int DEFENDER_HP = 100;

//	attacker = new AttackableFighterCreature("Attacker", new CreatureStatistics.Builder(10, 10).hitPoints(100)
//		    .build());
	defender = new AttackableFighterCreature("Defender", new CreatureStatistics.Builder(DEFENDER_STR, DEFENDER_DEX)
		.hitPoints(DEFENDER_HP).build());

	int fightsWon = 0;
	for (int i = 0; i < NO_OF_FIGHTS; i++) {
	    attacker = new AttackableFighterCreature("Attacker", new CreatureStatistics.Builder(10, 10).hitPoints(100)
		    .build());
	    attacker.equipWeapon(createWeapon());
	    for (Armor armor : createArmorItems()) {
		attacker.equipArmor(armor);		
	    }
	    while (true) {
		attacker.attack(defender);
		if (defender.isDead()) {
		    fightsWon++;
		    defender = new AttackableFighterCreature("Defender", new CreatureStatistics.Builder(DEFENDER_STR,
			    DEFENDER_DEX).hitPoints(DEFENDER_HP).build());
		}
		defender.attack(attacker);
		if (attacker.isDead()) {
		    break;
		}
	    }
	}
	System.out.println("Fights won: " + fightsWon);
	System.out.println("Avg. fights won: " + fightsWon / NO_OF_FIGHTS);
    }

    private List<Armor> createArmorItems() {
	List<Armor> armorItems = new LinkedList<Armor>();	
	armorItems.add(new Armor("Chain mail", Armor.Type.TORSO, 7));
	return armorItems;
    }

    private Weapon createWeapon() {
	Weapon weapon = new Weapon("Holy stick");
	weapon.setChanceOfCritical(0.1);
	weapon.setCriticalModifier(2);
	weapon.setMinDamage(10);
	weapon.setMaxDamage(15);
	weapon.setType(Weapon.Type.BLUNT);
	return weapon;
    }

    @Override
    public void attackPerformed(AttackReport attackReport) {
	totalDamage += attackReport.totalDamage();
	noOfHits += attackReport.successfulHit() ? 1 : 0;
	noOfCriticalHits += attackReport.criticalHit() ? 1 : 0;
    }
}
