local t=require"nixio.fs"
local e=require"luci.sys"
m=Map("shadowsocks")
s=m:section(TypedSection,"global",translate("DNS Setting"))
s.anonymous=true
s.addremove=false
o=s:option(Value,"dns_forward",translate("DNS Forward Address"))
o.default="8.8.8.8:53"
o.rmempty=false
o=s:option(Value,"dns_1",translate("Mainland DNS Sever 1"))
o.default="223.5.5.5"
o:value("223.5.5.5",translate("223.5.5.5(阿里)"))
o:value("223.6.6.6",translate("223.6.6.6(阿里)"))
o:value("114.114.114.114",translate("114.114.114.114(114DNS)"))
o:value("114.114.115.115",translate("114.114.115.115(114DNS)"))
o:value("119.29.29.29",translate("119.29.29.29(DNSPOD)"))
o:value("182.254.116.116",translate("182.254.116.116(DNSPOD)"))
o:value("1.2.4.8",translate("1.2.4.8(CNNIC)"))
o:value("210.2.4.8",translate("210.2.4.8(CNNIC)"))
o:value("180.76.76.76",translate("180.76.76.76(BAIDU)"))
o:value("8.8.8.8",translate("8.8.8.8(GOOGLE)"))
o:value("8.8.4.4",translate("8.8.4.4(GOOGLE)"))
o.rmempty=false
o=s:option(Value,"dns_2",translate("Mainland DNS Sever 2"))
o.default="119.29.29.29"
o:value("223.5.5.5",translate("223.5.5.5(阿里)"))
o:value("223.6.6.6",translate("223.6.6.6(阿里)"))
o:value("114.114.114.114",translate("114.114.114.114(114DNS)"))
o:value("114.114.115.115",translate("114.114.115.115(114DNS)"))
o:value("119.29.29.29",translate("119.29.29.29(DNSPOD)"))
o:value("182.254.116.116",translate("182.254.116.116(DNSPOD)"))
o:value("1.2.4.8",translate("1.2.4.8(CNNIC)"))
o:value("210.2.4.8",translate("210.2.4.8(CNNIC)"))
o:value("180.76.76.76",translate("180.76.76.76(BAIDU)"))
o:value("8.8.8.8",translate("8.8.8.8(GOOGLE)"))
o:value("8.8.4.4",translate("8.8.4.4(GOOGLE)"))
o.rmempty=false
local e=luci.sys.exec("ip route|grep default|wc -l")
o=s:option(ListValue,"dns_port",translate("DNS Export Of Multi WAN"))
for e=0,e do
if e==0 then o:value(e,translate("Not Specify"))
else
local t=luci.sys.exec("ip route|grep default|sed -n %qp|awk -F' ' {'print $5'}"%{e})
local t=luci.sys.exec("cat /var/state/network|grep -w %q|awk -F'.' '{print $2}'"%{t})
o:value(e,translate("%s"%{t}))
end
end
o.default=0
o.rmempty=false
o=s:option(Flag,"dns_53",translate("DNS Hijack"))
o.default=0
o.rmempty=false
local e=luci.sys.exec("ip route|grep default|wc -l")
o=s:option(ListValue,"wan_port",translate("Export Of Multi WAN"))
for e=0,e do
if e==0 then o:value(e,translate("Not Specify"))
else
local t=luci.sys.exec("ip route|grep default|sed -n %qp|awk -F' ' {'print $5'}"%{e})
local t=luci.sys.exec("cat /var/state/network|grep -w %q|awk -F'.' '{print $2}'"%{t})
o:value(e,translate("%s"%{t}))
end
end
o.default=0
o.rmempty=false
s=m:section(TypedSection,"global",translate("Start Delay"))
s.anonymous=true
s.addremove=false
o=s:option(Value,"start_delay",translate("Delay Start"),translate("Units:seconds"))
o.default="0"
o.rmempty=true
o=s:option(Flag,"auto_on",translate("Open and close automatically"))
o.default=0
o.rmempty=false
o=s:option(ListValue,"time_on",translate("Automatically turn on time"))
for e=0,23 do
o:value(e,translate(e.."点"))
end
o.default=8
o:depends("auto_on","1")
o=s:option(ListValue,"time_off",translate("Automatically turn off time"))
for e=0,23 do
o:value(e,translate(e.."点"))
end
o.default=2
o:depends("auto_on","1")
s=m:section(TypedSection,"global",translate("Custom Dnsmasq"))
s.anonymous=true
local e="/etc/dnsmasq.d/user.conf"
o=s:option(TextValue,"userconf")
o.description=translate("Setting a parameter error will cause dnsmasq fail to start.")
o.rows=15
o.wrap="off"
o.cfgvalue=function(a,a)
return t.readfile(e)or""
end
o.write=function(o,o,a)
t.writefile(e,a:gsub("\r\n","\n"))
end
return m
