local e=require"nixio.fs"
local t=require"luci.sys"
m=Map("shadowsocks")
s=m:section(TypedSection,"global",translate("Set Blacklist"))
s.anonymous=true
local t="/etc/gfwlist/gfwlist"
o=s:option(TextValue,"weblist")
o.description=translate("These had been joined websites will use proxy,but only GFW model.Please input the domain names of websites,every line can input only one website domain.For example,google.com.")
o.rows=18
o.wrap="off"
o.cfgvalue=function(a,a)
return e.readfile(t)or""
end
o.write=function(o,o,a)
e.writefile("/tmp/gfwlist",a:gsub("\r\n","\n"))
if(luci.sys.call("cmp -s /tmp/gfwlist /etc/gfwlist/gfwlist")==1)then
e.writefile(t,a:gsub("\r\n","\n"))
luci.sys.call("rm -f /tmp/dnsmasq.d/custom.conf >/dev/null")
end
e.remove("/tmp/gfwlist")
end
local t="/etc/gfwlist/custom"
o=s:option(TextValue,"iplist")
o.description=translate("These had been joined ip addresses will use proxy,but only GFW model.Please input the ip address or ip address segment,every line can input only one ip address.For example,112.123.134.145/24 or 112.123.134.145.")
o.rows=18
o.wrap="off"
o.cfgvalue=function(a,a)
return e.readfile(t)or""
end
o.write=function(o,o,a)
e.writefile(t,a:gsub("\r\n","\n"))
end
return m
