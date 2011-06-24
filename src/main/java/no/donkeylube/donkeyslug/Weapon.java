package no.donkeylube.donkeyslug;

public class Weapon extends Item {
    private String name;
    private int minDamage;
    private int maxDamage;
    
    public Weapon() {
	
    }
    
    public Weapon(String name, int minDamage, int maxDamage) {
	this.name = name;
	this.minDamage = minDamage;
	this.maxDamage = maxDamage;
    }
    
    public void setName(String name) {
	this.name = name;
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
