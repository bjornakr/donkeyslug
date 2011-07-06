package no.donkeylube.donkeyslug;

import java.util.LinkedList;
import java.util.List;

import no.donkeylube.donkeyslug.items.Consumable;
import no.donkeylube.donkeyslug.items.Item;
import no.donkeylube.donkeyslug.items.Weapon;

public class AttackableFighterCreature extends Creature implements Attackable, Fighter {
    private final CreatureStatistics myStats;
    private final String name;
    private Weapon weapon;
    private List<AttackListener> attackListeners = new LinkedList<AttackListener>();

    public AttackableFighterCreature(String name, CreatureStatistics creatureStats) {
	super(name, creatureStats);
	this.name = name;
	myStats = creatureStats;
	weapon = new Weapon("Bare hands");
//	weapon.setName("Bare hands");
	weapon.setChanceOfCritical(0.1);
	weapon.setCriticalModifier(2);
	weapon.setType(Weapon.Type.BLUNT);
	weapon.setMinDamage(4);
	weapon.setMaxDamage(6);
    }

    @Override
    public void attack(Attackable opponent) {
	notifyAttackToReporter(opponent);
	BattleCalculator battleCalculator = new BattleCalculator(this, opponent);
	if (battleCalculator.attackerHitsOpponent()) {
	    opponent.takeDamage(battleCalculator.determineDamage());
	}
	else {
	    notifyMissToReporter();
	}
	notifyAttackListeners(null);
    }

    private void notifyMissToReporter() {
	GameReporter.getInstance().offer(name + " misses.");
    }

    private void notifyAttackToReporter(Attackable opponent) {
	GameReporter.getInstance().offer(name + " attacks " + opponent.getName() +
		" with " + weapon.name().toLowerCase() + ".");
    }

    @Override
    public void takeDamage(int initialDamage) {
	int totalDamage = initialDamage;
	myStats.decreaseHitPointsBy(totalDamage);
	GameReporter.getInstance().offer(name + " takes " + totalDamage + " damage.");
    }

    @Override
    public void equipWeapon(Weapon weapon) {
	this.weapon = weapon;
	GameReporter.getInstance().offer(name + " equips " + weapon.name());
    }

    @Override
    public int getAccumulatedDefensiveValueOfArmor() {
	// TODO Auto-generated method stub
	return 1;
    }

    @Override
    public Weapon getWeapon() {
	return weapon;
    }

    @Override
    public void addAttackListener(AttackListener attackListener) {
	attackListeners.add(attackListener);
    }

    @Override
    public void notifyAttackListeners(AttackReport attackReport) {
	for (AttackListener attackListener : attackListeners) {
	    attackListener.attackPerformed(attackReport);
	}
    }

    public void pickUp(Item item, Tile tile) {
	super.pickUp(item, tile);
	if (item instanceof Weapon) {
	    equipWeapon((Weapon) item);
	    System.out.println("Weapon equipped");
	}
	else if (item instanceof Consumable) {
	    consume((Consumable) item);
	    System.out.println("Quaffed something");
	}
    }
}
