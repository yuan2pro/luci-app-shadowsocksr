local e=require"nixio.fs"
local e=require"luci.sys"
local r=luci.model.uci.cursor()
local h="shadowsocks"
local a,t,e
local s=luci.sys.exec("kcpclient -v | awk '{print $3}'")
local n={
"manual",
"normal",
"fast",
"fast2",
"fast3",
}
local i={
"aes",
"aes-128",
"aes-192",
"salsa20",
"blowfish",
"twofish",
"cast5",
"3des",
"tea",
"xtea",
"xor",
"none",
}
local o={}
r:foreach(h,"servers",function(e)
if e.server and e.server_port then
o[e[".name"]]="%s"%{e.server}
end
end)
a=Map("shadowsocks",translate("Kcp Settings<br /><br />Settings Tutorial:</font><a style=\"color: #ff0000;\" onclick=\"window.open('http://koolshare.cn/forum.php?mod=viewthread&tid=66315')\">Jump Link to Koolshare Forum Tutorial</a>"),translate("Kcp server version and the client needs to be consistent,or can not connect.<br />Current kcp version:</font><a style=\"color: #00ff00;\">")..s.."</a>")
t=a:section(TypedSection,"kcp",translate("Kcp on or off"))
t.anonymous=true
e=t:option(Flag,"kcpon",translate("Use kcp acceleration"))
e.default=0
e.rmempty=false
t=a:section(TypedSection,"kcp",translate("Kcp Server settings"))
t.anonymous=true
e=t:option(Value,"kcp_server",translate("KCP Server Address"))
e.width="30%"
for a,t in pairs(o)do e:value(t,t)end
e.rmempty=false
e=t:option(Value,"kcp_port",translate("Kcp Port"))
e.default="1185"
e.rmempty=false
e=t:option(Value,"password",translate("Password"))
e.password=true
e.rmempty=false
e=t:option(ListValue,"mode",translate("Speed Mode"))
e.rmempty=false
e.default="fast"
for a,t in ipairs(n)do e:value(t)end
e=t:option(ListValue,"crypt",translate("Encrypt Method"))
e.rmempty=false
for a,t in ipairs(i)do e:value(t)end
e=t:option(Value,"mtu",translate("MTU"))
e.datatype="uinteger"
e.default=1350
e.rmempty=false
e=t:option(Value,"sndwnd",translate("Send Window"))
e.datatype="uinteger"
e.default=128
e.rmempty=false
e=t:option(Value,"rcvwnd",translate("Recv Window"))
e.datatype="uinteger"
e.default=1024
e.rmempty=false
e=t:option(Value,"conn",translate("Conn"))
e.default=1
e.rmempty=false
e=t:option(Flag,"compon",translate("Use Compression"))
e.rmempty=false
e=t:option(Value,"kcpconfig",translate("Kcp Parameters"))
e.default="--dscp 46"
e.rmempty=false
return a
