package no.donkeylube.donkeyslug;

public class AttackReport {
    private int attackRoll = 0;
    private int defenseRoll = 0;
    private boolean successfulHit = false;
    private boolean criticalHit = false;
    private int initalAttackDamage = 0;
    private int defendersDamageReduction = 0;
    private int totalDamage = 0;
    
    public int attackRoll() {
	return attackRoll;
    }
    
    public int defenseRoll() {
	return defenseRoll;
    }
    
    public boolean successfulHit() {
	return successfulHit;
    }
    
    public boolean criticalHit() {
	return criticalHit;
    }
    
    public int initialAttackDamage() {
	return initalAttackDamage; 
    }
    
    public int defendersDamageReduction() {
	return defendersDamageReduction;
    }
    
    public int totalDamage() {
	return totalDamage;
    }
    
    public void setAttackRoll(int attackRoll) {
	this.attackRoll = attackRoll;
    }

    public void setDefenseRoll(int defenseRoll) {
	this.defenseRoll = defenseRoll;
	
    }

    public void setSuccessfulHit(boolean successfulHit) {
	this.successfulHit = successfulHit;
    }

    public void setInitialAttackDamage(int initialAttackDamage) {
	initalAttackDamage = initialAttackDamage;
    }

    public void setDefendersDamageReduction(int defendersDamageReduction) {
	this.defendersDamageReduction = defendersDamageReduction;
    }

    public void setTotalDamage(int totalDamage) {
	this.totalDamage = totalDamage;
    }

    public void setCriticalHit(boolean criticalHit) {
	this.criticalHit = criticalHit;
    }

}
