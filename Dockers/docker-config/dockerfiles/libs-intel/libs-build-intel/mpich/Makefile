# Simple makefile for building and packaging project

library       = mpich
url=http://flow.nti.tul.cz/libraries/mpich-${version}.tar.gz
base_name=mpich-$(version)

conf_opt_Debug= \
	--with-device=ch4:ofi 

conf_opt_Release= \
	--enable-fast=O3,ndebug \
	--disable-error-checking \
	--without-timing \
	--without-mpit-pvars \
	--with-device=ch4:ofi 

configure_options=$(conf_opt_$(build_type))
	
include ../common_configure.mk

