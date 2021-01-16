all:
	jflex src/LexicalAnalyzer.flex
	jflex src/GrammarReader.flex
	javac -d bin -cp src/ src/*.java
	mkdir -p dist/
	jar cfe dist/WriteTree.jar WriteTree -C bin .
	jar cfe dist/ProcessGrammar.jar ProcessGrammar -C bin .
	jar cfe dist/Part3.jar Main -C bin .
	javadoc -private src/Main.java -d doc/javadoc
	# javadoc -private -html5 src/*.java -d doc/javadoc

testing:
	java -jar dist/WriteTree.jar -wat test/06b-voidIfThen.fs



clean:
	rm -f src/*.class
	rm -f src/*.java~
	rm -f bin/*.class
	rm -f dist/*.jar
