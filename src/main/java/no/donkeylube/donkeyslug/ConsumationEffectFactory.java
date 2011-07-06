package no.donkeylube.donkeyslug;

import no.donkeylube.donkeyslug.items.ConsumationEffect;

public class ConsumationEffectFactory {
    public static ConsumationEffect createModifyHealthEffect(final int value) {
	return new ConsumationEffect() {
	    public void apply(CreatureStatistics creatureStatistics) {
		creatureStatistics.increaseHitPointsBy(value);
	    }
	};
    }
    
    public static ConsumationEffect createModifyHealthEffect(final double value) {
	return new ConsumationEffect() {
	    public void apply(CreatureStatistics creatureStatistics) {
		creatureStatistics.increaseHitPointsBy((int)(creatureStatistics.getHitPoints() * value));
	    }
	};
    }
}
