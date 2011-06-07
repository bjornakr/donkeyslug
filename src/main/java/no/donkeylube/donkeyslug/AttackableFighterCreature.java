package no.donkeylube.donkeyslug;

public class AttackableFighterCreature extends Creature implements Attackable, Fighter {
    private final CreatureStatistics myStats;
    private final String name;
    private Weapon weapon;
    
    public AttackableFighterCreature(String name, CreatureStatistics creatureStats) {
	super(name, creatureStats);
	this.name = name;
	myStats = creatureStats;
	weapon = new Weapon("Bare hands", 3, 5);
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
    }

    private void notifyMissToReporter() {
	GameReporter.getInstance().offer(name + " misses.");
    }

    private void notifyAttackToReporter(Attackable opponent) {
	GameReporter.getInstance().offer(name + " attacks " + opponent.getName() +
		" with " + weapon.getName().toLowerCase() + ".");
    }

    @Override
    public boolean dodgesAttack(int dexterityOfOpponent) {
	double dexterityComparison = (myStats.getDexterity() - dexterityOfOpponent) / 100;
	double chanceToDodge = 0.3 + dexterityComparison;
	return Math.random() < chanceToDodge;
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
	GameReporter.getInstance().offer(name + " equips " + weapon.getName());
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
}    
