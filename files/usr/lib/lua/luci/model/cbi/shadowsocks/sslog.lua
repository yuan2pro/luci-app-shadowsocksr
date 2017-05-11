local e=require"nixio.fs"
local e=require"luci.sys"
m=Map("shadowsocks")
s=m:section(TypedSection,"global",translate("These is shadowsocks start logs."))
s.anonymous=true
local e="/var/log/shadowsocks.log"
tvlog=s:option(TextValue,"sylogtext")
tvlog.rows=50
tvlog.readonly="readonly"
tvlog.wrap="off"
function tvlog.cfgvalue(t,t)
sylogtext=""
if e and nixio.fs.access(e)then
sylogtext=luci.sys.exec("tail -n 100 %s"%e)
end
return sylogtext
end
tvlog.write=function(e,e,e)
end
return m
