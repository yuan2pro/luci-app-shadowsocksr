local i="shadowsocks"
local d=require"luci.dispatcher"
local r=require("luci.model.ipkg")
local a,t,e
local o={
"none",
"table",
"rc4",
"rc4-md5",
"aes-128-cfb",
"aes-192-cfb",
"aes-256-cfb",
"aes-128-ctr",
"aes-192-ctr",
"aes-256-ctr",
"aes-128-gcm",
"aes-192-gcm",
"aes-256-gcm",
"bf-cfb",
"camellia-128-cfb",
"camellia-192-cfb",
"camellia-256-cfb",
"cast5-cfb",
"des-cfb",
"idea-cfb",
"rc2-cfb",
"seed-cfb",
"salsa20",
"chacha20",
"chacha20-ietf",
"chacha20-ietf-poly1305",
"chacha20-poly1305",
}
local h={
"origin",
"verify_simple",
"verify_deflate",
"verify_sha1",
"auth_simple",
"auth_sha1",
"auth_sha1_v2",
"auth_sha1_v4",
"auth_aes128_md5",
"auth_aes128_sha1",
"auth_chain_a",
}
local s={
"plain",
"http_simple",
"http_post",
"random_head",
"tls_simple",
"tls1.0_session_auth",
"tls1.2_ticket_auth",
}
local n={
"http",
"tls",
}
local n={
"false",
"true",
}
if r.installed("shadowsocks-polarssl")then
for e=1,5,1 do table.remove(o,11)end
end
arg[1]=arg[1]or""
a=Map(i,translate("ShadowSocks Server Config"),translate("Leave the default false if the server does not support TCP_fastopen and Onetime Authentication."))
a.redirect=d.build_url("admin","services","shadowsocks")
t=a:section(NamedSection,arg[1],"servers","")
t.addremove=false
t.dynamic=false
e=t:option(Value,"remarks",translate("Remarks"))
e.default="Shadowsocks"
e.rmempty=false
e=t:option(ListValue,"server_type",translate("Server Type"))
e:value("ss",translate("Shadowsocks Server"))
e:value("ssr",translate("ShadowsocksR Server"))
e.rmempty=false
e=t:option(Value,"server",translate("Server Address"))
e.datatype="host"
e.rmempty=false
e=t:option(Value,"server_port",translate("Server Port"))
e.datatype="port"
e.rmempty=false
e=t:option(Value,"password",translate("Password"))
e.password=true
e.rmempty=false
e=t:option(ListValue,"encrypt_method",translate("Encrypt Method"))
for a,t in ipairs(o)do e:value(t)end
e.rmempty=false
e=t:option(Value,"timeout",translate("Connection Timeout"))
e.datatype="uinteger"
e.default=300
e.rmempty=false
e=t:option(Value,"local_port",translate("Local Port"))
e.datatype="port"
e.default=1080
e.rmempty=false
e=t:option(ListValue,"fast_open",translate("Fast_open"))
for a,t in ipairs(n)do e:value(t)end
e.rmempty=false
e=t:option(ListValue,"protocol",translate("Protocol"))
for a,t in ipairs(h)do e:value(t)end
e:depends("server_type","ssr")
e=t:option(ListValue,"obfs",translate("Obfs"))
for a,t in ipairs(s)do e:value(t)end
e:depends("server_type","ssr")
e=t:option(Value,"obfs_param",translate("Obfs_param"))
e.rmempty=true
e:depends("server_type","ssr")
e=t:option(Value,"plugin",translate("Plugin Name"))
e.placeholder="eg: obfs-local"
e:depends("server_type","ss")
e=t:option(Value,"plugin_opts",translate("Plugin Arguments"))
e.placeholder="eg: obfs=http;obfs-host=www.bing.com"
e:depends("server_type","ss")
return a
