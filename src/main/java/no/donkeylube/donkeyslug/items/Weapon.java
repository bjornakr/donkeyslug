package no.donkeylube.donkeyslug.items;


public class Weapon extends Item {
    public enum Type {SLASHING, PIERCING, BLUNT};
    
    private String name;
    private Type type;
    private int minDamage;
    private int maxDamage;
    private double chanceOfCritical;
    private double criticalModifier;

    public Weapon(String name) {
	super(name);
    }
    
//    public String getName() {
//	return name;
//    }
//
//    public void setName(String name) {
//	this.name = name;
//    }

    public Type getType() {
	return type;
    }

    public void setType(Type type) {
	this.type = type;
    }

    public int getMinDamage() {
	return minDamage;
    }

    public void setMinDamage(int minDamage) {
	this.minDamage = minDamage;
    }

    public int getMaxDamage() {
	return maxDamage;
    }

    public void setMaxDamage(int maxDamage) {
	this.maxDamage = maxDamage;
    }

    public double getChanceOfCritical() {
	return chanceOfCritical;
    }

    public void setChanceOfCritical(double chanceOfCritical) {
	this.chanceOfCritical = chanceOfCritical;
    }

    public double getCriticalModifier() {
	return criticalModifier;
    }

    public void setCriticalModifier(double criticalModifier) {
	this.criticalModifier = criticalModifier;
    }
    
    public String toString() {
	return "name = " + name + "\n" +
	"type = " + type + "\n";	
    }
}
