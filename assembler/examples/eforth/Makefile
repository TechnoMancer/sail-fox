
all: eforth.bin eforth.txt

fox.asm: ../../fox.asm
	cp $< $@

eforth.bin: eforth.asm fox.asm
	customasm eforth.asm

eforth.txt: eforth.asm fox.asm
	customasm -f annotated eforth.asm

eforth.asm: eforth.asm.j2
	j2 -o $@ $<
