for file in *.asm
do
	tmpx $file -o output/${file%.asm}.prg -l lst/${file%.asm}.lst
done




