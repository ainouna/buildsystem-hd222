#
# hotplug_e2
#
$(D)/hotplug_e2: $(D)/bootstrap
	$(START_BUILD)
	$(REMOVE)/hotplug-e2-helper
	@set -e; if [ -d $(ARCHIVE)/hotplug-e2-helper.git ]; \
		then cd $(ARCHIVE)/hotplug-e2-helper.git; git pull; \
		else cd $(ARCHIVE); git clone https://github.com/OpenPLi/hotplug-e2-helper.git hotplug-e2-helper.git; \
		fi
	cp -ra $(ARCHIVE)/hotplug-e2-helper.git $(BUILD_TMP)/hotplug-e2-helper
	@set -e; cd $(BUILD_TMP)/hotplug-e2-helper; \
		$(PATCH)/hotplug-e2-helper.patch; \
		$(CONFIGURE) \
			--prefix=/usr \
		; \
		$(MAKE) all; \
		$(MAKE) install prefix=/usr DESTDIR=$(TARGETPREFIX)
	$(REMOVE)/hotplug-e2-helper
	$(TOUCH)

#
# tuxtxtlib
#
$(D)/tuxtxtlib: $(D)/bootstrap
	$(START_BUILD)
	$(REMOVE)/tuxtxtlib
	@set -e; if [ -d $(ARCHIVE)/tuxtxt.git ]; \
		then cd $(ARCHIVE)/tuxtxt.git; git pull; \
		else cd $(ARCHIVE); git clone https://github.com/OpenPLi/tuxtxt.git tuxtxt.git; \
		fi
	cp -ra $(ARCHIVE)/tuxtxt.git/libtuxtxt $(BUILD_TMP)/tuxtxtlib
	@set -e; cd $(BUILD_TMP)/tuxtxtlib; \
		$(PATCH)/tuxtxtlib-1.0-fix-dbox-headers.patch; \
		aclocal; \
		autoheader; \
		autoconf; \
		libtoolize --force; \
		automake --foreign --add-missing; \
		$(BUILDENV) \
		./configure \
			--build=$(BUILD) \
			--host=$(TARGET) \
			--prefix=/usr \
			--with-boxtype=generic \
			--with-configdir=/etc \
			--with-datadir=/usr/share/tuxtxt \
			--with-fontdir=/usr/share/fonts \
		; \
		$(MAKE) all; \
		$(MAKE) install prefix=/usr DESTDIR=$(TARGETPREFIX)
	$(REWRITE_PKGCONF) $(PKG_CONFIG_PATH)/tuxbox-tuxtxt.pc
	$(REWRITE_LIBTOOL)/libtuxtxt.la
	$(REMOVE)/tuxtxtlib
	$(TOUCH)

#
# tuxtxt32bpp
#
$(D)/tuxtxt32bpp: $(D)/bootstrap $(D)/tuxtxtlib
	$(START_BUILD)
	$(REMOVE)/tuxtxt
	cp -ra $(ARCHIVE)/tuxtxt.git/tuxtxt $(BUILD_TMP)/tuxtxt; \
	@set -e; cd $(BUILD_TMP)/tuxtxt; \
		$(PATCH)/tuxtxt32bpp-1.0-fix-dbox-headers.patch; \
		aclocal; \
		autoheader; \
		autoconf; \
		libtoolize --force; \
		automake --foreign --add-missing; \
		$(BUILDENV) \
		./configure \
			--build=$(BUILD) \
			--host=$(TARGET) \
			--prefix=/usr \
			--with-fbdev=/dev/fb0 \
			--with-boxtype=generic \
			--with-configdir=/etc \
			--with-datadir=/usr/share/tuxtxt \
			--with-fontdir=/usr/share/fonts \
		; \
		$(MAKE) all; \
		$(MAKE) install prefix=/usr DESTDIR=$(TARGETPREFIX)
	$(REWRITE_LIBTOOL)/libtuxtxt32bpp.la
	$(REMOVE)/tuxtxt
	$(TOUCH)

#
# Plugins
#
$(D)/enigma2-plugins: $(D)/enigma2_networkbrowser $(D)/enigma2_openwebif

#
# enigma2-openwebif
#
$(D)/enigma2_openwebif: $(D)/bootstrap $(D)/python $(D)/python_cheetah
	$(START_BUILD)
	$(REMOVE)/e2openplugin-OpenWebif
	@set -e; if [ -d $(ARCHIVE)/e2openplugin-OpenWebif.git ]; \
		then cd $(ARCHIVE)/e2openplugin-OpenWebif.git; git pull; \
		else cd $(ARCHIVE); git clone https://github.com/HDMU/e2openplugin-OpenWebif.git e2openplugin-OpenWebif.git; \
		fi
	cp -ra $(ARCHIVE)/e2openplugin-OpenWebif.git $(BUILD_TMP)/e2openplugin-OpenWebif
	@set -e; cd $(BUILD_TMP)/e2openplugin-OpenWebif; \
		$(BUILDENV) \
		cp -a plugin $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/Extensions/OpenWebif; \
		mkdir -p $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/Extensions/OpenWebif/locale/cs/LC_MESSAGES; \
		mkdir -p $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/Extensions/OpenWebif/locale/de/LC_MESSAGES; \
		mkdir -p $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/Extensions/OpenWebif/locale/el/LC_MESSAGES; \
		mkdir -p $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/Extensions/OpenWebif/locale/nl/LC_MESSAGES; \
		mkdir -p $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/Extensions/OpenWebif/locale/pl/LC_MESSAGES; \
		mkdir -p $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/Extensions/OpenWebif/locale/uk/LC_MESSAGES; \
		msgfmt -cv -o $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/Extensions/OpenWebif/locale/cs/LC_MESSAGES/OpenWebif.mo locale/cs.po; \
		msgfmt -cv -o $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/Extensions/OpenWebif/locale/de/LC_MESSAGES/OpenWebif.mo locale/de.po; \
		msgfmt -cv -o $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/Extensions/OpenWebif/locale/el/LC_MESSAGES/OpenWebif.mo locale/el.po; \
		msgfmt -cv -o $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/Extensions/OpenWebif/locale/nl/LC_MESSAGES/OpenWebif.mo locale/nl.po; \
		msgfmt -cv -o $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/Extensions/OpenWebif/locale/pl/LC_MESSAGES/OpenWebif.mo locale/pl.po; \
		msgfmt -cv -o $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/Extensions/OpenWebif/locale/uk/LC_MESSAGES/OpenWebif.mo locale/uk.po
	$(REMOVE)/e2openplugin-OpenWebif
	$(TOUCH)

#
# enigma2-networkbrowser
#
$(D)/enigma2_networkbrowser: $(D)/bootstrap $(D)/python
	$(START_BUILD)
	$(REMOVE)/enigma2-networkbrowser
	@set -e; if [ -d $(ARCHIVE)/enigma2-plugins.git ]; \
		then cd $(ARCHIVE)/enigma2-plugins.git; git pull; \
		else cd $(ARCHIVE); git clone https://github.com/OpenPLi/enigma2-plugins.git enigma2-plugins.git; \
		fi
	cp -ra $(ARCHIVE)/enigma2-plugins.git/networkbrowser/ $(BUILD_TMP)/enigma2-networkbrowser
	@set -e; cd $(BUILD_TMP)/enigma2-networkbrowser; \
		$(PATCH)/enigma2-networkbrowser-support-autofs.patch; \
	@set -e; cd $(BUILD_TMP)/enigma2-networkbrowser/src/lib; \
		$(BUILDENV) \
		sh4-linux-gcc -shared -o netscan.so \
			-I $(TARGETPREFIX)/usr/include/python$(PYTHON_VERSION) \
			-include Python.h \
			errors.h \
			list.c \
			list.h \
			main.c \
			nbtscan.c \
			nbtscan.h \
			range.c \
			range.h \
			showmount.c \
			showmount.h \
			smb.h \
			smbinfo.c \
			smbinfo.h \
			statusq.c \
			statusq.h \
			time_compat.h
	@set -e; cd $(BUILD_TMP)/enigma2-networkbrowser; \
		mkdir -p $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/SystemPlugins/NetworkBrowser ; \
		cp -a po $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/SystemPlugins/NetworkBrowser/ ; \
		cp -a meta $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/SystemPlugins/NetworkBrowser/ ; \
		cp -a src/* $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/SystemPlugins/NetworkBrowser/ ; \
		cp -a src/lib/netscan.so $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/SystemPlugins/NetworkBrowser/ ; \
		rm -rf $(TARGETPREFIX)/usr/lib/enigma2/python/Plugins/SystemPlugins/NetworkBrowser/lib
	$(REMOVE)/enigma2-networkbrowser
	$(TOUCH)
