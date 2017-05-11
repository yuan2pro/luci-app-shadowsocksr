local e=require"nixio.fs"
local t=require"luci.sys"
m=Map("shadowsocks")
s=m:section(TypedSection,"global",translate("Set whitelist"))
s.anonymous=true
local t="/etc/dnsmasq.d/cdn.conf"
o=s:option(TextValue,"whitelist")
o.description=translate("Join the white list of domain names will not go agent.")
o.rows=18
o.wrap="off"
o.cfgvalue=function(a,a)
return e.readfile(t)or""
end
o.write=function(o,o,a)
e.writefile("/tmp/cdn",a:gsub("\r\n","\n"))
if(luci.sys.call("cmp -s /tmp/cdn /etc/dnsmasq.d/cdn.conf")==1)then
e.writefile(t,a:gsub("\r\n","\n"))
luci.sys.call("rm -f /tmp/dnsmasq.d/sscdn.conf")
end
e.remove("/tmp/cdn")
end
local t="/etc/gfwlist/whiteip"
o=s:option(TextValue,"wiplist")
o.description=translate("These had been joined ip addresses will not use proxy.Please input the ip address or ip address segment,every line can input only one ip address.For example,112.123.134.145/24 or 112.123.134.145.")
o.rows=18
o.wrap="off"
o.cfgvalue=function(a,a)
return e.readfile(t)or""
end
o.write=function(o,o,a)
e.writefile(t,a:gsub("\r\n","\n"))
end
return m
