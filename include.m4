m4_changequote(`!<', `>!')m4_dnl
m4_define(!<m4_getenv>!, !<m4_esyscmd(!<printf "$$1">!)>!)m4_dnl
m4_define(!<m4_getenv_req>!, !<m4_ifelse(m4_getenv(!<$1>!),,!<m4_errprint(!<Missing required environment variable $1
>!)m4_m4exit(1)>!,!<m4_getenv(!<$1>!)>!)>!)m4_dnl
