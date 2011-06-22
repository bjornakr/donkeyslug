package no.donkeylube.donkeyslug.view;

import java.awt.BorderLayout;

import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;

import no.donkeylube.donkeyslug.CreatureStatistics;

public class MainWindow extends JFrame {
    private static final long serialVersionUID = 1L;
    private JLabel hpLabel;
    private CreatureStatistics playerStats;
    
    public MainWindow(JPanel levelMapPainter, CreatureStatistics playerStats) {
	this.playerStats = playerStats;
	setLayout(new BorderLayout());
	add(levelMapPainter, BorderLayout.CENTER);
	hpLabel = new JLabel("HP: " + playerStats.getHitPoints()); 
	add(hpLabel, BorderLayout.PAGE_START);
	add(new JLabel("Test"), BorderLayout.PAGE_END);
	setDefaultCloseOperation(EXIT_ON_CLOSE);
	pack();
	setLocationRelativeTo(null);
    }
    
    @Override
    public void repaint() {
	super.repaint();
	hpLabel.setText("HP: " + playerStats.getHitPoints());
    }
}
