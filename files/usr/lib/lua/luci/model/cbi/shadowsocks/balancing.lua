local e=require"nixio.fs"
local e=require"luci.sys"
local i=luci.model.uci.cursor()
local n="shadowsocks"
local a,t,e
local o={}
i:foreach(n,"servers",function(e)
if e.server and e.server_port then
o[e[".name"]]="%s"%{e.server}
end
end)
a=Map("shadowsocks",translate("Load Balancing").."<br /><br />"..
"<a onclick=\"window.open('http://koolshare.cn/thread-65561-1-1.html')\">"..
translate("Click here to setting your Load Balancing")..
"</a>")
t=a:section(TypedSection,"global",translate("Load Balancing Setting"))
t.anonymous=true
e=t:option(Flag,"balancing_enable",translate("Enable or Disable Load Balancing"))
e.rmempty=false
e.default=false
e=t:option(Value,"haproxy_port",translate("Haproxy port setting"))
e.default="1181"
e.rmempty=false
t=a:section(TypedSection,"global",translate("Admin Status"),translate("In the browser input routing IP plus port access, such as:192.168.1.1:1188"))
t.anonymous=true
e=t:option(Flag,"admin_enable",translate("Enable Admin Status"))
e.rmempty=false
e.default=false
e=t:option(Value,"admin_port",translate("Admin Status port setting"))
e.default="1188"
e.rmempty=false
e=t:option(Value,"admin_user",translate("Admin Status User"))
e.default="admin"
e.rmempty=false
e=t:option(Value,"admin_password",translate("Admin Status Password"))
e.password=true
e.default="admin"
e.rmempty=false
t=a:section(TypedSection,"balancing",translate("Load Balancing Server Setting"),
translate("Add a load balancing server, note reading above requirements."))
t.template="cbi/tblsection"
t.sortable=true
t.anonymous=true
t.addremove=true
e=t:option(Value,"lbss",translate("Server Address"))
e.width="30%"
for a,t in pairs(o)do e:value(t,t)end
e.rmempty=false
e=t:option(Value,"lbort",translate("Server Port"))
e.width="20%"
e.rmempty=false
e=t:option(Value,"lbweight",translate("Server weight"))
e.width="20%"
e.default="5"
e.rmempty=false
local o=luci.sys.exec("ip route|grep default|wc -l")
e=t:option(ListValue,"export",translate("Export Of Multi WAN"))
for t=0,o do
if t==0 then e:value(t,translate("Not Specify"))
else
local a=luci.sys.exec("ip route|grep default|sed -n %qp|awk -F' ' {'print $5'}"%{t})
local a=luci.sys.exec("cat /var/state/network|grep -w %q|awk -F'.' '{print $2}'"%{a})
e:value(t,translate("%s"%{a}))
end
end
e.width="20%"
e.default=0
e.rmempty=false
e=t:option(ListValue,"backup",translate("Server Mode"))
e:value(0,translate("Primary Server"))
e:value(1,translate("Standby Server"))
e.rmempty=false
e.width="10%"
return a
