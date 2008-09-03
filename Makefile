RM=rm -f
ARCH!=uname -m
ARCH=i386
OBJ=kvm.o kvm_${ARCH}.o kvm_proc.o ps.o
KVM=kvm.c kvm_${ARCH}.c kvm_proc.c kvm_private.h

.if exists(/usr/src/lib/libkvm/kvm_minidump_${ARCH}.c)
OBJ+= kvm_minidump_${ARCH}.o
KVM+= kvm_minidump_${ARCH}.c
.endif

presto: $(OBJ)
	$(CC) $(CFLAGS) -o $@ $(OBJ) 

debug:
	$(MAKE) CFLAGS="-Wall -g"

clean:
	$(RM) $(OBJ) presto presto.core *.org

# The stuff below is probably not very interesting

distclean realclean: clean
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
