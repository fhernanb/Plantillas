# Makefile for building and installing project BDDCML and used Blobex library.
# - we partly use raw makefiles of BDDCML and BLOPEX to build individual object 
# - we add targets for single static and dynamic library linking with the BLOPEX files
# - install necessary header files and produced library to standard include, lib structure

library=permon
url=http://flow.nti.tul.cz/libraries/$(library)-$(version).tar.gz
base_name=$(library)-$(version)
clear=true


build_root=/libs-build-intel
build_dir     = $(build_root)/$(library)/build_$(build_type)
# package_dir   = $(build_root)/packages
# package_name  = $(library)_$(build_type)
# package=$(package_dir)/$(package_name).tar.gz
n_jobs	      = 5





install_file=$(notdir $(url))

prefix=/usr/local/$(library)_$(version)

# compilers and optimization flags taken from PETSC build


###################


.PHONY : clean_build
clean_build:
	@if [ "$(clear)" = "true" ]; then\
		rm -rf $(build_dir);\
	fi


$(install_file):
	wget $(url)
	

install_dir=/usr/local/$(library)_$(version)
.PHONY: build_dir
build_dir:  clean_build $(install_file)
	if [ ! -d $(build_dir) ]; then \
		cmake -E tar x $(install_file); \
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

.PHONY : build
build: build_dir
	cd $(build_dir) && \
	export PERMON_DIR=$(build_dir) && \
	export PETSC_DIR=$(petsc_dir) && \
	make -j$(n_jobs)

# shared library setting

# static library setting
#SHARED_FLAGS=
#bddcml_lib=$(build_dir)/lib/libbddcml.a

# shared linking


	
.PHONY : install


# BDDCML_LINK_SEQUENCE = \
# 	-L$(install_dir)/lib -lbddcml \
# 	-L$(petsc_dir)/lib -ldmumps -lmumps_common -lpord \
# 	-L$(petsc_dir)/lib -lparmetis \
# 	-L$(petsc_dir)/lib -lmetis \
# 	-L$(petsc_dir)/lib -lscalapack \
# 	-L/usr/lib -lblas -llapack \
# 	-lpthread


install: build
	#includes
	mkdir -p $(install_dir)
	cp -R $(build_dir)/include $(install_dir)
	#lib
	cp -R $(build_dir)/lib $(install_dir)

# $(package): install
# 	mkdir -p $(package_dir)
# 	ls -l $(prefix)
# 	dereference symlinked prefix directory
# 	cd /usr/local && tar cfvz  $(package) --dereference $(library)_$(version)
# 	ls /usr/local/$(library)_$(version)

.PHONY : package
package: $(package)




	
	

