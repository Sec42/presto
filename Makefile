RM=rm -f
OBJ=kvm.o kvm_i386.o kvm_proc.o ps.o
KVM=kvm.c kvm_i386.c kvm_proc.c kvm_private.h

presto: $(OBJ)
	$(CC) $(CFLAGS) -o $@ $(OBJ) 

debug:
	$(MAKE) CFLAGS="-Wall -g"

clean:
	$(RM) $(OBJ) presto presto.core

# The stuff below is probably not very interesting

realclean: clean
	$(RM) $(KVM) *.orig tags
	
new: $(KVM)

$(KVM):
	wd=`pwd`;cd /usr/src/lib/libkvm && cp $(KVM) $$wd
	patch < kvm.diff

dist: realclean new
	$(RM) *.orig
