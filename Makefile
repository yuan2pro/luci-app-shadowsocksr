include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-shadowsocksr
PKG_VERSION:=20170509
PKG_RELEASE:=1

PKG_MAINTAINER:=monokoo <realstones2012@gmail.com>

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)
#PKG_USE_MIPS16:=0

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=LuCI for shadowsocksr
        DEPENDS:=+shadowsocksr +shadowsocks +dnsmasq-full +ipset +ip-full +iptables-mod-tproxy +kmod-ipt-compat-xtables \
			+kmod-ipt-tproxy +iptables-mod-nat-extra +iptables-mod-geoip \
				+libustream-openssl +ca-bundle +ca-certificates +curl +whereis +resolveip \
					+haproxy +cdns +dns2socks +pcap-dnsproxy +pdnsd
endef

define Package/$(PKG_NAME)/description
    A luci app for shadowsocksr
endef

define Package/$(PKG_NAME)/preinst
endef

define Package/$(PKG_NAME)/postinst
#!/bin/sh
if [ -f "/usr/sbin/ip" ]; then
	rm -f /usr/sbin/ip
fi
if [ -f "/sbin/ip-full" ]; then
	ln -s /sbin/ip-full /usr/sbin/ip
else
	ln -s /sbin/ip /usr/sbin/ip
fi
if [ -z "$${IPKG_INSTROOT}" ]; then
	if [ -f /etc/uci-defaults/luci-shadowsocks ]; then
		( . /etc/uci-defaults/luci-shadowsocks ) && rm -f /etc/uci-defaults/luci-shadowsocks
	fi
	rm -rf /tmp/luci-indexcache /tmp/luci-modulecache
fi
if [ -f "/usr/sbin/haproxy" ]; then
	haproxypid=$$(pidof haproxy)
	if [ -n "$$haproxypid" ]; then
		echo haproxy stopped...
		/etc/init.d/haproxy stop
	fi
	echo haproxy disabled...
	/etc/init.d/haproxy disable

	if [ -f "/etc/hotplug.d/net/90-haproxy" ]; then
		rm /etc/hotplug.d/net/90-haproxy
	fi
	if [ -f "/usr/bin/haproxy" ]; then
		rm /usr/bin/haproxy
	fi
	ln -s /usr/sbin/haproxy /usr/bin/haproxy
fi
if [ -f "/etc/init.d/chinadns" ]; then
	chinadnspid=$$(pidof chinadns)
	if [ -n "$$chinadnspid" ]; then
		echo chinadns stopped...
		/etc/init.d/chinadns stop
	fi
	echo chinadns init script disabled...
	/etc/init.d/chinadns disable
fi
if [ -f "/etc/init.d/dns-forwarder" ]; then
	dnsforwarderpid=$$(pidof dns-forwarder)
	if [ -n "$$dnsforwarderpid" ]; then
		echo dns-forwarder stopped...
		/etc/init.d/dns-forwarder stop
	fi
	echo dns-forwarder init script disabled...
	/etc/init.d/dns-forwarder disable
fi
exit 0
endef

define Package/$(PKG_NAME)/prerm
endef

define Package/$(PKG_NAME)/postrm
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/conffiles
endef

define Package/$(PKG_NAME)/install

	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./files/etc/uci-defaults/luci-shadowsocks $(1)/etc/uci-defaults/luci-shadowsocks

	$(INSTALL_DIR) $(1)/etc/dnsmasq.d
	$(INSTALL_CONF) ./files/etc/dnsmasq.d/*.conf $(1)/etc/dnsmasq.d/
	$(INSTALL_CONF) ./files/etc/dnsmasq.d/dnsmasq.adblock $(1)/etc/dnsmasq.d/

	$(INSTALL_DIR) $(1)/etc/gfwlist
	$(INSTALL_CONF) ./files/etc/gfwlist/* $(1)/etc/gfwlist/

	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) ./files/usr/sbin/gfwlist $(1)/usr/sbin/

	$(INSTALL_DIR) $(1)/usr/share/xt_geoip
	$(CP) -R ./files/usr/share/xt_geoip/* $(1)/usr/share/xt_geoip/
	
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DATA) ./files/usr/lib/lua/luci/controller/*.lua $(1)/usr/lib/lua/luci/controller/
	
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi/shadowsocks
	$(INSTALL_DATA) ./files/usr/lib/lua/luci/model/cbi/shadowsocks/*.lua $(1)/usr/lib/lua/luci/model/cbi/shadowsocks/
	
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view/shadowsocks
	$(INSTALL_DATA) ./files/usr/lib/lua/luci/view/shadowsocks/* $(1)/usr/lib/lua/luci/view/shadowsocks/
	
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	$(INSTALL_DATA) ./files/usr/lib/lua/luci/i18n/shadowsocks.zh-cn.lmo $(1)/usr/lib/lua/luci/i18n/
	
	$(INSTALL_DIR) $(1)/usr/bin
	
ifeq ($(ARCH),mipsel)
	$(INSTALL_BIN) ./files/bin/kcpclient/client_linux_mipsle $(1)/usr/bin/kcpclient
	$(INSTALL_BIN) ./files/bin/mipsel $(1)/usr/sbin/addroute
endif
ifeq ($(ARCH),mips)
	$(INSTALL_BIN) ./files/bin/kcpclient/client_linux_mips $(1)/usr/bin/kcpclient
	$(INSTALL_BIN) ./files/bin/mips $(1)/usr/sbin/addroute
endif
ifeq ($(ARCH),i386)
	$(INSTALL_BIN) ./files/bin/kcpclient/client_linux_386 $(1)/usr/bin/kcpclient
	$(INSTALL_BIN) ./files/bin/i386 $(1)/usr/sbin/addroute
endif
ifeq ($(ARCH),arm)
	$(INSTALL_BIN) ./files/bin/kcpclient/client_linux_arm7 $(1)/usr/bin/kcpclient
	$(INSTALL_BIN) ./files/bin/arm $(1)/usr/sbin/addroute
endif
ifeq ($(ARCH),x86_64)
	$(INSTALL_BIN) ./files/bin/kcpclient/client_linux_amd64 $(1)/usr/bin/kcpclient
	$(INSTALL_BIN) ./files/bin/x86_64 $(1)/usr/sbin/addroute
endif


endef

$(eval $(call BuildPackage,$(PKG_NAME)))