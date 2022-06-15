# This generic makefile is included by makfiels of the specific libraries.
# Variables to set before include:
# 'library' - library name 
# 'url' - URL for download sources
# 'basename' - name of directory in the package

# 'version' - libary version
# 'build_type' - debug or release
# 'package-name' - optional, default is $(library)


package_name  ?= $(library)_$(build_type)
build_root=/libs-build-gnu
build_dir     = $(build_root)/$(library)/build_$(build_type)
# package_dir   = $(build_root)/packages
# package=$(package_dir)/$(package_name).tar.gz

cmake         = cmake
n_jobs	      = 5

# Armadillo fails to install to CPack temporary prefix. 
#tmp_install_prefix = $(build_dir)/_CPack_Packages/TGZ/$(library)_$(version)/
#prefix         = $(tmp_install_prefix)/$(package_name)

install_file=$(notdir $(url))
sources_dir=$(CURDIR)/$(base_name)
cpack_config=$(build_dir)/CPackConfig.cmake

.PHONY : $(build_dir)
$(build_dir):
	@if [ "$(clear)" = "true" ]; then\
			rm -rf $(build_dir);\
	fi
	echo "arma: $(CURDIR) $(build_dir)" 
	mkdir -p $(build_dir)


$(CURDIR)/$(install_file):
	echo "${PWD} $(CURDIR)"
	wget $(url)

$(sources_dir): $(CURDIR)/$(install_file)
	cmake -E tar x $(install_file)

.PHONY : configure
configure: $(build_dir) $(sources_dir)
	cd $(build_dir) && $(cmake) \
				-DCMAKE_BUILD_TYPE=$(build_type) \
				-DCMAKE_INSTALL_PREFIX=/usr/local/$(library)_$(version) \
				-DCMAKE_CXX_FLAGS=$(CXX_FLAGS) \
				$(sources_dir)

.PHONY : build
build: configure
	cd $(build_dir) && make -j$(n_jobs)

.PHONY : install
install: build
	cd $(build_dir) && sudo make install

# $(cpack_config): ../common_cmake.mk
# 	echo "set(CPACK_PACKAGE_NAME \"$(library)\")" > $(cpack_config)
# 	echo "set(CPACK_PACKAGE_VERSION \"$(version)\")"  >> $(cpack_config)	
# 	echo "set(CPACK_GENERATOR \"DEB\")"  >> $(cpack_config)
# 	echo "set(CPACK_GENERATOR \"TGZ\")"  >> $(cpack_config)	
# 	echo "set(CPACK_INSTALL_PREFIX \"$(tmp_install_prefix)\")"  >> $(cpack_config)	
# 	echo "set(CPACK_PACKAGE_FILE_NAME \"$(library)_$(build_type)\")" >> $(cpack_config)	
# 	echo "SET(CPACK_INSTALLED_DIRECTORIES \"$(tmp_install_prefix)\")"  >> $(cpack_config)	
# 	required variables
# 	echo "set(CPACK_INSTALL_CMAKE_PROJECTS \"$(build_dir);$(library);all;/\")" >> $(cpack_config)	
# 	echo "set(CPACK_PACKAGE_DESCRIPTION \"Auxiliary $(library) package.\")" >> $(cpack_config) 
# 	echo "set(CPACK_CMAKE_GENERATOR \"Unix Makefiles\")" >> $(cpack_config) 	
# 	echo "set(CPACK_DEBIAN_PACKAGE_MAINTAINER \"Jan Brezina\")" >> $(cpack_config) 
# 
# 
# $(package): build $(cpack_config)
# 	cd $(build_dir) && cpack --debug -C $(build_type) 
# 	mkdir -p $(package_dir)
# 	mv $(build_dir)/$(package_name).tar.gz  $(package)   
# 
# 	
# 	
# .PHONY : package
# package: $(package)


.PHONY : clean
clean:
	rm -rf $(build_dir)
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
