package no.donkeylube.donkeyslug;

import java.util.List;

public class ChaseAndAttackBehavior implements Behavior {
    private Creature creature;
    
    @Override
    public void execute() {
	Attackable target = null;
	List<Attackable> attackablesInFieldOfVision = creature.attackablesInFieldOfVision();  
	if (attackablesInFieldOfVision.size() > 0) {
	    target = attackablesInFieldOfVision.get(0);
	    creature.moveTowards(target.getCoordinates());
	}
    }

    @Override
    public void setCreature(Creature creature) {
	this.creature = creature;
    }

}
