OBJ=kvm.o kvm_i386.o kvm_proc.o ps.o

presto: $(OBJ)
	$(CC) $(CFLAGS) -o $@ $(OBJ) 

debug:
	$(MAKE) CFLAGS="-Wall -g"

clean:
	-rm $(OBJ) presto presto.core
