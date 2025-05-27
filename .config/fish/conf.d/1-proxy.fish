# common env
set -l HOST_IP 127.0.0.1 # $(ipconfig.exe | grep IPv4 | head -1 | rev | awk "{print $1}" | rev | tr -d "\r")
set -l WSL2_IP 127.0.0.1 # $(hostname -I | awk "{print $1}")
set -l SOCKS5_ADDR socks5://$HOST_IP:7890
set -l HTTP_ADDR http://$HOST_IP:7890

# proxy
# set -Ux all_proxy $HTTP_ADDR
# set -Ux http_proxy $HTTP_ADDR
# set -Ux https_proxy $HTTP_ADDR
# set -Ux ALL_PROXY $HTTP_ADDR
# set -Ux HTTP_PROXY $HTTP_ADDR
# set -Ux HTTPS_PROXY $HTTP_ADDR
if type -q git
  git config --global http.proxy $HTTP_ADDR
  git config --global https.proxy $HTTP_ADDR
end