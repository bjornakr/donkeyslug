package no.donkeylube.donkeyslug;

import no.donkeylube.donkeyslug.items.Armor;

public interface Attackable {
    public void takeDamage(int damage);
    public String getName();
    public boolean isDead();
    public CreatureStatistics getStatistics();
    public int accumulativeDefensiveValueOfArmor();
    public Coordinates getCoordinates();
    public void equipArmor(Armor armorItem);
}
