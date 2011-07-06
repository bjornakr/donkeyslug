package no.donkeylube.donkeyslug.items;

public class Armor extends Item {
    public enum Type {HEAD, TORSO, HANDS, FEET, SHIELD, BODY}
    
    private Type type;
    private int defensiveValue;
    
    public Armor(String name, Type type, int defensiveValue) {
	super(name);
	this.type = type;
	this.defensiveValue = defensiveValue;
    }

    public int defensiveValue() {
	return defensiveValue;
    }

    public Type type() {
	return type;
    }    
}
