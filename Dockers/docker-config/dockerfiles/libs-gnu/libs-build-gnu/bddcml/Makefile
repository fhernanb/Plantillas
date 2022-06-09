# Makefile for building and installing project BDDCML and used Blobex library.
# - we partly use raw makefiles of BDDCML and BLOPEX to build individual object 
# - we add targets for single static and dynamic library linking with the BLOPEX files
# - install necessary header files and produced library to standard include, lib structure

library=bddcml
bddcml_url=http://flow.nti.tul.cz/libraries/bddcml-$(version).tar.gz
base_name=bddcml-$(version)
clear=false


build_root=/libs-build-gnu
build_dir     = $(build_root)/$(library)/build_$(build_type)
# package_dir   = $(build_root)/packages
# package_name  = $(library)_$(build_type)
# package=$(package_dir)/$(package_name).tar.gz
n_jobs	      = 5





bddcml_install_file=$(notdir $(bddcml_url))

prefix=/usr/local/$(library)_$(version)

FC_FLAGS_Debug=-O3 -DNDEBUG -g $(SHARED_FLAGS)
FC_FLAGS_Release=-O3 -DNDEBUG $(SHARED_FLAGS)
CC_FLAGS_Debug=$(FC_FLAGS_Debug) 
CC_FLAGS_Release=$(FC_FLAGS_Release)


# ********** BLOPEX build
blopex_build_dir=$(build_root)/bddcml/blopex_$(build_type)
blopex_make_inc=$(blopex_build_dir)/makefile.inc
blopex_url=http://flow.nti.tul.cz/libraries/blopex-read-only.tar.gz
blopex_install_file=$(notdir $(blopex_url))

$(blopex_install_file):
	wget $(blopex_url)

.PHONY : blopex_dir
blopex_dir: $(blopex_install_file)
	if [ ! -d $(blopex_build_dir) ]; then \
		cmake -E tar x $(blopex_install_file); \
		mv blopex-read-only blopex_$(build_type); \
	fi

$(blopex_make_inc): blopex_dir
	echo CC=/usr/bin/gcc >$(blopex_make_inc)
	echo CFLAGS=$(CC_FLAGS_$(build_type)) >>$(blopex_make_inc)
	echo include $(blopex_build_dir)/../blopex_make_inc.common >>$(blopex_make_inc)
	
	
.PHONY: blopex_build
blopex_build: $(blopex_make_inc)
	cd $(blopex_build_dir) && make -j$(n_jobs) all

###################


.PHONY : clean_build
clean_build:
	@if [ "$(clear)" = "true" ]; then\
		rm -rf $(build_dir);\
	fi


$(bddcml_install_file):
	wget $(bddcml_url)
	

install_dir=/usr/local/bddcml_$(version)
.PHONY: build_dir
build_dir:  clean_build $(bddcml_install_file)
	if [ ! -d $(build_dir) ]; then \
		cmake -E tar x $(bddcml_install_file); \
		mv $(base_name) build_$(build_type); \
	fi
	# link prefix into mounted volume in order to preserve it 
	
	#However it seems that PETSC links all used libraries into single libpetsc.so, since all used libraries are static libraries.
# 	mkdir -p $(install_dir)
# 	
# 	remove previous link
# 	if [ -d $(prefix) ]; then rm -rf $(prefix); fi
# 	
# 	sudo ln -s $(install_dir) $(prefix)
# 	ls -l $(prefix)

mpi_dir=/usr/local/$(mpich_lib)
# full_mpich_lib=$(mpi_dir)/lib/libmpi.so
# $(full_mpich_lib):
# 	cd /usr/local && sudo tar xzf $(package_dir)/mpich_$(build_type).tar.gz
# 	ls /usr/local
# 
petsc_dir=/usr/local/$(petsc_lib)
# full_petsc_lib=$(petsc_dir)/usr/local/$(petsc_lib)/lib/libpetsc.so
# $(full_petsc_lib):
# 	cd /usr/local && sudo tar xzf $(package_dir)/petsc_$(build_type).tar.gz
# 	ls /usr/local
	
make_inc=$(build_dir)/make.inc
$(make_inc): clean_build build_dir blopex_build 
	echo mpi_dir=$(mpi_dir) >$(make_inc)
	echo petsc_dir=$(petsc_dir) >>$(make_inc)
	echo blopex_dir=$(blopex_build_dir) >>$(make_inc)
	echo build_dir=$(build_dir) >>$(make_inc)
	echo fc_flags=$(FC_FLAGS_$(build_type)) >>$(make_inc)
	echo cc_flags=$(CC_FLAGS_$(build_type)) >>$(make_inc)
	cat $(build_dir)/../bddcml_make_inc.common >>$(make_inc)


.PHONY : build
build: $(make_inc)
	cd $(build_dir) && make -j$(n_jobs) all

# shared library setting
SHARED_FLAGS= -fPIC
bddcml_lib=$(build_dir)/lib/libbddcml.so

# static library setting
#SHARED_FLAGS=
#bddcml_lib=$(build_dir)/lib/libbddcml.a

# shared linking

OBJS=\
	$(build_dir)/src/*.o \
	$(blopex_build_dir)/blopex_serial_double/multivector/multi_vector.o \
	$(blopex_build_dir)/blopex_serial_double/pcg_multi/pcg_multi.o \
	$(blopex_build_dir)/blopex_serial_double/matmultivec/matmultivec.o \
	$(blopex_build_dir)/blopex_abstract/lib/*.o 

bddcml_lib_shared=$(build_dir)/lib/libbddcml.so
bddcml_cc=$(mpi_dir)/bin/mpicc $(cc_flags)

$(bddcml_lib_shared): build
	cp $(OBJS) $(build_dir)/lib
	$(bddcml_cc) $(CC_FLAGS) -shared $(build_dir)/lib/*.o -o $(bddcml_lib_shared)

# static lib - archive
bddcml_lib_static=$(build_dir)/lib/libbddcml.a
$(bddcml_lib_static): build	
	cp $(OBJS) $(build_dir)/lib
	ar crsv $(bddcml_lib_static) $(build_dir)/lib/*.o 
	# c - create archive
	# r - insert with replacement
	# s - create index (equivalent to runlib call)
	# v - verbose
	
.PHONY : install


BDDCML_LINK_SEQUENCE = \
	-L$(install_dir)/lib -lbddcml \
	-L$(petsc_dir)/lib -ldmumps -lmumps_common -lpord \
	-L$(petsc_dir)/lib -lparmetis \
	-L$(petsc_dir)/lib -lmetis \
	-L$(petsc_dir)/lib -lscalapack \
	-L/usr/lib -lblas -llapack \
	-lpthread


install: $(bddcml_lib)
	#includes
	mkdir -p $(install_dir)/include
	cp $(build_dir)/src/bddcml_interface_c.h $(install_dir)/include
	#lib
	mkdir -p $(install_dir)/lib
	cp $(bddcml_lib) $(install_dir)/lib
	# make.inc (BDDCML_LINK_SEQENCE)
	echo "BDDCML_LINK_SEQUENCE=$(BDDCML_LINK_SEQUENCE)" > $(install_dir)/make.inc 

# $(package): install
# 	mkdir -p $(package_dir)
# 	ls -l $(prefix)
# 	dereference symlinked prefix directory
# 	cd /usr/local && tar cfvz  $(package) --dereference $(library)_$(version)
# 	ls /usr/local/$(library)_$(version)

.PHONY : package
package: $(package)




	
	

