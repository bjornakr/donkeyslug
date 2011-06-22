package no.donkeylube.donkeyslug.ai;

import no.donkeylube.donkeyslug.Creature;

public interface Behavior {
    public void execute();
    public void setCreature(Creature creature);
}
