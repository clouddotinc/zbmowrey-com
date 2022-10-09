create_api_domain_name = true

aaaa_records  = {
  "5e.zbmowrey.com" = "d2ctarp2vmpznw.cloudfront.net"
}
mx_records    = {
  "zbmowrey.com" = [
    "10 mail.protonmail.ch",
    "20 mailsec.protonmail.ch"
  ]
}
txt_records   = {
  "zbmowrey.com"        = [
    "protonmail-verification=ea4260ba3df52d268f36ab707e662db9a8caaa64",
    "v=spf1 include:_spf.protonmail.ch mx ~all",
    "google-site-verification=aqaHYTsRFfMPZkODqroumu597XrOdnzf0WzpYovMQmg"
  ]
  "_dmarc.zbmowrey.com" = ["v=DMARC1; p=reject; rua=mailto:zb@zbmowrey.com"]
}
cname_records = {
  "v5ovgfocysfgiknwwxlo7fm3ax6rwufl._domainkey.zbmowrey.com" = "v5ovgfocysfgiknwwxlo7fm3ax6rwufl.dkim.amazonses.com"
  "qmg5aatpkrq7obcou2grvpqnsrkkv3b6._domainkey.zbmowrey.com" = "qmg5aatpkrq7obcou2grvpqnsrkkv3b6.dkim.amazonses.com"
  "kudr72x2mm234es5bvwfj7ojawwfgp45._domainkey.zbmowrey.com" = "kudr72x2mm234es5bvwfj7ojawwfgp45.dkim.amazonses.com"
  "protonmail3._domainkey.zbmowrey.com"                      = "protonmail3.domainkey.d2hfypnvtrf7upmspiqkg5tf2a2ynzawy5w25shesjfhrrkrjx57a.domains.proton.ch."
  "protonmail2._domainkey.zbmowrey.com"                      = "protonmail2.domainkey.d2hfypnvtrf7upmspiqkg5tf2a2ynzawy5w25shesjfhrrkrjx57a.domains.proton.ch."
  "protonmail._domainkey.zbmowrey.com"                       = "protonmail.domainkey.d2hfypnvtrf7upmspiqkg5tf2a2ynzawy5w25shesjfhrrkrjx57a.domains.proton.ch."
  "_f7a053058d7789d43016916be65b1c8c.zbmowrey.com."          = "_afe26c394835f5e5c5d58ba018318444.bcnrdwzwjt.acm-validations.aws."
  "_fbc223c4bc11fffb23e35a83b1fe2cf9.5e.zbmowrey.com."       = "_82a6ae5c2284561ffa4e6d283d986208.bcnrdwzwjt.acm-validations.aws."
}