# Simple makefile for building and packaging project Petsc
# PETSC build is specific do not use common makefile.

library       = petsc
url=http://flow.nti.tul.cz/libraries/petsc-$(version).tar.gz
base_name=petsc-$(version)
package_name  = $(library)_$(build_type)
clear=false

build_root=/libs-build-gnu
build_dir     = $(build_root)/$(library)/build_$(build_type)
package_dir   = $(build_root)/packages
n_jobs	      = 5


install_file=$(notdir $(url))
sources_dir=$(CURDIR)/$(base_name)
cpack_config=$(build_dir)/CPackConfig.cmake
package=$(package_dir)/$(package_name).tar.gz
cfg_opt_Debug= \
        --download-metis=yes --download-parmetis=yes \
        --download-blacs=yes --download-scalapack=yes \
        --download-mumps=yes --download-hypre=https://github.com/hypre-space/hypre/archive/v2.21.0.tar.gz \
        --with-debugging=1 --with-shared-libraries=1 \
        --with-make-np $(n_jobs) \
        --CFLAGS="-O" \
        --CXXFLAGS="-O -Wall -Wno-unused-local-typedefs -std=c++11"

cfg_opt_Release= \
        --download-metis=yes --download-parmetis=yes \
        --download-blacs=yes --download-scalapack=yes \
        --download-mumps=yes --download-hypre=https://github.com/hypre-space/hypre/archive/v2.21.0.tar.gz \
        --with-debugging=0 --with-shared-libraries=1 \
        --with-make-np $(n_jobs) \
        --CFLAGS="-O3 -DNDEBUG" \
        --CXXFLAGS="-O3 -DNDEBUG -Wall -Wno-unused-local-typedefs -std=c++11"

# Somehow we run under root's SUID even if as the 'flow' user. 
# So the simplest way is to install directly into /usr/local and then build packages from there.
petsc_arch=flow123d_$(build_type)
prefix=/usr/local/$(library)_$(version)
configure_options= \
	PETSC_ARCH=$(petsc_arch) \
	--prefix=$(prefix) \
	--with-mpi-dir=/usr/local/$(mpich_lib) \
	$(cfg_opt_$(build_type))

.PHONY : clean_build
clean_build:
	@if [ "$(clear)" = "true" ]; then\
		rm -rf $(build_dir);\
	fi

$(install_file):
	echo "${PWD} $(CURDIR)"
	wget $(url)

configure_bin=$(build_dir)/configure	
$(configure_bin):  clean_build $(install_file)
	if [ ! -d $(build_dir) ]; then \
		cmake -E tar x $(install_file); \
		mv $(base_name) build_$(build_type); \
	fi
	# link prefix into mounted volume in order to preserve it 
	
	#However it seems that PETSC links all used libraries into single libpetsc.so, since all used libraries are static libraries.
	#mkdir -p $(build_dir)/installation_$(build_type)
	
	# remove previous link
	#if [ -d $(prefix) ]; then rm -rf $(prefix); fi
	
	#sudo ln -s $(build_dir)/installation_$(build_type) $(prefix)
	#ls -l $(prefix)

# 
# mpich_lib=/usr/local/mpich_$(build_type)/lib/libmpi.la
# $(mpich_lib):
# 	cd /usr/local && sudo tar xzf $(package_dir)/mpich_$(build_type).tar.gz
# 	ls /usr/local
# 

lib_config=$(build_dir)/$(petsc_arch)/include/petscconf.h
$(lib_config): clean_build $(configure_bin)
	cd $(build_dir) && ./configure $(configure_options)

.PHONY: build
build: $(lib_config)
	cd $(build_dir) && make -j$(n_jobs)

.PHONY : install
install: build
	#mkdir -p $(tmp_install_prefix)
	cd $(build_dir) && make PETSC_DIR=$(build_dir) PETSC_ARCH=$(petsc_arch) install

$(package): install
	mkdir -p $(package_dir)
	ls -l $(prefix)
	dereference symlinked prefix directory
	cd /usr/local && tar cfvz  $(package) --dereference $(library)_$(version)

.PHONY : package
package: $(package)


