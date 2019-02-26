echo ~/.bashrc

archupd() {
  local filter="<title>([^<]*)</title>\\n<pubDate>([^<]*)</pubDate>"
  curl -s https://www.archlinux.org/feeds/news/ \
    | xmllint --xpath //item/title\ \|\ //item/pubDate /dev/stdin \
    | sed -rz -e "s:${filter}:\\2 -- \\1:g" \
              -e "s:&gt;:>:" \
              -e "s:&lt;:<:" \
    | tr -s " " \
    | cut -d " " --complement -f 1,5,6 \
    | head -n3 \
    && pacman -Syu 2>&1 | tee -ai /tmp/archupd.log
}

archmirr() {
  local url
  url="https://www.archlinux.org/mirrorlist/?country=FI"
  url="${url}&protocol=http&protocol=https&use_mirror_status=on"
  curl -q -ssL "$url" | sed -e 's/^#Server/Server/' -e '/^#/d' \
    | rankmirrors -n 5 - >/etc/pacman.d/mirrorlist
}
