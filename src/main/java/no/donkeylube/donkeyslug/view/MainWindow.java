package no.donkeylube.donkeyslug.view;

import java.awt.BorderLayout;

import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;

public class MainWindow extends JFrame {
	private static final long serialVersionUID = 1L;
	
	public MainWindow(JPanel levelMapPainter) {
		setLayout(new BorderLayout());
		add(levelMapPainter, BorderLayout.CENTER);
		add(new JLabel("Test"), BorderLayout.PAGE_START);
		add(new JLabel("Test"), BorderLayout.PAGE_END);
		setDefaultCloseOperation(EXIT_ON_CLOSE);
		pack();
		setLocationRelativeTo(null);
	}	
}
