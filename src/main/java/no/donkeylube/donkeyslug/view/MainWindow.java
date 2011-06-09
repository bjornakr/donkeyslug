package no.donkeylube.donkeyslug.view;

import java.awt.BorderLayout;
import java.awt.Font;
import java.awt.event.KeyListener;

import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;

public class MainWindow extends JFrame {
	private static final long serialVersionUID = 1L;
	JTextArea mapScreen = new JTextArea(20, 40);
	
	public MainWindow(KeyListener l) {
		mapScreen.setFont(new Font(Font.MONOSPACED, Font.PLAIN, 12));
		mapScreen.setEditable(false);
		mapScreen.setText("Vi vandrer med freidig mot!");
		mapScreen.addKeyListener(l);
		JScrollPane scrollPane = new JScrollPane(mapScreen);
		setLayout(new BorderLayout());
		add(scrollPane, BorderLayout.CENTER);
		add(new JLabel("Test"), BorderLayout.PAGE_START);
		add(new JLabel("Test"), BorderLayout.PAGE_END);
		setLocationRelativeTo(null);
		setDefaultCloseOperation(EXIT_ON_CLOSE);
		pack();
	}
	
	public void setMap(String map) {
		mapScreen.setText(map);
	}
}
