local o=require"luci.dispatcher"
local n=require("luci.model.ipkg")
local s=luci.model.uci.cursor()
local e=require"nixio.fs"
local e=require"luci.sys"
local i="shadowsocks"
local a,t,e
function is_installed(e)
return n.installed(e)
end
local n={}
s:foreach(i,"servers",function(e)
if e.server and e.remarks then
n[e[".name"]]="%s:%s"%{e.remarks,e.server}
end
end)
a=Map(i,translate("ShadowSocks"),translate("A lightweight secured SOCKS5 proxy"))
a.template="shadowsocks/index"
t=a:section(TypedSection,"global",translate("Running Status"))
t.anonymous=true
e=t:option(DummyValue,"ss_redir_status",translate("Transparent Proxy"))
e.template="shadowsocks/dvalue"
e.value=translate("Collecting data...")
e=t:option(DummyValue,"haproxy_status",translate("Load Balancing"))
e.template="shadowsocks/haproxy"
e.value=translate("Collecting data...")
e=t:option(DummyValue,"kcp_status",translate("Kcp Client"))
e.template="shadowsocks/kcp"
e.value=translate("Collecting data...")
e=t:option(DummyValue,"china_china",translate("China Connection"))
e.template="shadowsocks/china"
e.value=translate("Collecting data...")
e=t:option(DummyValue,"foreign_foreign",translate("Foreign Connection"))
e.template="shadowsocks/foreign"
e.value=translate("Collecting data...")
t=a:section(TypedSection,"global",translate("Global Setting"))
t.anonymous=true
t.addremove=false
e=t:option(ListValue,"global_server",translate("Current Server"))
e.default="nil"
e.rmempty=false
e:value("nil",translate("Disable"))
for a,t in pairs(n)do e:value(a,t)end
e=t:option(ListValue,"proxy_mode",translate("Default")..translate("Proxy Mode"))
e.default="gfwlist"
e.rmempty=false
e:value("disable",translate("No Proxy"))
e:value("global",translate("Global Proxy"))
e:value("gfwlist",translate("GFW List"))
e:value("chnroute",translate("China WhiteList"))
e:value("gamemode",translate("Game Mode"))
e:value("returnhome",translate("Return Home"))
e=t:option(ListValue,"dns_mode",translate("DNS Forward Mode"))
e.default="dns2socks"
e.rmempty=false
e:reset_values()
if is_installed("dns2socks")then
e:value("dns2socks","dns2socks")
end
if is_installed("pcap-dnsproxy")then
e:value("pcap-dnsproxy","pcap-dnsproxy")
end
if is_installed("pdnsd")then
e:value("pdnsd","pdnsd")
end
if is_installed("cdns")then
e:value("cdns","cdns")
end
if is_installed("ChinaDNS")then
e:value("chinadns","chinadns")
end
e:value("ssr-tunnel","ssr-tunnel")
t=a:section(TypedSection,"servers",translate("Servers List"))
t.anonymous=true
t.addremove=true
t.template="cbi/tblsection"
t.extedit=o.build_url("admin","services","shadowsocks","serverconfig","%s")
function t.create(e,t)
local e=TypedSection.create(e,t)
luci.http.redirect(o.build_url("admin","services","shadowsocks","serverconfig",e))
end
function t.remove(t,a)
t.map.proceed=true
t.map:del(a)
luci.http.redirect(o.build_url("admin","services","shadowsocks"))
end
e=t:option(DummyValue,"remarks",translate("Node Remarks"))
e.width="30%"
e=t:option(DummyValue,"server_type",translate("Server Type"))
e.width="15%"
e=t:option(DummyValue,"server",translate("Server Address"))
e.width="20%"
e=t:option(DummyValue,"server_port",translate("Server Port"))
e.width="10%"
e=t:option(DummyValue,"encrypt_method",translate("Encrypt Method"))
e.width="15%"
e=t:option(DummyValue,"server",translate("Ping Latency"))
e.template="shadowsocks/ping"
e.width="10%"
return a
