package no.donkeylube.donkeyslug;

public interface Fighter {
    public void attack(Attackable attackable);
    public void equipWeapon(Weapon weapon);
    public CreatureStatistics getStatistics();
    public Weapon getWeapon();
    public void addAttackListener(AttackListener attackListener);
    public void notifyAttackListeners(AttackReport attackReport);
}
