package no.donkeylube.donkeyslug.items;

import no.donkeylube.donkeyslug.CreatureStatistics;

public class Consumable extends Item {
    private ConsumationEffect consumationEffect;
    
    public Consumable(String name, ConsumationEffect consumationEffect) {
	super(name);
	this.consumationEffect = consumationEffect;
    }

    public void consume(CreatureStatistics creatureStatistics) {
	consumationEffect.apply(creatureStatistics);
    }
}
