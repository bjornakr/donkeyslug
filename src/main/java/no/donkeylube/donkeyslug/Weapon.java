package no.donkeylube.donkeyslug;

public class Weapon extends Item {
    private final String name;
    private final int minDamage;
    private final int maxDamage;
    
    public Weapon(String name, int minDamage, int maxDamage) {
	this.name = name;
	this.minDamage = minDamage;
	this.maxDamage = maxDamage;
    }
    
    public String getName() {
	return name;
    }

    public int getMaxDamage() {
	return maxDamage;
    }

    public int getMinDamage() {
	return minDamage;
    }
}
