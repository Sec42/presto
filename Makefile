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
	@VERS=`awk '/define/{print $$3}' /usr/include/osreldate.h` && \
	if [ -f $$VERS.diff ] ; then \
	wd=`pwd` && cd /usr/src/lib/libkvm && cp $(KVM) $$wd && \
	cd $$wd && patch < $$VERS.diff ;\
	else \
	echo ;\
	echo Sorry there is no diff for $$VERS, You can try using the ;\
	echo next-bigger or the next smaller patch. One of them should ;\
	echo apply cleanly. ;\
	echo ;\
	exit 1 ;\
	fi

dist: realclean new
	$(RM) *.orig
