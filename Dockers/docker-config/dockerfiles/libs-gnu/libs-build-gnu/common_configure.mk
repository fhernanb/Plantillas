# This generic makefile is included by makfiels of the specific libraries.
# Variables to set before include:
# 'library' - library name 
# 'url' - URL for download sources
# 'basename' - name of directory in the package

# 'version' - libary version
# 'build_type' - debug or release
# 'package-name' - optional, default is $(library)


build_root=/libs-build-gnu
package_name  ?= $(library)_$(build_type)
build_dir     = $(build_root)/$(library)/build_$(build_type)

# package_dir   = $(build_root)/packages
# package=$(package_dir)/$(package_name).tar.gz

clear         = false
n_jobs	      = 5

install_prefix= /usr/local/$(library)_$(version)

#tmp_install_prefix=$(build_dir)/INSTALLATION_ROOT/
#TODO: use installation to /usr/local with mpich subdir symlinked into build dir

install_file=$(notdir $(url))


.PHONY : clean_build
clean_build:
	@if [ "$(clear)" = "true" ]; then\
			rm -rf $(build_dir);\
	fi


$(CURDIR)/$(install_file):
	echo "${PWD} $(CURDIR)"
	wget $(url)

$(build_dir)/configure: clean_build $(CURDIR)/$(install_file) 
	if [ ! -d $(build_dir) ]; then \
		cmake -E tar x $(install_file); \
		mv $(base_name) build_$(build_type); \
	fi

lib_makefile=$(build_dir)/Makefile
$(lib_makefile): $(build_dir)/configure
	cd $(build_dir) && ./configure --prefix=$(install_prefix) $(configure_options)


.PHONY : build
build: $(lib_makefile)
	cd $(build_dir) && make -j$(n_jobs)

.PHONY : install
install: build
	#mkdir -p $(tmp_install_prefix)
	cd $(build_dir) && make  install

# 
# $(package): install	
# 	mkdir -p $(package_dir)
# 	cd $(tmp_install_prefix)/usr/local && tar cfvz  $(package) $(library)_$(version)
# 	
# 	
# 
# .PHONY : package
# package: $(package)


.PHONY : clean
clean:
	rm -rf $(build_dir)
	rm -rf $(prefix)
	rm -rf $(package_dir)/$(package_name)*

# .PHONE : help
# help:
# 	@echo "Valid targets for this Makefile: "
# 	@echo "   configure - run cmake in BUILD_TREE dir"
# 	@echo "   build     - downloads external lib and runs compilation"
# 	@echo "   package   - packs library and copies packages to package_dir"
# 	@echo "   clean     - deletes build_dir dir and all build_*"
# 	@echo "   help      - prints this message"
# 	@echo ""
# 	@echo "To change buildy type (default Debug) set variable"
# 	@echo "   build_type - e.g. make build_type=Release package (default is $(build_type))"
# 	@echo "To change package copy location (default is $(package_dir)) set variable"
# 	@echo "   package_dir - e.g. make package_dir=/var/www/html package"
