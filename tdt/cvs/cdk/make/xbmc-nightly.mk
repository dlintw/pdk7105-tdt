# tuxbox/xbmc-nightly

$(DEPDIR)/xbmc-nightly.do_prepare:
	REVISION=""; \
	PVRREVISION=""; \
	DIFF="0"; \
	REPO="https://github.com/xbmc/xbmc.git"; \
	PVRREPO="https://github.com/opdenkamp/xbmc-pvr-addons.git"; \
	rm -rf $(appsdir)/xbmc-nightly; \
	rm -rf $(appsdir)/xbmc-nightly.org; \
	echo "default to use Fr,  02 Jan 2013 22:34 - Frodo_rc3    - 7a6cb7f49ae19dca3c48c40fa3bd20dc3c490e60"; \
	DIFF="5" && REVISION="Frodo_rc3" \
	&& PVRREVISION="Frodo_rc3"; \
	\
	echo "Revision: " $$REVISION; \
	[ -d "$(archivedir)/xbmc.git" ] && \
	(cd $(archivedir)/xbmc.git; git pull ; git checkout HEAD; cd "$(buildprefix)";); \
	[ -d "$(archivedir)/xbmc.git" ] || \
	git clone $$REPO $(archivedir)/xbmc.git; \
	\
	echo "PVR Revision: " $$PVRREVISION; \
	[ -d "$(archivedir)/xbmc-pvr-addons.git" ] && \
	(cd $(archivedir)/xbmc-pvr-addons.git; git pull ; git checkout HEAD; cd "$(buildprefix)";); \
	[ -d "$(archivedir)/xbmc-pvr-addons.git" ] || \
	git clone $$PVRREPO $(archivedir)/xbmc-pvr-addons.git; \
	\
	cp -ra $(archivedir)/xbmc.git $(appsdir)/xbmc-nightly.newest; \
	rm -rf $(appsdir)/xbmc-nightly.newest/.git; \
	cp -ra $(archivedir)/xbmc.git $(appsdir)/xbmc-nightly; \
	\
	cp -ra $(archivedir)/xbmc-pvr-addons.git $(appsdir)/xbmc-nightly.newest/pvr-addons; \
	rm -rf $(appsdir)/xbmc-nightly.newest/pvr-addons/.git; \
	cp -ra $(archivedir)/xbmc-pvr-addons.git $(appsdir)/xbmc-nightly/pvr-addons; \
	\
	[ "$$REVISION" == "" ] || (cd $(appsdir)/xbmc-nightly; git checkout "$$REVISION"; cd "$(buildprefix)";); \
	[ "$$PVRREVISION" == "" ] || (cd $(appsdir)/xbmc-nightly/pvr-addons; git checkout "$$PVRREVISION"; cd "$(buildprefix)";); \
	\
	rm -rf $(appsdir)/xbmc-nightly/.git; \
	rm -rf $(appsdir)/xbmc-nightly/pvr-addons/.git; \
	\
	cp -ra $(appsdir)/xbmc-nightly $(appsdir)/xbmc-nightly.org; \
	cd $(appsdir)/xbmc-nightly && patch -p1 < "../../cdk/Patches/xbmc-nightly.$$DIFF.diff"; \
	cd $(appsdir)/xbmc-nightly && patch -p1 < "../../cdk/Patches/xbmc-nightly.pvr.$$DIFF.diff"
	touch $@

#endable webserver else httpapihandler will fail
$(appsdir)/xbmc-nightly/config.status: bootstrap opkg libboost directfb libstgles libass libmpeg2 libmad libjpeg libsamplerate libogg libvorbis libmodplug libcurl libflac bzip2 tiff lzo libfribidi libfreetype sqlite libpng libpcre libcdio jasper yajl libmicrohttpd tinyxml python gstreamer gst_plugins_dvbmediasink libexpat libnfs taglib samba
	cd $(appsdir)/xbmc-nightly && \
		$(BUILDENV) \
		./bootstrap && \
		./configure \
			--host=$(target) \
			--prefix=/usr \
			PKG_CONFIG=$(hostprefix)/bin/pkg-config \
			PKG_CONFIG_PATH=$(targetprefix)/usr/lib/pkgconfig \
			PYTHON_SITE_PKG=$(targetprefix)/usr/lib/python$(PYTHON_VERSION)/site-packages \
			PYTHON_CPPFLAGS=-I$(targetprefix)/usr/include/python$(PYTHON_VERSION) \
			PY_PATH=$(targetprefix)/usr \
			TEXTUREPACKER_NATIVE_ROOT=/usr \
			SWIG_EXE=none \
			JRE_EXE=none \
			--disable-gl \
			--enable-glesv1 \
			--disable-gles \
			--disable-sdl \
			--enable-webserver \
			--enable-nfs \
			--disable-x11 \
			--enable-samba \
			--disable-mysql \
			--disable-joystick \
			--disable-rsxs \
			--disable-projectm \
			--disable-goom \
			--disable-afpclient \
			--disable-airplay \
			--disable-airtunes \
			--disable-dvdcss \
			--disable-hal \
			--disable-avahi \
			--disable-optical-drive \
			--disable-libbluray \
			--disable-texturepacker \
			--disable-udev \
			--disable-libusb \
			--disable-libcec \
			--enable-gstreamer \
			--disable-paplayer \
			--enable-gstplayer \
			--enable-dvdplayer \
			--disable-pulse \
			--disable-alsa \
			--disable-ssh

$(DEPDIR)/xbmc-nightly.do_compile: $(appsdir)/xbmc-nightly/config.status
	cd $(appsdir)/xbmc-nightly && \
		$(MAKE) all
	touch $@

$(DEPDIR)/xbmc-nightly: xbmc-nightly.do_prepare xbmc-nightly.do_compile
	$(MAKE) -C $(appsdir)/xbmc-nightly install DESTDIR=$(targetprefix)
	if [ -e $(targetprefix)/usr/lib/xbmc/xbmc.bin ]; then \
		$(target)-strip $(targetprefix)/usr/lib/xbmc/xbmc.bin; \
	fi
	touch $@

xbmc-nightly-clean xbmc-nightly-distclean:
	rm -f $(DEPDIR)/xbmc-nightly
	rm -f $(DEPDIR)/xbmc-nightly.do_compile
	rm -f $(DEPDIR)/xbmc-nightly.do_prepare
	rm -rf $(appsdir)/xbmc-nightly
	rm -rf $(appsdir)/xbmc-nightly.newest
	rm -rf $(appsdir)/xbmc-nightly.org
	rm -rf $(appsdir)/xbmc-nightly.patched

