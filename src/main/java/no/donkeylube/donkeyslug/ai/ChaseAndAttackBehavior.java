package no.donkeylube.donkeyslug.ai;

import java.util.List;

import no.donkeylube.donkeyslug.Attackable;
import no.donkeylube.donkeyslug.Coordinates;
import no.donkeylube.donkeyslug.Creature;

public class ChaseAndAttackBehavior implements Behavior {
    private Creature creature;
    private Coordinates lastSeenInterestingLocation;
    
    @Override
    public void execute() {
	Attackable target = null;
	List<Attackable> attackablesInFieldOfVision = creature.liveAttackablesInFieldOfVision();
	if (attackablesInFieldOfVision.size() > 0) {
	    target = attackablesInFieldOfVision.get(0);
	    creature.moveTowards(target.getCoordinates());
	    lastSeenInterestingLocation = target.getCoordinates();
	}
	else if (lastSeenInterestingLocation != null) {
	    creature.moveTowards(lastSeenInterestingLocation);
	}
    }

    @Override
    public void setCreature(Creature creature) {
	this.creature = creature;
    }

}
