import javax.swing.*; 
import java.awt.*; 
import java.awt.event.*; 

import java.text.BreakIterator;

import java.util.Locale;
import java.util.ResourceBundle;
import java.util.MissingResourceException;
 
import CLIPSJNI.*;

class StarWars implements ActionListener
{
    JPanel choicesPanel;
    JLabel displayLabel;
    JButton prevButton;
    JButton nextButton;
    ButtonGroup choicesButtons;

    Environment clips;
    ResourceBundle resources;
    boolean isExecuting = false;
    Thread executionThread;

    StarWars()
    {
        try {
            resources = ResourceBundle.getBundle("resources.Resources", Locale.getDefault());
        }
        catch (MissingResourceException mre) {
            mre.printStackTrace();
            return;
        }

        /* New JFrame container */
        JFrame frame = new JFrame(resources.getString("StarWars"));
        frame.getContentPane().setLayout(new GridLayout(3,1));
        frame.setSize(420,250);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        /* Display panel */
        JPanel displayPanel = new JPanel();
        displayLabel = new JLabel();
        displayPanel.add(displayLabel);

        /* Choices panel */
        choicesPanel = new JPanel();
        choicesButtons = new ButtonGroup();

        /* Buttons */
        JPanel buttonPanel = new JPanel();

        prevButton = new JButton(resources.getString("Prev"));
        prevButton.setActionCommand("Prev");
        buttonPanel.add(prevButton);
        prevButton.addActionListener(this);

        nextButton = new JButton(resources.getString("Next"));
        nextButton.setActionCommand("Next");
        buttonPanel.add(nextButton);
        nextButton.addActionListener(this);

        /* Add the panels to the content pane */
        frame.getContentPane().add(displayPanel);
        frame.getContentPane().add(choicesPanel);
        frame.getContentPane().add(buttonPanel);

        /* Load the program */
        clips = new Environment();      //CLIPSJNI
        clips.load("starwars.clp");
        clips.reset();
        runStarWars();

        /* Display the frame. */
        frame.setVisible(true);
    }

    /**
    /* nextUIState
    */
    private void nextUIState() throws Exception
    {
        /* Get the state-list */
        String evalStr = "(find-all-facts ((?f state-list)) TRUE)";
        String currentID = clips.eval(evalStr).get(0).getFactSlot("current").toString();

        /* Get the current UI state */
        evalStr = "(find-all-facts ((?f UI-state)) " + "(eq ?f:id " + currentID + "))";
        PrimitiveValue actionList = clips.eval(evalStr).get(0);

        /* Determine the Next/Prev button states */
        if (actionList.getFactSlot("state").toString().equals("final"))
        {
            nextButton.setActionCommand("Restart");
            nextButton.setText(resources.getString("Restart"));
            prevButton.setVisible(true);
        }
        else if (actionList.getFactSlot("state").toString().equals("initial"))
        {
            nextButton.setActionCommand("Next");
            nextButton.setText(resources.getString("Next"));
            prevButton.setVisible(false);
        }
        else
        {
            nextButton.setActionCommand("Next");
            nextButton.setText(resources.getString("Next"));
            prevButton.setVisible(true);
        }

        /* Set up choices */
        choicesPanel.removeAll();
        choicesButtons = new ButtonGroup();
        PrimitiveValue validAnswers = actionList.getFactSlot("valid-answers");
        String selected = actionList.getFactSlot("response").toString();

        for (int i = 0; i < validAnswers.size(); i++)
        {
            PrimitiveValue chosen = validAnswers.get(i);
            JRadioButton rButton;

            if (chosen.toString().equals(selected)) { rButton = new JRadioButton(resources.getString(chosen.toString()),true);  }
            else                                    { rButton = new JRadioButton(resources.getString(chosen.toString()),false); }

            rButton.setActionCommand(chosen.toString());
            choicesPanel.add(rButton);
            choicesButtons.add(rButton);
        }
        choicesPanel.repaint();

        /* Set the label to the display text */
        String theText = resources.getString(actionList.getFactSlot("display").symbolValue());
        wrapLabelText(displayLabel,theText);

        executionThread = null;
        isExecuting = false;
    }

    /**
    /* actionPerformed
    */
    public void actionPerformed( ActionEvent ae)
    {
        try                 { onActionPerformed(ae);  }
        catch (Exception e) { e.printStackTrace();    }
    }

    /**
    /* runStarWars
    */
    public void runStarWars()
    {
        Runnable runThread = new Runnable()
        {
            public void run()
            {
                clips.run();
                SwingUtilities.invokeLater( new Runnable()
                {
                    public void run()
                    {
                        try                     { nextUIState();        }
                        catch (Exception e)     { e.printStackTrace();  }
                    }
                });
            }
        };
        isExecuting = true;
        executionThread = new Thread(runThread);
        executionThread.start();
    }

    /**
    /* onActionPerformed
    */
    public void onActionPerformed( ActionEvent ae ) throws Exception
    {
        if (isExecuting) return;

        /* Get the state-list */
        String evalStr = "(find-all-facts ((?f state-list)) TRUE)";
        String currentID = clips.eval(evalStr).get(0).getFactSlot("current").toString();

        /* Handle the Next button */

        if (ae.getActionCommand().equals("Next"))
        {
            if (choicesButtons.getButtonCount() == 0)   { clips.assertString("(next " + currentID + ")"); }
            else                                        { clips.assertString("(next " + currentID + " " + choicesButtons.getSelection().getActionCommand() + ")"); }
            runStarWars();
        }
        else if (ae.getActionCommand().equals("Restart"))
        {
            clips.reset();
            runStarWars();
        }
        else if (ae.getActionCommand().equals("Prev"))
        {
            clips.assertString("(prev " + currentID + ")");
            runStarWars();
        }
    }

    /**
     * Wrap GUI label text
     */
    private void wrapLabelText( JLabel label, String text)
    {
        FontMetrics fm = label.getFontMetrics(label.getFont());
        Container container = label.getParent();
        int containerWidth = container.getWidth();
        int textWidth = SwingUtilities.computeStringWidth(fm,text);
        int desiredWidth;

        if (textWidth <= containerWidth)
        {
            desiredWidth = containerWidth;
        }
        else
        {
            int lines = (int)((textWidth + containerWidth) / containerWidth);
            desiredWidth = (int)(textWidth / lines);
        }

        BreakIterator boundary = BreakIterator.getWordInstance();
        boundary.setText(text);

        StringBuffer trial = new StringBuffer();
        StringBuffer perform = new StringBuffer("<html><br><center>");

        int start = boundary.first();
        for (int end = boundary.next(); end != BreakIterator.DONE; start = end, end = boundary.next())
        {
            String word = text.substring(start,end);
            trial.append(word);
            int trialWidth = SwingUtilities.computeStringWidth(fm,trial.toString());
            if (trialWidth > containerWidth)
            {
                trial = new StringBuffer(word);
                perform.append("<br>");
                perform.append(word);
            }
            else if (trialWidth > desiredWidth)
            {
                trial = new StringBuffer("");
                perform.append(word);
                perform.append("<br>");
            }
            else
            {
                perform.append(word);
            }
        }
        perform.append("</html>");
        label.setText(perform.toString());
    }
}