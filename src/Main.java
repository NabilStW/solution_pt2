import java.io.FileReader;
import java.io.FileNotFoundException;
import java.io.FileInputStream;
import java.io.InputStream;
import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;

import java.util.ArrayList;
import java.util.Collections;
import java.util.TreeMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 *
 * Project Part 2: Parser
 *
 * @author Marie Van Den Bogaard, Léo Exibard, Gilles Geeraerts
 * updated by Raphaël Berthon and Sarah Winter
 *
 */

public class Main{
    /**
     *
     * The parser
     *
     * @param args  The argument(s) given to the program
     * @throws IOException java.io.IOException if an I/O-Error occurs
     * @throws FileNotFoundException java.io.FileNotFoundException if the specified file does not exist
     *
     */
    public static void main(String[] args) throws FileNotFoundException, IOException, SecurityException, Exception{
        // Display the usage when no arguments are given
        if(args.length == 0){
            System.out.println("Usage:  java -jar Part2.jar [OPTIONS] [FILES]\n"
                               + "\tOPTIONS:\n"
                               + "\t -pat (print-action-table): prints action table on screen\n"
                               + "\t -wat (write-action-table) filename.txt: writes action table to filename.txt\n"
                               + "\tA .txt file containing a grammar\n"
                               + "\tA .sf file containing a Super-Fortran program\n"
                               );
            System.exit(0);
        } else {
            //System.out.println("C'est déjà ça !");
            boolean printActionTable = false;
            boolean writeActionTable = false;
            boolean writeTree = false;
            FileReader grammarSource = new FileReader("more/Fortr-S_Grammar.txt");
            BufferedWriter bwActionTable = null;
            FileWriter fwActionTable = null;
            BufferedWriter bwTree = null;
            FileWriter fwTree = null;
            StringBuilder output = new StringBuilder();
            FileReader codeSource = null;

            for (int i = 0 ; i < args.length; i++) {
                if (args[i].equals("-pat")) {
                    printActionTable = true;
                } else if (args[i].equals("-wat")) {
                    writeActionTable = true;
                    try {
                        fwActionTable = new FileWriter(args[i+1]);
                        bwActionTable = new BufferedWriter(fwActionTable);
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                } else if (args[i].equals("-wt")) {
                    writeTree = true;
                    try {
                        fwTree = new FileWriter(args[i+1]);
                        bwTree = new BufferedWriter(fwTree);
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
            
            System.out.println("On est passé là");

            if ((bwActionTable != null || printActionTable) && writeTree) {
                throw new Exception("You cannot use this program for grammar processing and parsing at the same time.\n");
            }
            if (writeTree) {
                Parser parser = new Parser(codeSource);
                ParseTree parseTree = null;
                try {
                    parseTree = parser.parse();
                } catch (ParseException e) {
                    System.out.println("Error:> " + e.getMessage());
                } catch (Exception e) {
                    System.out.println("Error:> " + e);
                }
                try {
                    bwTree.write(parseTree.toLaTeX());
                } catch (IOException e) {
                    e.printStackTrace();
                } finally {
                    try {
                        if (bwTree != null)
                            bwTree.close();
                        if (fwTree != null)
                            fwTree.close();
                    } catch (IOException ex) {
                        ex.printStackTrace();
                    }
                }
            }
            if (bwActionTable != null || printActionTable) {
                System.out.println("On est passé là aussi");
                final GrammarReader grammarReader = new GrammarReader(grammarSource);
                System.out.println("Ah bon ?");
                Grammar grammar = grammarReader.getGrammar();
                System.out.println("Ah bon ?");
                output.append("********** The Grammar **********");
                output.append(grammar);
                grammar.setFirst();
                output.append("********** First **********\n" + grammar.stringFirst());
                grammar.setFollow();
                output.append("\n********** Follow **********\n" + grammar.stringFollow());
                try {
                    grammar.setActionTable();
                    output.append("\n********** Action table **********");
                    output.append(grammar.stringActionTable());
                } catch (Exception e) {
                    System.out.println("Erreur ici" + e.getMessage());
                }

                

                if (bwActionTable != null) {
                    System.out.println("Ca rentre ?");
                    try {
                        bwActionTable.write(output.toString());
                    } catch (IOException e) {
                        e.printStackTrace();
                    } finally {
                        try {
                            if (bwActionTable != null)
                                bwActionTable.close();
                            if (fwActionTable != null)
                                fwActionTable.close();
                        } catch (IOException ex) {
                            ex.printStackTrace();
                        }
                    }
                }
                //if (printActionTable) {
                if (true){
                    System.out.println(output);
                }
            }
        }
    }
}
