package no.donkeylube.donkeyslug;

public class CreatureStatistics {
    private int strength;
    private int dexterity;
    private int hitPoints;
    private int sightRange;

    public static class Builder {
	// Required
	private final int strength;
	private final int dexterity;

	// Optional
	private int hitPoints = 100;
	private int sightRange = 10;

	public Builder(int strength, int dexterity) {
	    this.strength = strength;
	    this.dexterity = dexterity;
	}

	public Builder hitPoints(int value) {
	    hitPoints = value;
	    return this;
	}

	public Builder sightRange(int sightRange) {
	    this.sightRange = sightRange; 
	    return this;
	}

	public CreatureStatistics build() {
	    return new CreatureStatistics(this);
	}
    }

    private CreatureStatistics(Builder builder) {
	strength = builder.strength;
	dexterity = builder.dexterity;
	hitPoints = builder.hitPoints;
	sightRange = builder.sightRange;
    }

    public int getStrength() {
	return strength;
    }

    public int getDexterity() {
	return dexterity;
    }

    public int getHitPoints() {
	return hitPoints;
    }
    
    public int getSightRange() {
	return sightRange;
    }

    public void decreaseHitPointsBy(int initialDamage) {
	hitPoints -= initialDamage;
    }
}
